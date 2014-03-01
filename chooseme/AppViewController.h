//
//  AppViewController.h
//  chooseme
//
//  Created by Jenny Kwan on 2/8/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraVC.h"
#import "NewFeedVC.h"

@interface AppViewController : UIViewController <UIPageViewControllerDataSource, CameraVCDelegate, NewFeedVCDelegate>

@property (strong, nonatomic) UIPageViewController *pageVC;
@end
