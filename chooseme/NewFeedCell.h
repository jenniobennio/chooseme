//
//  NewFeedCell.h
//  chooseme
//
//  Created by Jenny Kwan on 2/28/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureView.h"
#import "UserQuestionView.h"
#import "Question.h"

@interface NewFeedCell : UITableViewCell <UIGestureRecognizerDelegate>

@property (strong, nonatomic) PictureView *pView;
@property (strong, nonatomic) UserQuestionView *uqView;
@property (strong, nonatomic) Question *q;

@property (strong, nonatomic) UITapGestureRecognizer *doubleTap;

- (void)reloadUserPic:(UIImage *)userImage;
- (void)reloadBigPic:(UIImage *)image1;
//- (void)loadCell:(UIColor *)color withImage1:(UIImage *)image1 withImage2:(UIImage *)image2 withUserImage:(UIImage *)userImage;
- (void)loadCell:(UIColor *)color withQuestion:(Question *)q withUserImage:(UIImage *)userImage;


@end
