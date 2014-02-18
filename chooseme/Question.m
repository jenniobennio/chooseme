//
//  Question.m
//  chooseme
//
//  Created by Jenny Kwan on 2/9/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "Question.h"
#import <Parse/PFObject+Subclass.h>

@implementation Question
@dynamic author, profilePic, image1, image2;

+ (NSString *)parseClassName {
    return @"question";
}

- (PFUser *) author {
    return self[@"author"];
}

- (void) setAuthor:(PFUser *) user {
    self[@"author"] = user;
}

- (NSString *) image1 {
    return self[@"image1"];
}

- (void) setImage1:(NSString *)image1 {
    self[@"image1"] = image1;
}

- (NSString *) image2 {
    return self[@"image2"];
}

- (void) setImage2:(NSString *)image2 {
    self[@"image2"] = image2;
}

@end