//
//  ScrollView.m
//  playtext
//
//  Created by 宋朝阳 on 2017/5/19.
//  Copyright © 2017年 song. All rights reserved.
//

#import "ScrollView.h"

@interface ScrollView () <UIScrollViewDelegate>

{
    float _viewWidth;
    float _viewHeight;
}

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UIImageView *firstView;
@property (strong, nonatomic) UIImageView *middleView;
@property (strong, nonatomic) UIImageView *lastView;
@property (strong, nonatomic) NSTimer *autoScrollTimer;
@property (strong, nonatomic) UITapGestureRecognizer *tap;

@end

@implementation ScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _viewWidth = self.bounds.size.width;
        _viewHeight = self.bounds.size.height;
        
        self.firstView = [[UIImageView alloc] init];
        self.middleView = [[UIImageView alloc] init];
        self.lastView = [[UIImageView alloc] init];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight)];
        self.scrollView.delegate = self;
        self.scrollView.contentSize = CGSizeMake(_viewWidth * 3, _viewHeight);
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.pagingEnabled = YES;
        [self addSubview:self.scrollView];
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _viewHeight - 20, _viewWidth, 20)];
        self.pageControl.userInteractionEnabled = NO;
        self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        [self addSubview:self.pageControl];
        
        self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        self.tap.numberOfTapsRequired = 1;
        self.tap.numberOfTouchesRequired = 1;
        [self.scrollView addGestureRecognizer:self.tap];
        
        [self addTimer];
    }
    return self;
}

- (void)addTimer{
    self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    //将定时器添加到当前的运行循环中(不添加会导致拖动其他控件时图片轮播器会停止)
    [[NSRunLoop currentRunLoop] addTimer:self.autoScrollTimer forMode:NSRunLoopCommonModes];
}

//移除定时器
- (void)removeTimer {
    [self.autoScrollTimer invalidate];//定时器一旦停止就废了
    self.autoScrollTimer = nil;
}

// tap block
- (void)tapScroll:(TapScrollView)tapScrollBlock {
    self.tapBlock = tapScrollBlock;
}

-(void)handleTap:(UITapGestureRecognizer*)sender
{
    self.tapBlock();
}

// set image
- (void) setImageViewAry:(NSMutableArray *)imageViewAry {
    
    _imageViewAry = imageViewAry;
    self.currentPage = 0;
    self.pageControl.currentPage = imageViewAry.count;
    [self loadImageData];
}

- (void)loadImageData {
    [self.firstView removeFromSuperview];
    [self.middleView removeFromSuperview];
    [self.lastView removeFromSuperview];
    
    self.firstView.frame = CGRectMake(0, 0, _viewWidth, _viewHeight);
    self.middleView.frame = CGRectMake(_viewWidth, 0, _viewWidth, _viewHeight);
    self.lastView.frame = CGRectMake(_viewWidth*2, 0, _viewWidth, _viewHeight);
    
    if (self.currentPage == 0) {
        [self.firstView setImage:[UIImage imageNamed:[self.imageViewAry lastObject]]] ;
        [self.middleView setImage:[UIImage imageNamed:[self.imageViewAry objectAtIndex:self.currentPage]]];
        [self.lastView setImage:[UIImage imageNamed:[self.imageViewAry objectAtIndex:self.currentPage + 1]]];
    } else if (self.currentPage == self.imageViewAry.count - 1) {
        [self.firstView setImage:[UIImage imageNamed:[self.imageViewAry objectAtIndex:self.currentPage - 1]]];
        [self.middleView setImage:[UIImage imageNamed:[self.imageViewAry objectAtIndex:self.currentPage]]];
        [self.lastView setImage:[UIImage imageNamed:[self.imageViewAry firstObject]]];
    } else {
        [self.firstView setImage:[UIImage imageNamed:[self.imageViewAry objectAtIndex:self.currentPage - 1]]];
        [self.middleView setImage:[UIImage imageNamed:[self.imageViewAry objectAtIndex:self.currentPage]]];
        [self.lastView setImage:[UIImage imageNamed:[self.imageViewAry objectAtIndex:self.currentPage + 1]]];
    }
    [self.scrollView addSubview:self.firstView];
    [self.scrollView addSubview:self.middleView];
    [self.scrollView addSubview:self.lastView];
    
    self.pageControl.currentPage = self.currentPage;
    self.scrollView.contentOffset = CGPointMake(_viewWidth, 0);
}

-(void)nextImage
{
    if (self.currentPage == self.imageViewAry.count-1) {
        self.currentPage = 0;
    }else{
        self.currentPage ++;
    }
    
    [self loadImageData];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self removeTimer];
    [self addTimer];
    
    //得到当前页数
    float x = _scrollView.contentOffset.x;
    
    //往前翻
    if (x<=0) {
        if (_currentPage-1<0) {
            _currentPage = _imageViewAry.count-1;
        }else{
            _currentPage --;
        }
    }
    
    //往后翻
    if (x>=_viewWidth*2) {
        if (_currentPage==_imageViewAry.count-1) {
            _currentPage = 0;
        }else{
            _currentPage ++;
        }
    }
    [self loadImageData];
}

@end
