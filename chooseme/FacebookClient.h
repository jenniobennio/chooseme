//
//  FacebookClient.h
//  chooseme
//
//  Created by subha on 3/1/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface FacebookClient : NSObject

@property (strong, nonatomic) NSString *myFacebookID;
@property (strong, nonatomic) NSString *myName;
@property (strong, nonatomic) UIImage *myPic;
@property (strong, nonatomic) FBCacheDescriptor *cacheDescriptor;

+ (FacebookClient *) instance;

- (void) meRequest:(void (^)())onSuccess;
- (FBCacheDescriptor *)loadCache;

@end
