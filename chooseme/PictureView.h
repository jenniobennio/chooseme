//
//  PictureView.h
//  chooseme
//
//  Created by Jenny Kwan on 2/28/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *bigPic;
@property (strong, nonatomic) IBOutlet UIButton *thumbnail1;
@property (strong, nonatomic) IBOutlet UIButton *thumbnail2;
@property (strong, nonatomic) IBOutlet UIScrollView *friendsVotedScrollView;
@property (strong, nonatomic) IBOutlet UILabel *numVotesLabel;
@property (strong, nonatomic) IBOutlet UILabel *numCommentsLabel;

- (void)formatThumbnails;
- (void)highlightImage:(int)index;

@end
