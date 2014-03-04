//
//  PictureView.h
//  chooseme
//
//  Created by Jenny Kwan on 2/28/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@interface PictureView : UIView <UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *bigPic;
@property (strong, nonatomic) IBOutlet UIView *bigPicBgColor;
@property (strong, nonatomic) IBOutlet UIButton *thumbnail1;
@property (strong, nonatomic) IBOutlet UIButton *thumbnail2;
@property (strong, nonatomic) IBOutlet UIScrollView *friendsVotedScrollView;
@property (strong, nonatomic) IBOutlet UILabel *numVotesLabel;
@property (strong, nonatomic) IBOutlet UILabel *numCommentsLabel;
@property (strong, nonatomic) IBOutlet UIImageView *heartIcon;
@property (strong, nonatomic) IBOutlet UIImageView *commentIcon;
@property (strong, nonatomic) IBOutlet UIButton *xButton;
@property (strong, nonatomic) IBOutlet UILabel *questionLabel;

- (void)hideDetails;
- (void)formatThumbnails;
- (void)colorIcons:(UIImage *)image;
- (UIColor *) calculateTextColor:(UIImage *)img;
- (void)highlightImage:(int)index;
- (void)updateComments:(int)comments;
- (void)updatePercentages:(Question *)q;
- (void)populateData:(Question *)question withColor:(UIColor *)color;

@end
