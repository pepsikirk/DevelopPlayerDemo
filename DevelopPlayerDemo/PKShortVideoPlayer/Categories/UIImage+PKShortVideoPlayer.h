//
//  UIImage+PKShortVideoPlayer.h
//  DevelopPlayerDemo
//
//  Created by jiangxincai on 16/1/4.
//  Copyright © 2016年 pepsikirk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVAsset;

@interface UIImage (PKShortVideoPlayer)

+ (UIImage *)pk_previewImageWithVideoURL:(NSURL *)videoURL;

@end
