//
//  PKVideoDecoder.m
//  DevelopPlayerDemo
//
//  Created by jiangxincai on 16/1/7.
//  Copyright © 2016年 1yyg. All rights reserved.
//

#import "PKVideoDecoder.h"

@import AVFoundation;

@interface PKVideoDecoder () {
    AVAsset    *_asset;
    AVAssetReader *_assetReader;
    AVAssetReaderTrackOutput *_assetReaderOutput;
    
    ////////////////////////
    BOOL      _initFlag;
    BOOL      _resetFlag;
    BOOL      _finishFlag;
    NSTimer  *_timer;
    NSRecursiveLock *_lock;
    ////////////////////////
}

@end

@implementation PKVideoDecoder

-(id)init{
    self = [super init];
    [self init_];
    return self;
}

-(id)initWithMovie:(NSURL*)path format:(int)format{
    self = [super init];
    _format = format;
    [self init_];
    [self loadMovie:path];
    return self;
}

-(void)init_{
    _lock = [[NSRecursiveLock alloc] init];
    _frameRate = 23;
}

-(void)dealloc{
    [_lock lock];
    NSRecursiveLock *lock =_lock;
    [_timer invalidate];
    [lock unlock];
}

-(void)setLoop:(BOOL)loop{
    _loop = loop;
}

-(void)setDelegate:(id<MovieDecoderDelegate>)delegate{
    _delegate = delegate;
}

-(void)setCurrentTime:(double)currentTime{
    _currentTime = currentTime;
}

-(void)setFormat:(int)format{
    _format = format;
}

-(void)setFrameRate:(int)frameRate{
    _frameRate = frameRate;
}

-(BOOL)loadMovie:(NSURL*)path{
    [_lock lock];
    if( _assetReader ){
        [_lock unlock];
        return NO;
    }
    _asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    [_lock unlock];
    return YES;
}

-(void)start{

    [_lock lock];
    if( [self isRunning] ){
        [_lock unlock];
        return;
    }
    _initFlag = NO;
    [self preprocessForDecoding];
    _timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/_frameRate)
                                                     target:self
                                                   selector:@selector(captureLoop)
                                                   userInfo:nil repeats:YES];
    [_lock unlock];
}

-(void)pause{
    [_lock lock];
    if( ![self isRunning] ){
        [_lock unlock];
        return;
    }
    [_timer invalidate];
    _timer = nil;
    [self processForPausing];
    [_lock unlock];
}

-(void)stop{
    [_lock lock];
    _currentTime  = 0;
    [_timer invalidate];
    _timer = nil;
    [self postprocessForDecoding];
    [_lock unlock];
}

-(void)captureLoop{
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self captureNext];
//    });
}

-(void)captureNext{
    [_lock lock];
    [self processForDecoding];
    [_lock unlock];
}

-(BOOL)isRunning{
    return [_timer isValid]? YES : NO;
}

-(void)preprocessForDecoding{
    [self initReader];
}

-(void)postprocessForDecoding{
    [self releaseReader];
}

-(void)processForDecoding
{
    if( _assetReader.status != AVAssetReaderStatusReading ){
        if( _assetReader.status == AVAssetReaderStatusCompleted ){
            if( !_loop ){
                [_timer invalidate];
                _timer = nil;
                _resetFlag = YES;
                [_delegate movieDecoderDidFinishDecoding:self];
                _currentTime = 0;
                [self releaseReader];
                return;
            }else{
                [_delegate movieDecoderDidFinishDecoding:self];
                _currentTime = 0;
                [self initReader];
            }
        }
    }
    CMSampleBufferRef sampleBuffer = [_assetReaderOutput copyNextSampleBuffer];
    if( !sampleBuffer ){ return; }
    _currentTime = CMTimeGetSeconds(CMSampleBufferGetPresentationTimeStamp(sampleBuffer));
    CVImageBufferRef pixBuff = CMSampleBufferGetImageBuffer(sampleBuffer);
//    [_delegate movieDecoderDidDecodeFrame:self pixelBuffer:pixBuff];
    CVPixelBufferRelease(pixBuff);
    CMSampleBufferInvalidate(sampleBuffer);
}

-(void)processForPausing{

}

- (BOOL)isFinished{
    return (_assetReader.status==AVAssetReaderStatusCompleted)? YES : NO;
}

/////////////////////////////////////

-(void)releaseReader{
    _assetReader = nil;
    _assetReaderOutput = nil;
}

-(void)initReader{
    AVAssetTrack *track = [[_asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    NSDictionary *setting = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:_format]
                                                        forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    _assetReaderOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:track outputSettings:setting];
    
    _assetReader = [[AVAssetReader alloc] initWithAsset:_asset error:nil];
    [_assetReader addOutput:_assetReaderOutput];
    CMTime tm = CMTimeMake((int64_t)(_currentTime*30000), 30000);
    [_assetReader setTimeRange:CMTimeRangeMake(tm,_asset.duration)];
    [_assetReader startReading];
}

@end
