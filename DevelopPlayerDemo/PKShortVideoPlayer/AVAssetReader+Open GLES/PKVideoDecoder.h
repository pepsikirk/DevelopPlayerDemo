//
//  PKVideoDecoder.h
//  DevelopPlayerDemo
//
//  Created by jiangxincai on 16/1/11.
//  Copyright © 2016年 1yyg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class GPUImageFramebuffer;

@protocol PKVideoDecoderDelegate <NSObject>

- (void)didCompletePlayingMovie;

- (void)didDecodeInputFramebuffer:(GPUImageFramebuffer *)newInputFramebuffer inputSize:(CGSize)newSize frameTime:(CMTime)frameTime;

@end

@interface PKVideoDecoder : NSObject

@property (readwrite, retain) AVAsset *asset;
@property(readwrite, retain) NSURL *url;
@property(readonly, nonatomic) CGFloat progress;
@property (readonly, nonatomic) AVAssetReader *assetReader;

@property (readwrite, nonatomic, weak) id <PKVideoDecoderDelegate>delegate;

- (id)initWithURL:(NSURL *)url;
- (void)yuvConversionSetup;

/// @name Movie processing
- (BOOL)readNextVideoFrameFromOutput:(AVAssetReaderOutput *)readerVideoTrackOutput;
- (void)startProcessing;
- (void)endProcessing;
- (void)cancelProcessing;
- (void)processMovieFrame:(CMSampleBufferRef)movieSampleBuffer;

@end
