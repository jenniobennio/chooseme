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

- (NSData *) profilePic {
    return self[@"profilePic"];
}
- (void) setProfilePic:(NSData *) image {
    self[@"profilePic"] = image;
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

- (NSData *) imageData1 {
    return self[@"imageData1"];
}
- (void) setImageData1:(NSData *) image {
    self[@"imagedata1"] = image;
}

- (NSData *) imageData2 {
    return self[@"imageData2"];
}
- (void) setImageData2:(NSData *) image {
    self[@"imagedata2"] = image;
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

- (NSString *)formattedDate {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [format setDateFormat:@"EEE MMM dd HH:mm:ss Z y"];
    NSTimeInterval timeSinceDate = [[NSDate date] timeIntervalSinceDate:self.time];
    
    // print up to 24 hours as a relative offset
    if(timeSinceDate < 24.0 * 60.0 * 60.0)
    {
        int hoursSinceDate = (int)(timeSinceDate / (60.0 * 60.0));
        
        switch(hoursSinceDate)
        {
            default: return [NSString stringWithFormat:@"%dh", hoursSinceDate];
            case 1: return @"1h";
            case 0: {
                int minutesSinceDate = (int)(timeSinceDate / 60.0);
                return [NSString stringWithFormat:@"%dm", minutesSinceDate];
                break;
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

@end
