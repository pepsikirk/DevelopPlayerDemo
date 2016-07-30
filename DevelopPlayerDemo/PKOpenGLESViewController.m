//
//  PKOpenGLESViewController.m
//  DevelopPlayerDemo
//
//  Created by jiangxincai on 16/1/11.
//  Copyright © 2016年 pepsikirk. All rights reserved.
//

#import "PKOpenGLESViewController.h"
#import "PKChatMessagePlayerView.h"

@interface PKOpenGLESViewController ()

@property (nonatomic, strong) PKChatMessagePlayerView *playerView;

@end

@implementation PKOpenGLESViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGSize viewSize = self.view.bounds.size;
    CGSize imageSize = self.image.size;
    
    self.playerView = [[PKChatMessagePlayerView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.width* (imageSize.height/imageSize.width) ) videoPath:self.videoPath previewImage:self.image];
    [self.playerView play];
    self.playerView.center = self.view.center;
    
    [self.view addSubview:self.playerView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playerView stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
