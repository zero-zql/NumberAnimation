//
//  ViewController.m
//  NumberAnimation
//
//  Created by zhuqinlu on 16/9/22.
//  Copyright © 2016年 zero. All rights reserved.
//

#define kScreenHeight [[UIScreen mainScreen] bounds].size.height //主屏幕的高度
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width  //主屏幕的宽度


#import "ViewController.h"

@interface ViewController ()
{
       NSTimer *_balanceLabelAnimationTimer;
}
@property (nonatomic, strong) UILabel *moneyLab;

@property (nonatomic, assign) float balance;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self bulidUI];

}
- (void)bulidUI{
    
    self.moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 50.0f)];
    self.moneyLab.font = [UIFont systemFontOfSize:50.0f];
    self.moneyLab.textAlignment = NSTextAlignmentCenter;
    self.moneyLab.text = @"0.00";
    [self.view addSubview:self.moneyLab];
    
    [self setNumberTextOfLabel:self.moneyLab WithAnimationForValueContent:10000];
}

//- (void)setBalance:(float)balance {
//    _balance = 1000;
//    _balance = balance;
//    _moneyLab.text = [NSString stringWithFormat:@"%f",balance];
//    [self setNumberTextOfLabel:self.moneyLab WithAnimationForValueContent:balance];
//}

#pragma mark --- 余额支付的动画----
- (void)setNumberTextOfLabel:(UILabel *)label WithAnimationForValueContent:(CGFloat)value
{
    CGFloat lastValue = [label.text floatValue];
    CGFloat delta = value - lastValue;
    if (delta == 0) {
        
        return;
    }
    
    if (delta > 0) {
        
        CGFloat ratio = value / 60.0;
        
        NSDictionary *userInfo = @{@"label" : label,
                                   @"value" : @(value),
                                   @"ratio" : @(ratio)
                                   };
        _balanceLabelAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(setupLabel:) userInfo:userInfo repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_balanceLabelAnimationTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)setupLabel:(NSTimer *)timer
{
    NSDictionary *userInfo = timer.userInfo;
    UILabel *label = userInfo[@"label"];
    CGFloat value = [userInfo[@"value"] floatValue];
    CGFloat ratio = [userInfo[@"ratio"] floatValue];
    
    static int flag = 1;
    CGFloat lastValue = [label.text floatValue];
    CGFloat randomDelta = (arc4random_uniform(2) + 1) * ratio;
    CGFloat resValue = lastValue + randomDelta;
    
    if ((resValue >= value) || (flag == 50)) {
        label.text = [NSString stringWithFormat:@"%.2f", value];
        flag = 1;
        [timer invalidate];
        timer = nil;
        return;
    } else {
        label.text = [NSString stringWithFormat:@"%.2f", resValue];
    }
    
    flag++;
}

- (void)dealloc {
    
    //释放定时器
    [_balanceLabelAnimationTimer invalidate];
    _balanceLabelAnimationTimer = nil;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
