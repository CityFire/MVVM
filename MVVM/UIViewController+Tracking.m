//
//  UIViewController+Tracking.m
//  MVVM
//
//  Created by wjc on 15/8/25.
//  Copyright © 2015年 wjc. All rights reserved.
//  因为+load是在一个类最开始加载时调用。dispatch_once是GCD中的一个方法，它保证了代码块只执行一次，并让其为一个原子操作，线程安全是很重要的。

#import "UIViewController+Tracking.h"
#import <objc/runtime.h>

@implementation UIViewController (Tracking)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class aClass = [self class];
//        NSLog(@"%p", aClass);
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(xxx_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector);
        
        // When swizzling a class method, use the following:
//         Class aClass2 = object_getClass((id)self);
//        NSLog(@"class:%@", aClass2);
        // ...
        // Method originalMethod = class_getClassMethod(aClass, originalSelector);
        // Method swizzledMethod = class_getClassMethod(aClass, swizzledSelector);
        
        // object_getClass((id)self) 与 [self class] 返回的结果类型都是 Class,但前者为元类,后者为其本身,因为此时 self 为 Class 而不是实例.注意 [NSObject class] 与 [object class] 的区别：
        swizzleMethod(aClass, @selector(viewDidLoad), @selector(xxx_viewDidLoad));
        
        BOOL didAddMethod =
        class_addMethod(aClass,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(aClass,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        }
        else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark - Method Swizzling

- (void)xxx_viewDidLoad {
    [self xxx_viewDidLoad];
    NSLog(@"xxx_viewDidLoad: %@",[self class]);
    if (![self isKindOfClass:NSClassFromString(@"UIInputWindowController")]) {
        [self addBackButton];
    }
//    if (![self isKindOfClass:NSClassFromString(@"UIInputWindowController")]) {
//        self.view.backgroundColor = [UIColor greenColor];
//    }
//    self.view.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.2];
}

- (void)xxx_viewWillAppear:(BOOL)animated {
    [self xxx_viewWillAppear:animated];
    NSLog(@"xxx_viewWillAppear: %@", self);
}

- (void)addBackButton {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = item;
    
    [self.view setBackgroundColor: [UIColor whiteColor]];
}

#pragma mark - 注意 [NSObject class] 与 [object class] 的区别：

+ (Class)class {
    return self;
}

- (Class)class {
    return object_getClass(self);
}

@end
