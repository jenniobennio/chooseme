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
        self.thumbnail2.alpha = 0.4;
    } else {
        self.thumbnail1.alpha = 0.4;
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

- (void)populateData:(Question *)question withColor:(UIColor *)color
{
    UIImage *image1 = question.image1;
    UIImage *image2 = question.image2;
    
    // Set the images
    [self.thumbnail1 setBackgroundImage:image1 forState:UIControlStateNormal];
    [self.thumbnail2 setBackgroundImage:image2 forState:UIControlStateNormal];
    [self.bigPic setImage:image1];
    
    // Format the thumbnails
    self.thumbnail1.layer.borderColor = [color CGColor];
    self.thumbnail2.layer.borderColor = [color CGColor];
    [self formatThumbnails];
    [self highlightImage:1];
    
    // Format icons
    [self colorIcons:question.image1];
    [self updateHeartIcon:question];
    
    /*
    // ************* Image Switching *********************
    // Set up button touch actions
    [self.pView.thumbnail1 addTarget:self action:@selector(onTapPic1:) forControlEvents:UIControlEventTouchUpInside];
    self.pView.thumbnail1.tag = 1;
    [self.pView.thumbnail2 addTarget:self action:@selector(onTapPic2:) forControlEvents:UIControlEventTouchUpInside];
    self.pView.thumbnail2.tag = 2;
    
    // Enable Swiping
    self.pView.userInteractionEnabled = YES;
    self.pView.bigPic.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)];
    rightSwipe.delegate = self;
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)];
    leftSwipe.delegate = self;
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.pView.bigPic addGestureRecognizer:rightSwipe];
    [self.pView.bigPic addGestureRecognizer:leftSwipe];
    
    // ************** Voting ********************************
    // Enable double tap to vote
    self.doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doHeartPic:)];
    self.doubleTap.numberOfTapsRequired = 2;
    [self.pView.bigPic addGestureRecognizer:self.doubleTap];
    
    self.pView.heartIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *heartTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doHeartPic:)];
    [self.pView.heartIcon addGestureRecognizer:heartTap];
    */
    
    
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
    UIColor *defaultColor;
    if (image == 1)
        defaultColor = [self calculateTextColor:q.image1];
    else
        defaultColor = [self calculateTextColor:q.image2];
    UIColor *heartColor = (vote == image) ? [UIColor colorWithRed:1 green:0.07 blue:0.5 alpha:0.8] : defaultColor;
    self.heartIcon.image = [self.heartIcon.image maskWithColor:heartColor];
}

- (void) updateVoteCount:(Question *)q {
    if (self.thumbnail1.alpha == 1) {
        self.numVotesLabel.text = [NSString stringWithFormat:@"%d", q.numVoted1];
    } else {
        self.numVotesLabel.text = [NSString stringWithFormat:@"%d", q.numVoted2];
    }
    [self updatePercentages:q];
}


@end
