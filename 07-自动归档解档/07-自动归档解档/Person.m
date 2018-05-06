//
//  Person.m
//  004-demo
//
//  Created by hzg on 2018/5/4.
//  Copyright © 2018年 tz. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>

@implementation Person


/// 归档，编码
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    /// 获取所有的成员变量
    unsigned int count = 0;
    
    /// copy create
    Ivar* ivars = class_copyIvarList([Person class], &count);
    
    /// 遍历
    for (int i = 0; i < count; i++) {
        Ivar var = ivars[i];
        const char* name = ivar_getName(var);
        
        NSString* key = [NSString stringWithUTF8String:name];
        
        /// kvc
        id value = [self valueForKey:key];
        
        /// 编码
        [aCoder encodeObject:value forKey:key];
    }
    
    free(ivars);
    
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        /// 获取所有的成员变量
        unsigned int count = 0;
        
        /// copy create
        Ivar* ivars = class_copyIvarList([Person class], &count);
        
        /// 遍历
        for (int i = 0; i < count; i++) {
            Ivar var = ivars[i];
            const char* name = ivar_getName(var);
            
            NSString* key = [NSString stringWithUTF8String:name];
            
            // 解码
            id value = [aDecoder decodeObjectForKey:key];
           
            /// kvc
            [self setValue:value forKey:key];
        }
        
        free(ivars);
    }
    return self;
}

@end
