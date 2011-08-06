//
//  UVFavoriteListViewController.h
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnicodeDetailViewController.h"

@interface UVFavoriteListViewController : UITableViewController <UVFavoriteStateChangedDelegate> {
    NSMutableArray *charInfos;
}
@end
