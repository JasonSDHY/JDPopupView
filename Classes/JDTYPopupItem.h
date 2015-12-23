//
//  JDTYPopupItem.h
//  JDPopupView
//
//  Created by Jason on 15/11/20.
//  Copyright © 2015年 Jason Ding. All rights reserved.
//

#import "JDPopupItem.h"

typedef NS_ENUM(NSUInteger, JDTYItemType) {
    JDTYItemTypeWhite,
    JDTYItemTypeBlue,
};


@interface JDTYPopupItem : JDPopupItem



@end

NS_INLINE JDPopupItem* JDTYItemMake(NSString *title, JDTYItemType type, JDPopupItemHandler handler)
{
    JDPopupItem* item = [JDPopupItem new];
    item.title = title;
    item.handler = handler;
    
    switch (type) {
        case JDTYItemTypeWhite:
        {
            
        }
            break;
        case JDTYItemTypeBlue:
        {
            
        }
            
        default:
            break;
    }
    return item;
}
