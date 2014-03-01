//
//  PostVC.m
//  chooseme
//
//  Created by Jenny Kwan on 2/9/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "PostVC.h"

@interface PostVC ()

// View elements
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *question;
@property (strong, nonatomic) IBOutlet UIImageView *image1;
@property (strong, nonatomic) IBOutlet UIImageView *image2;
@property (strong, nonatomic) IBOutlet UILabel *count1;
@property (strong, nonatomic) IBOutlet UILabel *count2;
@property (strong, nonatomic) IBOutlet UILabel *numVoted1;
@property (strong, nonatomic) IBOutlet UILabel *numVoted2;
@property (strong, nonatomic) IBOutlet UIScrollView *friendsVoted1;
@property (strong, nonatomic) IBOutlet UIScrollView *friendsVoted2;

// Button actions
- (IBAction)onBack:(id)sender;

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

    // Add pan gestureRecognizer for going Back
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self.view addGestureRecognizer:panGesture];
    
    // Load and display Question data
    self.profilePic.image = self.posterImage;
    self.name.text = self.post.name;
    self.time.text = [self.post formattedDate];
    self.question.text = self.post.question;
    self.image1.image = self.post.image1;
    self.image2.image = self.post.image2;
    self.count1.text = [NSString stringWithFormat:@"%d", [self.post percentPic:1]];
    self.count2.text = [NSString stringWithFormat:@"%d", [self.post percentPic:2]];
    self.numVoted1.text = [NSString stringWithFormat:@"%d", [self.post numVoted1]];
    self.numVoted2.text = [NSString stringWithFormat:@"%d", [self.post numVoted2]];
}

# pragma mark - actions from button presses

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - private methods

- (void)onPan:(UIPanGestureRecognizer *) sender
{
    // TODO: Make this more smooth
    if (sender.state == UIGestureRecognizerStateBegan) {
    }
    else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:self.view];
        self.view.center = CGPointMake(self.view.frame.size.width/2, translation.y + self.view.frame.size.height/2);
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint translation = [sender translationInView:self.view];
        if (translation.y > 100)
            [self dismissViewControllerAnimated:YES completion:nil];
        else
            self.view.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    }
    

}
@end
