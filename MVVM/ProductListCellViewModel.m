//
//  ProductListCellViewModel.m
//  MVVM
//
//  Created by wjc on 15/9/18.
//  Copyright (c) 2015年 CityFire. All rights reserved.
//

#import "ProductListCellViewModel.h"

@interface ProductListCellViewModel ()

@property (nonatomic, strong) ProductListModel *model;

@end

@implementation ProductListCellViewModel

#pragma mark - init

- (instancetype)initWithModel:(ProductListModel *)model {
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

#pragma mark - public method

- (NSString *)ProductName {
    return _model.productName;
}

- (NSString *)ProductBank {
    return _model.returnType;
}

- (NSString *)ProductProfit {
    return [NSString stringWithFormat:@"%@",_model.hopeRate];
}

- (NSString *)ProductTerm {
    return [NSString stringWithFormat:@"%@", _model.investTime];
}

- (NSString *)ProductAmt {
    return [NSString stringWithFormat:@"%@起", _model.beginMoney];
}

@end
