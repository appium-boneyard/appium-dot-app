//
//  ANSIUtils.m
//  Appium
//
//  Created by Dan Cuellar on 3/3/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//
// Code adapted from Samuel Goodwin's Turbo Mud Client
// "https://github.com/sgoodwin/Turbo-Mud/tree/experiment/Turbo%20Mud"
//

#import "ANSIUtility.h"

#define kFontSize 12

@implementation ANSIUtility

+ (NSAttributedString*)processIncomingStream:(NSString*)string withPreviousAttributes:(NSMutableDictionary **)attrs{
    [self setupDefaults:*attrs overwrite:NO];
    if([string length] == 0){
        NSMutableAttributedString *attributedResult = [[NSMutableAttributedString alloc] init];
        [attributedResult addAttributes:*attrs range:NSMakeRange(0, [string length])];
        return attributedResult;
    }

    NSError *error = nil;

    error = nil;
    NSRegularExpression *colorRegex = [NSRegularExpression regularExpressionWithPattern:@"\\e.(\\d{1,1};)??(\\d{1,2}m)" options:NSRegularExpressionUseUnixLineSeparators error:&error];
    if(error){
        NSLog(@"error: %@", [error localizedDescription]);
    }
    NSArray *matches = [colorRegex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
    NSString *colorStrippedString = [colorRegex stringByReplacingMatchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0,[string length]) withTemplate:@""];

    NSMutableAttributedString *attributedResult = [[NSMutableAttributedString alloc] initWithString:[colorStrippedString stringByAppendingString:@"\r\n"]];
    [attributedResult addAttributes:*attrs range:NSMakeRange(0, [colorStrippedString length])];

    NSInteger offset = 2;
    for(int i=0;i<[matches count];i++){
        NSTextCheckingResult *result = [matches objectAtIndex:i];
        NSRange firstRange = [result rangeAtIndex:1];
        if(firstRange.location != NSNotFound){
            NSString *firstString = [string substringWithRange:firstRange];
            firstRange.location = firstRange.location - offset;
            NSInteger code = [firstString integerValue];
            if(code == 0){
                [self setupDefaults:*attrs overwrite:YES];
            }else{
                [*attrs setObject:[self attributeForCode:code] forKey:[self attributeNameForCode:code]];
            }
            [attributedResult addAttributes:*attrs range:NSMakeRange(firstRange.location,[attributedResult length]-firstRange.location)];
            offset+=2;
        }
        NSRange secondRange = [result rangeAtIndex:2];
        if(secondRange.location != NSNotFound){
            NSString *secondString = [string substringWithRange:secondRange];
            secondRange.location = secondRange.location - offset;
            NSInteger code = [secondString integerValue];
            if(code == 0){
                [self setupDefaults:*attrs overwrite:YES];
            }else{
                [*attrs setObject:[self attributeForCode:code] forKey:[self attributeNameForCode:code]];
            }
            [attributedResult addAttributes:*attrs range:NSMakeRange(secondRange.location,[attributedResult length]-secondRange.location)];
            offset+=5;
        }
    }
    return attributedResult;
}

+ (void)setupDefaults:(NSMutableDictionary*)dict overwrite:(BOOL)overwrite{
    // Setup defaults...
    if(nil == [dict objectForKey:NSForegroundColorAttributeName] || overwrite){
        [dict setObject:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
    }
    if(nil == [dict objectForKey:NSBackgroundColorAttributeName] || overwrite){
        //[dict setObject:[NSColor blackColor] forKey:NSBackgroundColorAttributeName];
		// use clear instead so it doesn't block the background image
		[dict setObject:[NSColor clearColor] forKey:NSBackgroundColorAttributeName];
    }
    if(nil == [dict objectForKey:NSFontAttributeName] || overwrite){
        [dict setObject:[NSFont fontWithName:@"Menlo" size:kFontSize] forKey:NSFontAttributeName];
    }
}

/* color codes taken from http://pueblo.sourceforge.net/doc/manual/ansi_color_codes.html */
+ (NSString*)attributeNameForCode:(NSInteger)code{
    if(code == 1){
        return NSFontAttributeName;
    }
    if(code >= 2 && code <=29){
        return nil;
    }
    if(code >= 30 && code <= 39){
        return NSForegroundColorAttributeName;
    }
    return NSBackgroundColorAttributeName;
}

+ (id)attributeForCode:(NSInteger)code{
    switch(code){
        case 1:
            return [NSFont fontWithName:@"Andale Mono" size:kFontSize];
        case 30:
            return [NSColor whiteColor];
            break;
        case 31:
            return [NSColor redColor];
            break;
        case 32:
            return [NSColor greenColor];
            break;
        case 33:
            return [NSColor yellowColor];
            break;
        case 34:
            return [NSColor blueColor];
            break;
        case 35:
            return [NSColor magentaColor];
            break;
        case 36:
            return [NSColor cyanColor];
            break;
        case 37:
            return [NSColor whiteColor];
            break;
        case 39:
            return [NSColor whiteColor];
            break;
        default:
			// use instead of black so the background is draw correctly
            return [NSColor clearColor];
            break;
    }
}

@end
