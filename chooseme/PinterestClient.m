//
//  PinterestClient.m
//  chooseme
//
//  Created by subha on 2/28/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "PinterestClient.h"
#import "AFNetworking.h"

@implementation PinterestClient

- (void)get {
    
    NSString *getPinsURL = @"http://pinterestapi.co.uk/subhastar/pins";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:getPinsURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
