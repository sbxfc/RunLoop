//
//  MyWorkerClass.h
//  RunLoops-NSMachPort
//
//  Created by sbx_fc on 15-5-8.
//  Copyright (c) 2015年 RG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyWorkerClass : NSObject<NSPortDelegate>

+ (void)launchThreadWithPort:(id)inData;

@end
