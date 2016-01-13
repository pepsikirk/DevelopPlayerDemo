//
//  PKFullScreenPlayerViewController.m
//  DevelopPlayerDemo
//
//  Created by jiangxincai on 16/1/4.
//  Copyright © 2016年 pepsikirk. All rights reserved.
//

#import "PKFullScreenPlayerViewController.h"
#import "PKFullScreenPlayerView.h"

@interface PKFullScreenPlayerViewController ()

@property (nonatomic, strong) PKFullScreenPlayerView *playerView;

@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) UIImage *image;

@end

@implementation PKFullScreenPlayerViewController

#pragma mark - Initialization

- (instancetype)initWithVideoURL:(NSURL *)videoURL previewImage:(UIImage *)previewImage {
    NSParameterAssert(videoURL != nil);
    NSParameterAssert(previewImage != nil);

    self = [super init];
    if (self) {
        _videoURL = videoURL;
        _image = previewImage;
    }
    return self;
}



#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    CGSize viewSize = self.view.bounds.size;
    CGSize imageSize = self.image.size;
    
    self.playerView = [[PKFullScreenPlayerView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.width* (imageSize.height/imageSize.width) ) videoURL:self.videoURL previewImage:self.image];
    self.playerView.center = self.view.center;
    
    [self.view addSubview:self.playerView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [self.view addGestureRecognizer:tap];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - Tap GestureRecognizer

- (void)tapGestureRecognizer:(UITapGestureRecognizer *)tap {
    [self.playerView pause];
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.25];
    [animation setType: kCATransitionFade];
    
    [animation setSubtype: kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
}

@end
