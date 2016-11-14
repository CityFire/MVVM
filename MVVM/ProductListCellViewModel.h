//
//  ProductListCellViewModel.h
//  MVVM
//
//  Created by wjc on 15/9/18.
//  Copyright (c) 2015年 CityFire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductListModel.h"

@interface ProductListCellViewModel : NSObject

/**
 *  产品名称
 */
@property (strong,nonatomic,readonly) NSString *ProductName;
/**
 *  发行银行
 */
@property (strong,nonatomic,readonly) NSString *ProductBank;
/**
 *  预期收益率
 */
@property (assign,nonatomic,readonly) NSString *ProductProfit;
/**
 *  期限
 */
@property (assign,nonatomic,readonly) NSString *ProductTerm;
/**
 *  起购金额
 */
@property (assign,nonatomic,readonly) NSString *ProductAmt;
/**
 *  收益类型
 */
@property (strong,nonatomic,readonly) NSString *ProductClassCn;
/**
 *  销售状态名称
 */
@property (strong,nonatomic,readonly) NSString *SaleStatusCn;

- (instancetype)initWithModel:(ProductListModel *)model;

@end
