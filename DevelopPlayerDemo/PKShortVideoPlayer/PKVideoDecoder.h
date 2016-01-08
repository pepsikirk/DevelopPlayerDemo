//
//  PKVideoDecoder.h
//  DevelopPlayerDemo
//
//  Created by jiangxincai on 16/1/7.
//  Copyright © 2016年 1yyg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>

@class PKVideoDecoder;

@protocol PKVideoDecoderDelegate <NSObject>

@required
- (void)videoDecoderDidDecodeFrame:(PKVideoDecoder *)decoder pixelBuffer:(CVImageBufferRef)buffer;

@optional
- (void)videoDecoderDidFinishDecoding:(PKVideoDecoder *)decoder;

@end

@interface PKVideoDecoder : NSObject

@property (nonatomic, assign , readonly) BOOL isRunning, isFinished;
@property (nonatomic, assign) int format;
@property (nonatomic, assign) int frameRate;
@property (nonatomic, assign) double currentTime;
@property (nonatomic, assign) BOOL loop;

@property (nonatomic, weak)   id<PKVideoDecoderDelegate> delegate;



- (instancetype)initWithVideoURL:(NSURL *)videoURL format:(int)format;

- (void)start;

- (void)pause;

- (void)stop;

@end
