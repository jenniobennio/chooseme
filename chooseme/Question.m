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

- (NSURL *) image1 {
    return [NSURL URLWithString:self[@"image1"]];
}

- (void) setImage1:(NSURL *)image1 {
    self[@"image1"] = [image1 absoluteString];
}

- (NSURL *) image2 {
    return [NSURL URLWithString:self[@"image2"]];
}

- (void) setImage2:(NSURL *)image2 {
    self[@"image2"] = [image2 absoluteString];
}

@end