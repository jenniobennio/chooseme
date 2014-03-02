//
//  GoogleClient.m
//  chooseme
//
//  Created by subha on 3/1/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "GoogleClient.h"
#import "AFNetworking.h"

@implementation GoogleClient

+ (GoogleClient *) instance {
    static dispatch_once_t once;
    static GoogleClient *instance;
    
    dispatch_once(&once, ^{
        instance = [[GoogleClient alloc] init];
    });
    
    return instance;
}

- (void) get:(NSString *)query andCallback:(void (^)(NSMutableArray *results))success {
    NSString *baseURL = @"https://ajax.googleapis.com/ajax/services/search/images";
    NSString *queryURL = baseURL; // add more stuff to this
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:queryURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *results = [[NSMutableArray alloc] init];
        
        // grab the URLs out of the results array here
        
        if (success) {
            success(results);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
@end
