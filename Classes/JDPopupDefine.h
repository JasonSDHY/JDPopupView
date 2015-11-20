//
//  JDPopupDefine.h
//  JDPopupView
//
//  Created by Jason on 15/11/17.
//  Copyright © 2015年 Jason Ding. All rights reserved.
//

#ifndef JDPopupDefine_h
#define JDPopupDefine_h

#define JDWeakify(o)        __weak   typeof(self) jdwo = o;
#define JDStrongify(o)      __strong typeof(self) o = jdwo;
#define JDHexColor(color)   [UIColor jd_colorWithHex:color]
#define JD_SPLIT_WIDTH      (1/[UIScreen mainScreen].scale)


#define isIOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define isIOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
#define isIOS9 ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)



#endif /* JDPopupDefine_h */
