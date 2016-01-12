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

@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong, readonly) AVAssetReader *assetReader;
@property (nonatomic, assign, readonly) CGFloat progress;

@property (nonatomic, assign) BOOL keepLooping;

@property (nonatomic, weak) id <PKVideoDecoderDelegate>delegate;

- (instancetype)initWithVideoURL:(NSURL *)videoURL size:(CGSize)size;

- (void)startProcessing;
- (void)endProcessing;
- (void)cancelProcessing;

@end
