//
//  ScrollView.h
//  playtext
//
//  Created by 宋朝阳 on 2017/5/19.
//  Copyright © 2017年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapScrollView)();

@interface ScrollView : UIView

@property (nonatomic, copy) TapScrollView tapBlock;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *imageViewAry;

- (void) tapScroll:(TapScrollView)tapScrollBlock;

@end
