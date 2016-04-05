//
//  ViewController.m
//  DevelopPlayerDemo
//
//  Created by jiangxincai on 16/1/4.
//  Copyright © 2016年 pepsikirk. All rights reserved.
//

#import "ViewController.h"
#import "PKFullScreenPlayerViewController.h"
#import "UIImage+PKShortVideoPlayer.h"
#import "PKLayerContentsViewController.h"
#import "PKOpenGLESViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSString *videoPath;
@property (nonatomic, strong) UIImage *image;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.videoPath = [[NSBundle mainBundle] pathForResource:@"Cat" ofType:@"mp4"];
    
    self.image = [UIImage pk_previewImageWithVideoURL:[NSURL fileURLWithPath:self.videoPath]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToAVPlayer:(id)sender {
    if (!self.image) {
        return;
    }
    
    PKFullScreenPlayerViewController *playerViewController = [[PKFullScreenPlayerViewController alloc] initWithVideoPath:self.videoPath previewImage:self.image];
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.25];
    [animation setType: kCATransitionFade];
    
    [animation setSubtype: kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController pushViewController:playerViewController animated:NO];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueLayerContents"]) {
        PKLayerContentsViewController *vc = segue.destinationViewController;
        vc.videoPath = self.videoPath;
        vc.image = self.image;
    } else if ([segue.identifier isEqualToString:@"segueOpenGLES"]) {
        PKOpenGLESViewController *vc = segue.destinationViewController;
        vc.videoPath = self.videoPath;
        vc.image = self.image;
    }
}

@end
