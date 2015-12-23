//
//  JDTYAlertView.m
//  JDPopupView
//
//  Created by Jason on 15/11/20.
//  Copyright © 2015年 Jason Ding. All rights reserved.
//

#import "JDTYAlertView.h"
#import "JDPopupCategory.h"
#import "JDPopupDefine.h"
#import "JDPopupItem.h"

@interface JDTYAlertView ()


@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *detailLabel;

@property (nonatomic, strong) UIView      *buttonView;
@property (nonatomic, strong) NSArray     *actionItems;


@end

@implementation JDTYAlertView

- (instancetype)initWithTitle:(NSString *)title detail:(NSString *)detail items:(NSArray *)items
{

    self = [super init];
    
    if ( self ) {
        NSAssert(items.count>0, @"Could not find any items.");

        JDTYAlertViewConfig* config = [JDTYAlertViewConfig globalConfig];
        
        self.type = JDPopupTypeAlert;
        self.withKeyboard = NO;
        
        self.actionItems = items;
        
        self.layer.cornerRadius = config.cornerRadius;
        self.clipsToBounds = YES;
        self.backgroundColor = config.backgroundColor;
        self.layer.borderWidth = JD_SPLIT_WIDTH;
        self.layer.borderColor = config.splitColor.CGColor;

        
        CGRect selfFrame = self.frame;
        selfFrame.size.width = config.width;
        self.frame = selfFrame;
        
        CGFloat subViewTop = 0;
        
        if ( title && title.length > 0) {
            UILabel* titleLabel = [UILabel new];
            titleLabel.textColor = config.titleColor;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont boldSystemFontOfSize:config.titleFontSize];
            titleLabel.numberOfLines = 0;
            titleLabel.backgroundColor = self.backgroundColor;
            titleLabel.text = title;
            [self addSubview:titleLabel];
            self.titleLabel = titleLabel;
            
            CGFloat x = config.innerMargin;
            CGFloat y = config.innerMargin;
            CGFloat w = config.width- 2*config.innerMargin;
            CGFloat h= [title jd_getSizeWithFont:titleLabel.font withWidth:w].height;
            self.titleLabel.frame = (CGRect){{x,y},{w,h}};
            
            subViewTop = CGRectGetMaxY(self.titleLabel.frame);
        }
        
        if ( detail && detail.length > 0) {
            UILabel *detailLabel = [UILabel new];
            detailLabel.textColor = config.detailColor;
            detailLabel.textAlignment = NSTextAlignmentCenter;
            detailLabel.font = [UIFont systemFontOfSize:config.detailFontSize];
            detailLabel.numberOfLines = 0;
            detailLabel.backgroundColor = self.backgroundColor;
            detailLabel.text = detail;
            [self addSubview:detailLabel];
            self.detailLabel = detailLabel;
            
            CGFloat x = config.innerMargin;
            CGFloat y = subViewTop + 5;
            CGFloat w = config.width - 2*config.innerMargin;
            CGFloat h= [detail jd_getSizeWithFont:detailLabel.font withWidth:w].height;
            self.detailLabel.frame = (CGRect){{x,y},{w,h}};
            
            subViewTop = CGRectGetMaxY(self.detailLabel.frame);
            
        }
        
        // 装载按钮的View
        self.buttonView = [UIView new];
        [self addSubview:self.buttonView];
        
        CGRect btnViewFrame = self.bounds;
        btnViewFrame.origin.y = subViewTop + config.innerMargin;
        btnViewFrame.size.height = (items.count > 2 ? config.buttonHeight * items.count : config.buttonHeight ) + 20 ;
        btnViewFrame.size.width = config.width;
        self.buttonView.frame = btnViewFrame;
        subViewTop = CGRectGetMaxY(btnViewFrame);
        
        // 计算按钮的位置,
        for (int i = 0; i < items.count; i++) {
            
            JDPopupItem* item = items[i];
            
            UIButton* btn = [UIButton jd_buttonWithTarget:self action:@selector(actionButton:)];
            [self.buttonView addSubview:btn];
            btn.tag = i;

            [btn setBackgroundImage:[UIImage jd_imageWithColor:self.backgroundColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage jd_imageWithColor:config.itemPressedColor] forState:UIControlStateHighlighted];
            [btn setTitle:item.title forState:UIControlStateNormal];
            [btn setTitleColor:item.highlight?config.itemHighlightColor:config.itemNormalColor forState:UIControlStateNormal];
            btn.layer.borderWidth = 2;
            btn.layer.borderColor = config.splitColor.CGColor;
            btn.titleLabel.font = (btn==items.lastObject)?[UIFont boldSystemFontOfSize:config.buttonFontSize]:[UIFont systemFontOfSize:config.buttonFontSize];
            btn.layer.cornerRadius = config.cornerRadius;
            
            
            CGFloat JD_BTN_Margin = 10;
            
            CGFloat btnW = ( 2 == items.count  ) ? (config.width )*0.5 - 2*JD_BTN_Margin
            : (config.width  - 2*JD_BTN_Margin) ;
            
            CGFloat btnH = config.buttonHeight ;
            
            CGFloat btnX = (1 == i && 2 == items.count ) ? (btnW ) + 3*JD_BTN_Margin
            : JD_BTN_Margin ;
            
            CGFloat btnY = ((1 == i || 0 == i) && 2 == items.count ) ?  + JD_BTN_Margin
            :  + i * config.buttonHeight + JD_BTN_Margin;
            
            
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            
        }
        
        
        // 根据子控件的尺寸,从新设置alertView的frame
        CGRect selfFrame2 = self.frame;
        selfFrame2.size.height = subViewTop;
        self.frame = selfFrame2;

        
    }
    return self;
    
}



- (void)actionButton:(UIButton*)btn
{
    JDPopupItem *item = self.actionItems[btn.tag];
    
    if ( item.disabled )
    {
        return;
    }
    
    [self hide];
    
    if ( item.handler )
    {
        item.handler(btn.tag);
    }
    
}


@end

@interface JDTYAlertViewConfig()

@end

@implementation JDTYAlertViewConfig

+ (JDTYAlertViewConfig *)globalConfig
{
    static JDTYAlertViewConfig *config;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        config = [JDTYAlertViewConfig new];
        
    });
    
    return config;
}

- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.width          = 275.0f;
        self.buttonHeight   = 50.0f;
        self.innerMargin    = 25.0f;
        self.cornerRadius   = 5.0f;
        
        self.titleFontSize  = 18.0f;
        self.detailFontSize = 14.0f;
        self.buttonFontSize = 17.0f;
        
        
        
        self.backgroundColor    = JDHexColor(0xFFFFFFFF);
        self.titleColor         = JDHexColor(0x333333FF);
        self.detailColor        = JDHexColor(0x333333FF);
        self.splitColor         = JDHexColor(0xCCCCCCFF);
        
        self.itemNormalColor    = JDHexColor(0x333333FF);
        self.itemHighlightColor = JDHexColor(0xE76153FF);
        self.itemPressedColor   = JDHexColor(0xEFEDE7FF);
        
        self.defaultTextOK      = @"好";
        self.defaultTextCancel  = @"取消";
        self.defaultTextConfirm = @"确定";
    }
    
    return self;
}
@end


