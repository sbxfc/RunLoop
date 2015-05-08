//
//  ViewController.m
//  RunLoops-NSMachPort
//
//  Created by sbx_fc on 15-5-8.
//  Copyright (c) 2015年 RG. All rights reserved.
//

#import "ViewController.h"
#import "MyWorkerClass.h"

@interface ViewController ()
{
    NSPort *distantPort;
}
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(20, 80, 120, 50)];
    [b setTitle:@"New Thread" forState:UIControlStateNormal];
    [b setBackgroundColor:[UIColor blueColor]];
    [b addTarget:self action:@selector(launchThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
}



//启动线程
- (void)launchThread{
    
    //设置主线程port，子线程通过此端口发送消息给主线程
    NSPort *myPort = [NSMachPort port];
    if (myPort) {
        myPort.delegate = self;
        [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
        
        //启动次线程,并传入端口信息
        [NSThread detachNewThreadSelector:@selector(launchThreadWithPort:) toTarget:[MyWorkerClass class] withObject:myPort];
    }
}

#pragma mark - NSPortDelegate

#define kCheckinMessage 100
#define kExitMessage 101

//port代理，用于处理子线程发给主线程的消息，但NSPortMessage貌似是似有方法,会有警告，如果是arc模式则编译不通过
- (void)handlePortMessage:(NSMessagePort*)message{
    
    NSLog(@"接到子线程传递的消息！");
//    unsigned int msgid = [message msgid];
//    
//    if (msgid == kCheckinMessage) {
//        distantPort = [message sendPot];//执行到此会崩溃
//        //获得distantPort后可向此端口发送kExitMessage让子线程退出
//    }else{
//        
//    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
