//
//  NewFeedVC.h
//  
//
//  Created by Jenny Kwan on 2/27/14.
//
//

#import <UIKit/UIKit.h>

@protocol NewFeedVCDelegate <NSObject>
-(void)previousPage:(NSUInteger)index;
-(void)nextPage:(NSUInteger)index;
@end

@interface NewFeedVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

// NewFeedVC's delegate will be the AppViewController for swipe navigating between pages
@property (nonatomic, weak) id<NewFeedVCDelegate> delegate;
// Index in pageViewController
@property (assign, nonatomic) NSInteger index;

@end
