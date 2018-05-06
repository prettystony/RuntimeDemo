//
//  Person.h
//  004-demo
//
//  Created by hzg on 2018/5/4.
//  Copyright © 2018年 tz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject 

@property (nonatomic, copy) NSString* name;
@property (nonatomic, strong) NSNumber* age;
@property (nonatomic, copy) NSString* nick;

@end
