//
//  CameraVC.m
//  chooseme
//
//  Created by Jenny Kwan on 2/7/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "CameraVC.h"
#import "Question.h"
#import "UIImage+mask.h"
#import "UIImageView+AFNetworking.h"
#import "FacebookClient.h"
#import "PinterestClient.h"
#import "GoogleVC.h"
#import "Colorful.h"
#import "AwesomeMenuItem.h"
#import "QuestionKeeper.h"

@interface CameraVC ()

// View elements
@property (strong, nonatomic) IBOutlet UIImageView *mainPic;
@property (strong, nonatomic) IBOutlet UIButton *pic1;
@property (strong, nonatomic) IBOutlet UIButton *pic2;

@property (strong, nonatomic) IBOutlet UIButton *takePicButton;
@property (strong, nonatomic) IBOutlet UIButton *friendsButton;
@property (strong, nonatomic) IBOutlet UIButton *meButton;

@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *pinterestButton;
@property (weak, nonatomic) IBOutlet UIButton *galleryButton;

// Button actions
- (IBAction)onPic1:(id)sender;
- (IBAction)onPic2:(id)sender;

- (IBAction)takePic:(id)sender;
- (IBAction)onFriends:(id)sender;
- (IBAction)onMe:(id)sender;

- (IBAction)choosePicSource:(id)sender;
- (IBAction)choosePicFromGallery:(id)sender;
- (IBAction)choosePicFromPinterest:(id)sender;
- (IBAction)choosePicFromGoogle:(id)sender;

// Private variables:
// Random themed color
@property (nonatomic, strong) Colorful *colorManager;

// Current Question object
@property (strong, nonatomic) Question *currentQuestion;

// Keep track of which thumbnail image is selected
@property (nonatomic, assign) int picIndex;

// Store images
@property (strong, nonatomic) UIImage *image1;
@property (strong, nonatomic) UIImage *image2;

// Private variable for checking whether we just selected some image
@property (nonatomic, assign) BOOL justSelectedImage;

// For setting default picture source
@property (weak, nonatomic) UIButton *defaultPicSource;
@property (nonatomic) BOOL shouldSetDefaultPicSource;

// BOOL to track whether Pinterest is default image source -- this affects formatting for image insets
@property (nonatomic, assign) BOOL pinterestIsDefault;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) AwesomeMenuItem *startButton;

@end

@implementation CameraVC

