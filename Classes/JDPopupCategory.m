//
//  JDPopupCategory.m
//  JDPopupView
//
//  Created by Jason on 15/11/17.
//  Copyright © 2015年 Jason Ding. All rights reserved.
//

#import "JDPopupCategory.h"
#import <objc/runtime.h>


static const void *jd_dimReferenceCountKey      = &jd_dimReferenceCountKey;

static const void *jd_dimBackgroundViewKey      = &jd_dimBackgroundViewKey;
static const void *jd_dimAnimationDurationKey   = &jd_dimAnimationDurationKey;
static const void *jd_dimBackgroundAnimatingKey = &jd_dimBackgroundAnimatingKey;


@interface UIView (JDPopupInner)

@property (nonatomic, assign, readwrite) NSInteger jd_dimReferenceCount;

@end

@implementation UIView (JDPopupInner)

@dynamic jd_dimReferenceCount;

- (NSInteger)jd_dimReferenceCount
{
    return  [objc_getAssociatedObject(self, jd_dimReferenceCountKey) integerValue];
}

- (void)setJd_dimReferenceCount:(NSInteger)jd_dimReferenceCount
{
    objc_setAssociatedObject(self, jd_dimReferenceCountKey, @(jd_dimReferenceCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


@implementation UIView (JDPopupCategory)

@dynamic jd_dimBackgroundView;
@dynamic jd_dimAnimationDuration;
@dynamic jd_dimBackgroundAnimating;

- (UIView *)jd_dimBackgroundView
{
    UIView* dimView = objc_getAssociatedObject(self, jd_dimBackgroundViewKey);
    if ( !dimView ) {
        
        
        dimView = [UIView new];
        [self addSubview:dimView];
        
        
    }
    
    return dimView;
}


@end
