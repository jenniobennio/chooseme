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

@interface PinterestVC ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

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
    
    NSLog(@"Pinterest vc view did load.");
    [self.collectionView registerClass:[PinCell class] forCellWithReuseIdentifier:@"PinCell"];
    UINib *cellNib = [UINib nibWithNibName:@"PinCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"PinCell"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 100)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    
    PinterestClient *pinterestClient = [[PinterestClient alloc] init];
    [pinterestClient get:^(NSMutableArray *pins) {
        self.pins = pins;
        [self.collectionView reloadData];
    }];
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

#pragma mark - random methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
