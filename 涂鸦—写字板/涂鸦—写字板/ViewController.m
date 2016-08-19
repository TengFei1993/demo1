//
//  ViewController.m
//  涂鸦—写字板
//
//  Created by yangxiaofei on 15/12/30.
//  Copyright (c) 2015年 yangxiaofei. All rights reserved.
//

#import "ViewController.h"
#import "paintView.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet paintView *paintview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//按钮的操作都是跟绘图有关，需要重新绘图，实际上就是将数组中的点消除掉或者消除全部，所以实现应该view中，在这里只是调用它的方法
- (IBAction)BtnClick:(UIButton *)sender
{
    //在控制器里面调用view的方法，让控制器拥有这个控件，然后直接调用，如下
    switch (sender.tag) {
        case 1:
            [self.paintview clearLine];
            break;
        case 2:
            [self.paintview backLine];
            break;
        case 3:
            //保存按钮，将写好的图片保存到桌面上,操作类似于 截图操作
            [self clipScreensie:self.paintview.bounds.size];
            break;
        default:
            break;
    }
}

//设置颜色
- (IBAction)setcolor:(UIButton *)sender
{
    NSLog(@"%s",__func__);
    self.paintview.currentColor = sender.backgroundColor;
}

- (void) clipScreensie:(CGSize) size
{
    //获取图形上下文 ****第一个参数是最终生成图片的大小*****
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //截图 ****调用者是一个UIView对象，要把哪部分的view截图下来，哪个view的layer就调用这个方法
    [self.paintview.layer renderInContext:context];
    //获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //结束编辑
    UIGraphicsEndImageContext();
    
    //将图片保存到桌面
    NSData *iamgedata = UIImagePNGRepresentation(newImage);
    [iamgedata writeToFile:@"/Users/yangxiaofei/Desktop/jietu.png" atomically:YES];
    
}
@end
