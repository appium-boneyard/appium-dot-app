//
//  NodeUtility.h
//  Appium
//
//  Created by Dan Cuellar on 3/3/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NodeInstance : NSObject

-(id) initWithPath:(NSString*)rootPath;
-(void) installPackageWithNPM:(NSString*)packageName;

@end
