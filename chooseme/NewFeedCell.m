//
//  NewFeedCell.m
//  chooseme
//
//  Created by Jenny Kwan on 2/28/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "NewFeedCell.h"

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
    UIImage *image1 = [UIImage imageWithData:q.imageData1];
    UIImage *image2 = [UIImage imageWithData:q.imageData2];
    
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

    // Set the big pig background color to fade from
    self.pView.bigPicBgColor.backgroundColor = color;
    // Load and fade in big pic
    [self reloadBigPic:image1];

    // Format the thumbnails
    self.pView.thumbnail1.layer.borderColor = [color CGColor];
    self.pView.thumbnail2.layer.borderColor = [color CGColor];
    [self.pView formatThumbnails];
    [self.pView highlightImage:1];
    
    // Format icons
    [self.pView colorIcons];
    
    // Set any text
    [self.pView updateVotes:q.numReplies];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
