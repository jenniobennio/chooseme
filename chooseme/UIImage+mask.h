//
//  UIImage+mask.h
//  chooseme
//
//  Created by Jenny Kwan on 2/25/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (mask)

- (UIImage *)maskWithColor:(UIColor *)color;
- (UIImage*)imageWithShadow;
- (UIImage *)invertImage;
- (UIColor *)averageColor;

@end
