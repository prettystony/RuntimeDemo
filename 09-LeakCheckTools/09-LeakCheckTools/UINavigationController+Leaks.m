//
//  UINavigationController+Leaks.m
//  LeakCheckTools
//
//  Created by hzg on 2018/4/30.
//  Copyright © 2018年 tz. All rights reserved.
//

#import "UINavigationController+Leaks.h"
#import <objc/runtime.h>
#import "NSObject+Leaks.h"

@implementation UINavigationController (Leaks)

+ (void) load {
    [self swizzleSEL:@selector(popViewControllerAnimated:) withSEL:@selector(swizzled_podViewControllerAnimated:)];
}


- (UIViewController*) swizzled_podViewControllerAnimated:(BOOL) animated {
    UIViewController* popedViewController = [self swizzled_podViewControllerAnimated:animated];
    
    extern const char* kHasBeenPoppedKey;
    objc_setAssociatedObject(popedViewController, &kHasBeenPoppedKey, @(YES), OBJC_ASSOCIATION_RETAIN);
    
    return popedViewController;
}

@end
