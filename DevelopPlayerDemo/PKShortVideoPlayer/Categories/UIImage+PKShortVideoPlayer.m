//
//  UIImage+PKShortVideoPlayer.m
//  DevelopPlayerDemo
//
//  Created by jiangxincai on 16/1/4.
//  Copyright © 2016年 1yyg. All rights reserved.
//

#import "UIImage+PKShortVideoPlayer.h"
@import AVFoundation;

@implementation UIImage (PKShortVideoPlayer)

+ (UIImage *)previewImageWithVideoURL:(NSURL *)videoURL {
    AVAsset *asset = [AVAsset assetWithURL:videoURL];
    
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;

    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(1, asset.duration.timescale) actualTime:NULL error:nil];
    UIImage *image = [UIImage imageWithCGImage:img];
    
    CGImageRelease(img);
    return image;
}

@end
