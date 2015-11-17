//
//  JDPopupWindow.m
//  JDPopupView
//
//  Created by Jason on 15/11/17.
//  Copyright © 2015年 Jason Ding. All rights reserved.
//

#import "JDPopupWindow.h"

@interface JDPopupWindow ()

@property (nonatomic, assign) CGRect keyboardRect;


@end

@implementation JDPopupWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 1;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyKeyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
        [self addGestureRecognizer:gesture];

        
    }
    return self;
}


+ (JDPopupWindow *)sharedWindow
{
    static JDPopupWindow *window;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        window = [[JDPopupWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
    });
    
    return window;
}

- (void)cacheWindow
{
    [self makeKeyAndVisible];
    [[[UIApplication sharedApplication].delegate window] makeKeyWindow];
    
    self.mm_dimBackgroundView.hidden = YES;
    self.hidden = YES;
}

- (void)actionTap:(UITapGestureRecognizer*)gesture
{
    if ( self.touchWildToHide && !self.mm_dimBackgroundAnimating )
    {
        for ( UIView *v in self.mm_dimBackgroundView.subviews )
        {
            if ( [v isKindOfClass:[MMPopupView class]] )
            {
                MMPopupView *popupView = (MMPopupView*)v;
                [popupView hide];
            }
        }
    }
}
- (void)notifyKeyboardChangeFrame:(NSNotification *)n
{
    NSValue *keyboardBoundsValue = [[n userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    self.keyboardRect = [keyboardBoundsValue CGRectValue];
}


@end
