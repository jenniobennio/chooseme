//
//  PinterestVC.h
//  chooseme
//
//  Created by subha on 2/28/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PinterestVCDelegate <NSObject>
- (void)pinChosen:(NSURL *)pinURL;
@end

@interface PinterestVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) id <PinterestVCDelegate> delegate;
@end
