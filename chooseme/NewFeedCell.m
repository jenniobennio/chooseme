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

- (void)loadCell:(UIColor *)color
{
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"PictureView" owner:self options:nil];
    self.pView = [nibViews objectAtIndex:0];
    CGRect newFrame = self.pView.frame;
    newFrame.origin = CGPointMake(0, 0);
    self.pView.frame = newFrame;
    self.pView.bigPic.image = [UIImage imageNamed:@"111834.jpg"];
    [self.pView.thumbnail1 setImage:[UIImage imageNamed:@"111834.jpg"] forState:UIControlStateNormal];
    [self.pView.thumbnail2 setImage:[UIImage imageNamed:@"131466.jpg"] forState:UIControlStateNormal];
    self.pView.thumbnail1.layer.borderColor = [color CGColor];
    self.pView.thumbnail2.layer.borderColor = [color CGColor];
    [self.pView formatThumbnails];
    [self.pView highlightImage:1];
    [self.contentView addSubview:self.pView];
    
    nibViews = [[NSBundle mainBundle] loadNibNamed:@"UserQuestionView" owner:self options:nil];
    self.uqView = [nibViews objectAtIndex:0];
    newFrame = self.uqView.frame;
    newFrame.origin = CGPointMake(0, 368);
    self.uqView.frame = newFrame;
    self.uqView.colorView.backgroundColor = color;
    [self.contentView addSubview:self.uqView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
