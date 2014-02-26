//
//  FeedVC.h
//  chooseme
//
//  Created by Jenny Kwan on 2/7/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FeedVCDelegate <NSObject>
-(void)previousPage:(NSUInteger)index;
-(void)nextPage:(NSUInteger)index;
@end

@interface FeedVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

// FeedVC's delegate will be the AppViewController for swipe navigating between pages
@property (nonatomic, weak) id<FeedVCDelegate> delegate;
// Index in pageViewController
@property (assign, nonatomic) NSInteger index;

@end
