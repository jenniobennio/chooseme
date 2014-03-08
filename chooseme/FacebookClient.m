//
//  FacebookClient.m
//  chooseme
//
//  Created by subha on 3/1/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "FacebookClient.h"
#import <Parse/Parse.h>

@implementation FacebookClient

+ (FacebookClient *) instance {
    static dispatch_once_t once;
    static FacebookClient *instance;
    
    dispatch_once(&once, ^{
        instance = [[FacebookClient alloc] init];
    });
    
    return instance;
}

- (void) meRequest:(void (^)())onSuccess {
    // Load my data
    // Create request for user's Facebook data
    FBRequest *request = [FBRequest requestForMe];
    
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            self.myFacebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", self.myFacebookID]];
            
            // Assign the data accordingly
            self.myName = name;
            self.myPic = [UIImage imageWithData:[NSData dataWithContentsOfURL:pictureURL]];
            
            if (onSuccess != nil) {
                onSuccess();
            }
        }
    }];
}

- (FBCacheDescriptor *)loadCache
{
    if (!self.cacheDescriptor) {
        // Create a cache descriptor based on the default friend picker data fetch settings
        self.cacheDescriptor = [FBFriendPickerViewController cacheDescriptor];
        // Pre-fetch and cache friend data
        [self.cacheDescriptor prefetchAndCacheForSession:FBSession.activeSession];
    }
    return self.cacheDescriptor;
}

@end
