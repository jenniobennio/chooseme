//
//  CameraVC.m
//  chooseme
//
//  Created by Jenny Kwan on 2/7/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "CameraVC.h"
#import "FeedVC.h"
#import "QuestionVC.h"

@interface CameraVC ()
@property (strong, nonatomic) FBFriendPickerViewController *friendPickerController;

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

- (void)viewDidAppear:(BOOL)animated
{
    /*if ((self.picIndex == 0 && self.currentQuestion.image1) || (self.picIndex == 1 && self.currentQuestion.image2)) {
        self.takePicButton.selected = NO;
        self.takePicButton.highlighted = YES;
    }*/
    
    if (!self.pic1.imageView.image && self.currentQuestion.image1)
        NSLog(@"Load pic1");
    if (!self.pic2.imageView.image && self.currentQuestion.image2)
        NSLog(@"Load pic2");

}

# pragma mark - private methods

// Initial formatting for thumbnail image buttons
- (void)formatPic:(UIButton *)button isSelected:(BOOL)selected
{
    button.layer.masksToBounds = YES;

    if (selected)
        button.layer.borderWidth = 3;
    else
        button.layer.borderWidth = 0;

    button.backgroundColor = [UIColor colorWithWhite:.79 alpha:0.5];
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
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

// Open ImagePicker for taking picture with camera
- (void)takePicFromCamera
{
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
        [self presentModalViewController:questionVC animated:YES];
    }
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

# pragma mark - actions from button presses

- (IBAction)takePic:(id)sender {
    // Confirm pic
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
        NSLog(@"Take pic with camera");
        
        // Choosing pic from library when camera isn't available
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            [self takePicFromCamera];
        else
            [self choosePicFromLib];
    }
}

- (IBAction)choosePic:(id)sender {
    NSLog(@"Choose pic from library");
    [self choosePicFromLib];
}

- (IBAction)onPic1:(id)sender {
    NSLog(@"Select pic1 thumbnail");

    if (self.currentQuestion.image1) {
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
        self.takePicButton.selected = NO;
        self.takePicButton.highlighted = YES;
    } else {
        self.takePicButton.selected = NO;
        self.takePicButton.highlighted = NO;
    }
    [self selectPic:1];
    self.mainPic.image = self.pic2.imageView.image;
}

- (IBAction)onPost:(id)sender {
    NSLog(@"Posting question.");
    
    self.currentQuestion.author = [PFUser currentUser];
    [self.currentQuestion saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"successfully posted question");
        } else {
            NSLog(@"failed to post question.");
        }
    }];
    
    // Reset the question and view.
    self.currentQuestion = [[Question alloc] init];
    self.mainPic.image = nil;
    
    [self.pic1 setImage:nil forState:UIControlStateNormal];
    self.pic1.titleLabel.text = @"1";
    self.pic1.titleLabel.textColor = [UIColor whiteColor];
    self.pic1.backgroundColor = [UIColor colorWithWhite:0.76 alpha:1.0];
    self.pic1.alpha = 0.8;
    
    [self.pic2 setImage:nil forState:UIControlStateNormal];
    self.pic2.titleLabel.text = @"2";
    self.pic2.titleLabel.textColor = [UIColor whiteColor];
    self.pic2.backgroundColor = [UIColor colorWithWhite:0.76 alpha:1.0];
    self.pic2.alpha = 0.8;
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

- (IBAction)onMe:(id)sender {
    [self.delegate nextPage:self.index];
}

- (IBAction)onFriends:(id)sender {
    [self.delegate previousPage:self.index];
}

- (IBAction)onTap:(id)sender {
    self.takePicButton.selected = NO;
    self.takePicButton.highlighted = NO;
    self.mainPic.image = nil;
    
    // Select next picture
    [self selectPic:(self.picIndex + 1) % 2];
    
    // If both images are set, go to questionVC
    [self goToQuestionVC];
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

# pragma mark - QuestionVCDelegate methods

- (void)pictureClicked:(int)picNum {
    NSLog(@"Picture clicked %d", picNum);
    if (picNum == 1)
        [self onPic1:nil];
    else
        [self onPic2:nil];
}

- (void)clearImages {
    NSLog(@"Clear images");
    self.currentQuestion = nil;
    UIImage *imgClear = [UIImage imageNamed:@"clear"];
    
    // Weirdness. Just setting the image to nil doesn't work. Need to additionally set the button image to nil forState
    [self.pic1 setImage:nil forState:UIControlStateNormal];
    [self.pic1.imageView setImage:nil];
    self.pic1.backgroundColor = [UIColor colorWithWhite:.79 alpha:0.5];
    [self.pic2 setImage:imgClear forState:UIControlStateNormal];
    [self.pic2.imageView setImage:nil];
    self.pic2.backgroundColor = [UIColor colorWithWhite:.79 alpha:0.5];

}
@end
