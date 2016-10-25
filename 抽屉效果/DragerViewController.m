//
//  DragerViewController.m
//  抽屉效果
//
//  Created by jianglingfeng on 16/10/17.
//  Copyright © 2016年 jianglingfeng. All rights reserved.
//

#import "DragerViewController.h"

#define screenW [UIScreen mainScreen].bounds.size.width

@interface DragerViewController ()
@property (nonatomic,strong) UIView *leftV;
@property (nonatomic,strong) UIView *rightV;
@property (nonatomic,strong) UIView *mainV;
@end

@implementation DragerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUp];
        
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.mainV addGestureRecognizer:pan];
    
    //给控制器的view添加点按手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
}

-(void)tap{
    //让mainV复位
    [UIView animateWithDuration:0.5 animations:^{
        self.mainV.frame = self.view.bounds;
    }];
}

#define targetR 275
#define targetL -275
-(void)pan:(UIPanGestureRecognizer *)pan{
    //获取偏移量
    CGPoint transP = [pan translationInView:self.mainV];
    
    //为什么不使用transform，是因为还要去修改高度，使用transform只能修改x，y
//    self.mainV.transform = CGAffineTransformTranslate(self.mainV.transform, transP.x, transP.y);
    
    self.mainV.frame = [self frameWithOffsetX:transP.x];
    
    //判断拖动的方向
    if (self.mainV.frame.origin.x > 0) {
        //向右
        self.rightV.hidden = YES;
    }else if (self.mainV.frame.origin.x < 0){
        //向左
        self.rightV.hidden = NO;
    }
    
    //当手指松开时自动定位
    CGFloat target = 0;
    if (pan.state == UIGestureRecognizerStateEnded) {

        if (self.mainV.frame.origin.x > screenW * 0.5) {
            //1.判断在右侧
            //当前view的x有没有大于屏幕宽度的一半，大于在右侧
            target = targetR;
        }else if(CGRectGetMaxX(self.mainV.frame)< screenW * 0.5){
            //2. 判断在左侧
            //当前view的最大x有没有小于屏幕宽度的一半，小于在左侧
            target = targetL;
        }
        
        NSLog(@"=====%f",self.mainV.frame.origin.x);
        //计算当前mainV的frame
        CGFloat offset = target - self.mainV.frame.origin.x;
        [UIView animateWithDuration:0.5 animations:^{
             self.mainV.frame = [self frameWithOffsetX:offset];
        }];
       
    }
    
    //复位
    [pan setTranslation:CGPointZero inView:self.mainV];
}

#define maxY 100
//根据偏移量计算mainV的frame
-(CGRect)frameWithOffsetX:(CGFloat)offsetX{
    CGRect frame = self.mainV.frame;
    frame.origin.x += offsetX;
    
    //当拖动的view的x值等于屏幕宽度的时候，maxY为最大，最大为100
   
    //对计算的结果取绝对值
    CGFloat y = fabs(frame.origin.x * maxY / [UIScreen mainScreen].bounds.size.width);
    frame.origin.y = y;
    
    //屏幕的高度减去两倍的Y值
    frame.size.height = [UIScreen mainScreen].bounds.size.height - (2 * frame.origin.y);
    
    return frame;
}

-(void)setUp{
    UIView *leftV = [[UIView alloc] initWithFrame:self.view.bounds];
    leftV.backgroundColor = [UIColor blueColor];
    [self.view addSubview:leftV];
    self.leftV = leftV;
    
    UIView *rightV = [[UIView alloc] initWithFrame:self.view.bounds];
    rightV.backgroundColor = [UIColor greenColor];
    [self.view addSubview:rightV];
    self.rightV = rightV;
    
    UIView *mainV = [[UIView alloc] initWithFrame:self.view.bounds];
    mainV.backgroundColor = [UIColor redColor];
    [self.view addSubview:mainV];
    self.mainV = mainV;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
