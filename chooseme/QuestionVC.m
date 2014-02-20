//
//  QuestionVC.m
//  chooseme
//
//  Created by Jenny Kwan on 2/17/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "QuestionVC.h"

@interface QuestionVC ()

// View elements
@property (strong, nonatomic) IBOutlet UITextField *questionTextField;
@property (strong, nonatomic) IBOutlet UIButton *pic1;
@property (strong, nonatomic) IBOutlet UIButton *pic2;
@property (strong, nonatomic) IBOutlet UITableView *friendsTable;

// Button actions
- (IBAction)onBack:(id)sender;
- (IBAction)onSubmit:(id)sender;

- (IBAction)onPic1:(id)sender;
- (IBAction)onPic2:(id)sender;

// Friend picker things
@property (strong, nonatomic) FBFriendPickerViewController *friendPickerController;
@property (nonatomic, strong) NSMutableArray *friends;
@property (nonatomic, strong) NSMutableArray *friendsVoted;

// Private user data
@property (strong, nonatomic) NSString *myName;
@property (strong, nonatomic) UIImage *myPic;

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

    // Set delegates/ datasources
    self.questionTextField.delegate = self;
    self.friendsTable.delegate = self;
    self.friendsTable.dataSource = self;

    // Pre-fill images and format
    [self.pic1 setImage:self.image1 forState:UIControlStateNormal];
    self.pic1.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.pic2 setImage:self.image2 forState:UIControlStateNormal];
    self.pic2.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    // Pre-fill question text (for if we 1./ went Back or 2./ clicked one of the pics to redo)
    if (self.question.question)
        self.questionTextField.text = self.question.question;
    
    // Init friends
    self.friends = [[NSMutableArray alloc] init];
    self.friendsVoted = [[NSMutableArray alloc] init];
    
    // Don't show lines below available cells
    self.friendsTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Add pan gestureRecognizer for going Back
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self.view addGestureRecognizer:panGesture];
    
    // Create request for user's Facebook data
    FBRequest *request = [FBRequest requestForMe];
    
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            // Assign the data accordingly
            self.myName = name;
            self.myPic = [UIImage imageWithData:[NSData dataWithContentsOfURL:pictureURL]];
        }    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.friendsTable reloadData];
}

# pragma mark - actions from button presses

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSubmit:(id)sender {
    NSLog(@"Posting question.");
    
    self.question.author = [PFUser currentUser];
    self.question.profilePic = UIImageJPEGRepresentation(self.myPic, 0.05f);
    self.question.name = self.myName;
    
    self.question.time = [NSDate date];
    if (![self.questionTextField.text isEqualToString:@""])
        self.question.question = self.questionTextField.text;
    else
        self.question.question = @"Which one?";
    self.question.imageData1 = UIImageJPEGRepresentation(self.image1, 0.05f);
    self.question.imageData2 = UIImageJPEGRepresentation(self.image2, 0.05f);
    
    self.question.youVoted = [NSNumber numberWithInt:0];
    self.question.friends = self.friends;
    self.question.friendsVoted = self.friendsVoted;
    
    [self.question saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"successfully posted question");
            [self.delegate clearImages];
        } else {
            NSLog(@"failed to post question.");
        }
    }];
    
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


# pragma mark - UITextFieldDelegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Save question object's question attribute here in case the user presses any buttons while typing
    self.question.question = [NSString stringWithFormat:@"%@%@", self.questionTextField.text, string];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Pressing enter dismisses keyboard
    [textField resignFirstResponder];
    return YES;
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
        [self.friends addObject:user.name];
        [self.friendsVoted addObject:[NSNumber numberWithInt:0]];
    }
    
    NSLog(@"%@", text);
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - TableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSString *friend = self.friends[indexPath.row];
    cell.textLabel.text = friend;
    return cell;
}

#pragma mark - private methods

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
