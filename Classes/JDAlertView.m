//
//  JDAlertView.m
//  JDPopupView
//
//  Created by Jason on 15/11/19.
//  Copyright © 2015年 Jason Ding. All rights reserved.
//

#import "JDAlertView.h"
#import "JDPopupItem.h"
#import "JDPopupCategory.h"
#import "JDPopupDefine.h"

@interface JDAlertView ()

@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *detailLabel;
@property (nonatomic, strong) UITextField *inputView;
@property (nonatomic, strong) UIView      *buttonView;

@property (nonatomic, strong) NSArray     *actionItems;

@property (nonatomic, copy) JDPopupInputHandler inputHandler;


@end

@implementation JDAlertView

- (instancetype)initWithInputTitle:(NSString *)title
                            detail:(NSString *)detail
                       placeholder:(NSString *)inputPlaceholder
                           handler:(JDPopupInputHandler)inputHandler
{
    JDAlertViewConfig *config = [JDAlertViewConfig globalConfig];
    
    NSArray *items = @[
                       JDItemMake(config.defaultTextCancel, JDItemTypeHighlight, nil),
                       JDItemMake(config.defaultTextConfirm, JDItemTypeHighlight, nil)
                       ];
    
    return [self initWithTitle:title detail:detail items:items inputPlaceholder:inputPlaceholder inputHandler:inputHandler];
    
}

- (instancetype)initWithConfirmTitle:(NSString *)title detail:(NSString *)detail
{
    JDAlertViewConfig *config = [JDAlertViewConfig globalConfig];
    
    NSArray *items = @[
                       JDItemMake(config.defaultTextOK, JDItemTypeHighlight, nil)
                       ];
    
    return [self initWithTitle:title detail:detail items:items];
}


- (instancetype)initWithTitle:(NSString *)title
                       detail:(NSString *)detail
                        items:(NSArray *)items
{
    return [self initWithTitle:title detail:detail items:items inputPlaceholder:nil inputHandler:nil];
}


- (instancetype)initWithTitle:(NSString *)title
                       detail:(NSString *)detail
                        items:(NSArray *)items
             inputPlaceholder:(NSString *)inputPlaceholder
                 inputHandler:(JDPopupInputHandler)inputHandler
{
    
    self = [super init];
    
    if ( self ) {
        NSAssert(items.count>0, @"Could not find any items.");
        
        JDAlertViewConfig* config = [JDAlertViewConfig globalConfig];
        
        self.type = JDPopupTypeAlert;
        self.withKeyboard = (inputHandler != nil);
        
        self.inputHandler = inputHandler;
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
        if ( title.length > 0) {
            
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
        
        if ( detail.length > 0) {
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
        
        if ( self.inputHandler ) {
            UITextField *inputView = [UITextField new];
            inputView.backgroundColor = self.backgroundColor;
            inputView.layer.borderWidth = JD_SPLIT_WIDTH;
            inputView.layer.borderColor = config.splitColor.CGColor;
            inputView.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
            inputView.leftViewMode = UITextFieldViewModeAlways;
            inputView.clearButtonMode = UITextFieldViewModeWhileEditing;
            inputView.placeholder = inputPlaceholder;
            [self addSubview:inputView];
            self.inputView = inputView;
            
            CGFloat x = config.innerMargin;
            CGFloat y = subViewTop + 10;
            CGFloat w = config.width- 2*config.innerMargin;
            CGFloat h = 40;
            self.inputView.frame = (CGRect){{x,y},{w,h}};
            
            subViewTop = CGRectGetMaxY(self.inputView.frame);
        }
        
        // 装载按钮的View
        self.buttonView = [UIView new];
        [self addSubview:self.buttonView];
        
        CGRect btnViewFrame = self.bounds;
        btnViewFrame.origin.y = subViewTop + config.innerMargin;
        btnViewFrame.size.height = items.count > 2 ? config.buttonHeight * items.count : config.buttonHeight;
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
            btn.layer.borderWidth = JD_SPLIT_WIDTH;
            btn.layer.borderColor = config.splitColor.CGColor;
            btn.titleLabel.font = (btn==items.lastObject)?[UIFont boldSystemFontOfSize:config.buttonFontSize]:[UIFont systemFontOfSize:config.buttonFontSize];
            
            
            CGFloat btnW = ( 2 == items.count  ) ? (config.width )*0.5 + JD_SPLIT_WIDTH
                                                 : (config.width + JD_SPLIT_WIDTH) ;
            
            CGFloat btnH = config.buttonHeight + JD_SPLIT_WIDTH;

            CGFloat btnX = (1 == i && 2 == items.count ) ? (btnW - JD_SPLIT_WIDTH)
                                                         : -JD_SPLIT_WIDTH;
            
            CGFloat btnY = ((1 == i || 0 == i) && 2 == items.count ) ? JD_SPLIT_WIDTH
                                                                     : -JD_SPLIT_WIDTH + i * config.buttonHeight;

            
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            
        }
        
        
        // 根据子控件的尺寸,从新设置alertView的frame
        CGRect selfFrame2 = self.frame;
        selfFrame2.size.height = subViewTop;
        self.frame = selfFrame2;

        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyTextChange:) name:UITextFieldTextDidChangeNotification object:nil];

    
    return self;
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}


- (void)actionButton:(UIButton*)btn
{
    JDPopupItem *item = self.actionItems[btn.tag];
    
    if ( item.disabled )
    {
        return;
    }
    
    if ( self.withKeyboard && (btn.tag==1) )
    {
        if ( self.inputView.text.length > 0 )
        {
            [self hide];
        }
    }
    else
    {
        [self hide];
    }
    
    if ( self.inputHandler && (btn.tag>0) )
    {
        self.inputHandler(self.inputView.text);
    }
    else
    {
        if ( item.handler )
        {
            item.handler(btn.tag);
        }
    }
}
- (void)notifyTextChange:(NSNotification *)n
{
    if ( self.maxInputLength == 0 )
    {
        return;
    }
    
    if ( n.object != self.inputView )
    {
        return;
    }
    
    UITextField *textField = self.inputView;
    
    NSString *toBeString = textField.text;
    
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        if (toBeString.length > self.maxInputLength) {
            textField.text = [toBeString jd_truncateByCharLength:self.maxInputLength];
        }
    }
}
- (void)showKeyboard
{
    [self.inputView becomeFirstResponder];
}

- (void)hideKeyboard
{
    [self.inputView resignFirstResponder];
}


@end



@interface JDAlertViewConfig()

@end

@implementation JDAlertViewConfig

+ (JDAlertViewConfig *)globalConfig
{
    static JDAlertViewConfig *config;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        config = [JDAlertViewConfig new];
        
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
