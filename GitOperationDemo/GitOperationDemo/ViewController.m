//
//  ViewController.m
//  GitOperationDemo
//
//  Created by ASSASSIN on 2020/12/2.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    int a ,b ,c;
    a = 10;
    b = 10;
    c = a + b;
    NSLog(@"%d",c);
    
    //i love you
    // shit on me
    //我要保存我自己的版本    
    
    //我想本地的，和远程的都保存
    //我要保存远端的，我要保存远端


    //https://github.com/ASSASSINYM/SoureTreePro/edit/master/GitOperationDemo/GitOperationDemo/ViewController.m


    //多练习可以牛逼
    
    //新增一个对象
    NSObject *obj = [NSObject new];
    NSLog(@"%@",obj.description);

    
    
    
    

    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    blueView.backgroundColor = [UIColor blueColor];
    [redView addSubview:blueView];
    
    
    
    
        UITextField *passwordTextfield = [[UITextField alloc] initWithFrame:CGRectMake(0, 150, 200, 50)];
        passwordTextfield.placeholder = @"请输入密码";
        [self.view addSubview:passwordTextfield];
    
    
    [redView addSubview:passwordTextfield];
// 什么情况 啊  啊 啊 啊啊 啊啊 啊
    
    ///我 对冲突有点迷糊了 哈哈哈😄
}


@end
