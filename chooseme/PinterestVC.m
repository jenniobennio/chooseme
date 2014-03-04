//
//  PinterestVC.m
//  chooseme
//
//  Created by subha on 2/28/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "PinterestVC.h"
#import "PinterestClient.h"
#import "PinCell.h"
#import "MBProgressHUD.h"
#import "Colorful.h"
#import "UIImage+mask.h"

@interface PinterestVC ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *pinterestImage;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)onBack:(id)sender;

// For now, this is an array of strings with the pin URL.
@property (strong, nonatomic) NSMutableArray *pins;

@end

@implementation PinterestVC

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
    
    [self.collectionView registerClass:[PinCell class] forCellWithReuseIdentifier:@"PinCell"];
    UINib *cellNib = [UINib nibWithNibName:@"PinCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"PinCell"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 100)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[PinterestClient instance] get:^(NSMutableArray *pins) {
        self.pins = pins;
        [self.collectionView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    Colorful *colorManager = [Colorful sharedManager];
    UIColor *color = [colorManager currentColor];
    self.titleView.backgroundColor = color;
    self.titleLabel.text = @"Add a Pin";
    
    self.pinterestImage.image = [self.pinterestImage.image maskWithColor:[UIColor whiteColor]];
    self.backButton.imageView.image = [self.backButton.imageView.image maskWithColor:[UIColor whiteColor]];
}

#pragma mark - UICollectionView methods

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pins.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"PinCell";
    PinCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSString *pinURL = [self.pins objectAtIndex:indexPath.row];
    [cell setPinURL:pinURL];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *pinURL = [self.pins objectAtIndex:indexPath.row];
    [self.delegate pinChosen:[NSURL URLWithString:pinURL]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - random methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
