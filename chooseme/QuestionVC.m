//
//  QuestionVC.m
//  chooseme
//
//  Created by Jenny Kwan on 2/17/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "QuestionVC.h"

@interface QuestionVC ()
@property (strong, nonatomic) IBOutlet UIButton *pic1;
@property (strong, nonatomic) IBOutlet UIButton *pic2;
@property (strong, nonatomic) FBFriendPickerViewController *friendPickerController;

- (IBAction)onBack:(id)sender;
- (IBAction)onSubmit:(id)sender;

- (IBAction)onPic1:(id)sender;
- (IBAction)onPic2:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *questionTextField;

@end

@implementation QuestionVC

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
    self.questionTextField.delegate = self;

    [self.pic1 setImage:self.image1 forState:UIControlStateNormal];
    self.pic1.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.pic2 setImage:self.image2 forState:UIControlStateNormal];
    self.pic2.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)onSubmit:(id)sender {
    // TODO: Upload images to server
    
    NSLog(@"Posting question.");
    
    self.question.author = [PFUser currentUser];
    [self.question saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"successfully posted question");
        } else {
            NSLog(@"failed to post question.");
        }
    }];
    
    [self.delegate clearImages];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onPic1:(id)sender {
    NSLog(@"Selected pic1 to redo");
    [self.delegate pictureClicked:1];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onPic2:(id)sender {
    NSLog(@"Selected pic2 to redo");
    [self.delegate pictureClicked:2];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)onAddFriends:(id)sender {
    if (self.friendPickerController == nil) {
        // Create friend picker, and get data loaded into it.
        self.friendPickerController = [[FBFriendPickerViewController alloc] init];
        self.friendPickerController.title = @"Pick Friends";
        self.friendPickerController.delegate = self;
    }
    
    [self.friendPickerController loadData];
    [self.friendPickerController clearSelection];
    
    [self presentViewController:self.friendPickerController animated:YES completion:nil];
}


# pragma mark - facebook friend picker delegate methods
- (void)facebookViewControllerDoneWasPressed:(id)sender {
    NSLog(@"getting done press.");
    NSMutableString *text = [[NSMutableString alloc] init];
    
    // we pick up the users from the selection, and create a string that we use to update the text view
    // at the bottom of the display; note that self.selection is a property inherited from our base class
    for (id<FBGraphUser> user in self.friendPickerController.selection) {
        if ([text length]) {
            [text appendString:@", "];
        }
        [text appendString:user.name];
    }
    
    NSLog(@"%@", text);
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
