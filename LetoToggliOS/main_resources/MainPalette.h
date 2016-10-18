//
//  MainPalette.h
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 03/03/16.
//  Copyright © 2016 Leto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainPalette : NSObject

//MAIN COLORS
+ (UIColor *)primaryColor;

+ (UIColor *)primaryDarkColor;

+ (UIColor *)primaryDarkerColor;

+ (UIColor *)accentColor;

//BASIC COLORS
+ (UIColor *)whiteColor;

+ (UIColor *)blackColor;

+ (UIColor *)transparentColor;

+ (UIColor *)darkGreyTextColor;

+ (UIColor *)lightGreyTextColor;

+ (UIColor *)mediumGreyTextColor;
+ (UIColor *)lightBackgroundColor;

+ (UIColor *)darkBackgroundColor;

+ (UIColor *)darkestBackgroundColor;

// OTHERS
+ (UIColor *)flatRedColor;
+ (UIColor *)flatGreenColor;

@end