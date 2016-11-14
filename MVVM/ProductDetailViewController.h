//
//  ProductDetailViewController.h
//  MVVM
//
//  Created by wjc on 16/8/26.
//  Copyright © 2016年 CityFire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ProductDetailViewController : UIViewController

@property (nonatomic, strong) RACSubject *delegateSignal;

@end
