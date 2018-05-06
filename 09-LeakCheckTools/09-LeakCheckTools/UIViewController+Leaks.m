//
//  UIViewController+Leaks.m
//  LeakCheckTools
//
//  Created by hzg on 2018/4/30.
//  Copyright © 2018年 tz. All rights reserved.
//

#import "UIViewController+Leaks.h"
#import "NSObject+Leaks.h"
#import <objc/runtime.h>


/**
 
 目标：监听UIViewController类是否发生内存泄漏(这里只考虑push, pop的情况)
 
 思路: 我们在视图控制器出栈，并在视图完全消失的时候，监听对象是否还活着
 
 步骤：
 1） 交换视图控制器的 viewwillAppear与swizzled_viewWillAppear方法， viewDidDisapper与swizzled_viewDidDisappear方法
 2) 使用关联方法， 获取和设置视图控制器的进出栈的状态
 3) 视图完全消失，并且视图控制器是出栈的状态， 这是， 观察对象是否还活着
 
 */

const char* kHasBeenPoppedKey = "kHasBeenPoppedKey";

@implementation UIViewController (Leaks)

+ (void) load {
    [self swizzleSEL:@selector(viewWillAppear:) withSEL:@selector(swizzled_viewWillAppear:)];
    [self swizzleSEL:@selector(viewDidDisappear:) withSEL:@selector(swizzled_viewDidDisappear:)];
}



- (void) swizzled_viewWillAppear:(BOOL) animated {
    [self swizzled_viewWillAppear:animated];
    
    objc_setAssociatedObject(self, &kHasBeenPoppedKey, @(NO), OBJC_ASSOCIATION_RETAIN);
}

// 界面消失
- (void) swizzled_viewDidDisappear:(BOOL) animated {
    [self swizzled_viewDidDisappear:animated];
    
    if ([objc_getAssociatedObject(self, &kHasBeenPoppedKey) boolValue]) {
        /// 观察对象是否还活着
        [self willDealloc];
    }
}

@end
