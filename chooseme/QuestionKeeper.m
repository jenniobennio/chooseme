//
//  QuestionKeeper.m
//  chooseme
//
//  Created by subha on 3/4/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "QuestionKeeper.h"

@implementation QuestionKeeper

+ (QuestionKeeper *) instance {
    static dispatch_once_t once;
    static QuestionKeeper *instance;
    
    dispatch_once(&once, ^{
        instance = [[QuestionKeeper alloc] init];
    });
    
    return instance;
}

@end
