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

@implementation Utility

+(NSString*) pathToAndroidBinary:(NSString*)binaryName
{
	// get the path to $ANDROID_HOME
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
    NSString *androidHomePath = [[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""];

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

	// try using the which command
	NSTask *whichTask = [NSTask new];
    [whichTask setLaunchPath:@"/bin/bash"];
    [whichTask setArguments: [NSArray arrayWithObjects: @"-l",
							  @"-c", [NSString stringWithFormat:@"which %@", binaryName], nil]];
	pipe = [NSPipe pipe];
    [whichTask setStandardOutput:pipe];
	[whichTask setStandardError:[NSPipe pipe]];
    [whichTask setStandardInput:[NSPipe pipe]];
    [whichTask launch];
	[whichTask waitUntilExit];
	stdOutHandle = [pipe fileHandleForReading];
    data = [stdOutHandle readDataToEndOfFile];
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
    FILE *fp;
    char line[1035];
    NSString *lsofCmd = [NSString stringWithFormat: @"/usr/sbin/lsof -t -i :%d", [port intValue]];
    NSNumber * pid = nil;

    // open the command for reading
    fp = popen([lsofCmd UTF8String], "r");
    if (fp != NULL)
    {
        // read the output line by line
        while (fgets(line, sizeof(line)-1, fp) != NULL)
        {
            NSString *lineString = [[NSString stringWithUTF8String:line] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSNumberFormatter *f = [NSNumberFormatter new];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber * myNumber = [f numberFromString:lineString];
            pid = myNumber != nil ? myNumber : pid;
        }
    }
    return pid;
}

@end
