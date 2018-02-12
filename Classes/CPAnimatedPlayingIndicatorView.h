//
//  CPAnimatedPlayingIndicatorView.h
//  CPAnimatedPlayingIndicatorView
//
//  Created by Can Poyrazoğlu on 11.02.2018.
//  Copyright © 2018 Can Poyrazoğlu. All rights reserved.
//

@import UIKit;

IB_DESIGNABLE
@interface CPAnimatedPlayingIndicatorView : UIView

/// Number of bars to display. Default is 5.
@property(nonatomic) IBInspectable int barCount;
/// Color of the displayed bars. Default is blackish gray.
@property(nonatomic) IBInspectable UIColor *color;
/// Space between bars, in points. Default is 0.
@property(nonatomic) IBInspectable float barSpacing;
/// Corner radius of each bar, in points. Default is 0.
@property(nonatomic) IBInspectable float cornerRadius;
/// Animation speed. The units for this one is a bit complicated. Hey, I've failed math 3 times in college. Play with this value to get the desired effect.
@property(nonatomic) IBInspectable double animationSpeed;
/// Defines how much each consequent bar has a different height. Default is 5, play with it to get desired value.
@property(nonatomic) IBInspectable double divergence;

/// Indicates whether the view is currently animating. To begin an animation use: @code -[CPAnimatedPlayingIndicatorView beginAnimating] @endcode To end an animation use: @code -[CPAnimatedPlayingIndicatorView endAnimating] @endcode
@property(readonly, nonatomic) BOOL isAnimating;

-(void)beginAnimating;
-(void)endAnimating;


@end
