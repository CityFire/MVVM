//
//  ProductListModel.m
//  MVVM
//
//  Created by wjc on 15/9/25.
//  Copyright © 2015年 CityFire. All rights reserved.
//

#import "ProductListModel.h"

@implementation ProductListModel

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{ @"ID" : @"id",
              };
}


@end
