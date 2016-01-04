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

+ (void)previewImageWithVideoURL:(NSURL *)videoURL returnBlock:(void(^)(UIImage *))block {
    AVAsset *avAsset = [AVAsset assetWithURL:videoURL];
    
    UIImage *image = [self previewImageWithAsset:avAsset];
    if (image) {
        block(image);
        return;
    }
    
    [avAsset loadValuesAsynchronouslyForKeys:@[@"playable"] completionHandler:^{
        UIImage *image = [self previewImageWithAsset:avAsset];
        dispatch_async(dispatch_get_main_queue(), ^{
            block(image);
        });
    }];
}

+ (UIImage *)previewImageWithAsset:(AVAsset *)asset {
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    NSError *error;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(1, 24) actualTime:NULL error:&error];
    UIImage *image = [UIImage imageWithCGImage:img];
    
    CGImageRelease(img);
    return image;
}

@end
