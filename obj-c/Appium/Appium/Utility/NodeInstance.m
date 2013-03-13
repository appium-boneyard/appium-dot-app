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

NSString *nodeRootPath;

#pragma mark - Constructors

- (id)init
{
    self = [super init];
    return [self initWithPath:[[NSBundle mainBundle] resourcePath]];
}

- (id)initWithPath:(NSString*)rootPath;
{
    self = [super init];
    if (self) {
        nodeRootPath = rootPath;
        NSString *nodePath = [NSString stringWithFormat:@"%@/%@", nodeRootPath, @"node"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:nodePath])
        {
            [[NSFileManager defaultManager ] createDirectoryAtPath: nodePath withIntermediateDirectories: YES attributes: nil error: NULL ];
            
            // download node
            NSString *nodeTarPath;
            NSString *stringURL = @"http://nodejs.org/dist/v0.8.21/node-v0.8.21-darwin-x86.tar.gz";
            NSLog(@"Download NodeJS binaries from \"%@.\"", stringURL);
            NSURL  *url = [NSURL URLWithString:stringURL];
            NSData *urlData = [NSData dataWithContentsOfURL:url];
            if (!urlData)
            {
                return nil;
            }
            nodeTarPath = [NSString stringWithFormat:@"%@/%@", nodeRootPath,@"node.tar"];
            [urlData writeToFile:nodeTarPath atomically:YES];
            
            // extract node
            [Utility runTaskWithBinary:@"/usr/bin/tar" arguments:[NSArray arrayWithObjects: @"--strip-components", @"1", @"-zxvf", nodeTarPath, @"-C", @"./node", nil] path:nodeRootPath];
        }
    }
    return self;
}

#pragma mark - Instance Methods

-(void) installPackage:(NSString*)packageName forceInstall:(BOOL)forceInstall
{
    
    NSString *packagePath = [NSString stringWithFormat:@"%@/%@", nodeRootPath, [NSString stringWithFormat:@"%@/%@", @"node_modules", packageName]];
    if (forceInstall || ![[NSFileManager defaultManager] fileExistsAtPath:packagePath])
    {
        // install package
        NSString *npmPath = [NSString stringWithFormat:@"%@/%@", nodeRootPath, @"node/bin/npm"];
        [Utility runTaskWithBinary:npmPath arguments:[NSArray arrayWithObjects: @"install", packageName, nil] path:nodeRootPath];
    }
}

-(NSString*) pathtoPackage:(NSString*)packageName
{
    return [NSString stringWithFormat:@"%@/%@/%@/%@", nodeRootPath, @"node_modules", packageName, @"package.json"];
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
