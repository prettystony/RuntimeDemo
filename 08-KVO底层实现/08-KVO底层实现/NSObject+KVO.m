//
//  NSObject+KVO.m
//  006-demo
//
//  Created by hzg on 2018/5/4.
//  Copyright © 2018年 tz. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/message.h>

@implementation NSObject (KVO)

- (void)gv_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context {
    
    /// 创建一个类
    NSString* oldName = NSStringFromClass([self class]);
    NSString* newName = [NSString stringWithFormat:@"CustomKVO_%@", oldName];
    
    Class CustomClass = objc_allocateClassPair([self class], newName.UTF8String, 0);
    objc_registerClassPair(CustomClass);
    
    /// 动态修改self 类型
    object_setClass(self, CustomClass);
    
    /// 重写setName
    NSString* methodName = [NSString stringWithFormat:@"set%@:", keyPath.capitalizedString];
    SEL sel = NSSelectorFromString(methodName);
    class_addMethod(CustomClass, sel, (IMP)setterMethodIMP, "v@:@");
    
    /// 关联属性
    objc_setAssociatedObject(self, (__bridge const void *)@"objc", observer, OBJC_ASSOCIATION_ASSIGN);
}

void setterMethodIMP(id self, SEL _cmd, id newVaule) {
    NSLog(@"%@", newVaule);
    
    // 改变父类的属性值
    struct objc_super superClass = {self, class_getSuperclass([self class])};
    objc_msgSendSuper(&superClass, _cmd, newVaule);
    
    /// observe
    id observer = objc_getAssociatedObject(self, (__bridge const void *)@"objc");
    
    NSString* methodName = NSStringFromSelector(_cmd);
    NSString* key = getValueKey(methodName);
    objc_msgSend(observer, @selector(observeValueForKeyPath:ofObject:change:context:), key, self, @{key:newVaule}, nil);
    
}

NSString* getValueKey(NSString* setter) {
    if (setter.length <= 0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) {
        return nil;
    }
    
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString* key = [setter substringWithRange:range];
    
    NSString* firstLetter = [[key substringToIndex:1] lowercaseString];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstLetter];
    
    return key;
}


@end
