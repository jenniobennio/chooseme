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
}

- (IBAction)onVote2:(id)sender {
    self.youVoted2.selected = !self.youVoted2.selected;
    if (self.youVoted2.selected)
        self.youVoted1.selected = NO;
}
@end
