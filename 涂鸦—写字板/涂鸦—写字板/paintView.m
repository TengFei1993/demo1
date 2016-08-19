//
//  paintView.m
//  涂鸦—写字板
//
//  Created by yangxiaofei on 15/12/30.
//  Copyright (c) 2015年 yangxiaofei. All rights reserved.
//

#import "paintView.h"

@interface paintView ()

@property (nonatomic,strong) NSMutableArray *alllines;

@property (nonatomic,strong) NSMutableArray *colors;

@end

/*
 调用[self setNeedsDisplay]方法，是将view上所有的图形都要重新绘制，如果原来有，看似没动，其实重新绘制了，原来没有的就重新绘制到view上。
 
 每条线的点放在不同的数组中，遍历每个数组的点的时候，画一条线，互不干扰，所以不会连成一条线
 
 */

@implementation paintView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//数组懒加载
- (NSMutableArray *) alllines{
    if (!_alllines) {
        _alllines = [NSMutableArray array];
    }
    return _alllines;
}

- (NSMutableArray *)colors{
    if (!_colors) {
        _colors = [NSMutableArray array];
    }
    return _colors;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    //图形上下文
//    NSLog(@"%s",__func__);
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSInteger count1 = self.alllines.count;
    for (NSInteger i = 0; i < count1; i++) {
        NSArray *locations = self.alllines[i];
        NSInteger count2 = locations.count;
        for (NSInteger i = 0; i < count2; i++) {
            CGPoint location = [locations[i] CGPointValue];
            if (i == 0) {
//                NSLog(@"%d",1);
                CGContextMoveToPoint(context, location.x, location.y);
            }else{
//                NSLog(@"%d",2);
                CGContextAddLineToPoint(context, location.x, location.y);
//                NSLog(@"%@",self.alllines);
            }
        }
        //设置 线宽
        CGContextSetLineWidth(context, 4);
        //设置 拐角和头上 圆滑
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        //设置颜色,先 取出颜色
        UIColor *color = self.colors[i];
        [color set];
        //渲染
        CGContextStrokePath(context);
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"%s",__func__);
    NSMutableArray *locations = [NSMutableArray array];
    //获取touch
    UITouch *touch = [touches anyObject];
    //获取当前的位置
    CGPoint location = [touch locationInView:touch.view];
    //存入数组
    [locations addObject:[NSValue valueWithCGPoint:location]];
    //将当前颜色 存入数组
    /*
     自己创建的颜色对象默认的值是nil，既不是白色，也不是黑色，使用颜色的时候必须先赋值
     
     这里，currentcolor在不点击颜色选项的时候是nil，画图时就会取不到颜色，会报错。所以需要判断这种情况，给一个默认的黑色
     */
    if (!self.currentColor) {
        //给一个，默认的黑色
        [self.colors addObject:[UIColor blackColor]];
    }else{
        [self.colors addObject:self.currentColor];
    }
    
    [self.alllines addObject:locations];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
//    NSLog(@"%s",__func__);
    //touch
    UITouch *touch = [touches anyObject];
    //位置
    CGPoint location = [touch locationInView:self];
    //存入数组,应该是 存放所有线的数组的最后一个元素，这个元素是存放每条线的所有点
    [self.alllines.lastObject addObject:[NSValue valueWithCGPoint:location]];
    //重绘
    [self setNeedsDisplay];
}

- (void) clearLine
{
    //清屏操作，将数组清空，重新绘图
    [self.alllines removeAllObjects];
    [self setNeedsDisplay];
}
- (void) backLine
{
    //将刚画的线 清除 ，清除数组的最后一个元素
    [self.alllines removeLastObject];
    [self setNeedsDisplay];
}
/*
 不能使用重写setter方法的方式更改颜色，这样会更改全部的颜色。要求是每一条线都有一个颜色，所以也应该对应一个数组，存放颜色。
 */
//- (void) setCurrentColor:(UIColor *)currentColor
//{
//    _currentColor = currentColor;
//    [self setNeedsDisplay];
//}











/*
 仅使用touchesMoved一个方法的时候，所有画的线都会连接成为一条线
 
 改进：使用tochesBegin方法，每次点击屏幕的时候，代表一条线的开始，用一个数组存储所有线，数组的元素就是每条线的所有点
 */


/*         画一条线所需要的步骤
 
 @interface paintView ()
 
 @property (nonatomic,strong) NSMutableArray *locations;
 
 @end
 
@implementation paintView
 //数组懒加载
 - (NSMutableArray *) locations{
 if (!_locations) {
 _locations = [NSMutableArray array];
 }
 return _locations;
 }
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 
 //图形上下文
 CGContextRef context = UIGraphicsGetCurrentContext();
 //遍历数组，取出所有点
 NSInteger count = self.locations.count;
 for (NSInteger i = 0; i < count; i++) {
 CGPoint point = [self.locations[i] CGPointValue];
 if (i == 0) {
 CGContextMoveToPoint(context, point.x, point.y);
 }else{
 CGContextAddLineToPoint(context, point.x,point.y);
 }
 
 }
 //渲染
 CGContextStrokePath(context);
 }
 - (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
 {
 //获取当前触摸事件
 UITouch *touch = [touches anyObject];
 //获取move时的所有点
 CGPoint curpoint = [touch locationInView:touch.view];
 //将点存到一个数组中，提供画线时使用
 [self.locations addObject:[NSValue valueWithCGPoint:curpoint]];
 
 //需要在触摸事件进行的时候进行重绘图形，这样徒刑才会随着触摸事件的进行而画出来，因为DrawRect方法是在view加载好的时候执行的，如果不进行重绘，是不会执行的，就不能画出图形
 [self setNeedsDisplay];
 
 }

 */
@end
