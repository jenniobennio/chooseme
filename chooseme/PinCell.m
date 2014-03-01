//
//  PinCell.m
//  chooseme
//
//  Created by subha on 2/28/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "PinCell.h"
#import "UIImageView+AFNetworking.h"

@implementation PinCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setPinURL:(NSString *)url
{
    NSURL *imageURL = [NSURL URLWithString:url];
    [self.pinImage setImageWithURL:imageURL];
}

@end
