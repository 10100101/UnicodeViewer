//
//  UVFavoritRibbonManager.m
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 09.11.11.
//  Copyright 2011 10100101.com. All rights reserved.
//

#import "UVFavoritRibbonManager.h"

@implementation UVFavoritRibbonManager

- (id)initWithParent:(UIView *)parent
{
    self = [super init];
    if (self) {
        isShowingRibbon = NO;
        UIImage *ribbonImg = [UIImage imageNamed:@"bookmark-ribbon.png"];
        UIImageView *ribbonImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ribbonImg.size.width, ribbonImg.size.height)];
        [ribbonImgView setImage:ribbonImg];
        ribbonView = [[UIView alloc] initWithFrame:CGRectMake(315-ribbonImg.size.width, -ribbonImg.size.height, ribbonImg.size.width, ribbonImg.size.height)];
        [ribbonView addSubview:ribbonImgView];
        [ribbonImgView release];
        [parent addSubview:ribbonView];        
    }
    
    return self;
}

- (void) showRibbonWithAnimation:(BOOL)animation {
    isShowingRibbon = YES;

    if (animation) {
        // Animate the view downwards
        [UIView beginAnimations:@"" context:nil];
    
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5f];
    
        [ribbonView setFrame:CGRectMake(ribbonView.frame.origin.x, ribbonView.frame.origin.y+ribbonView.frame.size.height, ribbonView.frame.size.width, ribbonView.frame.size.height)];
        
        [UIView commitAnimations];
    } else {
        [ribbonView setFrame:CGRectMake(ribbonView.frame.origin.x, ribbonView.frame.origin.y+ribbonView.frame.size.height, ribbonView.frame.size.width, ribbonView.frame.size.height)];    
    }
}

- (void) hideRibbonWithAnimation:(BOOL)animation {
    isShowingRibbon = NO;
    
    if (animation) {
        // Animate the view upwards
        [UIView beginAnimations:@"" context:nil];
    
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5f];
    
        [ribbonView setFrame:CGRectMake(ribbonView.frame.origin.x, ribbonView.frame.origin.y-ribbonView.frame.size.height, ribbonView.frame.size.width, ribbonView.frame.size.height)];
    
        [UIView commitAnimations];
    } else {
        [ribbonView setFrame:CGRectMake(ribbonView.frame.origin.x, ribbonView.frame.origin.y-ribbonView.frame.size.height, ribbonView.frame.size.width, ribbonView.frame.size.height)];    
    }
}


- (void) toggel {
    if (isShowingRibbon) {
        [self hideRibbonWithAnimation:YES];
    } else {
        [self showRibbonWithAnimation:YES];
    }
}

- (void) dealloc {
    [ribbonView release];
    [super dealloc]; 
}

@end
