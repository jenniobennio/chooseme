//
//  PinCell.h
//  chooseme
//
//  Created by subha on 2/28/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pinImage;

- (void) setPinURL:(NSString *)url;

@end
