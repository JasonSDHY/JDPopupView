//
//  JDPopupWindow.h
//  JDPopupView
//
//  Created by Jason on 15/11/17.
//  Copyright © 2015年 Jason Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDPopupWindow : UIWindow

@property (nonatomic, assign) BOOL touchWildToHide; /**< 默认是NO, 当是YES时,popup views 会在点击透明的背景图片时被隐藏 */

+ (JDPopupWindow *) sharedWindow;

/**
 *  预加载 popupWindow, 防止第一次出现时卡顿
 */
- (void) cacheWindow;


@end
