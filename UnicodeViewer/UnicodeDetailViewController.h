//
//  UnicodeDetailViewController.h
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 03.07.11.
//
//  Copyright 2011 Ulrich von Poblotzki.
//
//  This file is part of UnicodeViewer.
//
//  UnicodeViewer is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  UnicodeViewer is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with UnicodeViewer.  If not, see <http://www.gnu.org/licenses/>.
//

#import <UIKit/UIKit.h>
#import "UVChar.h"

@protocol UVFavoriteStateChangedDelegate;
@class UVCharEncodingTableViewCell;
@class UVCharBlockTableViewCell;
@class UVRelatedCharTableViewCell;
@class UVFavoritRibbonManager;

@interface UnicodeDetailViewController : UIViewController <UIActionSheetDelegate> {

    NSArray *relatedChars;
    UVFavoritRibbonManager *ribbonManager;
    
}

@property(nonatomic, assign) IBOutlet UILabel *charLabel; 
@property(nonatomic, assign) IBOutlet UILabel *charNameLabel; 
@property(nonatomic, assign) IBOutlet UIView  *tableHeaderView;
@property(nonatomic, assign) IBOutlet UITableView *tableView;
@property(nonatomic, assign) IBOutlet UVCharEncodingTableViewCell *charEncodingCell;
@property(nonatomic, assign) IBOutlet UVCharBlockTableViewCell *blockCell;
@property(nonatomic, assign) IBOutlet UVRelatedCharTableViewCell *relatedCharCell;

@property(nonatomic, assign) int unicode;
@property(nonatomic, assign) UVChar *charInfo;
@property(nonatomic, assign) id<UVFavoriteStateChangedDelegate> delegate;

@end

@protocol UVFavoriteStateChangedDelegate

-(void) favoriteStateDidChange:(UnicodeDetailViewController *) controller forCharWithNumber: (NSNumber *) number;

@end
