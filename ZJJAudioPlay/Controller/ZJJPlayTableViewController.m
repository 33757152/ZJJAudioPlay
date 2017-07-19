//
//  ZJJPlayTableViewController.m
//  ZJJAudioPlay
//
//  Created by 张锦江 on 2017/7/18.
//  Copyright © 2017年 ZJJ. All rights reserved.
//

#import "ZJJPlayTableViewController.h"
#import "ZJJPlayPauseViewController.h"
#import "ZJJGetFileTool.h"

@interface ZJJPlayTableViewController ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ZJJPlayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"歌单";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [ZJJGetFileTool obtainMusicList];
    }
    return _dataArray;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZJJPlayPauseViewController *playVC = [[ZJJPlayPauseViewController alloc] init];
    playVC.dataArray = self.dataArray;
    playVC.playIndex = indexPath.row;
    [self.navigationController pushViewController:playVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
