//
//  QuestionKeeper.h
//  chooseme
//
//  Created by subha on 3/4/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"

@interface QuestionKeeper : NSObject

@property Question *lastPosted;

+ (QuestionKeeper *) instance;
@end
