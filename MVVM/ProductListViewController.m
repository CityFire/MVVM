//
//  ViewController.m
//  MVVM
//
//  Created by wjc on 15/9/17.
//  Copyright (c) 2015年 CityFire. All rights reserved.
//

#import "ProductListViewController.h"
#import "APIClient.h"
#import "ProductListViewModel.h"
#import <MJRefresh/MJRefresh.h>
#import "ProductListCell.h"
#import "ProductDetailViewController.h"

@interface ProductListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *table;

@property (nonatomic, strong) ProductListViewModel *viewModel;

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation ProductListViewController

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self initView];
    [self setupViewUI];
    [self initViewModel];
    [self bindViewModel];
    [self.table.header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
    
- (void)initView {
    /*
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        [subscriber sendNext:@3];
        [subscriber sendCompleted];
        return nil;
    }];
    NSLog(@"Signal was create.");
    [[RACScheduler mainThreadScheduler] afterDelay:0.1 schedule:^{
        [signal subscribeNext:^(id x) {
            NSLog(@"Subcriber 1 reveive: %@", x);
        }];
    }];
    
    [[RACScheduler mainThreadScheduler] afterDelay:1 schedule:^{
        [signal subscribeNext:^(id x) {
            NSLog(@"Subcriber 2 reveive: %@", x);
        }];
    }];
     
    
    
    RACMulticastConnection *connection = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[RACScheduler mainThreadScheduler] afterDelay:1 schedule:^{
            [subscriber sendNext:@1];
        }];
        
        [[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{
            [subscriber sendNext:@2];
        }];
        
        [[RACScheduler mainThreadScheduler] afterDelay:3 schedule:^{
            [subscriber sendNext:@3];
        }];
        
        [[RACScheduler mainThreadScheduler] afterDelay:4 schedule:^{
            [subscriber sendCompleted];
        }];
        
        return nil;
    }] publish];
    
    [connection connect];
    RACSignal *signal = connection.signal;
    
    NSLog(@"Signal was created.");
    
    [[RACScheduler mainThreadScheduler] afterDelay:1.1 schedule:^{
        [signal subscribeNext:^(id x) {
            NSLog(@"Subcriber 1 receive: %@", x);
        }];
    }];
    
    [[RACScheduler mainThreadScheduler] afterDelay:2.1 schedule:^{
        [signal subscribeNext:^(id x) {
            NSLog(@"Subscriber 2 recveive: %@", x);
        }];
    }];
     
     */
    
    __block NSInteger count = 0;
    
    self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.88.com.cn/app/"]];
    self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    @weakify(self)
    RACSignal *fetchData = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        count++;
        NSLog(@"count:%@", @(count));
        NSURLSessionDataTask *task = [self.sessionManager GET:@"plistnew" parameters:
                        @{ @"type":@"3", @"page":@"1", @"pagesize":@"100" } success:^(NSURLSessionDataTask *task, id responseObject) {
                            [subscriber sendNext:responseObject];
                            // 如果不再发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
                            [subscriber sendCompleted];
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            [subscriber sendError:error];
                        }];
        return [RACDisposable disposableWithBlock:^{
            // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
            
            // 执行完Block后，当前信号就不在被订阅了。
            
            NSLog(@"信号被销毁");
            if (task.state != NSURLSessionTaskStateCompleted) {
                [task cancel];
            }
        }];
    }];
    
    _viewModel = [ProductListViewModel new];
    RACSignal *data = [fetchData flattenMap:^RACSignal *(NSDictionary *value) {
        if ([value[@"data"] isKindOfClass:[NSArray class]]) {
            @strongify(self)
            NSLog(@"data:%@", value[@"data"]);
            self.viewModel.items = [ProductListModel objectArrayWithKeyValuesArray:value[@"data"]];
            return [RACSignal return:value[@"data"]];
        }
        else {
            return [RACSignal error:[NSError errorWithDomain:@"some error" code:400 userInfo:@{@"originData": value}]];
        }
    }];
    
    RACSignal *succ = [fetchData flattenMap:^RACSignal *(NSDictionary *value) {
        if ([value[@"succ"] isKindOfClass:[NSString class]]) {
            return [RACSignal return:value[@"succ"]];
        } else {
            return [RACSignal error:[NSError errorWithDomain:@"some error" code:400 userInfo:@{@"originData": value}]];
        }
    }];
    
    RACSignal *page = [fetchData flattenMap:^RACStream *(NSDictionary *value) {
        if ([value[@"page"] isKindOfClass:[NSObject class]]) {
            return [RACSignal return:value[@"page"]];
        } else {
            return [RACSignal error:[NSError errorWithDomain:@"some error" code:400 userInfo:@{@"originData": value}]];
        }
    }];
    
    [RACObserve(self.viewModel, items) subscribeNext:^(id x) {
        @strongify(self);
        [self.table reloadData];
    }];
    
    [[RACSignal merge:@[data, succ, page]] subscribeError:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.domain delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
    
//    RAC(self.someLablel, text) = [[data catchTo:[RACSignal return:@"Error"]]  startWith:@"Loading..."];
//    RAC(self.originTextView, text) = [[desc catchTo:[RACSignal return:@"Error"]] startWith:@"Loading..."];
//    RAC(self.renderedTextView, attributedText) = [[renderedDesc catchTo:[RACSignal return:[[NSAttributedString alloc] initWithString:@"Error"]]] startWith:[[NSAttributedString alloc] initWithString:@"Loading..."]];
}

