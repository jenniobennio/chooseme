//
//  PostVC.h
//  chooseme
//
//  Created by Jenny Kwan on 2/9/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@interface PostVC : UIViewController

@property (nonatomic, strong) Question *post;
@property (strong, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *question;
@property (strong, nonatomic) IBOutlet UIImageView *image1;
@property (strong, nonatomic) IBOutlet UIImageView *image2;
@property (strong, nonatomic) IBOutlet UILabel *count1;
@property (strong, nonatomic) IBOutlet UILabel *count2;
@property (strong, nonatomic) IBOutlet UILabel *youVoted1;
@property (strong, nonatomic) IBOutlet UILabel *youVoted2;

- (IBAction)onBack:(id)sender;
@end
