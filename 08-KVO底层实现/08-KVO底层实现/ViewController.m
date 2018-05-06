//
//  ViewController.m
//  006-demo
//
//  Created by hzg on 2018/5/4.
//  Copyright © 2018年 tz. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import <objc/runtime.h>
#import "NSObject+KVO.h"

@interface ViewController ()

@property (nonatomic, strong) Person* p;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _p = [Person new];
    
    //[_p addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    
    //NSLog(@"%@", [ViewController findSubClass:[_p class]]);
    
    [_p gv_addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];

    _p.name = @"Tom";
}

/// 获取指定类的子类
+ (NSArray*) findSubClass:(Class) defaultClass {
    
    /// 注册类的总数
    int count = objc_getClassList(NULL, 0);
    
    /// 创建一个数组， 其中包含给定对象
    NSMutableArray* array = [NSMutableArray arrayWithObject:defaultClass];
    
    /// 获取所有已注册的类
    Class* classes = (Class*)malloc(sizeof(Class)*count);
    objc_getClassList(classes, count);
    
    /// 遍历s
    for (int i = 0; i < count; i++) {
        if (defaultClass == class_getSuperclass(classes[i])) {
            [array addObject:classes[i]];
        }
    }
    
    free(classes);
    return array;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%@", change);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
