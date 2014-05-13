//
//  Utility.m
//  Appium
//
//  Created by Dan Cuellar on 3/3/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "Utility.h"
#import "AppiumGlobals.h"

#include <stdio.h>
#include <stdlib.h>
#define READ 0
#define WRITE 1

pid_t
popen2(const char *command, int *infp, int *outfp)
{
    int p_stdin[2], p_stdout[2];
    pid_t pid;
	
    if (pipe(p_stdin) != 0 || pipe(p_stdout) != 0)
        return -1;
	
    pid = fork();
	
    if (pid < 0)
        return pid;
    else if (pid == 0)
    {
        close(p_stdin[WRITE]);
        dup2(p_stdin[READ], READ);
        close(p_stdout[READ]);
        dup2(p_stdout[WRITE], WRITE);
		close(p_stdout[READ]);
		close(p_stdin[WRITE]);
		
        execl("/bin/sh", "sh", "-c", command, NULL);
        perror("execl");
        exit(1);
    }
	
    if (infp == NULL)
        close(p_stdin[WRITE]);
    else
        *infp = p_stdin[WRITE];
	
    if (outfp == NULL)
        close(p_stdout[READ]);
    else
        *outfp = p_stdout[READ];
	
	close(p_stdin[READ]);
	close(p_stdout[WRITE]);
    return pid;
}

@implementation Utility

