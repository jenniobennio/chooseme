//
//  PictureView.m
//  chooseme
//
//  Created by Jenny Kwan on 2/28/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "PictureView.h"
#import "UIImage+mask.h"

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
        self.thumbnail2.alpha = 0.25;
    } else {
        self.thumbnail1.alpha = 0.25;
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

- (void)updateVotes:(int)votes
{
    self.numVotesLabel.text = [NSString stringWithFormat:@"%d", votes];
}

- (void)updateComments:(int)comments
{
    self.numCommentsLabel.text = [NSString stringWithFormat:@"%d", comments];
}

- (void)enableSwipe
{
    self.userInteractionEnabled = YES;
    self.bigPic.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    recognizer.delegate = self;
    recognizer.direction = (UISwipeGestureRecognizerDirectionRight|UISwipeGestureRecognizerDirectionLeft);
    
    [self.bigPic addGestureRecognizer:recognizer];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe
{
    NSLog(@"receiving swipe.");
    // direction doesn't matter. just toggle.
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"right swipe");
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"left swipe.");
    }
}

#pragma mark - Gesture Recognizer Delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}


@end
