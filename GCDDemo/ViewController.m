//
//  ViewController.m
//  GCDDemo
//
//  Created by Dee on 2016/11/29.
//  Copyright © 2016年 Dee. All rights reserved.
//

#import "ViewController.h"
#import "DemoViewController.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>


@property(nonatomic,strong) UITableView *tableview;

@property(nonatomic,strong) NSMutableArray *titleArray;

@property(nonatomic,strong) NSMutableArray *headerArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.titleArray = [NSMutableArray arrayWithArray:@[@[@"同步分发——串行队列",
                                                       @"异步分发——并发队列",
                                                       @"异步分发——串行队列",
                                                       @"同步分发——并发队列"],// 区分同步 与 异步
                                                       @[@"串行队列——异步分发",
                                                       @"并发队列——异步分发",
                                                       @"串行队列——同步分发",
                                                       @"并发队列——同部分发"], // 区分并发 与 串行
                                                       @[@"barrier_Sync - 并发队列",
                                                         @"barrier_Async - 并发队列",
                                                         @"barrier_Sync - 串行队列",
                                                         @"barrier_Async - 串行队列"],//barrier
                                                       @[@"Dispatch_Group",
                                                         @"Dispatch_Apply",
                                                         @"Dispatch_Once",
                                                         @"Dispatch_After"]]]; //other
    
    
    self.headerArray = [NSMutableArray arrayWithArray:@[@"同步与异步",
                                                        @"串行与并发",
                                                        @"Barrier",
                                                        @"other"]];
    
    self.tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    

}

#pragma mark - uitablvieDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.headerArray[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titleArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const ID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger index = indexPath.row + indexPath.section * 10;
    DemoViewController *vc = [[DemoViewController alloc] initWithIndex:index];
    vc.title = self.titleArray[indexPath.section][indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
