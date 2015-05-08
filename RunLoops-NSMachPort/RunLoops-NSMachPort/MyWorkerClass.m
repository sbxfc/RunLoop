//
//  MyWorkerClass.m
//  RunLoops-NSMachPort
//
//  Created by sbx_fc on 15-5-8.
//  Copyright (c) 2015年 RG. All rights reserved.
//

#import "MyWorkerClass.h"
#import "MyWorkerClass.h"

@interface MyWorkerClass(){
    NSPort *distantPort;
    BOOL   shouldExit;
}
@end

@implementation MyWorkerClass

//类方法，用于创建子线程
+ (void)launchThreadWithPort:(id)inData{
    
    NSPort *outPort = (NSPort *)inData;
    MyWorkerClass *workThread = [[self alloc] init];
    [workThread sendCheckinMessage:outPort];
    
    do{
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }while (![workThread shouldExit]);
    
}

- (void)sendCheckinMessage:(NSPort*)outPort{
    //主线程端口，用于发送消息
    distantPort = outPort;
    
    NSPort *myPort = [NSMachPort port];
    myPort.delegate = self;
    [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
    //发送消息到主线程
    [distantPort sendBeforeDate:[NSDate date] msgid:10 components:nil from:myPort reserved:0];
    
    // Create the check-in message.
//    NSPortMessage* messageObj = [[NSPortMessage alloc] initWithSendPort:outPort
//                                                            receivePort:myPort components:nil];
//    
//    if (messageObj)
//    {
//        // Finish configuring the message and send it immediately.
//        [messageObj setMsgid:kCheckinMessage];
//        [messageObj sendBeforeDate:[NSDate date]];
//    }
    
}

- (BOOL)shouldExit{
    return shouldExit;
}

#pragma mark - NSPortDelegate

#define kCheckinMessage 100
#define kExitMessage 101

- (void)handlePortMessage:(NSPortMessage *)message
{
    
//    unsigned int msgid = [message msgid];
//    NSPort* distantPort = nil;
//    
//    if (msgid == kCheckinMessage)
//    {
//        distantPort = [message sendPort];
//        
//    }
//    else if(msgid == kExitMessage)
//    {
//        shouldExit = YES;
//    }
}


@end
