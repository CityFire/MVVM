//
//  ProductListModel.h
//  MVVM
//
//  Created by wjc on 15/9/25.
//  Copyright © 2015年 CityFire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

/**
 *  产品列表实体
 */
@interface ProductListModel : NSObject

@property (nonatomic, copy) NSString *cancoins;  // "cancoins": 0,
@property (nonatomic, copy) NSString *isactivity; //"isactivity": 0,
@property (nonatomic, copy) NSString *isdjj;//"isdjj": 1,
@property (nonatomic, copy) NSString *syts;//"syts": "",
@property (nonatomic, copy) NSString *istransfer;//"istransfer": 0,
@property (nonatomic, copy) NSString *jxtime;//"jxtime": "2016-08-25",
@property (nonatomic, copy) NSString *returnType;//"returnType": "到期还本付息",
@property (nonatomic, copy) NSString *Bl;//"Bl": "54.74",
@property (nonatomic, copy) NSString *tag;//"tag": 0,
@property (nonatomic, copy) NSString *productName;//"productName": "季盈宝",
@property (nonatomic, copy) NSString *hopeRate;//"hopeRate": "7%",
@property (nonatomic, copy) NSString *investTime;//"investTime": "3个月",
@property (nonatomic, copy) NSString *beginMoney;//"beginMoney": "1000元",
@property (nonatomic, copy) NSString *investMoney;//"investMoney": "226.30万元",
@property (nonatomic, copy) NSString *totalMoney;//"totalMoney": "273.70万元",
@property (nonatomic, copy) NSString *pType;//"pType": "37",
@property (nonatomic, copy) NSString *exp_pType;//"exp_pType": null,
@property (nonatomic, copy) NSString *ID;//"id": "1155",
@property (nonatomic, copy) NSString *count;//"count": "190"

@end
