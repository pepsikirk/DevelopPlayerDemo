//
//  AVAssetReaderViewController.m
//  DevelopPlayerDemo
//
//  Created by jiangxincai on 16/1/4.
//  Copyright © 2016年 1yyg. All rights reserved.
//

#import "AVAssetReaderViewController.h"
#import "PKChatMessagePlayerView.h"

@interface AVAssetReaderViewController ()

@property (nonatomic, strong) PKChatMessagePlayerView *playerView;

@end

@implementation AVAssetReaderViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    NSURL *URL =
    
    
    CGSize viewSize = self.view.bounds.size;
    CGSize imageSize = image.size;
    
    self.playerView = [[PKChatMessagePlayerView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.width* (imageSize.height/imageSize.width) ) videoURL:URL previewImage:image];
    self.playerView.center = self.view.center;
    
    [self.view addSubview:self.playerView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