+(NSString*) pathToAndroidBinary:(NSString*)binaryName atSDKPath:(NSString*)sdkPath
{
	NSString *androidHomePath = sdkPath;
	// get the path to $ANDROID_HOME if an sdk path is not supplied
	if (!androidHomePath)
	{
		NSTask *androidHomeTask = [NSTask new];
		[androidHomeTask setLaunchPath:@"/bin/bash"];
		[androidHomeTask setArguments: [NSArray arrayWithObjects: @"-l",
									@"-c", @"echo $ANDROID_HOME", nil]];
		NSPipe *pipe = [NSPipe pipe];
		[androidHomeTask setStandardOutput:pipe];
		[androidHomeTask setStandardError:[NSPipe pipe]];
		[androidHomeTask setStandardInput:[NSPipe pipe]];
		[androidHomeTask launch];
		[androidHomeTask waitUntilExit];
		NSFileHandle *stdOutHandle = [pipe fileHandleForReading];
		NSData *data = [stdOutHandle readDataToEndOfFile];
		[stdOutHandle closeFile];
		androidHomePath = [[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	}
	
	// check platform-tools folder
	NSString *androidBinaryPath = [[androidHomePath stringByAppendingPathComponent:@"platform-tools"] stringByAppendingPathComponent:binaryName];
	if ([[NSFileManager defaultManager] fileExistsAtPath:androidBinaryPath])
	{
		return androidBinaryPath;
	}

	// check tools folder
	androidBinaryPath = [[androidHomePath stringByAppendingPathComponent:@"tools"] stringByAppendingPathComponent:binaryName];
	if ([[NSFileManager defaultManager] fileExistsAtPath:androidBinaryPath])
	{
		return androidBinaryPath;
	}
	
	
	
	// check build-tools folders
	NSString *buildToolsDirectory = [androidHomePath stringByAppendingPathComponent:@"build-tools"];
	NSEnumerator* enumerator = [[[[NSFileManager defaultManager] enumeratorAtPath:buildToolsDirectory] allObjects] reverseObjectEnumerator];
	NSString *buildToolsSubDirectory;
	while (buildToolsSubDirectory = [enumerator nextObject])
	{
		buildToolsSubDirectory = [buildToolsDirectory stringByAppendingPathComponent:buildToolsSubDirectory];
		BOOL isDirectory = NO;
		if ([[NSFileManager defaultManager] fileExistsAtPath:buildToolsSubDirectory isDirectory: &isDirectory])
		{
			if (isDirectory) {
				androidBinaryPath = [buildToolsSubDirectory stringByAppendingPathComponent:binaryName];
				if ([[NSFileManager defaultManager] fileExistsAtPath:androidBinaryPath])
				{
					return androidBinaryPath;
				}
			}
		}
	}

	// try using the which command
	NSTask *whichTask = [NSTask new];
    [whichTask setLaunchPath:@"/bin/bash"];
    [whichTask setArguments: [NSArray arrayWithObjects: @"-l",
							  @"-c", [NSString stringWithFormat:@"which %@", binaryName], nil]];
	NSPipe *pipe = [NSPipe pipe];
    [whichTask setStandardOutput:pipe];
	[whichTask setStandardError:[NSPipe pipe]];
    [whichTask setStandardInput:[NSPipe pipe]];
    [whichTask launch];
	[whichTask waitUntilExit];
	NSFileHandle *stdOutHandle = [pipe fileHandleForReading];
    NSData *data = [stdOutHandle readDataToEndOfFile];
	[stdOutHandle closeFile];
    androidBinaryPath = [[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	if ([[NSFileManager defaultManager] fileExistsAtPath:androidBinaryPath])
	{
		return androidBinaryPath;
	}

	return nil;
}

+(NSString*) runTaskWithBinary:(NSString*)binary arguments:(NSArray*)args path:(NSString*)path
{
    NSTask *task = [NSTask new];
    if (path != nil)
    {
        [task setCurrentDirectoryPath:path];
    }

    [task setLaunchPath:binary];
    [task setArguments:args];
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    [task setStandardInput:[NSPipe pipe]];
	if (APPIUM_DEBUG_LEVEL > 0)
	{
		NSLog(@"Launching %@", binary);
	}
    [task launch];
    NSFileHandle *stdOutHandle = [pipe fileHandleForReading];
    NSData *data = [stdOutHandle readDataToEndOfFile];
	[stdOutHandle closeFile];
    NSString *output = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
	if (APPIUM_DEBUG_LEVEL > 1)
	{
		NSLog(@"%@ exited with output: %@", binary, output);
	}
    return output;
}

+(NSString*) runTaskWithBinary:(NSString*)binary arguments:(NSArray*)args
{
    return [self runTaskWithBinary:binary arguments:args path:nil];
}

+(NSNumber*) getPidListeningOnPort:(NSNumber*)port
{
    int fpIn, fpOut;
    char line[1035];
    NSString *lsofCmd = [NSString stringWithFormat: @"/usr/sbin/lsof -t -i :%d", [port intValue]];
    NSNumber *pid = nil;
	pid_t lsofProcPid;

    // open the command for reading
    lsofProcPid = popen2([lsofCmd UTF8String], &fpIn, &fpOut);
    if (lsofProcPid > 0)
    {
        // read the output line by line
	    read(fpOut, line, 1035);
        NSString *lineString = [[NSString stringWithUTF8String:line] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSNumberFormatter *f = [NSNumberFormatter new];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * myNumber = [f numberFromString:lineString];
        pid = myNumber != nil ? myNumber : pid;
		kill(lsofProcPid, 9);
	}
    return pid;
}

+(NSString*) pathToVBoxManageBinary
{
	NSTask *vBoxManageTask = [NSTask new];
    [vBoxManageTask setLaunchPath:@"/bin/bash"];
    [vBoxManageTask setArguments: [NSArray arrayWithObjects: @"-l",
								   @"-c", @"which vboxmanage", nil]];
	NSPipe *pipe = [NSPipe pipe];
    [vBoxManageTask setStandardOutput:pipe];
	[vBoxManageTask setStandardError:[NSPipe pipe]];
    [vBoxManageTask setStandardInput:[NSPipe pipe]];
    [vBoxManageTask launch];
	[vBoxManageTask waitUntilExit];
	NSFileHandle *stdOutHandle = [pipe fileHandleForReading];
    NSData *data = [stdOutHandle readDataToEndOfFile];
	[stdOutHandle closeFile];
    NSString *vBoxManagePath = [[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return vBoxManagePath;
}

@end
