//
//  QuestionVC.m
//  chooseme
//
//  Created by Jenny Kwan on 2/17/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "QuestionVC.h"
#import "AddFriendCell.h"
#import "PictureView.h"
#import "UIImage+mask.h"
#import "FriendCell.h"
#import "Colorful.h"
#import "QuestionKeeper.h"
#import "FacebookClient.h"

@interface QuestionVC ()

// View elements
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UITextField *questionTextField;
@property (strong, nonatomic) IBOutlet UICollectionView *friendsView;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIButton *addFriendButton;
@property (strong, nonatomic) IBOutlet PictureView *fakePView;

@property (strong, nonatomic) PictureView *pView;

// Button actions
- (IBAction)onBack:(id)sender;
- (IBAction)onSubmit:(id)sender;
- (IBAction)onEdit:(id)sender;
- (IBAction)onAddFriends:(id)sender;

- (void)onPic1;
- (void)onPic2;

// Friend picker + search bar
@property (strong, nonatomic) FBFriendPickerViewController *friendPickerController;
@property (retain, nonatomic) UISearchBar *searchBar;
@property (retain, nonatomic) NSString *searchText;

// Private user data
@property (strong, nonatomic) NSString *myName;
@property (strong, nonatomic) UIImage *myPic;
@property (strong, nonatomic) NSString *facebookID;

// Which pic to edit
@property (nonatomic, assign) int editIndex;

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
    [self.friendsView registerClass:[FriendCell class] forCellWithReuseIdentifier:@"FriendCell"];
    [self.friendsView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellWithReuseIdentifier:@"FriendCell"];
    self.friendsView.delegate = self;
    self.friendsView.dataSource = self;
    self.friendsView.backgroundColor = [UIColor clearColor];
    
    // Format title bar
    Colorful *colorManager = [Colorful sharedManager];
    UIColor *color = [colorManager currentColor];
    self.view.backgroundColor = color;
    self.titleView.backgroundColor = [UIColor clearColor]; // so that it's not super dark
    self.titleLabel.text = @"Post";
    
    self.backButton.imageView.image = [self.backButton.imageView.image maskWithColor:[UIColor whiteColor]];
    self.submitButton.imageView.image = [self.submitButton.imageView.image maskWithColor:[UIColor whiteColor]];
    self.editButton.layer.cornerRadius = 25;
    self.addFriendButton.imageView.image = [self.addFriendButton.imageView.image maskWithColor:[UIColor whiteColor]];

    // Pre-fill images and format
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"PictureView" owner:self options:nil];
    self.pView = [nibViews objectAtIndex:0];
    self.pView.frame = CGRectMake(0, 64, self.view.frame.size.width, 344);

    [self.pView.bigPic setImage:self.image1];
    [self.pView.thumbnail1 setBackgroundImage:self.image1 forState:UIControlStateNormal];
    [self.pView.thumbnail2 setBackgroundImage:self.image2 forState:UIControlStateNormal];

    [self.pView populateData:self.question withColor:color andLoad:NO];
    
    // fakePView was used to set up autolayout constraints, so send it all the way to the back
    // pView contains the actual image data, etc
    [self.view addSubview:self.pView];
    [self.view sendSubviewToBack:self.pView];
    [self.view sendSubviewToBack:self.fakePView];
    
    NSLog(@"QuestionVC viewDidLoad");
    
    [self.pView hideDetails];

    // Set up button touch actions
    self.editIndex = 1;
    [self.pView.thumbnail1 addTarget:self action:@selector(onTapPic1:) forControlEvents:UIControlEventTouchUpInside];
    [self.pView.thumbnail2 addTarget:self action:@selector(onTapPic2:) forControlEvents:UIControlEventTouchUpInside];
    
    // Format question textField
    UIColor *textcolor = [self.pView calculateTextColor:self.question.image1];
    self.questionTextField.textColor = textcolor;
    self.questionTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    self.questionTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Share a thought" attributes:@{NSForegroundColorAttributeName: textcolor}];

    // Load question text
    if (self.question.question)
        self.questionTextField.text = self.question.question;
    
    // Load friends
    if (!self.question.friends) {
        self.question.friends = [[NSMutableArray alloc] init];
        self.question.friendsVoted = [[NSMutableArray alloc] init];
        self.question.friendsCommenting = [[NSMutableArray alloc] init];
        self.question.friendsComments = [[NSMutableArray alloc] init];
    }
    // Submit button enabled only if at least one friend added
    [self.submitButton setEnabled:self.question.friends.count > 0];
    
    // Add pan gestureRecognizer for going Back
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self.view addGestureRecognizer:panGesture];
    
    // Create request for user's Facebook data
    void (^onSuccess)(void) = ^{
        FacebookClient *facebookClient = [FacebookClient instance];
        
        self.myName = [facebookClient myName];
        self.facebookID = [facebookClient myFacebookID];
        self.myPic = [facebookClient myPic];
    };
    if ([[FacebookClient instance] myFacebookID] == nil) { // hasn't loaded yet
        [[FacebookClient instance] meRequest:onSuccess];
    } else {
        onSuccess();
    }
    
    // Create a cache descriptor based on the default friend picker data fetch settings
    self.cacheDescriptor = [[FacebookClient instance] loadCache];
}

