//
//  JDPopupCategory.h
//  JDPopupView
//
//  Created by Jason on 15/11/17.
//  Copyright © 2015年 Jason Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (JDPopupCategory)

+ (UIColor *) jd_colorWithHex:(NSUInteger)hex ;

@end

@interface UIImage (JDPopupCategory)

+ (UIImage *) jd_imageWithColor:(UIColor *)color;

+ (UIImage *) jd_imageWithColor:(UIColor *)color Size:(CGSize)size;

- (UIImage *) jd_stretched;

@end


@interface UIButton (JDPopupCategory)

+ (id) jd_buttonWithTarget:(id)target action:(SEL)sel;

@end

@interface NSString (JDPopupCategory)

- (NSString *)jd_truncateByCharLength:(NSUInteger)charLength;

- (CGSize) jd_getSizeWithFont:(UIFont *)font withWidth:(CGFloat)width;


@end


@interface UIView (JDPopupCategory)

@property (nonatomic, strong, readonly) UIView         *jd_dimBackgroundView;
@property (nonatomic, assign, readonly) BOOL           jd_dimBackgroundAnimating;
@property (nonatomic, assign          ) NSTimeInterval jd_dimAnimationDuration;

- (void) jd_showDimBackground;
- (void) jd_hideDimBackground;

- (void) jd_distributeSpacingHorizontallyWith:(NSArray *)views;
- (void) jd_distributeSpacingVerticallyWith:(NSArray *)views;

@end
