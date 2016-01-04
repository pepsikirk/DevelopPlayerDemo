//
//  PKFullScreenPlayerViewController.m
//  DevelopPlayerDemo
//
//  Created by jiangxincai on 16/1/4.
//  Copyright © 2016年 1yyg. All rights reserved.
//

#import "PKFullScreenPlayerViewController.h"
#import "PKFullScreenPlayerView.h"

@interface PKFullScreenPlayerViewController ()

@property (nonatomic, strong) PKFullScreenPlayerView *playerView;

@property (nonatomic, strong) NSURL *videoURL;

@end

@implementation PKFullScreenPlayerViewController

#pragma mark - Initialization

- (instancetype)initWithVideoURL:(NSURL *)videoURL previewImage:(UIImage *)previewImage {
    NSParameterAssert(videoURL != nil);
    NSParameterAssert(previewImage != nil);

    self = [super init];
    if (self) {
        _videoURL = videoURL;
        
        CGSize viewSize = self.view.bounds.size;
        CGSize imageSize = previewImage.size;
        _playerView = [[PKFullScreenPlayerView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.width* (imageSize.height/imageSize.width) ) videoURL:videoURL previewImage:previewImage];
        [self.view addSubview:_playerView];
        _playerView.center = self.view.center;
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