- (void)setupViewUI {
    
    self.title = @"产品列表";
    self.table.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.table.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:nil];

}

- (void)initViewModel {
    
    _viewModel = [ProductListViewModel new];
    @weakify(self)
    [_viewModel.fetchProductCommand.executing subscribeNext:^(NSNumber *executing) {
        NSLog(@"command executing:%@", executing);
        if (!executing.boolValue) {
            @strongify(self)
            [self.table.header endRefreshing];
        }
    }];
    
    [_viewModel.fetchMoreProductCommand.executing subscribeNext:^(NSNumber *executing) {
        if (!executing.boolValue) {
            @strongify(self);
            [self.table.footer endRefreshing];
        }
    }];
    
    [_viewModel.errors subscribeNext:^(NSError *error) {
        ResponseData *data = [ResponseData objectWithKeyValues:error.userInfo];
        NSLog(@"something error:%@", data.keyValues);
        //TODO: 这里可以选择一种合适的方式将错误信息展示出来
    }];
    
}

- (void)bindViewModel {
    @weakify(self);
    self.navigationItem.rightBarButtonItem.rac_command = [[RACCommand alloc]initWithEnabled:[[RACSignal
                                                                                             combineLatest:@[self.viewModel.fetchProductCommand.executing, self.viewModel.fetchMoreProductCommand.executing]] or]
                                                                                signalBlock:^RACSignal *(id input) {
                                                                                    @strongify(self);
                                                                                    [self.viewModel.cancelCommand execute:nil];
                                                                                    return [RACSignal empty];
                                                                                }];
    
    [RACObserve(self.viewModel, items) subscribeNext:^(id x) {
        @strongify(self);
        [self.table reloadData];
    }];
    
    //没有更多数据时，隐藏table的footer
    RAC(self.table.footer, hidden) = [self.viewModel.hasMoreData not];
}

#pragma mark - View Method

- (void)loadData {
    
    [self.viewModel.fetchProductCommand execute:nil];
}

- (void)loadMoreData {
    [self.viewModel.fetchMoreProductCommand execute:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductListCell" forIndexPath:indexPath];
    cell.viewModel = [self.viewModel itemViewModelForIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    ProductDetailViewController *detailVC = [[ProductDetailViewController alloc] init];
    UIStoryboard *storyb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProductDetailViewController *detailVC = [storyb instantiateViewControllerWithIdentifier:@"ProductDetailViewController"];
    // 设置代理信号
    detailVC.delegateSignal = [RACSubject subject];
    // 订阅代理信号
    [detailVC.delegateSignal subscribeNext:^(id x) {
        NSLog(@"点击了取消按钮");
    }];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
