//
//  commentView.h
//  chooseme
//
//  Created by Jenny Kwan on 3/4/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface commentView : UIView
@property (strong, nonatomic) IBOutlet UITableView *commentTable;
@property (strong, nonatomic) IBOutlet UITextField *commentTextField;

@end
