//
//  JDPopupItem.h
//  JDPopupView
//
//  Created by Jason on 15/11/19.
//  Copyright © 2015年 Jason Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JDPopupItemHandler)(NSInteger index);

@interface JDPopupItem : NSObject

@property (nonatomic, assign) BOOL     highlight;
@property (nonatomic, assign) BOOL     disabled;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor  *color;

@property (nonatomic, copy)   JDPopupItemHandler handler;

@end

typedef NS_ENUM(NSUInteger, JDItemType) {
    JDItemTypeNormal,
    JDItemTypeHighlight,
    JDItemTypeDisabled
};





NS_INLINE JDPopupItem* JDItemMake(NSString* title, JDItemType type, JDPopupItemHandler handler)
{
    JDPopupItem *item = [JDPopupItem new];
    
    item.title = title;
    item.handler = handler;
    
    switch (type)
    {
        case JDItemTypeNormal:
        {
            break;
        }
        case JDItemTypeHighlight:
        {
            item.highlight = YES;
            break;
        }
        case JDItemTypeDisabled:
        {
            item.disabled = YES;
            break;
        }
        default:
            break;
    }
    
    return item;
}

