//
//  NodeUtility.m
//  Appium
//
//  Created by Dan Cuellar on 3/3/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "NodeInstance.h"

#import "Utility.h"

@implementation NodeInstance

- (id)init
{
    self = [super init];
    return [self initWithPath:[[NSBundle mainBundle] resourcePath]];
}

- (id)initWithPath:(NSString*)rootPath;
{
    self = [super init];
    if (self) {
        _nodeRootPath = rootPath;
        NSString *nodePath = [NSString stringWithFormat:@"%@/%@", _nodeRootPath, @"node"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:nodePath])
        {
            [[NSFileManager defaultManager ] createDirectoryAtPath: nodePath withIntermediateDirectories: YES attributes: nil error: NULL ];
            
            // download node
            NSString *nodeTarPath;
            NSString *stringURL = @"http://nodejs.org/dist/v0.10.3/node-v0.10.3-darwin-x64.tar.gz";
            NSLog(@"Download NodeJS binaries from \"%@.\"", stringURL);
            NSURL  *url = [NSURL URLWithString:stringURL];
            NSData *urlData = [NSData dataWithContentsOfURL:url];
            if (!urlData)
            {
                return nil;
            }
            nodeTarPath = [NSString stringWithFormat:@"%@/%@", _nodeRootPath,@"node.tar"];
            [urlData writeToFile:nodeTarPath atomically:YES];
            
            // extract node
            [Utility runTaskWithBinary:@"/usr/bin/tar" arguments:[NSArray arrayWithObjects: @"--strip-components", @"1", @"-zxvf", nodeTarPath, @"-C", @"./node", nil] path:_nodeRootPath];
        }
    }
    return self;
}

#pragma mark - Instance Methods

-(NSString*) pathToNodeBinary
{
    return [NSString stringWithFormat:@"%@/%@", _nodeRootPath, @"node/bin/node"];
}

-(void) installPackage:(NSString*)packageName forceInstall:(BOOL)forceInstall
{
    
    NSString *packagePath = [NSString stringWithFormat:@"%@/%@", _nodeRootPath, [NSString stringWithFormat:@"%@/%@", @"node_modules", packageName]];
    if (forceInstall || ![[NSFileManager defaultManager] fileExistsAtPath:packagePath])
    {
        // install package
        NSString *npmPath = [NSString stringWithFormat:@"%@/%@", _nodeRootPath, @"node/bin/npm"];
        [Utility runTaskWithBinary:npmPath arguments:[NSArray arrayWithObjects: @"install", packageName, nil] path:_nodeRootPath];
    }
}

-(NSString*) pathtoPackage:(NSString*)packageName
{
    return [NSString stringWithFormat:@"%@/%@/%@", _nodeRootPath, @"node_modules", packageName];
}

#pragma mark - Static Methods

+(BOOL) instanceExistsAtPath:(NSString*)rootPath;
{
    NSString *nodePath = [NSString stringWithFormat:@"%@/%@", rootPath, @"node"];
    return [[NSFileManager defaultManager] fileExistsAtPath:nodePath];
}

+(BOOL) packageIsInstalledAtPath:(NSString*)rootPath withName:(NSString*)packageName
{
    NSString *packagePath = [NSString stringWithFormat:@"%@/%@", rootPath, [NSString stringWithFormat:@"%@/%@", @"node_modules", packageName]];
    return [[NSFileManager defaultManager] fileExistsAtPath:packagePath];
}
@end
