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

- (void)colorIcons
{
    UIColor *color = [UIColor grayColor];
    self.heartIcon.image = [self.heartIcon.image maskWithColor:color];
    self.commentIcon.image = [self.commentIcon.image maskWithColor:color];
    self.numVotesLabel.textColor = color;
    self.numCommentsLabel.textColor = color;
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
