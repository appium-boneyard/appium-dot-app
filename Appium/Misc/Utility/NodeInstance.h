//
//  NodeUtility.h
//  Appium
//
//  Created by Dan Cuellar on 3/3/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NodeInstance : NSObject {
    @private
    NSString *_nodeRootPath;
}

-(id) initWithPath:(NSString*)rootPath;
-(NSString*) pathToNodeBinary;

+(BOOL) instanceExistsAtPath:(NSString*)rootPath;
+(BOOL) packageIsInstalledAtPath:(NSString*)rootPath withName:(NSString*)packageName;

-(void) installPackage:(NSString*)packageName atVersion:(NSString*)version forceInstall:(BOOL)forceInstall;
-(NSString*) pathtoPackage:(NSString*)packageName;

@end
