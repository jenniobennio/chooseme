//
//  FeedCell.h
//  chooseme
//
//  Created by Jenny Kwan on 2/9/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@interface FeedCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *image1;
@property (strong, nonatomic) IBOutlet UIImageView *image2;
@property (strong, nonatomic) IBOutlet UILabel *count1;
@property (strong, nonatomic) IBOutlet UILabel *count2;
@property (strong, nonatomic) IBOutlet UILabel *voteCount;
@property (strong, nonatomic) IBOutlet UIButton *youVoted1;
@property (strong, nonatomic) IBOutlet UIButton *youVoted2;

@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer1;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer2;

@property (strong, nonatomic) Question *question;
@property (assign, nonatomic) int myVoteIndex;
@property (assign, nonatomic) BOOL isMyQuestion;
- (IBAction)onVote1:(id)sender;
- (IBAction)onVote2:(id)sender;

- (void)updateVoteCount;
- (void)updateVoteLabels;

- (void)respondToTapGesture1;
- (void)respondToTapGesture2;

@end