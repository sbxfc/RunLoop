//
//  ViewController.m
//  RunLoops-RunLoopObserver
//
//  Created by sbx_fc on 15-5-8.
//  Copyright (c) 2015年 RG. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /**
     * 创建了一个1000项的列表,在列表拖动时注意监听事件的变化。
     * 当触摸发生时 主线程进入 UITrackingRunLoopMode 模式,
     * 绑定在kCFRunLoopDefaultMode模式下的timerFire:不会触发事件
     * 只有当 UITrackingRunLoopMode 模式结束,重新进入 kCFRunLoopDefaultMode 模式时才会触发 timerFire
     */
    UITableView* tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:tableView];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFire:) userInfo:nil repeats:YES];
    
    [self observerRunLoop];
}

/**
 * 定义一个运行在 kCFRunLoopDefaultMode 模式下的观察者
 */
- (void)observerRunLoop
{
    NSRunLoop *curRunLoop = [NSRunLoop currentRunLoop];
    //创建observer的运行环境
    CFRunLoopObserverContext  context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    //创建observer对象
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,    //分配内存
                                                            kCFRunLoopAllActivities,//设置观察类型
                                                            YES,                    //标识该observer是在第一次进入run loop时执行还是每次进入run loop处理时均执行
                                                            0,                      //设置该observer的优先级
                                                            &myRunLoopObserver,     //设置该observer的回调函数
                                                            &context);              //设置该observer的运行环境
    
    if (observer) {
        //将Cocoa的NSRunLoop类型转换成Core Foundation的CFRunLoopRef类型
        CFRunLoopRef cfRunLoop = [curRunLoop getCFRunLoop];
        //将新建的observer加入到当前thread的run loop
        CFRunLoopAddObserver(cfRunLoop, observer, kCFRunLoopDefaultMode);
    }
}

-(void)timerFire:(id)sender
{
    NSLog(@"Timer Fire!");
}

/**
 * observer设置了对所有的run loop行为都感兴趣。
 */
void myRunLoopObserver(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        case kCFRunLoopExit:
            NSLog(@"Run Loop 终止");
            break;
        case kCFRunLoopBeforeTimers:
            NSLog(@"将要处理一个Timer事件源");
            break;
        case kCFRunLoopBeforeWaiting:
            NSLog(@"即将进入休眠");
            break;
        case kCFRunLoopAfterWaiting:
            NSLog(@"被唤醒的时刻,但在唤醒它的事件被处理之前");
            break;
        case kCFRunLoopEntry:
            NSLog(@"RunLoop 进入");
            break;
        case kCFRunLoopBeforeSources:
            NSLog(@"即将处理一个 Input Source");
            break;
        default:
            break;
    }
}

#pragma mark -- UITableViewDelegate  --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1000;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
