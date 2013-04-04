//
//  SELocation.h
//  Selenium
//
//  Created by Khyati Dave on 3/25/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SELocation : NSObject


@property float latitude;
@property float longitude;
@property float altitude;


-(id) initWithDictionary:(NSDictionary*)dict;

@end
