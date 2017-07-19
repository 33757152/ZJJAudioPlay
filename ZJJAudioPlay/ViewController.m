//
//  ViewController.m
//  ZJJAudioPlay
//
//  Created by 张锦江 on 2017/7/18.
//  Copyright © 2017年 ZJJ. All rights reserved.
//

#import "ViewController.h"
#import "ZJJPlayTableViewController.h"

@interface ViewController ()
@property (nonatomic ,strong) UIButton *homeButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"HOME";
    [self.view addSubview:self.homeButton];
}

- (UIButton *)homeButton {
    if (!_homeButton) {
        _homeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _homeButton.frame = CGRectMake((self.view.frame.size.width-100)/2, 100, 100, 50);
        _homeButton.backgroundColor = [UIColor yellowColor];
        [_homeButton setTitle:@"Let's go!" forState:UIControlStateNormal];
        [_homeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_homeButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _homeButton;
}
- (void)nextClick {
    ZJJPlayTableViewController *playVC = [[ZJJPlayTableViewController alloc] init];
    CATransition *animation = [CATransition animation];
    animation.duration = 1;
    animation.type = @"cube";
    animation.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController pushViewController:playVC animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
