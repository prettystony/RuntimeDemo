//
//  Person.m
//  001-demo
//
//  Created by hzg on 2018/5/4.
//  Copyright © 2018年 tz. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import "Dog.h"

@implementation Person

/// 1. 动态方法解析
//+ (BOOL) resolveClassMethod:(SEL)sel {
//
//}

+ (BOOL) resolveInstanceMethod:(SEL)sel {
//    NSString* methodName = NSStringFromSelector(sel);
//    if ([methodName isEqualToString:@"sendMessage:"]) {
//        // object_getClass(self)
//        return class_addMethod(self, sel, (IMP)sendMessage, "v@");
//    }
    NSLog(@"%s",__func__);
    return NO;
}

void sendMessage(id self, SEL _cmd, NSString* message) {
    NSLog(@"message = %@", message);
}

// 2. 找备用者
- (id) forwardingTargetForSelector:(SEL)aSelector {
//    NSString* methodName = NSStringFromSelector(aSelector);
//    if ([methodName isEqualToString:@"sendMessage:"]) {
//        return [Dog new];
//    }
    NSLog(@"%s",__func__);
    return [super forwardingTargetForSelector:aSelector];
}

// 3. 完整的消息转发
// 1) 方法的签名
- (NSMethodSignature*) methodSignatureForSelector:(SEL)aSelector {
    NSString* methodName = NSStringFromSelector(aSelector);
    NSLog(@"%s",__func__);
    if ([methodName isEqualToString:@"sendMessage:"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    }
    NSLog(@"%s",__func__);
    return [super methodSignatureForSelector:aSelector];
}

// 2) 消息转发
- (void) forwardInvocation:(NSInvocation *)anInvocation {
    
//    SEL sel = [anInvocation selector];
//
//    Dog* dog = [Dog new];
//    if ([dog respondsToSelector:sel]) {
//        [anInvocation invokeWithTarget:dog];
//    } else {
//        [super forwardInvocation:anInvocation];
//    }
    NSLog(@"%s",__func__);
    [super forwardInvocation:anInvocation];
}

// 4. 消息转发的最后一步
- (void) doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"doesNotRecognizeSelector");
}

@end
