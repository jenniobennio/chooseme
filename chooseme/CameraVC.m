//
//  CameraVC.m
//  chooseme
//
//  Created by Jenny Kwan on 2/7/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "CameraVC.h"
#import "FeedVC.h"

@interface CameraVC ()

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
    // Do any additional setup after loading the view from its nib.
    
    // Format things
    self.choosePicButton.layer.cornerRadius = 5;
    self.takePicButton.layer.cornerRadius = 25;
    [self formatPic:self.pic1 isSelected:YES];
    [self formatPic:self.pic2 isSelected:NO];
    
    // self.navigationController.navigationBarHidden = YES;
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - private methods
- (void) formatPic:(UIButton *)button isSelected:(BOOL)selected
{
    button.layer.masksToBounds = YES;

    if (selected)
        button.layer.borderWidth = 3;
    else
        button.layer.borderWidth = 0;

    button.layer.borderColor = [UIColor.lightGrayColor CGColor];
    button.layer.cornerRadius = 5;
    [button.imageView setContentMode:UIViewContentModeScaleAspectFill];

    
}

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

- (void) choosePicFromLib
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

# pragma mark - UIImagePicker methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
//    UIImage *chosenImage = info[UIImagePickerControllerEditedImage]; // if we want to crop image
    self.mainPic.image = chosenImage;
    
    if (self.picIndex == 0) {
        [self.pic1 setImage:chosenImage forState:UIControlStateNormal];
        [self.pic1 setBackgroundColor:[UIColor clearColor]];
        self.picURL1 = [info objectForKey:UIImagePickerControllerReferenceURL];
    } else {
        [self.pic2 setImage:chosenImage forState:UIControlStateNormal];
        [self.pic2 setBackgroundColor:[UIColor clearColor]];
        self.picURL2 = [info objectForKey:UIImagePickerControllerReferenceURL];
    }
    
    // Select next picture
    [self selectPic:(self.picIndex + 1) % 2];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

# pragma mark - actions from button presses

- (IBAction)takePic:(id)sender {
    NSLog(@"Take pic");
    [self choosePicFromLib];
    
    // This doesn't work in the iOS simulator-- Need a real device to test camera
    /*UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];*/
}

- (IBAction)choosePic:(id)sender {
    NSLog(@"Choose pic");
    [self choosePicFromLib];
}

- (IBAction)onPic1:(id)sender {
    NSLog(@"Select pic1");
    [self selectPic:0];
    self.mainPic.image = self.pic1.imageView.image;
}

- (IBAction)onPic2:(id)sender {
    NSLog(@"Select pic2");
    [self selectPic:1];
    self.mainPic.image = self.pic2.imageView.image;
}

- (IBAction)onPost:(id)sender {
    NSLog(@"on post.");
    NSLog(@"image one: %@", self.picURL1);
    NSLog(@"image two: %@", self.picURL2);
}

- (IBAction)onMe:(id)sender {
    [self.delegate nextPage:self.index];
}

- (IBAction)onFriends:(id)sender {
    [self.delegate previousPage:self.index];
}
@end
