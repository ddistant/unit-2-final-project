//
//  ColorData.m
//  finalProject
//
//  Created by Justine Gartner on 10/19/15.
//  Copyright © 2015 ddistant. All rights reserved.
//

//COLOR SCHEME
//creamsicleOrange = FF8552  rgb(255,133,82)
//
//icicleGray = E6E6E6  rgb(230,230,230)
//
//pavementGray = 39393A  rgb(57,57,58)
//
//oceanTeal = 297373  rgb(41,115,115)
//
//chartreuseYellow = E9D758  rgb(233,215,88)


#import "ColorData.h"

@implementation ColorData

//This makes this class a singleton.
//We can access these colors throughout the project
//by calling: [ColorData sharedModel].nameOfColorHere

+ (ColorData *)sharedModel {
    static ColorData *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        [sharedMyManager initializeColorData];
    });
    return sharedMyManager;
    
}

-(void)initializeColorData{
    
    self.creamsicleOrg = [ColorData makeColorWithRed:255 green:133 blue:82];
    self.icicleGry = [ColorData makeColorWithRed:230 green:230 blue:230];
    self.pavementGry = [ColorData makeColorWithRed:57 green:57 blue:58];
    self.oceanTeal = [ColorData makeColorWithRed:41 green:115 blue:115];
    self.chartreuseYel = [ColorData makeColorWithRed:233 green:215 blue:88];
    
    
}

+(UIColor *)makeColorWithRed:(NSInteger)red
                       green:(NSInteger)green
                        blue:(NSInteger)blue {
    return [UIColor colorWithRed:red / 255.0
                           green:green / 255.0
                            blue:blue / 255.0
                           alpha:1.0];
}


@end
