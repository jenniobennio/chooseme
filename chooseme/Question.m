//
//  Question.m
//  chooseme
//
//  Created by Jenny Kwan on 2/9/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "Question.h"
#import <Parse/PFObject+Subclass.h>

@interface Question () {
    UIImage *_image1;
    UIImage *_image2;
}

@end

@implementation Question
@dynamic facebookID, author, image1, image2;
@synthesize myVoteIndex;

+ (NSString *)parseClassName {
    return @"question";
}

- (NSString *) facebookID {
    return self[@"facebookID"];
}
- (void) setFacebookID:(NSString *)facebookID {
    self[@"facebookID"] = facebookID;
}

- (PFUser *) author {
    return self[@"author"];
}
- (void) setAuthor:(PFUser *) user {
    self[@"author"] = user;
}

- (NSString *) name {
    return self[@"name"];
}
- (void) setName:(NSString *) text {
    self[@"name"] = text;
}

- (NSDate *) time {
    return self[@"time"];
}
- (void) setTime:(NSDate *) date {
    self[@"time"] = date;
}

- (NSString *) question {
    return self[@"question"];
}
- (void) setQuestion:(NSString *) text {
    self[@"question"] = text;
}

- (UIImage *) image1 {
    if (!_image1) {
        if (self[@"imageData1"] != nil) {
            NSData *imageData = self[@"imageData1"];
            _image1 = [UIImage imageWithData:imageData];
        } else {
            NSString *picURL = self[@"imageURL1"];
            _image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picURL]]];
        }
    }
    
    return _image1;
}

- (void)clearPic:(int)index {
    if (index == 1)
        _image1 = nil;
    else
        _image2 = nil;
}

- (void) setImage1WithData:(NSData *)imageData {
    self[@"imageData1"] = imageData;
}

- (void) setImage1WithURL:(NSURL *)imageURL {
    self[@"imageURL1"] = [imageURL absoluteString];
}

- (UIImage *) image2 {
    if (!_image2) {
        if (self[@"imageData2"] != nil) {
            NSData *imageData = self[@"imageData2"];
            _image2 = [UIImage imageWithData:imageData];
        } else {
            NSString *picURL = self[@"imageURL2"];
            _image2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picURL]]];
        }
    }
    
    return _image2;
}

- (void) setImage2WithData:(NSData *)imageData {
    self[@"imageData2"] = imageData;
}

- (void) setImage2WithURL:(NSURL *)imageURL {
    self[@"imageURL2"] = [imageURL absoluteString];
}

- (NSNumber *) youVoted {
    return self[@"youVoted"];
}
- (void) setYouVoted:(NSNumber *) vote {
    self[@"youVoted"] = vote;
}

- (NSMutableArray *) friends {
    return self[@"friends"];
}
- (void) setFriends:(NSMutableArray *) array {
    self[@"friends"] = array;
}

- (NSMutableArray *) friendsVoted {
    return self[@"friendsVoted"];
}
- (void) setFriendsVoted:(NSMutableArray *) array {
    self[@"friendsVoted"] = array;
}

- (NSMutableArray *) friendsCommenting {
    return self[@"friendsCommenting"];
}
- (void) setFriendsCommenting:(NSMutableArray *) array {
    self[@"friendsCommenting"] = array;
}

- (NSMutableArray *) friendsComments {
    return self[@"friendsComments"];
}
- (void) setFriendsComments:(NSMutableArray *) array {
    self[@"friendsComments"] = array;
}

- (NSString *)formattedQuestion
{
    return [self.question uppercaseString];
}

- (NSString *)formattedName {
    return [self.name uppercaseString];
}

- (NSString *)formattedDate {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [format setDateFormat:@"EEE MMM dd HH:mm:ss Z y"];
    NSTimeInterval timeSinceDate = [[NSDate date] timeIntervalSinceDate:self.time];
    
    // print up to 7 days as a relative offset
    if (timeSinceDate < 7 * 24.0 * 60.0 * 60.0) {
        int daysSinceDate = (int)(timeSinceDate / (24.0 * 60.0 * 60.0));
        switch (daysSinceDate)
        {
            default: return [NSString stringWithFormat:@"%d DAYS AGO", daysSinceDate];
            case 1: return @"1 DAY AGO";
            case 0: {
                int hoursSinceDate = (int)(timeSinceDate / (60.0 * 60.0));
                
                switch(hoursSinceDate)
                {
                    default: return [NSString stringWithFormat:@"%d HOURS AGO", hoursSinceDate];
                    case 1: return @"1 HOUR AGO";
                    case 0: {
                        int minutesSinceDate = (int)(timeSinceDate / 60.0);
                        return [NSString stringWithFormat:@"%d MIN AGO", minutesSinceDate];
                        break;
                    }
                }

            }
        }
    }
    else
    {
        /* normal NSDateFormatter stuff here */
        [format setDateFormat:@"M/d/yy"];
        return [format stringFromDate:self.time];
    }
}

- (int)numReplies {
    int totalCount = 0;
    
    for (int i = 0; i < self.friendsVoted.count; i++) {
        // Count the people who submitted votes
        if ([self.friendsVoted[i] intValue] != 0)
            totalCount++;
    }
    
    int didYouVote = ([self.youVoted intValue] == 0) ? 0 : 1;
    
    return totalCount + didYouVote;
}

- (int)numVoted1 {
    int totalCount = 0;
    
    for (int i = 0; i < self.friendsVoted.count; i++) {
        // Count the people who submitted votes for pic1
        if ([self.friendsVoted[i] intValue] == 1)
            totalCount++;
    }
    
    int didYouVote = ([self.youVoted intValue] == 1) ? 1 : 0;
    return totalCount + didYouVote;
}

- (int)numVoted2 {
    int totalCount = 0;
    
    for (int i = 0; i < self.friendsVoted.count; i++) {
        // Count the people who submitted votes for pic1
        if ([self.friendsVoted[i] intValue] == 2)
            totalCount++;
    }
    
    int didYouVote = ([self.youVoted intValue] == 2) ? 1 : 0;
    return totalCount + didYouVote;
}

- (int)numComments {
    return (int)self.friendsCommenting.count;
}

- (int)percentPic:(int)picNum {
    int count1 = [self numVoted1];
    int count2 = [self numVoted2];
    int totalCount = [self numReplies];
    
    // Calculate percentages and make sure it adds up to 100
    if (totalCount != 0) {
        count1 = 100*count1/totalCount;
        count2 = 100-count1;
    } else {
        count1 = 50;
        count2 = 50;
    }
    
    if (picNum == 1)
        return count1;
    else
        return count2;
}

-(void)setVote:(int)vote {
    [self.friendsVoted setObject:[NSNumber numberWithInt:vote] atIndexedSubscript:self.myVoteIndex];
    [self saveInBackground];
}

-(int)vote {
    if (self.friendsVoted.count > 0)
        return [[self.friendsVoted objectAtIndex:self.myVoteIndex] intValue];
    else
        return 0;
}

@end
