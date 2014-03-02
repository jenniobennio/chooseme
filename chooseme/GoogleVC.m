//
//  GoogleVC.m
//  chooseme
//
//  Created by subha on 3/1/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "GoogleVC.h"
#import "GoogleClient.h"
#import "PinCell.h"

@interface GoogleVC ()

@property(strong, nonatomic) NSMutableArray *searchResults;
@property(nonatomic) NSInteger start;
@end

@implementation GoogleVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.start = 0;
        self.searchResults = [[NSMutableArray alloc] init];
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
}

#pragma mark - UICollectionView methods

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.searchResults.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"PinCell";
    PinCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSString *pinURL = [self.searchResults objectAtIndex:indexPath.row];
    [cell setPinURL:pinURL];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *pinURL = [self.searchResults objectAtIndex:indexPath.row];
    [self.delegate pinChosen:[NSURL URLWithString:pinURL]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - UISearchBar delegate methods
- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
{
    [self clearResults];
    [self handleSearch:searchBar.text];
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
    }
}

- (void) handleSearch:(NSString *)searchText
{
    [[GoogleClient instance] get:searchText withStart:self.start andCallback:^(NSMutableArray *results) {
        [self.searchResults addObjectsFromArray:results];
        self.start = self.start + 8;
        
        if (self.start < 20) {
            NSLog(@"updating start and calling recursive %d %d", self.start, self.searchResults.count);
            [self handleSearch:searchText];
        } else {
            NSLog(@"reloading. %d %d", self.start, self.searchResults.count);
            [self.collectionView reloadData];
        }
    }];
}

- (void) clearSearch {
    self.searchBar.text = @"";
    [self clearResults];
}

- (void) clearResults {
    [self.searchResults removeAllObjects];
    self.start = 0;
}

#pragma mark - random methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
