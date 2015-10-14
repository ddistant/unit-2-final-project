//
//  VideoDetailViewController.m
//  finalProject
//
//  Created by Justine Gartner on 10/10/15.
//  Copyright © 2015 ddistant. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "YTPlayerView.h"

@interface VideoDetailViewController ()
@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;

@end

@implementation VideoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.playerView loadWithVideoId:self.videoID];

}

- (IBAction)swipeToDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
