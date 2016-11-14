//
//  ProductListViewModel.m
//  MVVM
//
//  Created by wjc on 15/9/17.
//  Copyright (c) 2015年 CityFire. All rights reserved.
//

#import "ProductListViewModel.h"

@interface ProductListViewModel ()

@property (nonatomic, strong) Page *page;

@end

@implementation ProductListViewModel

#pragma mark - init

- (instancetype)init {
    if (self = [super init]) {
        
        [self initCommand];
        
        [self initSubscribe];
    }
    return self;
}

- (void)initCommand {
    
    _fetchProductCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        return [[[APIClient sharedClient]
                 fetchProductWithPageIndex:@(1)]
                 takeUntil:self.cancelCommand.executionSignals];
    }];
    
    _fetchMoreProductCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[[APIClient sharedClient] fetchProductWithPageIndex:@(self.page.PageIndex+1)] takeUntil:self.cancelCommand.executionSignals];
    }];
    
    _hasMoreData = [RACObserve(self, page) map:^id(Page *p) {
        if (p!= nil && p.PageIndex < p.PageCount) {
            return @YES;
        }
        return @NO;
    }];
}

- (void)initSubscribe {
    // switchToLatest:用于signalOfSignals（信号的信号），有时候信号也会发出信号，会在signalOfSignals中，获取signalOfSignals发送的最新信号。
    @weakify(self);
    [[_fetchProductCommand.executionSignals switchToLatest] subscribeNext:^(ResponseData *response) {
        @strongify(self);
        if (!response.success) {
            [self.errors sendNext:response.error];
        }
        else {
            self.items = [ProductListModel objectArrayWithKeyValuesArray:response.data];
            self.page = response.page;
        }
    }];
    
    [[_fetchMoreProductCommand.executionSignals switchToLatest] subscribeNext:^(ResponseData *response) {
        @strongify(self);
        if (!response.success) {
            [self.errors sendNext:response.error];
        }
        else {
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.items];
            [arr addObjectsFromArray:[ProductListModel objectArrayWithKeyValuesArray:response.data]];
            self.items = arr;
            self.page = response.page;
        }
    }];
    
    // merge:把多个信号合并为一个信号，任何一个信号有新值的时候就会调用
    [[RACSignal merge:@[_fetchProductCommand.errors, self.fetchMoreProductCommand.errors]] subscribe:self.errors];
}

#pragma mark - method

- (ProductListCellViewModel *)itemViewModelForIndex:(NSInteger)index {
    
    return [[ProductListCellViewModel alloc] initWithModel:[_items objectAtIndex:index]];
}

@end
