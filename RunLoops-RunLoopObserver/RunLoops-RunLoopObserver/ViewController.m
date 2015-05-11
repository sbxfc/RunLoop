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
    
    // 在新线程中运行：
    [self performSelectorInBackground:@selector(observerRunLoop) withObject:nil];
}

- (void)observerRunLoop
{
    //获得当前thread的Run loop
    NSRunLoop *myRunLoop = [NSRunLoop currentRunLoop];
    
    //设置Run loop observer的运行环境
    CFRunLoopObserverContext  context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    //创建Run loop observer对象
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,    //分配observer对象的内存
                                                            kCFRunLoopAllActivities,//设置observer所要关注的事件，详见回调函数myRunLoopObserver中注释
                                                            YES,                    //标识该observer是在第一次进入run loop时执行还是每次进入run loop处理时均执行
                                                            0,                      //设置该observer的优先级
                                                            &myRunLoopObserver,     //设置该observer的回调函数
                                                            &context);              //设置该observer的运行环境
    
    
    if (observer) {
        //将Cocoa的NSRunLoop类型转换成Core Foundation的CFRunLoopRef类型
        CFRunLoopRef cfRunLoop = [myRunLoop getCFRunLoop];
        //将新建的observer加入到当前thread的run loop
        CFRunLoopAddObserver(cfRunLoop, observer, kCFRunLoopDefaultMode);
    }
    
    //Creates and returns a new NSTimer object and schedules it on the current run loop in the default mode
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(doFireTimer:) userInfo:nil repeats:YES];
    
    NSInteger loopCount = 10;
    
    do {
        //启动当前thread的loop直到所指定的时间到达，在loop运行时，run loop会处理所有来自与该run loop联系的input source的数据
        //对于本例与当前run loop联系的input source只有一个Timer类型的source。
        //该Timer每隔0.1秒发送触发事件给run loop，run loop检测到该事件时会调用相应的处理方法。
        
        //由于在run loop添加了observer且设置observer对所有的run loop行为都感兴趣。
        //当调用runUnitDate方法时，observer检测到run loop启动并进入循环，observer会调用其回调函数，第二个参数所传递的行为是kCFRunLoopEntry。
        //observer检测到run loop的其它行为并调用回调函数的操作与上面的描述相类似。
        [myRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
        //当run loop的运行时间到达时，会退出当前的run loop。observer同样会检测到run loop的退出行为并调用其回调函数，第二个参数所传递的行为是kCFRunLoopExit。
        
        loopCount--;
    } while (loopCount);
    
    NSLog(@"The End.");
}


- (void)doFireTimer:(NSTimer*)timer
{
    NSLog(@"fire timer!");
}

// Run loop观察者的回调函数：
void myRunLoopObserver(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"run loop entry");
            break;
        case kCFRunLoopBeforeTimers:
            NSLog(@"run loop before timers");
            break;
        case kCFRunLoopBeforeSources:
            NSLog(@"run loop before sources");
            break;
        case kCFRunLoopBeforeWaiting:
            NSLog(@"run loop before waiting");
            break;
        case kCFRunLoopAfterWaiting:
            NSLog(@"run loop after waiting");
            break;
        case kCFRunLoopExit:
            NSLog(@"run loop exit");
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
