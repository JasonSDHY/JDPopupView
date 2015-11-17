//
//  JDPopupCategory.h
//  JDPopupView
//
//  Created by Jason on 15/11/17.
//  Copyright © 2015年 Jason Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JDPopupCategory)

@property (nonatomic, strong, readonly) UIView         *jd_dimBackgroundView;
@property (nonatomic, assign, readonly) BOOL           jd_dimBackgroundAnimating;
@property (nonatomic, assign          ) NSTimeInterval jd_dimAnimationDuration;

- (void) jd_showDimBackground;
- (void) jd_hideDimBackground;

- (void) jd_distributeSpacingHorizontallyWith:(NSArray *)view;
- (void) jd_distributeSpacingVerticallyWith:(NSArray *)view;

@end
