//
//  JDSheetView.h
//  JDPopupView
//
//  Created by Jason on 15/11/19.
//  Copyright © 2015年 Jason Ding. All rights reserved.
//

#import "JDPopupView.h"

#import "JDPopupDefine.h"

@interface JDSheetView : JDPopupView

- (instancetype) initWithTitle:(NSString*)title
                         items:(NSArray*)items;

@end


/**
 *  Global Configuration of MMSheetView.
 */
@interface JDSheetViewConfig : NSObject

+ (JDSheetViewConfig*) globalConfig;

@property (nonatomic, assign) CGFloat buttonHeight;         // Default is 50.
@property (nonatomic, assign) CGFloat innerMargin;          // Default is 19.

@property (nonatomic, assign) CGFloat titleFontSize;        // Default is 14.
@property (nonatomic, assign) CGFloat buttonFontSize;       // Default is 17.

@property (nonatomic, strong) UIColor *backgroundColor;     // Default is #FFFFFF.
@property (nonatomic, strong) UIColor *titleColor;          // Default is #666666.
@property (nonatomic, strong) UIColor *splitColor;          // Default is #CCCCCC.

@property (nonatomic, strong) UIColor *itemNormalColor;     // Default is #333333. effect with MMItemTypeNormal
@property (nonatomic, strong) UIColor *itemDisableColor;    // Default is #CCCCCC. effect with MMItemTypeDisabled
@property (nonatomic, strong) UIColor *itemHighlightColor;  // Default is #E76153. effect with MMItemTypeHighlight
@property (nonatomic, strong) UIColor *itemPressedColor;    // Default is #EFEDE7.

@property (nonatomic, strong) NSString *defaultTextCancel;  // Default is "取消"

@end

