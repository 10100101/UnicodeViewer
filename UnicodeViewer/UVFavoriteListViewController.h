//
//  UVFavoriteListViewController.h
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnicodeDetailViewController.h"
#import "UVCharListTableViewCell.h"

@interface UVFavoriteListViewController : UITableViewController <UVFavoriteStateChangedDelegate> {
    NSMutableArray *charInfos;
}

@property(nonatomic, assign) IBOutlet UVCharListTableViewCell *charListCell;

@end
