//
//  MainPalette.m
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 03/03/16.
//  Copyright © 2016 Leto. All rights reserved.
//

#import "MainPalette.h"
#import <ChameleonFramework/Chameleon.h>


@implementation MainPalette

+ (NSString *)paletteName
{
    return @"Main App Palette";
}

//MAIN COLORS
+ (UIColor *)primaryColor{
    return [self colorFromHexString:@"#EB241F"];
}

+ (UIColor *)primaryDarkColor{
    return [self colorFromHexString:@"#b6282c"];
}

+ (UIColor *)primaryDarkerColor{
    return [self colorFromHexString:@"#841a1e"];
}

+ (UIColor *)accentColor{
    return [self colorFromHexString:@"#1cbb9b"];
}

//BASIC COLORS
+ (UIColor *)whiteColor{
    return [self colorFromHexString:@"#ffffff"];
}

+ (UIColor *)blackColor{
    return [self colorFromHexString:@"#000000"];
}

+ (UIColor *)transparentColor{
    return [self colorFromHexString:@"#00ffffff"];
}

+ (UIColor *)darkGreyTextColor{
    return [self colorFromHexString:@"#666666"];
}

+ (UIColor *)lightGreyTextColor{
    return [self colorFromHexString:@"#a6a6a6"];
}

+ (UIColor *)mediumGreyTextColor{
    return [self colorFromHexString:@"#999999"];
}

+ (UIColor *)lightBackgroundColor{
    return [self colorFromHexString:@"#F5F3F6"];
}

+ (UIColor *)darkBackgroundColor{
    return [self colorFromHexString:@"#212121"];
}

+ (UIColor *)darkestBackgroundColor{
    return [self colorFromHexString:@"#111111"];
}

// OTHERS
+ (UIColor *)flatRedColor{
    return [self colorFromHexString:@"#e84c3d"];
}

+ (UIColor *)flatGreenColor{
    return [self colorFromHexString:@"#2fcc71"];
}


// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end