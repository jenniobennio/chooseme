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

- (void)postToFriend:(Question *)q
{
    NSLog(@"Post to friend");
    
    NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
    NSLog(@"access token: %@", fbAccessToken);
    
    NSDictionary *params0 = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"727526547279997", @"client_id",
                            @"6ee3807135f35e6aab61eccb6bb8e83a", @"client_secret",
//                            @"This is a test message", @"client_credentials",
                            nil
                            ];

    NSString *queryURL0 = @"/oauth/access_token";
    [FBRequestConnection startWithGraphPath:queryURL0
                                 parameters:params0
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              /* handle the result */
                              NSLog(@"Got access token");
                              
                              if (error)
                                  NSLog(@"%@", error);
                          }];

    

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            fbAccessToken, @"access_token",
                            @"/testurl?param1=value1", @"href",
                            @"This is a test message", @"template",
                            nil
                            ];
    
    NSString *queryURL = [NSString stringWithFormat:@"/%@/notifications", q.facebookID];
    [FBRequestConnection startWithGraphPath:queryURL
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              /* handle the result */
                              NSLog(@"posted");
                              
                              if (error)
                                  NSLog(@"%@", error);
                          }];
}

@end
