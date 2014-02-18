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

@protocol CameraVCDelegate <NSObject>
-(void)previousPage:(NSUInteger)index;
-(void)nextPage:(NSUInteger)index;
@end

@interface CameraVC : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, FBFriendPickerDelegate>

@property (nonatomic, weak) id<CameraVCDelegate> delegate;
@property (assign, nonatomic) NSInteger index;

@property (strong, nonatomic) IBOutlet UIImageView *mainPic;
@property (strong, nonatomic) IBOutlet UIButton *takePicButton;
@property (strong, nonatomic) IBOutlet UIButton *choosePicButton;
@property (strong, nonatomic) IBOutlet UIButton *pic1;
@property (strong, nonatomic) IBOutlet UIButton *pic2;
@property (strong, nonatomic) Question *currentQuestion;

@property (nonatomic) int picIndex;
- (IBAction)takePic:(id)sender;
- (IBAction)choosePic:(id)sender;
- (IBAction)onPic1:(id)sender;
- (IBAction)onPic2:(id)sender;
- (IBAction)onPost:(id)sender;
- (IBAction)onAddFriends:(id)sender;

- (IBAction)onMe:(id)sender;
- (IBAction)onFriends:(id)sender;

@end
