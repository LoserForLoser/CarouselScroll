//
//  ViewController.m
//  CarouselScroll
//
//  Created by 宋朝阳 on 2017/6/13.
//  Copyright © 2017年 Song. All rights reserved.
//

#define SCREEN_FRAME ([UIScreen mainScreen].applicationFrame)

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define viewWidthFrame(size) (size * SCREEN_WIDTH / 750)

#define viewHeightFrame(size) (size * SCREEN_HEIGHT / 1334)

#import "ViewController.h"
#import "ScrollView.h"

@interface ViewController ()

@property (strong, nonatomic) ScrollView *scroll;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    __weak ViewController *weakSelf = self;
    
    NSArray *arr1 = [[NSArray alloc] initWithObjects:@"IMG_1",@"IMG_2",@"IMG_3", nil];
    
    NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithArray:arr1];
    
    self.scroll = [[ScrollView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, viewHeightFrame(700))];
    
    [self.scroll setImageViewAry:mutableArr];
    
    [self.view addSubview:self.scroll];
    
    [self.scroll tapScroll:^{
        
        [weakSelf tapScroll];
        
    }];
}

/**
 点击scoroll
 Click scroll
 */
- (void) tapScroll {
    NSLog(@"点击Scroll第%ld张",self.scroll.currentPage + 1);
    NSLog(@"Click Scroll %ld picture",self.scroll.currentPage + 1);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
