//
//  CameraVC.h
//  chooseme
//
//  Created by Jenny Kwan on 2/7/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "QuestionVC.h"

@protocol CameraVCDelegate <NSObject>
-(void)previousPage:(NSUInteger)index;
-(void)nextPage:(NSUInteger)index;
@end

@interface CameraVC : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, QuestionVCDelegate>

// CameraVC's delegate will be the AppViewController for swipe navigating between pages
@property (nonatomic, weak) id<CameraVCDelegate> delegate;
// Index in pageViewController
@property (assign, nonatomic) NSInteger index;

@end
