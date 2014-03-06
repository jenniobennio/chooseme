//
//  Colorful.m
//  chooseme
//
//  Created by Jenny Kwan on 3/2/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "Colorful.h"

@implementation Colorful
@synthesize friendsColorIndex;
@synthesize colorIndex;
@synthesize colors;

// Using the singleton design pattern

+ (id)sharedManager {
    static Colorful *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (UIColor *)randColor {
    colorIndex = arc4random() % colors.count;
    
    // FIXME: Seeded for demo
    colorIndex = 5;
    
    return colors[colorIndex];
}

- (UIColor *)currentColor {
    return [self currentColor:0];
}
- (UIColor *)currentColor:(int)index {
    return colors[(colorIndex + index) % colors.count];
}

- (UIColor *)randFriendsColor {
    friendsColorIndex = arc4random() % colors.count;
    
    // FIXME: Seeded for demo
    friendsColorIndex = 0;
    
    return colors[friendsColorIndex];
}

- (UIColor *)currentFriendsColor {
    return [self currentFriendsColor:0];
}
- (UIColor *)currentFriendsColor:(int)index {
    return colors[(friendsColorIndex+index) % colors.count];
}


- (id)init {
    if (self = [super init]) {
        colorIndex = 0;
        friendsColorIndex = 0;
        
        // Pretty flat UI colors!
        colors = [[NSMutableArray alloc] init];
        [colors addObject:[UIColor colorWithRed:0.329 green:0.733 blue:0.616 alpha:0.75]];
        [colors addObject:[UIColor colorWithRed:0.149 green:0.706 blue:0.835 alpha:0.75]];
        [colors addObject:[UIColor colorWithRed:0.933 green:0.733 blue:0 alpha:0.75]];
        [colors addObject:[UIColor colorWithRed:0.702 green:0.141 blue:0.110 alpha:0.75]];
        [colors addObject:[UIColor colorWithRed:0.878 green:0.416 blue:0.039 alpha:0.75]];
        [colors addObject:[UIColor colorWithRed:0.929 green:0.345 blue:0.455 alpha:0.75]];
        [colors addObject:[UIColor colorWithRed:0.537 green:0.235 blue:0.663 alpha:0.75]];
//        [colors addObject:[UIColor colorWithRed:0.153 green:0.220 blue:0.298 alpha:0.75]]; // ugly gray
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}


@end
