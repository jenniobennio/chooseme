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
@property (weak, nonatomic) IBOutlet UIImageView *bigPic;
@property (weak, nonatomic) IBOutlet UIView *bigPicBgColor;
@property (weak, nonatomic) IBOutlet UIButton *thumbnail1;
@property (weak, nonatomic) IBOutlet UIButton *thumbnail2;
@property (weak, nonatomic) IBOutlet UIScrollView *friendsVotedScrollView;
@property (weak, nonatomic) IBOutlet UILabel *numVotesLabel;
@property (weak, nonatomic) IBOutlet UILabel *numCommentsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *heartIcon;
@property (weak, nonatomic) IBOutlet UIImageView *commentIcon;
@property (weak, nonatomic) IBOutlet UIButton *xButton;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@property (assign, nonatomic) int highlightedIndex;
@property (strong, nonatomic) Question *q;

- (void)populateData:(Question *)question withColor:(UIColor *)color;
- (void)highlightImage:(int)index;
- (void)hideDetails;
- (void)update;

- (UIColor *) calculateTextColor:(UIImage *)img;

@end
