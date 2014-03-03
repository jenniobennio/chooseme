//
//  Colorful.h
//  chooseme
//
//  Created by Jenny Kwan on 3/2/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Colorful : NSObject {
    int colorIndex;
    int friendsColorIndex;
    NSMutableArray *colors;
}

@property (nonatomic, assign) int colorIndex;
@property (nonatomic, assign) int friendsColorIndex;

@property (nonatomic, strong) NSMutableArray *colors;

+ (id)sharedManager;

- (UIColor *)randColor;
- (UIColor *)currentColor;

- (UIColor *)randFriendsColor;
- (UIColor *)currentFriendsColor;

@end
