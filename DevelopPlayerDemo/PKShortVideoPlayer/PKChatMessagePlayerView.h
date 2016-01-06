//
//  PKChatMessagePlayerView.h
//  DevelopPlayerDemo
//
//  Created by jiangxincai on 16/1/5.
//  Copyright © 2016年 1yyg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PKChatMessagePlayerView : UIView

- (instancetype)initWithFrame:(CGRect)frame videoURL:(NSURL *)videoURL previewImage:(UIImage *)previewImage;

@end

NS_ASSUME_NONNULL_END
