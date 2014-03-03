//
//  NewFeedCell.m
//  chooseme
//
//  Created by Jenny Kwan on 2/28/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "NewFeedCell.h"
#import "UIImage+mask.h"

@implementation NewFeedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)reloadUserPic:(UIImage *)userImage
{
    self.uqView.userPic.image = userImage;
    self.uqView.userPic.alpha = 0.0f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    self.uqView.userPic.alpha = 1.0f;
    [UIView commitAnimations];
}

- (void)reloadBigPic:(UIImage *)image1
{
    self.pView.bigPic.image = image1;
    self.pView.thumbnail1.alpha = 0.0f;
    self.pView.thumbnail2.alpha = 0.0f;
    self.pView.bigPic.alpha = 0.0f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    self.pView.thumbnail1.alpha = 1.0f;
    self.pView.thumbnail2.alpha = 1.0f;
    self.pView.bigPic.alpha = 1.0f;
    [UIView commitAnimations];
}

- (void)loadCell:(UIColor *)color withQuestion:(Question *)q withUserImage:(UIImage *)userImage
{
    self.q = q;
    
    UIImage *image1 = q.image1;
    UIImage *image2 = q.image2;
    
    // Use the URL instead
//    UIImage *userImage = [UIImage imageWithData:q.profilePic];
    
    ///////////////////////////
    // First, load PictureView
    ///////////////////////////
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"PictureView" owner:self options:nil];
    self.pView = [nibViews objectAtIndex:0];
    
    // Set the frame
    CGRect newFrame = self.pView.frame;
    newFrame.origin = CGPointMake(0, 0);
    self.pView.frame = newFrame;

    // Set the images
    [self.pView.thumbnail1 setImage:image1 forState:UIControlStateNormal];
    [self.pView.thumbnail2 setImage:image2 forState:UIControlStateNormal];

    // Set the big pic background color to fade from
    self.pView.bigPicBgColor.backgroundColor = color;
    // Load and fade in big pic
    [self reloadBigPic:image1];

    // Format the thumbnails
    self.pView.thumbnail1.layer.borderColor = [color CGColor];
    self.pView.thumbnail2.layer.borderColor = [color CGColor];
    [self.pView formatThumbnails];
    [self.pView highlightImage:1];
    
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
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doHeartPic:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.pView.bigPic addGestureRecognizer:doubleTap];
    
    self.pView.heartIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *heartTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doHeartPic:)];
    [self.pView.heartIcon addGestureRecognizer:heartTap];
    
    // Format icons
    [self.pView colorIcons];
    [self updateHeartIcon];
    
    // Set any text
    [self updateVoteCount];
    [self.pView updateComments:q.numComments];

    // Add as subview
    [self.contentView addSubview:self.pView];
    
    ///////////////////////////
    // Next, load UserQuestionView
    ///////////////////////////
    nibViews = [[NSBundle mainBundle] loadNibNamed:@"UserQuestionView" owner:self options:nil];
    self.uqView = [nibViews objectAtIndex:0];
    
    // Set the frame
    newFrame = self.uqView.frame;
    newFrame.origin = CGPointMake(0, 368);
    self.uqView.frame = newFrame;
    
    // Set the profile image background color to fade from
    self.uqView.userPicBgColor.backgroundColor = color;
    // Load and fade in user pic
    [self reloadUserPic:userImage];
    
    // Format the view
    self.uqView.colorView.backgroundColor = color;
    
    // Set any text
    self.uqView.questionLabel.text = [q formattedQuestion];
    self.uqView.nameLabel.text = [q formattedName];
    self.uqView.timestampLabel.text = [q formattedDate];
    
    // Add as subview
    [self.contentView addSubview:self.uqView];
}

- (void)onTapPic1:(UIButton *)button
{
    [self reloadBigPic:self.q.image1];
    [self.pView highlightImage:1];
    [self updateVoteCount];
    [self updateHeartIcon];
}

- (void)onTapPic2:(UIButton *)button
{
    [self reloadBigPic:self.q.image2];
    [self.pView highlightImage:2];
    [self updateVoteCount];
    [self updateHeartIcon];
}

- (void) updateHeartIcon
{
    int image = (self.pView.thumbnail1.alpha == 1)? 1 : 2;
    
    int vote = 0;
    if ([[[PFUser currentUser] objectId] isEqualToString:self.q.author.objectId]) {
        vote = [self.q.youVoted intValue];
    } else {
        vote = [self.q vote];
    }
    self.pView.heartIcon.image = [UIImage imageNamed:@"29-heart.png"]; // fix the disappearing alpha problem
    UIColor *heartColor = (vote == image) ? [UIColor colorWithRed:1 green:0.07 blue:0.5 alpha:0.8] : [UIColor grayColor];
    self.pView.heartIcon.image = [self.pView.heartIcon.image maskWithColor:heartColor];
}

- (void)handleRightSwipe:(UISwipeGestureRecognizer *)swipe
{
    [self handleSwipe:swipe];
}

- (void)handleLeftSwipe:(UISwipeGestureRecognizer *)swipe
{
    [self handleSwipe:swipe];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe
{
    if (self.pView.thumbnail1.alpha == 1) {
        [self onTapPic2:nil];
    } else {
        [self onTapPic1:nil];
    }
}

- (void)doHeartPic:(UITapGestureRecognizer *)tap
{
    if (tap.numberOfTapsRequired == 2) {
        UIImageView *largeHeart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"like-256.png"]];
        largeHeart.image = [largeHeart.image maskWithColor:[UIColor colorWithRed:1 green:0.07 blue:0.5 alpha:0.8]];
        largeHeart.center = self.pView.bigPic.center;
        [self.pView.bigPic addSubview:largeHeart];
        
        //largeHeart.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            //largeHeart.transform = CGAffineTransformIdentity;
            largeHeart.transform = CGAffineTransformMakeScale(0.01, 0.01);
        } completion:^(BOOL finished) {
            if (finished) {
                [largeHeart removeFromSuperview];
            }
        }];
    }
    
    [self doHeartPic];
}

- (void) doHeartPic
{
    int vote = 0; // 0 = no vote, 1 = image1, 2 = image2;
    
    // ****** UPDATE MODEL ******
    // you vote on your own pic
    if ([[[PFUser currentUser] objectId] isEqualToString:[self.q.author objectId]]) {
        if (self.q.youVoted == [NSNumber numberWithInteger:0]) {
            if (self.pView.thumbnail1.alpha == 1) {
                self.q.youVoted = [NSNumber numberWithInteger:1];
                vote = 1;
            } else {
                self.q.youVoted = [NSNumber numberWithInteger:2];
                vote = 2;
            }
        } else {
            self.q.youVoted = [NSNumber numberWithInteger:0];
            vote = 0;
        }
    } else { // you vote on a friend's pic
        if (self.q.vote == 0) {
            if (self.pView.thumbnail1.alpha == 1) {
                [self.q setVote:1];
                vote = 1;
            } else {
                [self.q setVote:2];
                vote = 2;
            }
        } else {
            [self.q setVote:0];
            vote = 0;
        }
    }
    [self.q saveInBackground];
    
    // ******** Update UI *********
    [self updateVoteCount];
    [self updateHeartIcon];

}

- (void) updateVoteCount {
    if (self.pView.thumbnail1.alpha == 1) {
        self.pView.numVotesLabel.text = [NSString stringWithFormat:@"%d", self.q.numVoted1];
    } else {
        self.pView.numVotesLabel.text = [NSString stringWithFormat:@"%d", self.q.numVoted2];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
