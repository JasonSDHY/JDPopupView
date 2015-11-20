//
//  JDSheetView.m
//  JDPopupView
//
//  Created by Jason on 15/11/19.
//  Copyright © 2015年 Jason Ding. All rights reserved.
//

#import "JDSheetView.h"
#import "JDPopupDefine.h"
#import "JDPopupCategory.h"
#import "JDPopupItem.h"

@interface JDSheetView ()

@property (nonatomic, strong) UIView      *titleView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIView      *buttonView;
@property (nonatomic, strong) UIButton    *cancelButton;

@property (nonatomic, strong) NSArray     *actionItems;



@end

@implementation JDSheetView

- (instancetype)initWithTitle:(NSString *)title items:(NSArray *)items
{
    self = [super init];
    if (self) {
        
        NSAssert(items.count>0, @"Could not find any items.");
        
        JDSheetViewConfig* config = [JDSheetViewConfig globalConfig];
        self.type = JDPopupTypeSheet;
        self.actionItems = items;
        
        self.backgroundColor = config.splitColor;
        
        CGFloat screenWidth       = [UIScreen mainScreen].bounds.size.width;
        CGRect sheetViewFrame     = self.frame;
        sheetViewFrame.size.width = screenWidth;
        self.frame                = sheetViewFrame;

        // 1,记录各个控件的最大Y值, 用于最后确定sheetView的高度
        CGFloat subViewTop = 0;
        
        
        // 2,放置title的View
        if ( title.length > 0) {
            
            self.titleView = [UIView new];
            [self addSubview:self.titleView];
            self.titleView.backgroundColor = config.backgroundColor;

            
            // 2.1显示title的Label
            UILabel* titleLabel           = [UILabel new];
            self.titleLabel               = titleLabel;

            self.titleLabel.textColor     = config.titleColor;
            self.titleLabel.font          = [UIFont systemFontOfSize:config.titleFontSize];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.numberOfLines = 0;
            self.titleLabel.text          = title;
            [self addSubview:titleLabel];
            
            CGFloat x = config.innerMargin;
            CGFloat y = config.innerMargin;
            CGFloat w = screenWidth - 2*config.innerMargin;
            CGFloat h = [title jd_getSizeWithFont:titleLabel.font withWidth:w].height;
            self.titleLabel.frame = (CGRect){{x,y},{w,h}};
            
            CGRect titleViewFrame      = self.titleView.frame;
            titleViewFrame.size.height = CGRectGetMaxY(self.titleLabel.frame) + config.innerMargin;
            titleViewFrame.size.width  = screenWidth;
            self.titleView.frame = titleViewFrame;
            
            subViewTop = CGRectGetMaxY(titleViewFrame);
        }

        
        // 3,装载按钮的View
        self.buttonView = [UIView new];
        [self addSubview:self.buttonView];

        CGRect btnViewFrame ;
        btnViewFrame.origin.y    = subViewTop + JD_SPLIT_WIDTH;
        btnViewFrame.size.height = config.buttonHeight * items.count;
        btnViewFrame.size.width  = screenWidth;
        self.buttonView.frame    = btnViewFrame;
        subViewTop               = CGRectGetMaxY(btnViewFrame);
        

        // 4,按钮代表选项
        for (int i = 0; i < items.count; i++) {
            
            JDPopupItem *item = items[i];
            
            UIButton *btn = [UIButton jd_buttonWithTarget:self action:@selector(actionButton:)];
            [self.buttonView addSubview:btn];
            btn.tag = i;

            [btn setBackgroundImage:[UIImage jd_imageWithColor:config.backgroundColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage jd_imageWithColor:config.backgroundColor] forState:UIControlStateDisabled];
            [btn setBackgroundImage:[UIImage jd_imageWithColor:config.itemPressedColor] forState:UIControlStateHighlighted];
            [btn setTitle:item.title forState:UIControlStateNormal];
            [btn setTitleColor:item.highlight?config.itemHighlightColor:item.disabled?config.itemDisableColor:config.itemNormalColor forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:config.buttonFontSize];
            btn.layer.borderWidth = JD_SPLIT_WIDTH;
            btn.layer.borderColor = config.splitColor.CGColor;
            btn.enabled = !item.disabled;
            
            
            CGFloat btnW = screenWidth;
            
            CGFloat btnH = config.buttonHeight + JD_SPLIT_WIDTH;
            
            CGFloat btnX = -JD_SPLIT_WIDTH;
            
            CGFloat btnY = -JD_SPLIT_WIDTH + i * config.buttonHeight;
            

            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            
        }
        
        
        
        // 5,最后的取消按钮
        self.cancelButton = [UIButton jd_buttonWithTarget:self action:@selector(actionCancel)];
        [self addSubview:self.cancelButton];
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:config.buttonFontSize];
        [self.cancelButton setBackgroundImage:[UIImage jd_imageWithColor:config.backgroundColor] forState:UIControlStateNormal];
        [self.cancelButton setBackgroundImage:[UIImage jd_imageWithColor:config.itemPressedColor] forState:UIControlStateHighlighted];
        [self.cancelButton setTitle:config.defaultTextCancel forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:config.itemNormalColor forState:UIControlStateNormal];
        
        
        CGFloat cancelBtnW = screenWidth;
        CGFloat cancelBtnH = config.buttonHeight + JD_SPLIT_WIDTH;
        CGFloat cancelBtnX = -JD_SPLIT_WIDTH;
        CGFloat cancelBtnY = -JD_SPLIT_WIDTH + 8 + subViewTop;
        self.cancelButton.frame = CGRectMake(cancelBtnX, cancelBtnY, cancelBtnW, cancelBtnH);

        
        subViewTop = CGRectGetMaxY(self.cancelButton.frame);
        
        
        // 6,根据子控件的尺寸,从新设置alertView的frame
        CGRect sheetViewFinishFrame = self.frame;
        sheetViewFinishFrame.size.height = subViewTop;
        self.frame = sheetViewFinishFrame;
        
    }
    
    return self;
}


- (void)actionButton:(UIButton*)btn
{
    JDPopupItem *item = self.actionItems[btn.tag];
    
    [self hide];
    
    if ( item.handler )
    {
        item.handler(btn.tag);
    }
}
- (void)actionCancel
{
    [self hide];
}



@end



@interface JDSheetViewConfig()

@end

@implementation JDSheetViewConfig

+ (JDSheetViewConfig *)globalConfig
{
    static JDSheetViewConfig *config;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        config = [JDSheetViewConfig new];
        
    });
    
    return config;
}

- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.buttonHeight   = 50.0f;
        self.innerMargin    = 19.0f;
        
        self.titleFontSize  = 14.0f;
        self.buttonFontSize = 17.0f;
        
        self.backgroundColor    = JDHexColor(0xFFFFFFFF);
        self.titleColor         = JDHexColor(0x666666FF);
        self.splitColor         = JDHexColor(0xCCCCCCFF);
        
        self.itemNormalColor    = JDHexColor(0x333333FF);
        self.itemDisableColor   = JDHexColor(0xCCCCCCFF);
        self.itemHighlightColor = JDHexColor(0xE76153FF);
        self.itemPressedColor   = JDHexColor(0xEFEDE7FF);
        
        self.defaultTextCancel  = @"取消";
    }
    
    return self;
}

@end
