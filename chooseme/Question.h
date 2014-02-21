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

@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSData *profilePic;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSDate *time;
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSData *imageData1;
@property (nonatomic, strong) NSData *imageData2;
// Note: Using image data for library files.. For online pics, store URL?
@property (nonatomic, strong) NSURL *image1;
@property (nonatomic, strong) NSURL *image2;

@property (nonatomic, strong) NSNumber *youVoted;

@property (nonatomic, strong) NSMutableArray *friends;
@property (nonatomic, strong) NSMutableArray *friendsVoted;

+ (NSString *)parseClassName;
- (NSString *)formattedDate;
- (int)numReplies;
- (int)numComments;
- (int)percentPic:(int)picNum;

@end