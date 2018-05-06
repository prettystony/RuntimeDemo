//
//  ViewController.m
//  004-demo
//
//  Created by hzg on 2018/5/4.
//  Copyright © 2018年 tz. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    Person* p = [[Person alloc] init];
    p.name = @"Tom";
    p.age = @18;
    p.nick = @"cat";
    
    NSString* path = [NSString stringWithFormat:@"%@/archive.plist", NSHomeDirectory()];
    
    /// 归档
    [NSKeyedArchiver archiveRootObject:p toFile:path];
    
    /// 解档
    Person* p1 = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSLog(@"name = %@, age = %@, nick = %@", p1.name, p1.age, p1.nick);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
