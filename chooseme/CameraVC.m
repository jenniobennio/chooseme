//
//  CameraVC.m
//  chooseme
//
//  Created by Jenny Kwan on 2/7/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "CameraVC.h"
#import "FeedVC.h"
#import "Question.h"

@interface CameraVC ()

// View elements
@property (strong, nonatomic) IBOutlet UIImageView *mainPic;
@property (strong, nonatomic) IBOutlet UIButton *takePicButton;
@property (strong, nonatomic) IBOutlet UIButton *choosePicButton;
@property (strong, nonatomic) IBOutlet UIButton *pic1;
@property (strong, nonatomic) IBOutlet UIButton *pic2;

// Button actions
- (IBAction)takePic:(id)sender;
- (IBAction)choosePic:(id)sender;
- (IBAction)onPic1:(id)sender;
- (IBAction)onPic2:(id)sender;
- (IBAction)onMe:(id)sender;
- (IBAction)onFriends:(id)sender;

// For testing only
- (IBAction)quickFill:(id)sender;
- (IBAction)onClear:(id)sender;
- (IBAction)onNext:(id)sender;

// Keep track of which thumbnail image is selected
@property (nonatomic, assign) int picIndex;

// Current Question object
@property (strong, nonatomic) Question *currentQuestion;
// Store images
@property (strong, nonatomic) UIImage *image1;
@property (strong, nonatomic) UIImage *image2;

@end

@implementation CameraVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"DressMe";
        self.picIndex = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Format things
    self.choosePicButton.layer.cornerRadius = 5;
    
    [self formatPic:self.pic1 isSelected:YES];
    [self formatPic:self.pic2 isSelected:NO];
    
    // Customize takePicButton depending on state
    self.takePicButton.layer.cornerRadius = 25;
    [self.takePicButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self.takePicButton setTitle:@"+" forState:UIControlStateNormal];
    [self.takePicButton setTitle:@"OK" forState:UIControlStateSelected];
    [self.takePicButton setTitle:@"REDO" forState:UIControlStateHighlighted];
    
    // Init currentQuestion
    self.currentQuestion = [[Question alloc] init];
    
    // Add tapRecognizer
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    // FIXME: Uncomment for when running on actual device
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

# pragma mark - actions from button presses

- (IBAction)takePic:(id)sender {
    // Confirm (OK) pic
    if (self.takePicButton.selected == YES) {
        self.takePicButton.selected = NO;
        
        // Select next picture
        [self selectPic:(self.picIndex + 1) % 2];
        
        // Clear main pic
        self.mainPic.image = nil;
        
        // If both images are set, go to questionVC
        [self goToQuestionVC];
    } else
        // Take pic
    {
         // Choosing pic from library when camera isn't available
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            [self takePicFromCamera];
        else
            [self choosePicFromLib];
    }
}

- (IBAction)choosePic:(id)sender {
    [self choosePicFromLib];
}

- (IBAction)onPic1:(id)sender {
    NSLog(@"Select pic1 thumbnail");
    
    if (self.currentQuestion.image1) {
        // REDO pic
        self.takePicButton.selected = NO;
        self.takePicButton.highlighted = YES;
    } else {
        self.takePicButton.selected = NO;
        self.takePicButton.highlighted = NO;
    }
    [self selectPic:0];
    self.mainPic.image = self.pic1.imageView.image;
}

- (IBAction)onPic2:(id)sender {
    NSLog(@"Select pic2 thumbnail");
    
    if (self.currentQuestion.image2) {
        // REDO pic
        self.takePicButton.selected = NO;
        self.takePicButton.highlighted = YES;
    } else {
        self.takePicButton.selected = NO;
        self.takePicButton.highlighted = NO;
    }
    [self selectPic:1];
    self.mainPic.image = self.pic2.imageView.image;
}

- (IBAction)onMe:(id)sender {
    [self.delegate nextPage:self.index];
}

- (IBAction)onFriends:(id)sender {
    [self.delegate previousPage:self.index];
}

