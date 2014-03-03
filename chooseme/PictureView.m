//
//  PictureView.m
//  chooseme
//
//  Created by Jenny Kwan on 2/28/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "PictureView.h"
#import "UIImage+mask.h"
#import "Question.h"

@implementation PictureView

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

- (void)hideDetails
{
    // For the QuestionVC, hide lots of things
    self.thumbnail1.titleLabel.text = @"";
    self.thumbnail2.titleLabel.text = @"";
    self.numVotesLabel.text = @"";
    self.numCommentsLabel.text = @"";
    self.heartIcon.image = nil;
    self.commentIcon.image = nil;
}

- (void)formatThumbnails
{
    self.thumbnail1.layer.borderWidth = 1;
    self.thumbnail1.layer.cornerRadius = 25;
    [self.thumbnail1.imageView setContentMode:UIViewContentModeScaleAspectFill];
    self.thumbnail1.layer.masksToBounds = YES;

    self.thumbnail2.layer.borderWidth = 1;
    self.thumbnail2.layer.cornerRadius = 25;
    [self.thumbnail2.imageView setContentMode:UIViewContentModeScaleAspectFill];
    self.thumbnail2.layer.masksToBounds = YES;
}

- (void)highlightImage:(int)index
{
    // TODO: Also, add a gray overlay?
    if (index == 1) {
        self.thumbnail1.alpha = 1;
        self.thumbnail2.alpha = 0.25;
    } else {
        self.thumbnail1.alpha = 0.25;
        self.thumbnail2.alpha = 1;
    }
}

- (void)colorIcons:(UIImage *)image
{
    UIColor *color = [self calculateTextColor:image];
    self.heartIcon.image = [self.heartIcon.image maskWithColor:color];
    self.commentIcon.image = [self.commentIcon.image maskWithColor:color];
    self.numVotesLabel.textColor = color;
    self.numCommentsLabel.textColor = color;
}

- (UIColor *) calculateTextColor:(UIImage *)img
{
    // Detect the average color of the bottom right corner of the image, and
    // color the text/ icons appropriately
    CGRect myImageArea = self.bigPic.frame;
    myImageArea.origin.x = myImageArea.size.width - 100;
    myImageArea.origin.y = myImageArea.size.height - 30;
    myImageArea.size.width = 100;
    myImageArea.size.height = 30;
    CGImageRef mySubimage  = CGImageCreateWithImageInRect([img CGImage], myImageArea);
    UIImage *image = [UIImage imageWithCGImage:mySubimage];
    
    // If the cropped image is not-nil, then check for the average color
    UIColor *color = [UIColor lightGrayColor];
    if (image) {
        UIColor *avgColor = [image averageColor];
        CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
        [avgColor getRed:&red green:&green blue:&blue alpha:&alpha];
        
        CGFloat threshold = 50.0/255;
        CGFloat bgDelta = ((red * 0.299) + (green * 0.587) + (blue * 0.114));
        color = (1 - bgDelta < threshold) ? [UIColor grayColor] : [UIColor whiteColor];
    }
    return color;
}

- (void)updateComments:(int)comments
{
    self.numCommentsLabel.text = [NSString stringWithFormat:@"%d", comments];
}

- (void)updatePercentages:(Question *)q
{
    NSString *percent1 = [NSString stringWithFormat:@"%d", [q percentPic:1]];
    NSString *percent2 = [NSString stringWithFormat:@"%d", [q percentPic:2]];
    
    [self.thumbnail1 setTitle:percent1 forState:UIControlStateNormal];
    [self.thumbnail2 setTitle:percent2 forState:UIControlStateNormal];
    
    self.thumbnail1.titleLabel.alpha = 0.95;
    self.thumbnail2.titleLabel.alpha = 0.95;
}

@end
