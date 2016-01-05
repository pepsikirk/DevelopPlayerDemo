//
//  UIImage+PKShortVideoPlayer.h
//  DevelopPlayerDemo
//
//  Created by jiangxincai on 16/1/4.
//  Copyright © 2016年 1yyg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVAsset;

@interface UIImage (PKShortVideoPlayer)

+ (UIImage *)previewImageWithVideoURL:(NSURL *)videoURL;

@end
