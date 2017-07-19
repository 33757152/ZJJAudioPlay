//
//  ZJJGetFileTool.m
//  ZJJAudioPlay
//
//  Created by 张锦江 on 2017/7/18.
//  Copyright © 2017年 ZJJ. All rights reserved.
//

#import "ZJJGetFileTool.h"

@implementation ZJJGetFileTool

+ (NSArray *)obtainMusicList {
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *allSongs = [[NSBundle mainBundle] pathsForResourcesOfType:@"mp3" inDirectory:@""];
    for (NSString *song in allSongs) {
        [dataArray addObject:[song lastPathComponent]];
    }
    return dataArray;
}

@end
