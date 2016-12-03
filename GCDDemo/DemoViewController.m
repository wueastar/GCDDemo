//
//  DemoViewController.m
//  GCDDemo
//
//  Created by Dee on 2016/11/29.
//  Copyright © 2016年 Dee. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController ()


@property( nonatomic,assign) NSInteger index;

@end

@implementation DemoViewController

- (instancetype)initWithIndex:(NSInteger)index {
    if (self = [super init]) {
        self.index = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"Again" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
    //一些准备工作
    switch (self.index) {
        case 0: //同步提交 - 串行队列
            [self Dispatch_SyncCode];
            [btn addTarget:self action:@selector(Dispatch_SyncCode) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 1: //异步提交 - 并发队列
            [self Dispatch_AsyncCode];
            [btn addTarget:self action:@selector(Dispatch_AsyncCode) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 2: //异步分发 - 串行队列
            [self Dispatch_AsynCode1];
            [btn addTarget:self action:@selector(Dispatch_AsynCode1) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 3: //同步分发 - 并发队列
            [self Dispatch_SyncCode1];
            [btn addTarget:self action:@selector(Dispatch_SyncCode1) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 10://串行队列 - 异步分发
            [self Serial_AsyncFunc];
            [btn addTarget:self action:@selector(Serial_AsyncFunc) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 11://并发队列 - 异步分发
            [self Concurrent_AsyncFunc];
            [btn addTarget:self action:@selector(Concurrent_AsyncFunc) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 12://串行队列 - 同步分发
            [self Searil_SyncFunc];
            [btn addTarget:self action:@selector(Serial_AsyncFunc) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 13://并发队列 - 同步分发
            [self Concurrent_SyncFunc];
            [btn addTarget:self action:@selector(Concurrent_SyncFunc) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 20: //barrier_sync - 并发队列
            [self Dispatch_barrier_sync_inConcurrent_queueFunc];
            [btn addTarget:self action:@selector(Dispatch_barrier_sync_inConcurrent_queueFunc) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 21: //barrier_async - 并发队列
            [self Dispatch_barrier_async_inConcurrent_queueFunc];
            [btn addTarget:self action:@selector(Dispatch_barrier_async_inConcurrent_queueFunc) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 22: //barrier_sync - 串行队列
            [self Dispatch_barrier_sync_inSerial_queueFunc];
            [btn addTarget:self action:@selector(Dispatch_barrier_sync_inSerial_queueFunc) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 23: //barrier_async - 串行队列
            [self Dispatch_barrier_async_inSerial_queueFunc];
            [btn addTarget:self action:@selector(Dispatch_barrier_async_inSerial_queueFunc) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 30://Dispatch_group
            [self Dispatch_Group];
            [btn addTarget:self action:@selector(Dispatch_Group) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 31:
            [self Dispatch_Apply];
            [btn addTarget:self action:@selector(Dispatch_Apply) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 32:
            [self Dispatch_OnceCode];
            [btn addTarget:self action:@selector(Dispatch_OnceCode) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 33:
            [self Dispatch_AfterCode];
            [btn addTarget:self action:@selector(Dispatch_AfterCode) forControlEvents:UIControlEventTouchUpInside];
            break;
        default:
            break;
    }
    

}

#pragma mark - other

- (void)Dispatch_Group {
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    //出于其他线程中
    dispatch_group_enter(group);
    
    dispatch_group_async(group, quene, ^{
        NSLog(@"block0");
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, quene, ^{
        NSLog(@"block1");
        dispatch_group_leave(group);
    });
    
    //输出不定
    //第一个参数指定为要监听的group - 在group中的任务都执行完成后调用
    dispatch_group_notify(group, quene, ^{
        NSLog(@"done");
    });
    
    dispatch_group_async(group, quene, ^{
        NSLog(@"block2");
    });
}

- (void)Dispatch_Apply
{
    dispatch_queue_t queue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(10, queue, ^(size_t index) {
        NSLog(@"current thread is %@", [NSThread currentThread]);
        NSLog(@"%zu",index);
    });
}


- (void)Dispatch_OnceCode {
    NSLog(@"dispatch_once执行之前");
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"执行一次？");
    });
    NSLog(@"dispath_once执行之后");
}

- (void)Dispatch_AfterCode {
    NSLog(@"dispatch_afterz执行之前");
    //延迟最起码3秒以上，因为这里block任务会在3秒后提交到主队列，block后面的代码先执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"执行block代码");
    });
    
    NSLog(@"dispathch_alfter执行之后");
}

#pragma mark - Dispatchbarrier
//dispatch_barrier_sync在并发队列中
- (void)Dispatch_barrier_sync_inConcurrent_queueFunc {
    NSLog(@"block执行之前-------");
    
    dispatch_queue_t concurrent_queue = dispatch_queue_create("dee", DISPATCH_QUEUE_CONCURRENT);
    
    for (int index = 0; index<5; index++) {
        dispatch_async(concurrent_queue, ^{
            NSLog(@"index is %d",index);
              NSLog(@"current thread is %@", [NSThread currentThread]);
        });
    }
    
    dispatch_barrier_sync(concurrent_queue, ^{
        NSLog(@"barrier_sync Action....");
        NSLog(@"current thread is %@", [NSThread currentThread]);
    });
    
    for (int index = 5; index<10; index++) {
        dispatch_async(concurrent_queue, ^{
            NSLog(@"index is %d",index);
        });
    }
    
    NSLog(@"block完成后------");
}
//dispatch_barrier_async在并发队列中
- (void)Dispatch_barrier_async_inConcurrent_queueFunc {
    NSLog(@"block执行之前-------");
    
    dispatch_queue_t concurrent_queue = dispatch_queue_create("dee", DISPATCH_QUEUE_CONCURRENT);
    
    for (int index = 0; index<5; index++) {
        dispatch_async(concurrent_queue, ^{
            NSLog(@"index is %d",index);
              NSLog(@"current thread is %@", [NSThread currentThread]);
        });
    }
    
    dispatch_barrier_async(concurrent_queue, ^{
        NSLog(@"barrier_async Action....");
        NSLog(@"current thread is %@", [NSThread currentThread]);
    });
    
    for (int index = 5; index<10; index++) {
        dispatch_async(concurrent_queue, ^{
            NSLog(@"index is %d",index);
        });
    }
    
    NSLog(@"block完成后------");
}
//dispatch_barrier_sync在串行队列中
- (void)Dispatch_barrier_sync_inSerial_queueFunc {
    NSLog(@"block执行之前-------");
    
    dispatch_queue_t serial_queue = dispatch_queue_create("dee", DISPATCH_QUEUE_SERIAL);
    
    for (int index = 0; index<5; index++) {
        dispatch_async(serial_queue, ^{
            NSLog(@"index is %d",index);
              NSLog(@"current thread is %@", [NSThread currentThread]);
        });
    }
    
    dispatch_barrier_sync(serial_queue, ^{
        NSLog(@"barrier_sync Action....");
        NSLog(@"current thread is %@", [NSThread currentThread]);
    });
    
    for (int index = 5; index<10; index++) {
        dispatch_async(serial_queue, ^{
            NSLog(@"index is %d",index);
        });
    }
    
    NSLog(@"block完成后------");
}
//dispatch_barrier_async在串行队列中
- (void)Dispatch_barrier_async_inSerial_queueFunc {
    NSLog(@"block执行之前-------");
    
    dispatch_queue_t serial_queue = dispatch_queue_create("dee", DISPATCH_QUEUE_SERIAL);
    
    for (int index = 0; index<5; index++) {
        dispatch_async(serial_queue, ^{
            NSLog(@"index is %d",index);
            NSLog(@" ------ %@", [NSThread currentThread]);
        });
    }
    
    dispatch_barrier_async(serial_queue, ^{
        NSLog(@"barrier_async Action....");
        NSLog(@"current thread is %@", [NSThread currentThread]);
    });
    
    for (int index = 5; index<10; index++) {
        dispatch_async(serial_queue, ^{
            NSLog(@"index is %d",index);
            NSLog(@" ------ %@", [NSThread currentThread]);
        });
    }
    
    NSLog(@"block完成后------");
}

#pragma mark - 串行 和 并发

- (void)Serial_AsyncFunc {
    NSLog(@"block执行之前-------");
    dispatch_queue_t serail_queue = dispatch_queue_create("dee", DISPATCH_QUEUE_SERIAL);
    for (int index = 0; index<10; index++) {
        dispatch_async(serail_queue, ^{
            NSLog(@"current thread is %@", [NSThread currentThread]);
        });
    }
    NSLog(@"block完成后------");
}

- (void)Concurrent_AsyncFunc {
    NSLog(@"block执行之前-------");
    dispatch_queue_t concurrent_queue = dispatch_queue_create("dee", DISPATCH_QUEUE_CONCURRENT);
    for (int index = 0; index<10; index++) {
        dispatch_async(concurrent_queue, ^{
            NSLog(@"current thread is %@", [NSThread currentThread]);
        });
    }
    NSLog(@"block完成后------");
}

- (void)Searil_SyncFunc {
    NSLog(@"block执行之前-------");
    dispatch_queue_t serail_queue = dispatch_queue_create("dee", DISPATCH_QUEUE_SERIAL);
    for (int index = 0; index<10; index++) {
        dispatch_sync(serail_queue, ^{
            NSLog(@"current thread is %@", [NSThread currentThread]);
        });
    }
    NSLog(@"block完成后------");
}

- (void)Concurrent_SyncFunc {
    NSLog(@"block执行之前-------");
    dispatch_queue_t serail_queue = dispatch_queue_create("dee", DISPATCH_QUEUE_CONCURRENT);
    for (int index = 0; index<10; index++) {
        dispatch_sync(serail_queue, ^{
            NSLog(@"current thread is %@", [NSThread currentThread]);
        });
    }
    NSLog(@"block完成后------");
}
#pragma mark - 同步 和 异步
//同步分发 - 串行队列
- (void)Dispatch_SyncCode {
    NSLog(@"block执行之前----🙋---");
    dispatch_queue_t seril_queue = dispatch_queue_create("dee", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(seril_queue, ^{
        NSLog(@"执行中...");
        NSLog(@"current thread is %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:2.0];
        NSLog(@"执行结束...");
    });
    
    NSLog(@"block完成后------");
}

//异步分发 - 并发队列
- (void)Dispatch_AsyncCode {

    NSLog(@"block执行之前-------");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"执行中...");
        [NSThread sleepForTimeInterval:2.0];
        NSLog(@"执行结束...");
    });
    
    NSLog(@"block完成之后-------");
}

//异步分发 - 串行队列
- (void)Dispatch_AsynCode1 {
    
    
    
    NSLog(@"block执行之前-------");
    dispatch_queue_t seril_queue = dispatch_queue_create("dee", DISPATCH_QUEUE_SERIAL);
    dispatch_async(seril_queue, ^{
        NSLog(@"执行中...");
        [NSThread sleepForTimeInterval:2.0];
        NSLog(@"执行结束...");
    });
    
    NSLog(@"block完成之后-------");
}

//同步分发 - 并发队列
- (void)Dispatch_SyncCode1 {
    
    NSLog(@"block执行之前-------");
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"执行中...");
        [NSThread sleepForTimeInterval:2.0];
        NSLog(@"执行结束...");
    });
    
    NSLog(@"block完成之后-------");
}

@end