// For testing: Pre-fill in images
- (IBAction)quickFill:(id)sender {
    UIImage *chosenImage = [UIImage imageNamed:@"111834.jpg"];
    self.image1 = chosenImage;
    [self.pic1 setImage:chosenImage forState:UIControlStateNormal];
    [self.pic1 setBackgroundColor:[UIColor clearColor]];
    self.currentQuestion.image1 = [NSURL URLWithString:@"111834.jpg"];
    
    chosenImage = [UIImage imageNamed:@"131466.jpg"];
    self.image2 = chosenImage;
    [self.pic2 setImage:chosenImage forState:UIControlStateNormal];
    [self.pic2 setBackgroundColor:[UIColor clearColor]];
    self.currentQuestion.image2 = [NSURL URLWithString:@"131466.jpg"];
    
    // If both images are set, go to questionVC
    [self goToQuestionVC];
    
}

// For testing: Clear images
- (IBAction)onClear:(id)sender {
    [self clearImages:NO];
}

// For testing: Go to next step
- (IBAction)onNext:(id)sender {
    [self onTap:nil];
}

- (void)onTap:(id)sender {
    // FIXME: Is the tapping response intuitive?
    // A tap on the view is treated like an OK/ cancel, but
    // if both images are set, go to questionVC
    
    self.takePicButton.selected = NO;
    self.takePicButton.highlighted = NO;
    self.mainPic.image = nil;
    
    // Select next picture
    [self selectPic:(self.picIndex + 1) % 2];
    
    // If both images are set, go to questionVC
    [self goToQuestionVC];
}

# pragma mark - UIImagePicker methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    //    UIImage *chosenImage = info[UIImagePickerControllerEditedImage]; // if we want to crop image
    self.mainPic.image = chosenImage;
    
    if (self.picIndex == 0) {
        self.image1 = chosenImage;
        [self.pic1 setImage:chosenImage forState:UIControlStateNormal];
        [self.pic1 setBackgroundColor:[UIColor clearColor]];
        self.currentQuestion.image1 = [info objectForKey:UIImagePickerControllerReferenceURL];
    } else {
        self.image2 = chosenImage;
        [self.pic2 setImage:chosenImage forState:UIControlStateNormal];
        [self.pic2 setBackgroundColor:[UIColor clearColor]];
        self.currentQuestion.image2 = [info objectForKey:UIImagePickerControllerReferenceURL];
    }
    
    // Change takePicButton to OK
    self.takePicButton.selected = YES;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

# pragma mark - QuestionVCDelegate methods

- (void)pictureClicked:(int)picNum {
    NSLog(@"Picture clicked for redo: %d", picNum);
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
    self.takePicButton.highlighted = NO;

    if (submit) {
        [self.delegate nextPage:self.index];
    }
}

# pragma mark - private methods

// Initial formatting for thumbnail image buttons
- (void)formatPic:(UIButton *)button isSelected:(BOOL)selected
{
    button.layer.masksToBounds = YES;
    
    if (selected)
        button.layer.borderWidth = 3;
    else
        button.layer.borderWidth = 1;
    
    button.backgroundColor = [UIColor colorWithWhite:.76 alpha:1];
    button.alpha = 0.8;
    button.layer.borderColor = [UIColor.lightGrayColor CGColor];
    button.layer.cornerRadius = 5;
    [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
}

// Formatting for thumbnail image buttons when user selects them
- (void)selectPic:(int)index
{
    self.picIndex = index;
    if (index == 0) {
        self.pic1.layer.borderWidth = 3;
        self.pic2.layer.borderWidth = 1;
    }
    else {
        self.pic1.layer.borderWidth = 1;
        self.pic2.layer.borderWidth = 3;
    }
}

// Open ImagePicker for choosing from library files
- (void)choosePicFromLib
{
    NSLog(@"Choose pic from library");

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

// Open ImagePicker for taking picture with camera
- (void)takePicFromCamera
{
    NSLog(@"Take pic from camera");

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
    if (self.pic1.imageView.image && self.pic2.imageView.image && !self.takePicButton.selected) {
        QuestionVC *questionVC = [[QuestionVC alloc] initWithNibName:@"QuestionVC" bundle:nil];
        questionVC.question = self.currentQuestion;
        
        // Pass images for now since can't get image from local file URL
        questionVC.image1 = self.image1;
        questionVC.image2 = self.image2;
        
        // Set delegate so we can later pass info from questionVC to cameraVC
        questionVC.delegate = self;
        
        [self presentViewController:questionVC animated:YES completion:nil];
        
    }
}


@end
