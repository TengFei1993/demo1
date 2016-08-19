//
//  paintView.h
//  涂鸦—写字板
//
//  Created by yangxiaofei on 15/12/30.
//  Copyright (c) 2015年 yangxiaofei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface paintView : UIView

//当前颜色
@property (nonatomic,strong) UIColor *currentColor;

- (void) clearLine;
- (void) backLine;

@end
