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

- (void) get:(void (^)(NSMutableArray *pins))success {
    
    NSString *getPinsURL = @"http://pinterestapi.co.uk/subhastar/pins";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:getPinsURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *allPins = [responseObject objectForKey:@"body"];
        NSMutableArray *pinURLs = [[NSMutableArray alloc] initWithCapacity:allPins.count];

        for (NSDictionary *pin in allPins) {
            [pinURLs addObject:[pin objectForKey:@"src"]];
        }
        
        success(pinURLs);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
