//
//  UVFavoritRibbonManager.h
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 09.11.11.
//  Copyright 2011 10100101.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UVFavoritRibbonManager : NSObject {

    UIView *ribbonView;
    BOOL isShowingRibbon;
    
}

- (id)initWithParent:(UIView *)parent;

- (void) hideRibbonWithAnimation:(BOOL)animation;
- (void) showRibbonWithAnimation:(BOOL)animation;
- (void) toggel; 

@end
