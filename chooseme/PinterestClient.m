//
//  PinterestClient.m
//  chooseme
//
//  Created by subha on 2/28/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "PinterestClient.h"
#import "AFNetworking.h"

@interface PinterestClient ()
@property (strong, nonatomic) NSMutableArray *pinURLs;
@end

@implementation PinterestClient

+ (PinterestClient *) instance {
    static dispatch_once_t once;
    static PinterestClient *instance;
    
    dispatch_once(&once, ^{
        instance = [[PinterestClient alloc] init];
    });
    
    return instance;
}

- (id) init {
    if (self = [super init]) {
        [self get:nil];
    }
    return self;
}

- (void) get:(void (^)(NSMutableArray *pins))success {
    
    if (self.pinURLs) { // cache
        success(self.pinURLs);
        return;
    }
    
    NSString *getPinsURL = @"http://pinterestapi.co.uk/subhastar/pins";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:getPinsURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *allPins = [responseObject objectForKey:@"body"];
        self.pinURLs = [[NSMutableArray alloc] initWithCapacity:allPins.count];

        for (NSDictionary *pin in allPins) {
            [self.pinURLs addObject:[pin objectForKey:@"src"]];
        }
        
        if (success) {
            success(self.pinURLs);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
