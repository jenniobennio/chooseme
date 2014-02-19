//
//  CameraVC.h
//  chooseme
//
//  Created by Jenny Kwan on 2/7/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Question.h"
#import "QuestionVC.h"

@protocol CameraVCDelegate <NSObject>
-(void)previousPage:(NSUInteger)index;
-(void)nextPage:(NSUInteger)index;
@end

@interface CameraVC : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, FBFriendPickerDelegate, QuestionVCDelegate>

// CameraVC's delegate will be the AppViewController for swipe navigating between pages
@property (nonatomic, weak) id<CameraVCDelegate> delegate;
// Index to keep track of 
@property (assign, nonatomic) NSInteger index;

// Current Question object
@property (strong, nonatomic) Question *currentQuestion;

// Keep track of which thumbnail image is selected
@property (nonatomic, assign) int picIndex;

@property (strong, nonatomic) IBOutlet UIImageView *mainPic;
@property (strong, nonatomic) IBOutlet UIButton *takePicButton;
@property (strong, nonatomic) IBOutlet UIButton *choosePicButton;
@property (strong, nonatomic) IBOutlet UIButton *pic1;
@property (strong, nonatomic) IBOutlet UIButton *pic2;

- (IBAction)takePic:(id)sender;
- (IBAction)choosePic:(id)sender;
- (IBAction)onPic1:(id)sender;
- (IBAction)onPic2:(id)sender;
- (IBAction)onPost:(id)sender;
- (IBAction)onAddFriends:(id)sender;
- (IBAction)onMe:(id)sender;
- (IBAction)onFriends:(id)sender;

@end
