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
        img = [img maskWithColor:[UIColor whiteColor]];
    }
    self.image = img;
    self.userInteractionEnabled = YES;
    _contentImageView = [[UIImageView alloc] initWithImage:img];
    if (self.isStart) {
        _contentImageView.layer.backgroundColor = [[[Colorful sharedManager] currentColor] CGColor];
        _contentImageView.layer.cornerRadius = 25;
        _contentImageView.clipsToBounds = YES;
        _contentImageView.layer.masksToBounds = YES;
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.layer.cornerRadius = 25;
        self.layer.masksToBounds = YES;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startButtonTap)];
        tapGestureRecognizer.delegate = self;
        [self addGestureRecognizer:tapGestureRecognizer];
        
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(startButtonLongPress)];
        longPressRecognizer.delegate = self;
        longPressRecognizer.minimumPressDuration = 1.0; //seconds
        [self addGestureRecognizer:longPressRecognizer];
    }
    [self addSubview:_contentImageView];
    return self;
}

- (void) startButtonLongPress {
    [self.delegate StartButtonLongPress];
}

- (void) startButtonTap {
    [self.delegate StartButtonTap];
}

#pragma mark - GestureRecognizerDelegate methods
//used for long press
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - UIView's methods
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float width = self.isStart? 50 : 25;
    float height = self.isStart? 50 : 25;
    
    self.bounds = CGRectMake(0, 0, width, height);
    _contentImageView.frame = CGRectMake(self.bounds.size.width/2 - width/2, self.bounds.size.height/2 - height/2, width, height);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isStart) {
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(AwesomeMenuItemTouchesBegan:WithTouches:)])
    {
       [_delegate AwesomeMenuItemTouchesBegan:self WithTouches:touches];
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isStart) {
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(AwesomeMenuItemTouchesEnd:)])
    {
        [_delegate AwesomeMenuItemTouchesEnd:self];
    }
}

@end
