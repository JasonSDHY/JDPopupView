//
//  JDAlertView.h
//  JDPopupView
//
//  Created by Jason on 15/11/19.
//  Copyright © 2015年 Jason Ding. All rights reserved.
//

#import "JDPopupView.h"

typedef void(^JDPopupInputHandler)(NSString *text);


@interface JDAlertView : JDPopupView

@property (nonatomic, assign) NSUInteger maxInputLength; // 默认是0, 意思是不限制长度

- (instancetype) initWithInputTitle:(NSString*)title
                             detail:(NSString*)detail
                        placeholder:(NSString*)inputPlaceholder
                            handler:(JDPopupInputHandler)inputHandler;

- (instancetype) initWithConfirmTitle:(NSString*)title
                               detail:(NSString*)detail;

- (instancetype) initWithTitle:(NSString*)title
                        detail:(NSString*)detail
                         items:(NSArray*)items;


@end
/**
 *  为JDAlertView设置属性的全局类
 */
@interface JDAlertViewConfig : NSObject

+ (JDAlertViewConfig*) globalConfig;

@property (nonatomic, assign) CGFloat width;                // Default is 275.
@property (nonatomic, assign) CGFloat buttonHeight;         // Default is 50.
@property (nonatomic, assign) CGFloat innerMargin;          // Default is 25.
@property (nonatomic, assign) CGFloat cornerRadius;         // Default is 5.

@property (nonatomic, assign) CGFloat titleFontSize;        // Default is 18.
@property (nonatomic, assign) CGFloat detailFontSize;       // Default is 14.
@property (nonatomic, assign) CGFloat buttonFontSize;       // Default is 17.

@property (nonatomic, strong) UIColor *backgroundColor;     // Default is #FFFFFF.
@property (nonatomic, strong) UIColor *titleColor;          // Default is #333333.
@property (nonatomic, strong) UIColor *detailColor;         // Default is #333333.
@property (nonatomic, strong) UIColor *splitColor;          // Default is #CCCCCC.

@property (nonatomic, strong) UIColor *itemNormalColor;     // Default is #333333. effect with MMItemTypeNormal
@property (nonatomic, strong) UIColor *itemHighlightColor;  // Default is #E76153. effect with MMItemTypeHighlight
@property (nonatomic, strong) UIColor *itemPressedColor;    // Default is #EFEDE7.

@property (nonatomic, strong) NSString *defaultTextOK;      // Default is "好".
@property (nonatomic, strong) NSString *defaultTextCancel;  // Default is "取消".
@property (nonatomic, strong) NSString *defaultTextConfirm; // Default is "确定".

@end