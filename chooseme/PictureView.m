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
    if (index == 1) {
        self.thumbnail1.alpha = 1;
        self.thumbnail2.alpha = 0.4;
    } else {
        self.thumbnail1.alpha = 0.4;
        self.thumbnail2.alpha = 1;
    }
    
    // highlightedIndex is 0-indexed
    self.highlightedIndex = index-1;
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
    
    myImageArea.origin.x = img.size.width - 100;
    myImageArea.origin.y = img.size.height - 30;
    myImageArea.size.width = 100;
    myImageArea.size.height = 30;
    
    CGImageRef mySubimage  = CGImageCreateWithImageInRect([img CGImage], myImageArea);
    UIImage *image = [UIImage imageWithCGImage:mySubimage];
    
    // If the cropped image is not-nil, then check for the average color
    UIColor *color = [UIColor whiteColor]; //]lightGrayColor];
    if (image) {
        UIColor *avgColor = [image averageColor];
        CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
        [avgColor getRed:&red green:&green blue:&blue alpha:&alpha];
        
        CGFloat threshold = 50.0/255;
        CGFloat bgDelta = ((red * 0.299) + (green * 0.587) + (blue * 0.114));
//        NSLog(@"%f %f", threshold, bgDelta);
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
    
    
    if (![PFUser.currentUser.objectId isEqualToString:q.author.objectId] && q.vote == 0) {
        [self.thumbnail1 setTitle:@"" forState:UIControlStateNormal];
        [self.thumbnail2 setTitle:@"" forState:UIControlStateNormal];
    } else {
        [self.thumbnail1 setTitle:percent1 forState:UIControlStateNormal];
        [self.thumbnail2 setTitle:percent2 forState:UIControlStateNormal];
        
        self.thumbnail1.titleLabel.alpha = 0.95;
        self.thumbnail2.titleLabel.alpha = 0.95;
    }
}

- (void)populateData:(Question *)question withColor:(UIColor *)color
{
    UIImage *image1 = question.image1;
    UIImage *image2 = question.image2;
    
    // Set the images
    [self.thumbnail1 setBackgroundImage:image1 forState:UIControlStateNormal];
    [self.thumbnail2 setBackgroundImage:image2 forState:UIControlStateNormal];
    if (self.highlightedIndex == 0)
        [self.bigPic setImage:image1];
    else
        [self.bigPic setImage:image2];
    
    // Format the thumbnails
    self.thumbnail1.layer.borderColor = [color CGColor];
    self.thumbnail2.layer.borderColor = [color CGColor];
    [self formatThumbnails];
    [self highlightImage:self.highlightedIndex+1];
    
    // Format icons
    if (self.highlightedIndex == 0)
        [self colorIcons:question.image1];
    else
        [self colorIcons:question.image2];
    [self updateHeartIcon:question];
    
    // Set any text
    [self updateVoteCount:question];
    [self updateComments:question.numComments];
    [self updatePercentages:question];
}

- (void) updateHeartIcon:(Question *)q
{
    int image = (self.thumbnail1.alpha == 1)? 1 : 2;
    
    int vote = 0;
    if ([[[PFUser currentUser] objectId] isEqualToString:q.author.objectId]) {
        vote = [q.youVoted intValue];
    } else {
        vote = [q vote];
    }
    self.heartIcon.image = [UIImage imageNamed:@"29-heart.png"]; // fix the disappearing alpha problem
    UIColor *defaultColor = self.numVotesLabel.textColor;
    UIColor *heartColor = (vote == image) ? [UIColor colorWithRed:1 green:0.07 blue:0.5 alpha:0.8] : defaultColor;
    self.heartIcon.image = [self.heartIcon.image maskWithColor:heartColor];
}

- (void) updateVoteCount:(Question *)q {
    /*if (self.thumbnail1.alpha == 1) {
        self.numVotesLabel.text = [NSString stringWithFormat:@"%d / %d", q.numVoted1, q.numReplies];
    } else {
        self.numVotesLabel.text = [NSString stringWithFormat:@"%d / %d", q.numVoted2, q.numReplies];
    }*/
    self.numVotesLabel.text = [NSString stringWithFormat:@"%d", q.numReplies];
    [self updatePercentages:q];
}


- (void)reloadBigPic:(UIImage *)image1
{
    self.bigPic.image = image1;
    self.thumbnail1.alpha = 0.0f;
    self.thumbnail2.alpha = 0.0f;
    self.bigPic.alpha = 0.0f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    self.thumbnail1.alpha = 1.0f;
    self.thumbnail2.alpha = 1.0f;
    self.bigPic.alpha = 1.0f;
    [UIView commitAnimations];
}


@end
