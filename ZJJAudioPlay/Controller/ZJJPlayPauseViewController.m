//
//  ZJJPlayPauseViewController.m
//  ZJJAudioPlay
//
//  Created by 张锦江 on 2017/7/18.
//  Copyright © 2017年 ZJJ. All rights reserved.
//

#import "ZJJPlayPauseViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ZJJPlayPauseViewController () {
    NSTimer *_timer;
    BOOL _isCircle;
}

@property (weak, nonatomic) IBOutlet UIButton *playOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *lastButton;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet UIImageView *BgImageView;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *playedTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) AVPlayer *zjjPlayer;
@property (nonatomic, assign) int totalAllSeconds;

@end

@implementation ZJJPlayPauseViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self closeTimer];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _isCircle = YES;
    [self titleChanged];
    self.view.backgroundColor = [UIColor whiteColor];
    self.slider.value = 0.0f;
    [self.slider addTarget:self action:@selector(slideToPlay) forControlEvents:UIControlEventValueChanged];
}
- (void)titleChanged {
    // which song is playing now
    NSString *fileName = [_dataArray[_playIndex] stringByDeletingPathExtension];
    self.navigationItem.title = [NSString stringWithFormat:@"%@(%ld/%ld)",fileName,_playIndex+1,_dataArray.count];
}

- (void)openTimer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playedTime) userInfo:nil repeats:YES];
    }
}

- (void)closeTimer {
    [_timer invalidate];
    _timer = nil;
//    NSLog(@"timer closed!!!");
}

#pragma mark - slide to play part of music
- (void)slideToPlay {
    CMTime cmTime = CMTimeMakeWithSeconds(_totalAllSeconds*_slider.value, 1.0);
    [_zjjPlayer seekToTime:cmTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)playedTime {
//    NSLog(@"timer fired!!!");
    // has already playing time
    CMTimeValue alreadySon = self.zjjPlayer.currentTime.value;
    CMTimeValue alreadyMom = self.zjjPlayer.currentTime.timescale;
    int alreadyAllSeconds = [[NSNumber numberWithInteger:alreadySon/alreadyMom] intValue];
    int alreadyMinute = alreadyAllSeconds/60;
    int alreadySeconds = alreadyAllSeconds%60;
    self.playedTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",alreadyMinute,alreadySeconds];
    self.slider.value = (float)alreadyAllSeconds/_totalAllSeconds;
    if ((int)self.slider.value) {
        [self nextClick:self.nextButton];
    }
}
#pragma mark - songs time and progress and navigationItem's title settings
- (void)totalTimeInit {
    // which song is playing now
    [self titleChanged];
    // the total music time
    CMTimeValue totalSon = self.zjjPlayer.currentItem.asset.duration.value;
    CMTimeValue totalMom = self.zjjPlayer.currentItem.asset.duration.timescale;
    self.totalAllSeconds = [[NSNumber numberWithInteger:totalSon/totalMom] intValue];
    int totalMinute = _totalAllSeconds/60;
    int totalSeconds = _totalAllSeconds%60;
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",totalMinute,totalSeconds];
    self.totalTimeLabel.textAlignment = NSTextAlignmentRight;
    self.totalTimeLabel.adjustsFontSizeToFitWidth = YES;
    self.playedTimeLabel.text = @"00:00";
    self.playedTimeLabel.textAlignment = NSTextAlignmentLeft;
    self.playedTimeLabel.adjustsFontSizeToFitWidth = YES;
    [self openTimer];
}

- (AVPlayer *)zjjPlayer {
    if (!_zjjPlayer) {
        NSString *name = _dataArray[_playIndex];
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
        _zjjPlayer = [AVPlayer playerWithURL:[NSURL fileURLWithPath:path]];
        [self totalTimeInit];
    }
    return _zjjPlayer;
}
- (IBAction)lastClick:(UIButton *)sender {
    NSInteger randomIndex = arc4random()%_dataArray.count;
    if (_playIndex > 0) {
        if (_isCircle) {
            _playIndex -= 1;
        }else {
            _playIndex = randomIndex;
        }
    }else {
        if (_isCircle) {
            _playIndex = _dataArray.count-1;
        }else {
            _playIndex = randomIndex;
        }
    }
    [self restartSong];
}
- (IBAction)playClick:(UIButton *)sender {
    [self playOrPause];
}
- (IBAction)nextClick:(UIButton *)sender {
    NSInteger randomIndex = arc4random()%_dataArray.count;
    if (_playIndex < _dataArray.count-1) {
        if (_isCircle) {
            _playIndex += 1;
        }else {
            _playIndex = randomIndex;
        }
    }else {
        if (_isCircle) {
            _playIndex = 0;
        }else {
            _playIndex = randomIndex;
        }
    }
    [self restartSong];
}
- (IBAction)playOrder:(UIButton *)sender {
    if (_isCircle) {
        // random play
        [self.playOrderButton setBackgroundImage:[[UIImage imageNamed:@"arcrandom.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }else {
        // circle play
        [self.playOrderButton setBackgroundImage:[[UIImage imageNamed:@"circle.jpg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    _isCircle = !_isCircle;
}

- (void)playOrPause {
    if (!_zjjPlayer.rate) {
        [self openTimer];
        [self.zjjPlayer play];
        [_playPauseButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }else {
        [self closeTimer];
        [self.zjjPlayer pause];
        [_playPauseButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    }
}

- (void)restartSong {
    self.zjjPlayer = nil;
    [self playOrPause];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
