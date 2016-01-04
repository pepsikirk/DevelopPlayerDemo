//
//  ViewController.m
//  DevelopPlayerDemo
//
//  Created by jiangxincai on 16/1/4.
//  Copyright © 2016年 1yyg. All rights reserved.
//

#import "ViewController.h"
#import "PKFullScreenPlayerViewController.h"
#import "UIImage+PKShortVideoPlayer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToAVPlayer:(id)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Cat" ofType:@"mp4"];

    NSURL *URL = [[NSURL alloc] initWithString:path];
    
    [UIImage previewImageWithVideoURL:URL returnBlock:^(UIImage *image) {
        PKFullScreenPlayerViewController *playerViewController = [[PKFullScreenPlayerViewController alloc] initWithVideoURL:URL previewImage:image];
        [self.navigationController pushViewController:playerViewController animated:YES];
    }];
}

@end
