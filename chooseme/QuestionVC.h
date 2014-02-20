//
//  QuestionVC.h
//  chooseme
//
//  Created by Jenny Kwan on 2/17/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@protocol QuestionVCDelegate <NSObject>
- (void)pictureClicked:(int)picNum;
- (void)clearImages;
@end

@interface QuestionVC : UIViewController <UITextFieldDelegate, FBFriendPickerDelegate, UITableViewDelegate, UITableViewDataSource>
// CameraVC will be its delegate so we can pass it information (e.g. which pic was selected to redo, whether we submitted)
@property (nonatomic, weak) id <QuestionVCDelegate> delegate;

// Current Question object
@property (nonatomic, strong) Question *question;
@property (nonatomic, strong) UIImage *image1;
@property (nonatomic, strong) UIImage *image2;

@end
