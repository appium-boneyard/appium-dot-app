//
//  Utility.m
//  Appium
//
//  Created by Dan Cuellar on 3/3/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (NSString*) runTaskWithBinary:(NSString*)binary arguments:(NSArray*)args path:(NSString*)path
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
    NSLog(@"Launching %@", binary);
    [task launch];
    NSFileHandle *stdOutHandle = [pipe fileHandleForReading];
    NSData *data = [stdOutHandle readDataToEndOfFile];
    NSString *output = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    //NSLog(@"%@ exited with output: %@", binary, output);
    return output;
}

+ (NSString*) runTaskWithBinary:(NSString*)binary arguments:(NSArray*)args
{
    return [self runTaskWithBinary:binary arguments:args path:nil];
}

@end
