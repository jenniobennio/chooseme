//
//  PostVC.m
//  chooseme
//
//  Created by Jenny Kwan on 2/9/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "PostVC.h"

@interface PostVC ()
@property (nonatomic, assign) BOOL interactionInProgress;

@end

@implementation PostVC

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

    UISwipeGestureRecognizer *swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeDown:)];
    swipeDownGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDownGesture];
    
    self.name.text = self.post.name;
    self.question.text = self.post.question;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onSwipeDown:(UIGestureRecognizer *) sender
{
    // Should this gesture be changed to pan?
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Down swipe recognized: began");
        self.interactionInProgress = YES;

    }
    else if (sender.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Down swipe recognized: changed");
        
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"Down swipe recognized: ended");
        self.interactionInProgress = NO;

        [self dismissViewControllerAnimated:YES completion:nil];
    }
    

}
@end
