//
//  PKChatMessagePlayerView.m
//  DevelopPlayerDemo
//
//  Created by jiangxincai on 16/1/5.
//  Copyright © 2016年 1yyg. All rights reserved.
//

#import "PKChatMessagePlayerView.h"
@import AVFoundation;

@interface PKChatMessagePlayerView ()

@property (nonatomic, strong) NSURL *videoURL;

@property (nonatomic, strong) UIImage *previewImage;

@property (nonatomic, strong) AVURLAsset *asset;

@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation PKChatMessagePlayerView

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame videoURL:(NSURL *)videoURL previewImage:(UIImage *)previewImage {
    NSParameterAssert(videoURL != nil);
    NSParameterAssert(previewImage != nil);
    
    self = [super initWithFrame:frame];
    if (self) {
        _videoURL = videoURL;
        _previewImage = previewImage;
        _images = [NSMutableArray new];
        
        self.asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
        
        [self.asset loadValuesAsynchronouslyForKeys:@[@"playable"] completionHandler:^{
            
            AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:self.asset error:nil];
            NSArray *videoTracks = [self.asset tracksWithMediaType:AVMediaTypeVideo];
            AVAssetTrack *videoTrack =[videoTracks objectAtIndex:0];
            
            int m_pixelFormatType = kCVPixelFormatType_32BGRA;
            NSMutableDictionary *options = [NSMutableDictionary dictionary];
            [options setObject:@(m_pixelFormatType) forKey:(id)kCVPixelBufferPixelFormatTypeKey];
            
            NSDictionary *pixelBufferAttributes = @{
                                                    (id)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithInt:kCVPixelFormatType_32BGRA],
                                                    (id)kCVPixelBufferWidthKey : [NSNumber numberWithFloat:320],
                                                    (id)kCVPixelBufferHeightKey : [NSNumber numberWithFloat:180]
                                                    };
            AVAssetReaderTrackOutput *videoReaderOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:videoTrack outputSettings:options];
            
            [reader addOutput:videoReaderOutput];
            [reader startReading];
            
            // 要确保nominalFrameRate>0，之前出现过android拍的0帧视频
            NSInteger i = 0;
            while ([reader status] == AVAssetReaderStatusReading && videoTrack.nominalFrameRate > 0) {
                // 读取 video sample
                CMSampleBufferRef videoBuffer = [videoReaderOutput copyNextSampleBuffer];
                if (videoBuffer) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self playWithVideoBuffer:videoBuffer];
                    });
                }
                NSLog(@"i == %@",@(i++));
                CMSampleBufferInvalidate(videoBuffer);
                CMTime duration = self.asset.duration;
                [NSThread sleepForTimeInterval:(1.0/24)];
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                [self mMoveDecoderOnDecoderFinished];
            });
        }];
    }
    return self;
}

- (void)dealloc
{
    _images = nil;
}

- (void)playWithVideoBuffer:(CMSampleBufferRef)videoBuffer {
    CGImageRef cgimage = [self imageFromSampleBufferRef:videoBuffer];
    if (!(__bridge id)(cgimage)) { return; }
//    [self.images addObject:((__bridge id)(cgimage))];
//    CGImageRelease(cgimage);
    self.layer.contents = (__bridge id)(cgimage);
    CGImageRelease(cgimage);
}

- (void)mMoveDecoderOnDecoderFinished
{
    NSLog(@"视频解档完成");
    // 得到媒体的资源
    // 通过动画来播放我们的图片
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
//    // asset.duration.value/asset.duration.timescale 得到视频的真实时间
//    animation.duration = self.asset.duration.value/self.asset.duration.timescale;
//    animation.values = self.images;
//    animation.repeatCount = MAXFLOAT;
//    [self.layer addAnimation:animation forKey:nil];
}

- (CGImageRef)imageFromSampleBufferRef:(CMSampleBufferRef)sampleBufferRef
{
    // 为媒体数据设置一个CMSampleBufferRef
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBufferRef);

    // 锁定 pixel buffer 的基地址
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    // 得到 pixel buffer 的基地址
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // 得到 pixel buffer 的行字节数
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // 得到 pixel buffer 的宽和高
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // 创建一个依赖于设备的 RGB 颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphic context）对象
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst);
    
    //根据这个位图 context 中的像素创建一个 Quartz image 对象
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // 解锁 pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    // 释放 context 和颜色空间
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CVBufferRelease(imageBuffer);
    
    return quartzImage;
    
}


@end
