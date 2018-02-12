//
//  ViewController.m
//  CPAnimatedPlayingIndicatorView
//
//  Created by Can Poyrazoğlu on 11.02.2018.
//  Copyright © 2018 Can Poyrazoğlu. All rights reserved.
//

#import "ViewController.h"
#import "CPAnimatedPlayingIndicatorView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet CPAnimatedPlayingIndicatorView *indicatorView;

@end

@implementation ViewController

- (IBAction)didTapToggleAnimationButton:(id)sender {
    if(self.indicatorView.isAnimating){
        [self.indicatorView endAnimating];
    }else{
        [self.indicatorView beginAnimating];
    }
}

- (IBAction)didChangeBarCount:(UISlider *)sender {
    self.indicatorView.barCount = (int)sender.value;
}

- (IBAction)didChangeSpacing:(UISlider *)sender {
    self.indicatorView.barSpacing = sender.value;
}

- (IBAction)didChangeCornerRadius:(UISlider *)sender {
    self.indicatorView.cornerRadius = sender.value;
}

- (IBAction)didChangeAnimationSpeed:(UISlider *)sender {
    self.indicatorView.animationSpeed = sender.value;
}

- (IBAction)didChangeDivergence:(UISlider *)sender {
    self.indicatorView.divergence = sender.value;
}

@end