- (void)viewDidUnload
{
    self.searchBar = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.addFriendButton.imageView.image = [self.addFriendButton.imageView.image maskWithColor:[UIColor whiteColor]];
    [self.friendsView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.question.question = self.questionTextField.text;
}

# pragma mark - actions from button presses

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSubmit:(id)sender {
    NSLog(@"Posting question with ID %@", self.question.objectId);
    
    self.question.facebookID = self.facebookID;
    self.question.author = [PFUser currentUser];
    self.question.name = self.myName;
    
    self.question.time = [NSDate date];
    if (![self.questionTextField.text isEqualToString:@""])
        self.question.question = self.questionTextField.text;
    else
        self.question.question = @"Which one?";

    self.question.youVoted = [NSNumber numberWithInt:0];
    
//    [[FacebookClient instance] postToFriend:self.question];
    
    [self.question saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"successfully posted question");
        } else {
            NSLog(@"failed to post question.");
        }
    }];
    
    // Pick the next color
    // Note that we go backwards so that feed can go forward
    Colorful *colorManager = [Colorful sharedManager];
    if (colorManager.colorIndex == 0)
        colorManager.colorIndex = colorManager.colors.count-1;
    else
        colorManager.colorIndex = colorManager.colorIndex-1;
    
    [[QuestionKeeper instance] setLastPosted:self.question];
    
    [self.delegate clearImages:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onEdit:(id)sender {
    if (self.editIndex == 1)
        [self onPic1];
    else
        [self onPic2];
}

- (void)onPic1 {
    NSLog(@"Selected pic1 to redo");
    [self.delegate pictureClicked:1];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onPic2 {
    NSLog(@"Selected pic2 to redo");
    [self.delegate pictureClicked:2];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onAddFriends:(id)sender {
    if (self.friendPickerController == nil) {
        // Create friend picker, and get data loaded into it.
        self.friendPickerController = [[FBFriendPickerViewController alloc] init];
        [self.friendPickerController configureUsingCachedDescriptor:self.cacheDescriptor];
        self.friendPickerController.title = @"Pick Friends";
        self.friendPickerController.delegate = self;
    }
    
    [self.friendPickerController loadData];
    [self.friendPickerController clearSelection];
    
    // FIXME: Is there a better place I can add the SearchBar so that it doesn't come after the friendPicker view has loaded?
    [self presentViewController:self.friendPickerController animated:YES completion:^(void) {
        [self addSearchBarToFriendPickerView];
        [self.searchBar becomeFirstResponder];
    }];
}


# pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Pressing enter dismisses keyboard
    [textField resignFirstResponder];
    return YES;
}

# pragma mark - facebook friend picker delegate methods
- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker shouldIncludeUser:(id<FBGraphUser>)user {
    if ([self.question.friends containsObject:user])
        return NO;
    
    if (self.searchText && ![self.searchText isEqualToString:@""]) {
        NSRange result = [user.name
                          rangeOfString:self.searchText
                          options:NSCaseInsensitiveSearch];
        if (result.location != NSNotFound) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return YES;
    }
    return YES;
}

- (void)facebookViewControllerCancelWasPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
        [self.question.friends addObject:user];
        
        // everyone starts out as never having voted
        [self.question.friendsVoted addObject:[NSNumber numberWithInt:0]];
    }
    
    [self.submitButton setEnabled:self.question.friends.count > 0];
    self.submitButton.imageView.image = [self.submitButton.imageView.image maskWithColor:[UIColor whiteColor]];
    
    NSLog(@"%@", text);
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker
{
    [self clearSearch];
}

# pragma mark - UISearchBar delegate methods
- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
{
    [self handleSearch:searchBar];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [self clearSearch];
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""]) {
        [self clearSearch];
    } else {
        [self handleSearch:self.searchBar];
    }
}

