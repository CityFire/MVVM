//
//  BaseViewModel.m
//  MVVM
//
//  Created by wjc on 15/9/23.
//  Copyright © 2015年 CityFire. All rights reserved.
//

// 一、RACCommand使用步骤:
// 1.创建命令 initWithSignalBlock:(RACSignal * (^)(id input))signalBlock
// 2.在signalBlock中，创建RACSignal，并且作为signalBlock的返回值
// 3.执行命令 - (RACSignal *)execute:(id)input

// 二、RACCommand使用注意:
// 1.signalBlock必须要返回一个信号，不能传nil.
// 2.如果不想要传递信号，直接创建空的信号[RACSignal empty];
// 3.RACCommand中信号如果数据传递完，必须调用[subscriber sendCompleted]，这时命令才会执行完毕，否则永远处于执行中。
// 4.RACCommand需要被强引用，否则接收不到RACCommand中的信号，因此RACCommand中的信号是延迟发送的。

// 三、RACCommand设计思想：内部signalBlock为什么要返回一个信号，这个信号有什么用。
// 1.在RAC开发中，通常会把网络请求封装到RACCommand，直接执行某个RACCommand就能发送请求。
// 2.当RACCommand内部请求到数据的时候，需要把请求的数据传递给外界，这时候就需要通过signalBlock返回的信号传递了。

// 四、如何拿到RACCommand中返回信号发出的数据。
// 1.RACCommand有个执行信号源executionSignals，这个是signal of signals(信号的信号),意思是信号发出的数据是信号，不是普通的类型。
// 2.订阅executionSignals就能拿到RACCommand中返回的信号，然后订阅signalBlock返回的信号，就能获取发出的值。

// 五、监听当前命令是否正在执行executing

// 六、使用场景,监听按钮点击，网络请求

#import "BaseViewModel.h"

@implementation BaseViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _errors = [RACSubject subject];
        
        _cancelCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            // 创建空信号,必须返回信号
            return [RACSignal empty];
        }];
    }
    
    return self;
}

- (void)dealloc {
    [_errors sendCompleted];
}

@end
