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
}

- (void) updateVoteLabels {
    if (self.isMyQuestion) {
        self.youVoted1.userInteractionEnabled = NO;
        self.youVoted2.userInteractionEnabled = NO;
        self.youVoted1.hidden = YES;
        self.youVoted2.hidden = YES;
    } else {
        int vote = [self.question vote];
        if (vote == 1) {
            self.youVoted1.selected = YES;
        } else if (vote == 2) {
            self.youVoted2.selected = YES;
        }
    }
}
@end