# pragma mark - collection view methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.question.friends.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FriendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FriendCell" forIndexPath:indexPath];
    
//    NSString *friend = [self.question.friends[indexPath.row] name];
    NSString *strurl = [[NSString alloc] initWithFormat:@"https://graph.facebook.com/%@/picture",[[self.question.friends objectAtIndex:indexPath.row] objectForKey:@"id"]];
    NSURL *url = [NSURL URLWithString:strurl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    [cell.friendImage setImage:[[UIImage alloc] initWithData:data]];
    cell.friendImage.layer.cornerRadius = 25;
    cell.friendImage.clipsToBounds = YES;

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
        if (translation.y > 0)
            self.view.center = CGPointMake(self.view.frame.size.width/2, translation.y + self.view.frame.size.height/2);
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint translation = [sender translationInView:self.view];
        if (translation.y > 100)
            [self dismissViewControllerAnimated:YES completion:nil];
        else {
            [UIView animateWithDuration:0.5f animations:^{
                self.view.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
            }];
        }
    }
    
}

- (void)addSearchBarToFriendPickerView
{
    if (self.searchBar == nil) {
        CGFloat searchBarHeight = 44.0;
        self.searchBar =
        [[UISearchBar alloc]
         initWithFrame:
         CGRectMake(0,0,
                    self.view.bounds.size.width,
                    searchBarHeight)];
        self.searchBar.autoresizingMask = self.searchBar.autoresizingMask |
        UIViewAutoresizingFlexibleWidth;
        self.searchBar.delegate = self;
//        self.searchBar.showsCancelButton = YES;
        
        [self.friendPickerController.canvasView addSubview:self.searchBar];
        CGRect newFrame = self.friendPickerController.view.bounds;
        newFrame.size.height -= searchBarHeight;
        newFrame.origin.y = searchBarHeight;
        self.friendPickerController.tableView.frame = newFrame;
        
    }
}

- (void) handleSearch:(UISearchBar *)searchBar {
    self.searchText = searchBar.text;
    [self.friendPickerController updateView];
}

- (void) clearSearch {
    self.searchBar.text = @"";
    self.searchText = nil;
    [self.friendPickerController updateView];
}

- (void)onTapPic1:(UIButton *)button
{
    self.editIndex = 1;
    [self.pView highlightImage:1];
    
    UIColor *textcolor = [self.pView calculateTextColor:self.question.image1];
    self.questionTextField.textColor = textcolor;
    self.questionTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Share a thought" attributes:@{NSForegroundColorAttributeName: textcolor}];

}

- (void)onTapPic2:(UIButton *)button
{
    self.editIndex = 2;
    [self.pView highlightImage:2];
    
    UIColor *textcolor = [self.pView calculateTextColor:self.question.image2];
    self.questionTextField.textColor = textcolor;
    self.questionTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Share a thought" attributes:@{NSForegroundColorAttributeName: textcolor}];

}

@end
