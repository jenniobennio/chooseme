//
//  FeedCell.m
//  chooseme
//
//  Created by Jenny Kwan on 2/9/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "FeedCell.h"

@implementation FeedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onVote1:(id)sender {
    self.youVoted1.selected = !self.youVoted1.selected;
    if (self.youVoted1.selected)
        self.youVoted2.selected = NO;
    
    int vote = 0;
    if (self.youVoted1.selected) {
        vote = 1;
    }
    
    [self.question setVote:vote];
    [self updateVoteCount];
    
}

- (IBAction)onVote2:(id)sender {
    self.youVoted2.selected = !self.youVoted2.selected;
    if (self.youVoted2.selected)
        self.youVoted1.selected = NO;
    
    int vote = 0;
    if (self.youVoted2.selected) {
        vote = 2;
    }
    
    [self.question setVote:vote];
    [self updateVoteCount];
}

- (void) updateVoteCount {
    self.voteCount.text = [NSString stringWithFormat:@"%d votes, %d comments", [self.question numReplies], [self.question numComments]];
    
    self.count1.text = [NSString stringWithFormat:@"%d", [self.question percentPic:1]];
    self.count2.text = [NSString stringWithFormat:@"%d", [self.question percentPic:2]];
}

- (void) updateVoteLabels {
    if ([[self.question youVoted] intValue] == 1) {
        [self.image1.layer setBorderColor:[[UIColor colorWithRed:0.753 green:0.878 blue:0.690 alpha:1] CGColor]];
        [self.image1.layer setBorderWidth:5.0];
    } else if ([[self.question youVoted] intValue] == 2) {
        [self.image2.layer setBorderColor:[[UIColor colorWithRed:0.753 green:0.878 blue:0.690 alpha:1] CGColor]];
        [self.image2.layer setBorderWidth:5.0];
    }
    
    if (self.isMyQuestion) {
        self.youVoted1.userInteractionEnabled = NO;
        self.youVoted2.userInteractionEnabled = NO;
        self.youVoted1.hidden = YES;
        self.youVoted2.hidden = YES;
        
        if (self.tapGestureRecognizer1 == nil) {
            self.image1.userInteractionEnabled = YES;
            self.tapGestureRecognizer1 = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(respondToTapGesture1)];
            [self.image1 addGestureRecognizer:self.tapGestureRecognizer1];
        }
        if (self.tapGestureRecognizer2 == nil) {
            self.image2.userInteractionEnabled = YES;
            self.tapGestureRecognizer2 = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(respondToTapGesture2)];
            [self.image2 addGestureRecognizer:self.tapGestureRecognizer2];
        }
        
    } else {
        int vote = [self.question vote];
        if (vote == 1) {
            self.youVoted1.selected = YES;
        } else if (vote == 2) {
            self.youVoted2.selected = YES;
        }
    }
}

- (void) respondToTapGesture1 {
    [self.image1.layer setBorderColor:[[UIColor colorWithRed:0.753 green:0.878 blue:0.690 alpha:1] CGColor]];
    [self.image1.layer setBorderWidth:5.0];
    
    // deselect image 2
    [self.image2.layer setBorderColor:[[UIColor colorWithRed:0.753 green:0.878 blue:0.690 alpha:1] CGColor]];
    [self.image2.layer setBorderWidth:0];
    
    // update model
    self.question.youVoted = [NSNumber numberWithInt:1];
    [self.question saveInBackground];
}

- (void) respondToTapGesture2 {
    [self.image2.layer setBorderColor:[[UIColor colorWithRed:0.753 green:0.878 blue:0.690 alpha:1] CGColor]];
    [self.image2.layer setBorderWidth:5.0];
    
    // deselect image 1
    [self.image1.layer setBorderColor:[[UIColor colorWithRed:0.753 green:0.878 blue:0.690 alpha:1] CGColor]];
    [self.image1.layer setBorderWidth:0];
    
    // update model
    self.question.youVoted = [NSNumber numberWithInt:2];
    [self.question saveInBackground];
}
@end
