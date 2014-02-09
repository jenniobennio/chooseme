//
//  Question.h
//  chooseme
//
//  Created by Jenny Kwan on 2/9/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

@property (nonatomic, strong) NSString *profilePic;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSString *image1;
@property (nonatomic, strong) NSString *image2;
@property (nonatomic, assign) float count1;
@property (nonatomic, assign) float count2;
@property (nonatomic, assign) BOOL youVoted1;
@property (nonatomic, assign) BOOL youVoted2;

@end