@synthesize window = _window;

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
    
    self.picIndex = 0;
    
    // Pick a random color
    self.colorManager = [Colorful sharedManager];
    [self.colorManager randColor];
    
    // Init currentQuestion
    self.currentQuestion = [[Question alloc] init];
    
    // Format thumbnail buttons
    [self formatPic:self.pic1 isSelected:YES];
    [self formatPic:self.pic2 isSelected:NO];
    
    // *************** Initialize Menu *********************************
    self.takePicButton.hidden = YES;
    
    UIImage *cameraImage = [UIImage imageNamed:@"slr_camera-32.png"];
    UIImage *searchImage = [UIImage imageNamed:@"search-32.png"];
    UIImage *pinterestImage = [UIImage imageNamed:@"pinterest-32.png"];
    UIImage *galleryImage = [UIImage imageNamed:@"stack_of_photos-32.png"];
    UIImage *plusImage = [UIImage imageNamed:@"plus-50.png"];
    
    AwesomeMenuItem *cameraItem = [[AwesomeMenuItem alloc] initWithImage:cameraImage];
    AwesomeMenuItem *searchItem = [[AwesomeMenuItem alloc] initWithImage:searchImage];
    AwesomeMenuItem *pinterestItem = [[AwesomeMenuItem alloc] initWithImage:pinterestImage];
    AwesomeMenuItem *galleryItem = [[AwesomeMenuItem alloc] initWithImage:galleryImage];
    
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initStartWithImage:plusImage];
    self.startButton = startItem;
    
    NSArray *menus = [NSArray arrayWithObjects:cameraItem, searchItem, pinterestItem, galleryItem, nil];
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:self.window.bounds startItem:startItem optionMenus:menus];
    [self.view addSubview:menu];
    
    menu.delegate = self;
    
    //******************************************************************

    // Customize takePicButton depending on state
    /*self.takePicButton.layer.cornerRadius = 25;
    [self.takePicButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self.takePicButton setTitle:@"+" forState:UIControlStateNormal];
    [self.takePicButton setTitle:@"REDO" forState:UIControlStateSelected];
    // Add a long press gesture recognizer
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(takePicButtonLongPress)];
    longPressRecognizer.delegate = self;
    longPressRecognizer.minimumPressDuration = 1.0; //seconds
    [self.takePicButton addGestureRecognizer:longPressRecognizer];*/

    // Mask friends/ me buttons with white color
    [self.friendsButton setImage:[[UIImage imageNamed:@"112-group.png"] maskWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.meButton setImage:[[UIImage imageNamed:@"111-user.png"] maskWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    // Pre Fetching
    void (^success)(void) = ^void {
        [PinterestClient instance]; // Pinterest depends on facebook id values.
    };
    [[FacebookClient instance] meRequest:success];
    
    [QuestionKeeper instance];
    
    // Load question hack
    
    
    // Error if camera doesn't exist
    /*if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    }*/
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // Set mainPic not hidden
    self.mainPic.hidden = NO;
    
    // Set colors
    UIColor *color = [self.colorManager currentColor];
    self.takePicButton.backgroundColor = color;
    self.pic1.layer.borderColor = [color CGColor];
    self.pic2.layer.borderColor = [color CGColor];
    
    [self.startButton recolor];
    
    // Set insets
    [self setInsets];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // If both images are set (and just selected an image for redo), go to questionVC
    if (self.justSelectedImage) {
        [self goToQuestionVC];
    }
}

# pragma mark - actions from button presses

- (IBAction)onPic1:(id)sender {
    if (self.currentQuestion.image1) {
        // REDO pic
        self.takePicButton.selected = YES;
    } else {
        self.takePicButton.selected = NO;
    }
    [self setInsets];
    
    [self selectPic:0];

    if (self.pic1.imageView.image) {
        self.mainPic.image = self.pic1.imageView.image;
        self.mainPic.alpha = 0.0f;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5f];
        self.mainPic.alpha = 1.0f;
        [UIView commitAnimations];
    } else
        self.mainPic.image = self.pic1.imageView.image;
    
    // Add these lines so we don't need the dumb-looking arrow
//    if (self.pic1.imageView.image && self.pic2.imageView.image)
//        [self goToQuestionVC];
}

- (IBAction)onPic2:(id)sender {
    if (self.currentQuestion.image2) {
        // REDO pic
        self.takePicButton.selected = YES;
    } else {
        self.takePicButton.selected = NO;
    }
    [self setInsets];
    
    [self selectPic:1];
    
    if (self.pic2.imageView.image) {
        self.mainPic.image = self.pic2.imageView.image;
        self.mainPic.alpha = 0.0f;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        self.mainPic.alpha = 1.0f;
        [UIView commitAnimations];
    } else
        self.mainPic.image = self.pic2.imageView.image;
    
    // Add these lines so we don't need the dumb-looking arrow
//    if (self.pic1.imageView.image && self.pic2.imageView.image)
//        [self goToQuestionVC];
}

- (IBAction)onMe:(id)sender {
    [self.delegate nextPage:self.index];
}

- (IBAction)onFriends:(id)sender {
    [self.delegate previousPage:self.index];
}

- (IBAction)choosePicSource:(id)sender {
    NSLog(@"choose pic source.");
    
    if (self.defaultPicSource != nil) {
        if (self.defaultPicSource == self.galleryButton) {
            [self choosePicFromGallery:nil];
        } else if (self.defaultPicSource == self.pinterestButton) {
            [self choosePicFromPinterest:nil];
        } else if (self.defaultPicSource == self.searchButton) {
            [self choosePicFromGoogle:nil];
        } else {
            [self takePicFromCamera];
        }
        return;
    }
    
    if (self.galleryButton.hidden) {
        self.galleryButton.hidden = NO;
        self.cameraButton.hidden = NO;
        self.pinterestButton.hidden = NO;
        self.searchButton.hidden = NO;
    } else {
        [self hideImageSourceButtons];
        
        // If both images filled, go back to QuestionVC
        [self goToQuestionVC];
    }
}

- (void) takePicButtonLongPress {
    NSLog(@"receving long press.");
    self.shouldSetDefaultPicSource = true;
    
    if (self.galleryButton.hidden) {
        self.galleryButton.hidden = NO;
        self.cameraButton.hidden = NO;
        self.pinterestButton.hidden = NO;
        self.searchButton.hidden = NO;
    }
}

- (IBAction)takePic:(id)sender {
    [self hideImageSourceButtons];
    
    // Choosing pic from library when camera isn't available
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        [self takePicFromCamera];
    else
        [self choosePicFromLib];
    
    // If both images are set, go to questionVC
    [self goToQuestionVC];
    
}

- (IBAction)choosePicFromGallery:(id)sender {
    NSLog(@"choose pic from gallery");
    if (self.shouldSetDefaultPicSource) {
        self.defaultPicSource = self.galleryButton;
        [self.takePicButton setImage:[UIImage imageNamed:@"stack_of_photos-128.png"] forState:UIControlStateNormal];
        self.pinterestIsDefault = NO;
        self.takePicButton.titleLabel.text = @"";
        self.shouldSetDefaultPicSource = NO;
    }
    [self choosePicFromLib];
    [self hideImageSourceButtons];
}

- (IBAction)choosePicFromPinterest:(id)sender {
    NSLog(@"choose pic from pinterest.");
    if (self.shouldSetDefaultPicSource) {
        self.defaultPicSource = self.pinterestButton;
        [self.takePicButton setImage:[UIImage imageNamed:@"pinterest-128.png"] forState:UIControlStateNormal];
        self.pinterestIsDefault = YES;
        self.takePicButton.titleLabel.text = @"";
        self.shouldSetDefaultPicSource = NO;
    }
    [self hideImageSourceButtons];
    
    PinterestVC *pinterestVC = [[PinterestVC alloc] initWithNibName:@"PinterestVC" bundle:nil];
    pinterestVC.delegate = self;
    [self presentViewController:pinterestVC animated:YES completion:nil];
}

- (IBAction)choosePicFromGoogle:(id)sender {
    NSLog(@"choose pic from google.");
    if (self.shouldSetDefaultPicSource) {
        self.defaultPicSource = self.searchButton;
        [self.takePicButton setImage:[UIImage imageNamed:@"search-128.png"] forState:UIControlStateNormal];
        self.pinterestIsDefault = NO;
        self.takePicButton.titleLabel.text = @"";
        self.shouldSetDefaultPicSource = NO;
    }
    [self hideImageSourceButtons];
    
    GoogleVC *googleVC = [[GoogleVC alloc] initWithNibName:@"GoogleVC" bundle:nil];
    googleVC.delegate = self;
    [self presentViewController:googleVC animated:YES completion:nil];
}

# pragma mark - UIImagePicker methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage]; // for edited (cropped) image
    self.mainPic.image = chosenImage;
    
    if (self.picIndex == 0) {
        self.image1 = chosenImage;
        [self.pic1 setImage:chosenImage forState:UIControlStateNormal];
        [self.pic1 setBackgroundColor:[UIColor clearColor]];
        [self.currentQuestion setImage1WithData:UIImageJPEGRepresentation(self.image1, 0.5f)];
    } else {
        self.image2 = chosenImage;
        [self.pic2 setImage:chosenImage forState:UIControlStateNormal];
        [self.pic2 setBackgroundColor:[UIColor clearColor]];
        [self.currentQuestion setImage2WithData:UIImageJPEGRepresentation(self.image2, 0.5f)];
    }
    
    // Select next picture
    [self selectPic:(self.picIndex + 1) % 2];
    
    // Set BOOL so we know we can possibly move onto QuestionVC
    self.justSelectedImage = YES;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - GestureRecognizerDelegate methods 
//used for long press
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

# pragma mark - PinterestVCDelegate methods

- (void)pinChosen:(NSURL *)pinURL {
    [self.mainPic setImageWithURL:pinURL];
    UIImage *chosenImage = self.mainPic.image;
    
    if (self.picIndex == 0) {
        self.image1 = chosenImage;
        [self.pic1 setImage:chosenImage forState:UIControlStateNormal];
        [self.pic1 setBackgroundColor:[UIColor clearColor]];
        [self.currentQuestion setImage1WithURL:pinURL];
    } else {
        self.image2 = chosenImage;
        [self.pic2 setImage:chosenImage forState:UIControlStateNormal];
        [self.pic2 setBackgroundColor:[UIColor clearColor]];
        [self.currentQuestion setImage2WithURL:pinURL];
    }
    
    // Select next picture
    [self selectPic:(self.picIndex + 1) % 2];
    
    // Set BOOL so we know we can possibly move onto QuestionVC
    self.justSelectedImage = YES;
    
    
}

# pragma mark - QuestionVCDelegate methods

- (void)pictureClicked:(int)picNum {
    if (picNum == 1)
        [self onPic1:nil];
    else
        [self onPic2:nil];
}

- (void)clearImages:(BOOL)submit {
    NSLog(@"Clear images");
    self.currentQuestion = [[Question alloc] init];

    [self.mainPic setImage:nil];
    [self.pic1 setImage:nil forState:UIControlStateNormal];
    [self.pic1.imageView setImage:nil];
    [self.pic2 setImage:nil forState:UIControlStateNormal];
    [self.pic2.imageView setImage:nil];
    
    self.picIndex = 0;
    [self formatPic:self.pic1 isSelected:YES];
    [self formatPic:self.pic2 isSelected:NO];
    
    self.takePicButton.selected = NO;

    if (submit) {
        [self.delegate nextPage:self.index];
    }
}

# pragma mark - private methods

// Initial formatting for thumbnail image buttons
- (void)formatPic:(UIButton *)button isSelected:(BOOL)selected
{
    if (selected)
        button.alpha = 1;
    else
        button.alpha = 0.4;
    
    button.backgroundColor = [UIColor colorWithWhite:.76 alpha:1];
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 25;
    [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
}

// Formatting for thumbnail image buttons when user selects them
- (void)selectPic:(int)index
{
    self.picIndex = index;
    if (index == 0) {
        [UIView animateWithDuration:0.4f animations:^{
            self.pic1.alpha = 1;
            self.pic2.alpha = 0.4;
        }];
    }
    else {
        [UIView animateWithDuration:0.4f animations:^{
            self.pic2.alpha = 1;
            self.pic1.alpha = 0.4;
        }];
    }
}

// Open ImagePicker for choosing from library files
- (void)choosePicFromLib
{
    NSLog(@"Choose pic from library");

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

// Open ImagePicker for taking picture with camera
- (void)takePicFromCamera
{
    NSLog(@"Take pic from camera");
    
    if (self.shouldSetDefaultPicSource) {
        self.defaultPicSource = self.cameraButton;
        [self.takePicButton setImage:[UIImage imageNamed:@"slr_camera-128.png"] forState:UIControlStateNormal];
        self.pinterestIsDefault = NO;
        self.takePicButton.titleLabel.text = @"";
        self.shouldSetDefaultPicSource = NO;
    }

    // This doesn't work in the iOS simulator-- Need a real device to test camera
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

// Go to questionVC if both pictures are there and confirmed
- (void)goToQuestionVC
{
    if (self.pic1.imageView.image && self.pic2.imageView.image) {
        QuestionVC *questionVC = [[QuestionVC alloc] initWithNibName:@"QuestionVC" bundle:nil];
        questionVC.question = self.currentQuestion;
        
        // Set delegate so we can later pass info from questionVC to cameraVC
        questionVC.delegate = self;
        
        self.justSelectedImage = NO;
        
        // Set mainPic to be hidden so we don't still see it when the QuestionVC is coming up (and it not opaque)
        self.mainPic.hidden = YES;
        
        [self presentViewController:questionVC animated:YES completion:nil];
        
    }
}

- (void)hideImageSourceButtons {
    self.galleryButton.hidden = YES;
    self.cameraButton.hidden = YES;
    self.pinterestButton.hidden = YES;
    self.searchButton.hidden = YES;
}

- (void)setInsets {
    if ([self.takePicButton.titleLabel.text isEqualToString:@"+"]) {
        [self.takePicButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 8, 0)];
    } else if ([self.takePicButton.titleLabel.text isEqualToString:@"REDO"]) {
        [self.takePicButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 15, 0)];
    } else {
        if ([self pinterestIsDefault])
            [self.takePicButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        else
            [self.takePicButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    }
}

#pragma mark - image source menu delegate

/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */
/* ⬇⬇⬇⬇⬇⬇ GET RESPONSE OF MENU ⬇⬇⬇⬇⬇⬇ */
/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */
- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    int index = (int) idx;
    NSLog(@"Select the index : %d",index);
    
    if (index == 0) {
        [self takePic:nil];
    } else if (index == 1) {
        [self choosePicFromGoogle:nil];
    } else if (index == 2) {
        [self choosePicFromPinterest:nil];
    } else {
        [self choosePicFromGallery:nil];
    }
}

- (void)awesomeMenuDidFinishAnimationClose:(AwesomeMenu *)menu {
    NSLog(@"Menu was closed!");
}
- (void)awesomeMenuDidFinishAnimationOpen:(AwesomeMenu *)menu {
    NSLog(@"Menu is open!");
}

@end
