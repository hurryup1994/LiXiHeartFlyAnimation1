//
//  ViewController.m
//  LXHeartFlyAnimation
//
//  Created by wits on 16/9/21.
//  Copyright © 2016年 LiXi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) UIButton  *applauseBtn;
@property (strong, nonatomic) UILabel   *applauseNumLabel;
@property (assign, nonatomic) NSInteger applauseNum;
@property (strong, nonatomic) UILabel   *WeChat;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)setUI {
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [image setImage:[UIImage imageNamed:@"applause5"]];
    [self.view addSubview:image];
    
    //微信号LIXI134
    self.WeChat               = [[UILabel alloc] init];
    self.WeChat.textColor     = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    self.WeChat.font          = [UIFont systemFontOfSize:24];
    self.WeChat.text          = @"微信：LIXI134";
    self.WeChat.textAlignment = NSTextAlignmentCenter;
    self.WeChat.frame         = CGRectMake(10, self.view.frame.size.height-80-60, 250, 60);
    [self.view addSubview:self.WeChat];
    
    //鼓掌按钮
    self.applauseBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-15-60, self.view.frame.size.height-80-60, 60, 60)];
    self.applauseBtn.contentMode = UIViewContentModeScaleToFill;
    [self.applauseBtn setImage:[UIImage imageNamed:@"applause5"] forState:UIControlStateNormal];
    [self.applauseBtn setImage:[UIImage imageNamed:@"applause4"] forState:UIControlStateHighlighted];
    [self.applauseBtn addTarget:self action:@selector(applauseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.applauseBtn.layer.cornerRadius = 30;
    self.applauseBtn.clipsToBounds      = YES;
    [self.view addSubview:self.applauseBtn];
    
    //鼓掌数
    self.applauseNumLabel               = [[UILabel alloc] init];
    self.applauseNumLabel.textColor     = [UIColor whiteColor];
    self.applauseNumLabel.font          = [UIFont systemFontOfSize:12];
    self.applauseNumLabel.text          = @"0";
    self.applauseNumLabel.textAlignment = NSTextAlignmentCenter;
    self.applauseNumLabel.frame         = CGRectMake(6, 43, 60, 12);
    [self.applauseBtn addSubview:self.applauseNumLabel];
}


#pragma mark 鼓掌按钮event
- (void)applauseBtnClick {
    self.applauseNum++;
    self.applauseNumLabel.text = [NSString stringWithFormat:@"%zd", self.applauseNum];
    [self showTheApplauseInView:self.view belowView:self.applauseBtn];
}


#pragma mark 鼓掌动画
- (void)showTheApplauseInView:(UIView *)view belowView:(UIButton *)v {
    //随机去图片
    NSInteger index  = arc4random_uniform(8);
    NSString  *image = [NSString stringWithFormat:@"applause%zd", index];
    //增大Y值可隐藏弹出动画
    UIImageView *applauseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-15-50, self.view.frame.size.height-150, 40, 40)];
    [view insertSubview:applauseImageView belowSubview:v];
    applauseImageView.image = [UIImage imageNamed:image];
    applauseImageView.layer.cornerRadius = 20;
    applauseImageView.clipsToBounds = YES;
    
    //动画路径高度
    CGFloat AnimH = 350;
    applauseImageView.transform = CGAffineTransformMakeScale(0, 0);
    applauseImageView.alpha = 0;
    
    //弹出动画
    //usingSpringWithDamping : 阻力
    //initialSpringVelocity  : 动力
    [UIView animateWithDuration:0.2 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        applauseImageView.transform = CGAffineTransformIdentity;
        applauseImageView.alpha = 0.9;
    } completion:NULL];
    
    //随机跑偏角度
    NSInteger i = arc4random_uniform(2);
    //-1 or 1, 随机方向
    NSInteger rotationDirection = 1 - (2*i);
    //随机角度
    NSInteger roatationFraction = arc4random_uniform(10);
    //图片在上升过程中旋转
    [UIView animateWithDuration:4 animations:^{
        applauseImageView.transform = CGAffineTransformMakeRotation(rotationDirection * M_PI/(4 + roatationFraction*0.2));
    } completion:NULL];
    //动画路径
    UIBezierPath *heartTravelPath = [UIBezierPath bezierPath];
    [heartTravelPath moveToPoint:applauseImageView.center];
    
    //随机取点
    CGFloat ViewX = applauseImageView.center.x;
    CGFloat ViewY = applauseImageView.center.y;
    CGPoint endPoint = CGPointMake(ViewX + rotationDirection*10, ViewY - AnimH);
    
    //随机control点
    NSInteger j = arc4random_uniform(2);
    //随机方向 -1 or 1
    NSInteger travelDirection = 1 - (2*j);
    
    NSInteger m1 = ViewX + travelDirection*(arc4random_uniform(20) + 50);
    NSInteger n1 = ViewY - 60 + travelDirection*arc4random_uniform(20);
    NSInteger m2 = ViewX - travelDirection*(arc4random_uniform(20) + 50);
    NSInteger n2 = ViewY -90 + travelDirection*arc4random_uniform(20);
    CGPoint controlPoint1 = CGPointMake(m1, n1);
    CGPoint controlPoint2 = CGPointMake(m2, n2);
    
    //根据贝塞尔曲线添加动画
    [heartTravelPath addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    
    //关键帧动画，实现整体图片位移
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyframeAnimation.path = heartTravelPath.CGPath;
    keyframeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    //往上飘动画时长，可控制速度
    keyframeAnimation.duration = 3;
    [applauseImageView.layer addAnimation:keyframeAnimation forKey:@"positionOnPath"];
    
    //消失动画
    [UIView animateWithDuration:3 animations:^{
        applauseImageView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [applauseImageView removeFromSuperview];
    }];
}

@end
