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
@property (nonatomic, strong) NSString *facebookID;
@property (nonatomic, strong) NSData *profilePic;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSDate *time;
@property (nonatomic, strong) NSString *question;

// Note: Using image data for library files. For online pics, store URL.
@property (nonatomic, strong) UIImage *image1;
@property (nonatomic, strong) UIImage *image2;
- (void)setImage1WithURL:(NSURL *)imageURL;
- (void)setImage2WithURL:(NSURL *)imageURL;
- (void)setImage1WithData:(NSData *)imageData;
- (void)setImage2WithData:(NSData *)imageData;

@property (nonatomic, strong) NSNumber *youVoted;

@property (nonatomic, strong) NSMutableArray *friends;
@property (nonatomic, strong) NSMutableArray *friendsVoted;

@property (nonatomic, strong) NSMutableArray *friendsCommenting;
@property (nonatomic, strong) NSMutableArray *friendsComments;

// local client property not backed up to parse. use it to store the index of current user in the friends array.
@property (assign) int myVoteIndex;

+ (NSString *)parseClassName;
- (NSString *)formattedQuestion;
- (NSString *)formattedName;
- (NSString *)formattedDate;
- (int)numReplies;
- (int)numVoted1;
- (int)numVoted2;
- (int)numComments;
- (int)percentPic:(int)picNum;
- (int)vote;
- (void)setVote:(int)vote;

@end