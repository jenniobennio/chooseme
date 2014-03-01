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

@interface NewFeedCell : UITableViewCell

@property (strong, nonatomic) PictureView *pView;
@property (strong, nonatomic) UserQuestionView *uqView;

- (void)loadCell:(UIColor *)color;

@end
