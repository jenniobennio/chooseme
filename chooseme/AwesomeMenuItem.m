//
//  AwesomeMenuItem.m
//  AwesomeMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 Levey & Other Contributors. All rights reserved.
//

#import "AwesomeMenuItem.h"
#import "Colorful.h"
#import "UIImage+mask.h"

static inline CGRect ScaleRect(CGRect rect, float n) {return CGRectMake((rect.size.width - rect.size.width * n)/ 2, (rect.size.height - rect.size.height * n) / 2, rect.size.width * n, rect.size.height * n);}
@implementation AwesomeMenuItem

@synthesize contentImageView = _contentImageView;

@synthesize startPoint = _startPoint;
@synthesize endPoint = _endPoint;
@synthesize nearPoint = _nearPoint;
@synthesize farPoint = _farPoint;
@synthesize delegate  = _delegate;

#pragma mark - initialization & cleaning up
- (id)initWithImage:(UIImage *)img
{
    if (self = [super init]) 
    {
        return [self initCommon:img];
    }
    return self;
}

- (id)initStartWithImage:(UIImage *)img
{
    if (self = [super init])
    {
        self.isStart = YES;
        return [self initCommon:img];
    }
    return self;
}

- (id) initCommon:(UIImage *)img
{
    if (self.isStart) {
        img = [img maskWithColor:[[Colorful sharedManager] currentColor]];
    }
    self.image = img;
    self.userInteractionEnabled = YES;
    _contentImageView = [[UIImageView alloc] initWithImage:img];
    if (self.isStart) {
        _contentImageView.layer.backgroundColor = [[UIColor whiteColor] CGColor];
        _contentImageView.layer.cornerRadius = 25;
        _contentImageView.clipsToBounds = YES;
        _contentImageView.layer.masksToBounds = YES;
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.layer.cornerRadius = 25;
        self.layer.masksToBounds = YES;
    }
    [self addSubview:_contentImageView];
    return self;
}

#pragma mark - UIView's methods
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bounds = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    
    /*float width = _contentImageView.image.size.width;
    float height = _contentImageView.image.size.height;
    _contentImageView.frame = CGRectMake(self.bounds.size.width/2 - width/2, self.bounds.size.height/2 - height/2, width, height);*/
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_delegate respondsToSelector:@selector(AwesomeMenuItemTouchesBegan:)])
    {
       [_delegate AwesomeMenuItemTouchesBegan:self];
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_delegate respondsToSelector:@selector(AwesomeMenuItemTouchesEnd:)])
    {
        [_delegate AwesomeMenuItemTouchesEnd:self];
    }
}

@end
