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

- (void) get:(NSString *)rawQuery andCallback:(void (^)(NSMutableArray *results))success {
    NSString *query = [rawQuery stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *baseURL = @"https://ajax.googleapis.com/ajax/services/search/images?rsz=8&start=0&v=1.0&q=";
    NSString *queryURL = [NSString stringWithFormat:@"%@%@", baseURL, query];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:queryURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *results = [[NSMutableArray alloc] init];
        
        // grab the URLs out of the results array here
        NSDictionary *allResults = [[responseObject objectForKey:@"responseData"] objectForKey:@"results"];
        for (NSDictionary *imageResult in allResults) {
            [results addObject:[imageResult objectForKey:@"url"]];
        }
        
        if (success) {
            success(results);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
@end
