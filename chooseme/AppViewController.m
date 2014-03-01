//
//  AppViewController.m
//  chooseme
//
//  Created by Jenny Kwan on 2/8/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "AppViewController.h"
#import "CameraVC.h"
#import "FeedVC.h"
#import "NewFeedVC.h"
#import <Parse/Parse.h>
@interface AppViewController ()

@property (nonatomic, strong) NewFeedVC *friendsQuestionsVC;
@property (nonatomic, strong) NewFeedVC *myQuestionsVC;

@end

@implementation AppViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.friendsQuestionsVC = [[NewFeedVC alloc] initWithNibName:@"NewFeedVC" bundle:nil];
    self.myQuestionsVC = [[NewFeedVC alloc]  initWithNibName:@"NewFeedVC" bundle:nil];
    
    // The permissions requested from the user
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    // Bypass login screen if a user is currently cached
    if (!([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])) // Check if user is linked to Facebook
    {
        // Login PFUser using Facebook
        // subha todo: put ui loading indicators
        [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
            if (!user) {
                if (!error) {
                    NSLog(@"Uh oh. The user cancelled the Facebook login.");
                } else {
                    NSLog(@"Uh oh. An error occurred: %@", error);
                }
            } else if (user.isNew) {
                NSLog(@"User with facebook signed up and logged in!");
                NSLog(@"%@", user);
            } else {
                NSLog(@"User with facebook logged in!");
                NSLog(@"%@", user);        }
        }];
    }
    
    self.pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageVC.dataSource = self;
    [[self.pageVC view] setFrame:[[self view] bounds]];
    
    UIViewController *initialViewController = [self viewControllerAtIndex:1];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageVC setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:self.pageVC];
    [[self view] addSubview:[self.pageVC view]];
    [self.pageVC didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index;
    
    if ([viewController isKindOfClass:[CameraVC class]])
        index = [(CameraVC *)viewController index];
    else
        index = [(NewFeedVC *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;

    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index;
    
    if ([viewController isKindOfClass:[CameraVC class]])
        index = [(CameraVC *)viewController index];
    else
        index = [(NewFeedVC *)viewController index];
    
    index++;
    
    if (index == 3) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if (index == 1) {
        CameraVC *childViewController = [[CameraVC alloc] initWithNibName:@"CameraVC" bundle:nil];
        childViewController.index = index;
        childViewController.delegate = self;
        return childViewController;
    } else if (index == 0){
        self.friendsQuestionsVC.index = index;
        self.friendsQuestionsVC.delegate = self;
        return self.friendsQuestionsVC;
    } else if (index == 2) {
        self.myQuestionsVC.index = index;
        self.myQuestionsVC.delegate = self;
        return self.myQuestionsVC;
    } else
        return nil;
    
    //        FeedVC *childViewController = [[FeedVC alloc] initWithNibName:@"FeedVC" bundle:nil];
    //        childViewController.index = index;
    //        childViewController.delegate = self;
    //        return childViewController;
}

- (void)previousPage:(NSUInteger)index
{
    UIViewController *initialViewController = [self viewControllerAtIndex:index-1];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageVC setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

- (void)nextPage:(NSUInteger)index
{
    UIViewController *initialViewController = [self viewControllerAtIndex:index+1];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageVC setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

@end
