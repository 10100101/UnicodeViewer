//
//  UnicodeListViewController.h
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 03.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UVBlock.h"

@interface UnicodeListViewController : UITableViewController {
    NSMutableDictionary *charInfos;
}

@property(nonatomic, retain) UVBlock *block;

@end
