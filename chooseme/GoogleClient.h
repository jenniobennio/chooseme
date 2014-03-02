//
//  GoogleClient.h
//  chooseme
//
//  Created by subha on 3/1/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleClient : NSObject

+ (GoogleClient *) instance;

- (void) get:(NSString *)query andCallback:(void (^)(NSMutableArray *results))success;

@end
