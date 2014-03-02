//
//  GoogleVC.m
//  chooseme
//
//  Created by subha on 3/1/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "GoogleVC.h"
#import "GoogleClient.h"

@interface GoogleVC ()

@property(strong, nonatomic) NSMutableArray *searchResults;
@end

@implementation GoogleVC

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
    }
}

- (void) handleSearch:(UISearchBar *)searchBar
{
    NSLog(@"search text is %@", searchBar.text);
    
    [[GoogleClient instance] get:searchBar.text andCallback:^(NSMutableArray *results) {
        self.searchResults = results;
        NSLog(@"search results are : %@", self.searchResults);
    }];
}

- (void) clearSearch {
    self.searchBar.text = @"";
}

#pragma mark - random methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
