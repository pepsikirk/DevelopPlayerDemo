//
//  PKFullScreenPlayerView.m
//  DevelopPlayerDemo
//
//  Created by jiangxincai on 16/1/4.
//  Copyright © 2016年 1yyg. All rights reserved.
//

#import "PKFullScreenPlayerView.h"
@import AVFoundation;

@interface PKFullScreenPlayerView ()

@property (nonatomic, strong) NSURL *videoURL;

@property (nonatomic, strong) UIImage *previewImage;

@property (nonatomic, strong) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;

@end



@implementation PKFullScreenPlayerView

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame videoURL:(NSURL *)videoURL previewImage:(UIImage *)previewImage {
    NSParameterAssert(videoURL != nil);
    NSParameterAssert(previewImage != nil);
    
    self = [super initWithFrame:frame];
    if (self) {
        _videoURL = videoURL;
        _previewImage = previewImage;
        
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
        
        [asset loadValuesAsynchronouslyForKeys:@[@"playable"] completionHandler:^{
            dispatch_async( dispatch_get_main_queue(), ^{
                [self prepareToPlayAsset:asset];
            });
         }];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark Prepare to play asset, URL

- (void)prepareToPlayAsset:(AVURLAsset *)asset {
    NSError *error = nil;
    AVKeyValueStatus keyStatus = [asset statusOfValueForKey:@"playable" error:&error];
    if (keyStatus == AVKeyValueStatusFailed) {
        [self assetFailedToPrepareForPlayback:error];
        return;
    }
    
    if (!asset.playable) {
        error = [NSError errorWithDomain:@"StitchedStreamPlayer" code:0 userInfo:nil];
        [self assetFailedToPrepareForPlayback:error];
        return;
    }
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    
    _player = [AVPlayer playerWithPlayerItem:playerItem];
    
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = self.frame;
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layer addSublayer:_playerLayer];
}



#pragma mark Error Handling - Preparing Assets for Playback Failed

-(void)assetFailedToPrepareForPlayback:(NSError *)error {
    
}



#pragma mark - Notification

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    [self.player seekToTime:kCMTimeZero];
    
    [self.player play];
}


@end
