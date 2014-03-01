//
//  UserQuestionView.h
//  chooseme
//
//  Created by Jenny Kwan on 2/28/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserQuestionView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *userPic;
@property (strong, nonatomic) IBOutlet UIView *userPicBgColor;
@property (strong, nonatomic) IBOutlet UIView *colorView;
@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timestampLabel;

@end
