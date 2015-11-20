//
//  JDPopupView.h
//  JDPopupView
//
//  Created by Jason on 15/11/18.
//  Copyright © 2015年 Jason Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JDPopupType) {
    JDPopupTypeAlert,
    JDPopupTypeSheet,
    JDPopupTypeCustom,
};



@class JDPopupView;

typedef void(^JDPopupBlock)(JDPopupView *);


@interface JDPopupView : UIView

@property (nonatomic, assign, readonly)BOOL visible; // 默认是NO
@property (nonatomic, strong)UIView *attachedView; // 默认是JDPopupWindow, 也可以指定显示在某个UIView之上

@property (nonatomic, assign)JDPopupType type; // 默认是JDPopupTypeAlert
@property (nonatomic, assign)NSTimeInterval animationDuration;  // 默认是0.3秒
@property (nonatomic, assign)BOOL withKeyboard; // 默认是NO,当是YES时,alert view会被显示在屏幕的中间.

@property (nonatomic, copy)JDPopupBlock showCompletionBlock;
@property (nonatomic, copy)JDPopupBlock hideCompletionBlock;

@property (nonatomic, copy)JDPopupBlock showAnimation;
@property (nonatomic, copy)JDPopupBlock hideAnimation;


- (void) showKeyBoard;

- (void) hideKeyBoard;

- (void) show;

- (void) showWithBlcok:(JDPopupBlock)block;

- (void) hide;

- (void) hideWithBlock:(JDPopupBlock)block;












@end
