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
#import "MBProgressHUD.h"

@implementation PictureView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)populateData:(Question *)question withColor:(UIColor *)color
{
    self.q = question;
    self.highlightedIndex = 1;
    
    // Set the pictures (thumbnail + big pic)
    [self performSelectorInBackground:@selector(load_images) withObject:nil];
    self.thumbnail1.tag = 1;
    self.thumbnail2.tag = 2;
    [self formatThumbnails:color];
    self.bigPicBgColor.backgroundColor = color;
    
    // Format icons
    [self colorIcons];
    
    // Set any text
    [self updateVoteCount];
    [self updateCommentCount];
    [self updatePercentages];
}

- (void) load_images
{
    //    [MBProgressHUD showHUDAddedTo:self.bigPicBgColor animated:YES];
    
    if (self.highlightedIndex == 1)
        [self reloadBigPic:self.q.image1];
    else
        [self reloadBigPic:self.q.image2];
    
    [self.thumbnail1 setBackgroundImage:self.q.image1 forState:UIControlStateNormal];
    [self.thumbnail2 setBackgroundImage:self.q.image2 forState:UIControlStateNormal];
    
//    [MBProgressHUD hideHUDForView:self.bigPicBgColor animated:YES];

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
    
    if (self.highlightedIndex != index) {
        self.highlightedIndex = index;
        if (index == 1)
            [self reloadBigPic:self.q.image1];
        else
            [self reloadBigPic:self.q.image2];
        
        if (self.heartIcon.image) {
            [self colorIcons];
        }
    }
    
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

- (void)update
{
    [self updateVoteCount];
    [self updateCommentCount];
    [self updatePercentages];
    [self updateHeartIcon];
}


# pragma mark - private methods
 
- (void)formatThumbnails:(UIColor *)color
{
    if (self.highlightedIndex == 1) {
        self.thumbnail1.alpha = 1;
        self.thumbnail2.alpha = 0.4;
    } else {
        self.thumbnail1.alpha = 0.4;
        self.thumbnail2.alpha = 1;
    }
    
    self.thumbnail1.layer.borderColor = [color CGColor];
    self.thumbnail1.layer.borderWidth = 1;
    self.thumbnail1.layer.cornerRadius = 25;
    [self.thumbnail1.imageView setContentMode:UIViewContentModeScaleAspectFill];
    self.thumbnail1.layer.masksToBounds = YES;

    self.thumbnail2.layer.borderColor = [color CGColor];
    self.thumbnail2.layer.borderWidth = 1;
    self.thumbnail2.layer.cornerRadius = 25;
    [self.thumbnail2.imageView setContentMode:UIViewContentModeScaleAspectFill];
    self.thumbnail2.layer.masksToBounds = YES;
}

- (void)reloadBigPic:(UIImage *)image1
{
    self.bigPic.image = image1;
    self.thumbnail1.alpha = 0.0f;
    self.thumbnail2.alpha = 0.0f;
    self.bigPic.alpha = 0.0f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    if (self.highlightedIndex == 1) {
        self.thumbnail1.alpha = 1.0f;
        self.thumbnail2.alpha = 0.4f;
    } else {
        self.thumbnail2.alpha = 1.0f;
        self.thumbnail1.alpha = 0.4f;
    }
    self.bigPic.alpha = 1.0f;
    [UIView commitAnimations];
}

- (void)colorIcons
{
    UIColor *color = [self calculateTextColor:self.bigPic.image];
    
    self.commentIcon.image = [self.commentIcon.image maskWithColor:color];
    self.numVotesLabel.textColor = color;
    self.numCommentsLabel.textColor = color;
    self.questionLabel.textColor = color;
    
    [self updateHeartIcon];
}

- (UIColor *) calculateTextColor:(UIImage *)img
{
    // FIXME: For question text in middle of image, we shouldn't be
    // using the same calculated color from the bottom right??
    
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

- (void) updateHeartIcon
{
    int image = (self.thumbnail1.alpha == 1)? 1 : 2;
    
    int vote = 0;
    if ([[[PFUser currentUser] objectId] isEqualToString:self.q.author.objectId]) {
        vote = [self.q.youVoted intValue];
    } else {
        vote = [self.q vote];
    }
    self.heartIcon.image = [UIImage imageNamed:@"29-heart.png"]; // fix the disappearing alpha problem
    UIColor *defaultColor = self.numVotesLabel.textColor;
    UIColor *heartColor = (vote == image) ? [UIColor colorWithRed:1 green:0.07 blue:0.5 alpha:0.8] : defaultColor;
    self.heartIcon.image = [self.heartIcon.image maskWithColor:heartColor];
}

- (void) updateVoteCount {
    // FIXME: numVoted or numReplies?
    
    /*if (self.thumbnail1.alpha == 1) {
        self.numVotesLabel.text = [NSString stringWithFormat:@"%d / %d", q.numVoted1, q.numReplies];
    } else {
        self.numVotesLabel.text = [NSString stringWithFormat:@"%d / %d", q.numVoted2, q.numReplies];
    }*/
    self.numVotesLabel.text = [NSString stringWithFormat:@"%d", self.q.numReplies];
}

- (void)updateCommentCount
{
    self.numCommentsLabel.text = [NSString stringWithFormat:@"%d", self.q.numComments];
}

- (void)updatePercentages
{
    NSString *percent1 = [NSString stringWithFormat:@"%d", [self.q percentPic:1]];
    NSString *percent2 = [NSString stringWithFormat:@"%d", [self.q percentPic:2]];
    
    // Don't show percentage data if a friend hasn't voted
    if (![PFUser.currentUser.objectId isEqualToString:self.q.author.objectId] && self.q.vote == 0) {
        [self.thumbnail1 setTitle:@"" forState:UIControlStateNormal];
        [self.thumbnail2 setTitle:@"" forState:UIControlStateNormal];
    } else {
        [self.thumbnail1 setTitle:percent1 forState:UIControlStateNormal];
        [self.thumbnail2 setTitle:percent2 forState:UIControlStateNormal];
        
        self.thumbnail1.titleLabel.alpha = 0.95;
        self.thumbnail2.titleLabel.alpha = 0.95;
    }
}

@end
