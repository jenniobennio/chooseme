//
//  Question.h
//  chooseme
//
//  Created by Jenny Kwan on 2/9/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Question : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *profilePic;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSURL *image1;
@property (nonatomic, strong) NSURL *image2;
@property (nonatomic, assign) float count1;
@property (nonatomic, assign) float count2;
@property (nonatomic, assign) BOOL youVoted1;
@property (nonatomic, assign) BOOL youVoted2;
@property (nonatomic, strong) PFUser *author;

+ (NSString *)parseClassName;

@end