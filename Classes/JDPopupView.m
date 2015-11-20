//
//  JDPopupView.m
//  JDPopupView
//
//  Created by Jason on 15/11/18.
//  Copyright © 2015年 Jason Ding. All rights reserved.
//

#import "JDPopupView.h"
#import "JDPopupWindow.h"
#import "JDPopupDefine.h"
#import "JDPopupCategory.h"

@implementation JDPopupView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setup];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
        
    }
    return self;
}

- (void)setup{

    self.type = JDPopupTypeAlert ;
    self.animationDuration = 0.3 ;
    
}

- (BOOL)visible
{
    if ( self.attachedView ) {
        return !self.attachedView.jd_dimBackgroundView.hidden;
    }
    
    return NO;
}

- (void)setType:(JDPopupType)type
{
    _type = type;
    
    switch (type) {
        case JDPopupTypeAlert:
        {
            self.showAnimation = [self alertShowAnimation];
            self.hideAnimation = [self alertHideAnimation];
        }
            break;
        case JDPopupTypeSheet:
        {
            self.showAnimation = [self sheetShowAnimation];
            self.hideAnimation = [self sheetHideAnimation];
        }
            break;
            
        default:
            break;
    }
}

- (void)setAnimationDuration:(NSTimeInterval)animationDuration
{
    _animationDuration = animationDuration;
    
    self.attachedView.jd_dimAnimationDuration = animationDuration;
}

- (void)show
{
    [self showWithBlcok:nil];
}

- (void)showWithBlcok:(JDPopupBlock)block
{
    if ( block ) {
        self.showCompletionBlock = block;
    }
    
    // 指定显示在某个UIView之上, 如果没有,则显示在window上
    if ( !self.attachedView ) {
        self.attachedView = [JDPopupWindow sharedWindow];
    }
    
    // 定制的window显示 背景颜色view,并防止在最上层
    [self.attachedView jd_showDimBackground];
    
    NSAssert(self.showAnimation, @"show animation must be there");
    
    self.showAnimation(self);
    
    if (self.withKeyboard) {
        
        [self showKeyBoard];
        
    }
    
}

- (void)hide
{
    [self hideWithBlock:nil];
}

- (void)hideWithBlock:(JDPopupBlock)block
{
    if (block) {
        self.hideCompletionBlock = block;
    }
    
    if ( !self.attachedView ) {
        
        self.attachedView = [JDPopupWindow sharedWindow];
    }
    [self.attachedView jd_hideDimBackground];
    
    if ( self.withKeyboard ) {
        
        [self hideKeyBoard];
    }

    NSAssert(self.showAnimation, @"hide animation must be there");
    
    self.hideAnimation(self);

}

- (JDPopupBlock)alertShowAnimation
{
    JDWeakify(self);
    
    JDPopupBlock block = ^(JDPopupView *popupView){
        JDStrongify(self);
        [self.attachedView.jd_dimBackgroundView addSubview:self];
        
        
        CGPoint point = self.attachedView.center;
        point.y -= self.withKeyboard? + 216/2:0;
        self.center = point;

        [self layoutIfNeeded];
        
        self.layer.transform = CATransform3DMakeScale(1.2f, 1.2f, 1.2f);
        self.alpha = 0.0f;
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                            
                             self.layer.transform = CATransform3DIdentity;
                             self.alpha = 1.0f;
                             
                             
                         } completion:^(BOOL finished) {
                             
                             if (self.showCompletionBlock) {
                                 self.showCompletionBlock(self);
                             }
                             
                         }];
    };
    
    return block;
}

- (JDPopupBlock) alertHideAnimation
{
    JDWeakify(self);
    JDPopupBlock block = ^(JDPopupView *popupView){
        JDStrongify(self);
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             self.alpha = 0.0f;
                             
                         } completion:^(BOOL finished) {
                             
                             [self removeFromSuperview];
                             
                             if (self.hideCompletionBlock) {
                                 self.hideCompletionBlock(self);
                             }
                             
                         }];
        
        
    };
    return block;
}

- (JDPopupBlock)sheetShowAnimation{
    
    JDWeakify(self);
    JDPopupBlock block = ^(JDPopupView *popupView){
        JDStrongify(self);
        
        [self.attachedView.jd_dimBackgroundView addSubview:self];
        
        CGRect frame = self.frame;
        frame.origin.y = self.attachedView.frame.size.height;
        self.frame = frame;
        
        [self layoutIfNeeded];
        
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             CGRect frame = self.frame;
                             frame.origin.y = self.attachedView.frame.size.height - self.frame.size.height;
                             self.frame = frame;


                         } completion:^(BOOL finished) {
                             
                             if (self.showCompletionBlock) {
                                 self.showCompletionBlock(self);
                             }
                             
                         }];
        
        
    };
    return block;
    
}

- (JDPopupBlock)sheetHideAnimation
{
    JDWeakify(self);
    JDPopupBlock block = ^(JDPopupView *popupView){
        JDStrongify(self);
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             
                             CGRect frame = self.attachedView.frame;
                             frame.origin.y = self.attachedView.frame.size.height;
                             self.frame = frame;
                             
                             [self layoutIfNeeded];
                             
                         } completion:^(BOOL finished) {
                             
                             [self removeFromSuperview];
                             
                             if (self.hideAnimation) {
                                 self.hideAnimation(self);
                             }
                             
                         }];
        
        
    };
    return block;
}

- (JDPopupBlock)customShowAnimation
{
    JDWeakify(self);
    JDPopupBlock block = ^(JDPopupView *popupView){
        JDStrongify(self);
        
        [self.attachedView.jd_dimBackgroundView addSubview:self];
        
        
    };
    return block;
    
}


-(void)showKeyBoard
{
    
}

- (void)hideKeyBoard
{
    
}






@end
