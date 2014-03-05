//
//  PinterestClient.m
//  chooseme
//
//  Created by subha on 2/28/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "PinterestClient.h"
#import "AFNetworking.h"
#import "FacebookClient.h"

@interface PinterestClient ()
@property (strong, nonatomic) NSMutableArray *pinURLs;
@property (strong, nonatomic) NSMutableDictionary *usernameMap; // facebookID : pinterestName map

- (void) populateUsernameMap;
- (void) populatePinURLs:(NSString *)getPinsURL andCallback:(void (^)(NSMutableArray *pins))success;
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
        [self populateUsernameMap];
        [self get:nil];
    }
    return self;
}

- (void) get:(void (^)(NSMutableArray *pins))success {
    
    if (self.pinURLs) { // cache
        success(self.pinURLs);
        return;
    }
    
    void (^facebookSuccess)(void) = ^void {
        NSString *facebookID = [[FacebookClient instance] myFacebookID];
        NSString *pinterestUsername = [self.usernameMap objectForKey:facebookID];
        NSString *getPinsURL = [NSString stringWithFormat:@"http://pinterestapi.co.uk/%@/pins", pinterestUsername];
        [self populatePinURLs:getPinsURL andCallback:success];
    };
    
    if ([[FacebookClient instance] myFacebookID] != nil) {
        facebookSuccess();
    } else {
        [[FacebookClient instance] meRequest:facebookSuccess];
    }
}

- (void) populateUsernameMap {
    NSString *susyID = @"100007870230658";
    NSString *jennyID = @"1056420028";
    NSString *subhaID = @"712153";
    NSString *dustieID = @"100007914517190";
    
    self.usernameMap = [[NSMutableDictionary alloc] init];
    [self.usernameMap setObject:@"susychoosy5" forKey:susyID];
    [self.usernameMap setObject:@"jenniobennio" forKey:jennyID];
    [self.usernameMap setObject:@"subhastar" forKey:subhaID];
    [self.usernameMap setObject:@"frankunderwood3" forKey:dustieID];

}

- (void) populatePinURLs:(NSString *)getPinsURL andCallback:(void (^)(NSMutableArray *pins))success {
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
