//
//  ViewController.m
//  JDPopupView
//
//  Created by Jason on 15/11/17.
//  Copyright © 2015年 Jason Ding. All rights reserved.
//

#import "ViewController.h"
#import "JDPopupWindow.h"
#import "JDPopupView.h"
#import "JDAlertView.h"
#import "JDPopupItem.h"
#import "JDSheetView.h"
#import "JDTYAlertView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[JDPopupWindow sharedWindow]cacheWindow];
    [JDPopupWindow sharedWindow].touchWildToHide = YES;
    

    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    btn.backgroundColor = [UIColor blueColor];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}
- (void)btnClick
{
    
    JDPopupItemHandler block = ^(NSInteger index){
        NSLog(@"clickd %@ button",@(index));
    };

    NSArray *items =
    @[JDItemMake(@"Done", JDItemTypeNormal, block),
      JDItemMake(@"Save", JDItemTypeHighlight, block),
      JDItemMake(@"Cancel", JDItemTypeDisabled, block)
      ];
    
//    JDAlertView* alertView= [[JDAlertView alloc] initWithTitle:@"确认取消收藏" detail:@"" items:items ];
    
//    JDAlertView* alertView2 = [[JDAlertView alloc]initWithInputTitle:@"jjj" detail:@"lll" placeholder:@"lai啊" handler:^(NSString *text) {    NSLog(@"%@",text);    }];
    
//    JDSheetView* sheeView = [[ JDSheetView alloc]initWithTitle:@"你在哪啊?~~!" items:items];
    
    JDTYAlertView* al = [[JDTYAlertView alloc]initWithTitle:@"要收藏?" detail:nil items:items];
    [al show];
    
    
    
//    [alertView show];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

-(void)btnClick:(UIButton *)btn{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
