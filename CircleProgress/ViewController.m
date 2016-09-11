//
//  ViewController.m
//  CircleProgress
//
//  Created by lixun on 16/9/11.
//  Copyright © 2016年 sunshine. All rights reserved.
//

#import "ViewController.h"
#import "CircleProgressView.h"
@interface ViewController ()

@property (nonatomic, strong) CircleProgressView *circleView;

@end

@implementation ViewController

dispatch_queue_t queue;

static dispatch_source_t _timer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _circleView = [[CircleProgressView alloc] initWithFrame:CGRectMake(10, 50, self.view.frame.size.width - 20, 170)];
    _circleView.elapsedTime = 0.f;
    _circleView.timeLimit = 60;
    [self.view addSubview:_circleView];
    [self startAnimationProgress];
}


- (void)startAnimationProgress
{
    static NSInteger timeout = 60;
//    NSString *time = [[NSUserDefaults standardUserDefaults] objectForKey:@"strTime"];
//    
//    if (time && ![time isEqualToString:@"01"])  {
//        NSLog(@"%@",time);
//        timeout = [time integerValue];
//    }else{
//        timeout = 60;
//    }
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //UI的改变
                _circleView.elapsedTime = 0;
            });
        }else{
//            NSInteger seconds = timeout;
//            NSString *strTime = [NSString stringWithFormat:@"%.2ld", (long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                _circleView.elapsedTime = timeout;
//                [[NSUserDefaults standardUserDefaults] setObject:strTime forKey:@"strTime"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}



@end
