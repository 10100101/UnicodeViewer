//
//  UnicodeDetailViewController.m
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

#import "UVUIConstants.h"
#import "UnicodeDetailViewController.h"
#import "UnicodeListViewController.h"
#import "UVChar+Favorits.h"
#import "UVCharEncodingTableViewCell.h"
#import "UVCharBlockTableViewCell.h"
#import "UVRelatedCharTableViewCell.h"
#import "UVCharEncodingHelper.h"
#import "UVBlock.h"
#import "UVChar.h"
#import "UVRelatedChars.h"
#import "UVFavoritRibbonManager.h"

NSInteger const NUMBER_OF_SECTIONS      = 3;
NSInteger const NUMBER_OF_COMMON_ROWS   = 1;
NSInteger const NUMBER_OF_ENCODING_ROWS = 4;

enum UVDetailViewSectionPosition {
    UVDetailViewSectionPositionCommon   = 0,
    UVDetailViewSectionPositionEncoding = 1,
    UVDetailViewSectionPositionRelated  = 2
};

enum UVDetailViewEncodingPosition {
    UVDetailViewEncodingPositionUnicode = 0,
    UVDetailViewEncodingPositionUtf8    = 1,
    UVDetailViewEncodingPositionHtmlHex = 2,
    UVDetailViewEncodingPositionHtmlDec = 3,
    UVDetailViewEncodingPositionUtf16   = 4
};

enum UVDetailViewActionSheetPosition {
    UVDetailViewActionSheetCopy           = 0,
    UVDetailViewActionSheetAddToFavorites = 1,
    UVDetailViewActionSheetOpenDefinition = 2, 
    UVDetailViewActionSheetFileFormatInfo = 3
};

@interface UnicodeDetailViewController(Private)

- (void) updateCharNameLabel:(NSString *) name;
- (UITableViewCell *)tableView:(UITableView *)tableView encodingCellForRow:(NSInteger)row;
- (UITableViewCell *)tableView:(UITableView *)tableView commonCellForRow:(NSInteger)row;
- (UITableViewCell *)tableView:(UITableView *)tableView relatedCellForRow:(NSInteger)row;
        
- (NSArray *) sortedRelatedCharsFrom;

@end


@implementation UnicodeDetailViewController

@synthesize unicode;
@synthesize charInfo;
@synthesize charLabel; 
@synthesize charNameLabel; 
@synthesize delegate;
@synthesize tableHeaderView;
@synthesize tableView;
@synthesize charEncodingCell;
@synthesize blockCell;
@synthesize relatedCharCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [relatedChars release];
    [ribbonManager release];
    [tableHeaderView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Actions

- (void) addToFavorites {
    [ribbonManager toggel];
    if (delegate) {
        [delegate favoriteStateDidChange:self forCharWithNumber:[NSNumber numberWithInt:unicode]];
    }
}

- (void) showActionSheet {
    NSString *favoritButtonTitle = @"Add to Favorites";
    if ([self.charInfo hasFavorit]) {
        favoritButtonTitle = @"Remove from Favorites";
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Copy Character", favoritButtonTitle, @"Lookup in Wikipedia", @"Open FileFormat.Info", nil];
    [actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
    [actionSheet release];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == UVDetailViewActionSheetAddToFavorites) {
        [self addToFavorites];
    } else if (buttonIndex == UVDetailViewActionSheetOpenDefinition) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://en.wikipedia.org/wiki/%C", [self.charInfo.value intValue]]]];
    } else if (buttonIndex == UVDetailViewActionSheetFileFormatInfo) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.fileformat.info/info/unicode/char/%04X/index.htm", [self.charInfo.value intValue]]]];
    } else if (buttonIndex == UVDetailViewActionSheetCopy) {
        UIPasteboard *gpBoard = [UIPasteboard generalPasteboard];
        [gpBoard setString:[UVCharEncodingHelper toNSString:unicode]];   
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Date
    relatedChars = [[self sortedRelatedCharsFrom] retain];
    
    // GUI    
    [[NSBundle mainBundle] loadNibNamed:@"UVDetailTableViewHeader" owner:self options:nil];

    self.tableHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ios-fabric@2x.png"]];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 310)];
    [bgView addSubview:self.tableHeaderView];
    self.tableView.tableHeaderView = bgView;
    [bgView release];
                          
    self.navigationItem.backBarButtonItem.title = @"Unicodes";
    
    charLabel.text      = [UVCharEncodingHelper toNSString:unicode];
    [self updateCharNameLabel:charInfo.name];

    UIBarButtonItem *showActionSheet = 
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction 
         target:self action:@selector(showActionSheet)];
    self.navigationItem.rightBarButtonItem = showActionSheet;
    [showActionSheet release];
    
    // Show favorit state
    ribbonManager = [[UVFavoritRibbonManager alloc] initWithParent:self.tableHeaderView];
    if ([charInfo hasFavorit]) {
        [ribbonManager showRibbonWithAnimation:NO];
    }
    
}

- (NSArray *) sortedRelatedCharsFrom {
    NSArray * result = nil;
    if (self.charInfo && self.charInfo.related) {
        result = [self.charInfo.related sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"related.value" ascending:YES]]];
    }
    return result;
}

- (void) updateCharNameLabel:(NSString *) name {
    if (name) {
        charNameLabel.text = name;
        CGRect nameLableFrame = self.charNameLabel.frame;
        CGSize maximumSize = CGSizeMake(nameLableFrame.size.width, nameLableFrame.size.height);
        CGSize nameStringSize = [name sizeWithFont:self.charNameLabel.font 
                                 constrainedToSize:maximumSize 
                                     lineBreakMode:self.charNameLabel.lineBreakMode];
        int emptyHeight = nameLableFrame.size.height - nameStringSize.height;
        CGRect nameFrame = CGRectMake(nameLableFrame.origin.x, nameLableFrame.origin.y+emptyHeight/2, nameLableFrame.size.width, nameStringSize.height);
        self.charNameLabel.frame = nameFrame;
    } else {
        charNameLabel.text = @"";
    }    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (charInfo && [charInfo.related count] == 0) {
        return NUMBER_OF_SECTIONS-1;
    } 
    return NUMBER_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger rows = 0;
    if (section == UVDetailViewSectionPositionEncoding) {
        rows = NUMBER_OF_ENCODING_ROWS;
    } else if (section == UVDetailViewSectionPositionCommon) {
        rows = NUMBER_OF_COMMON_ROWS;
    } else if (section == UVDetailViewSectionPositionRelated) {
        rows = [relatedChars count];
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == UVDetailViewSectionPositionEncoding) {
        cell = [self tableView:tView encodingCellForRow:indexPath.row];
    } else if (indexPath.section == UVDetailViewSectionPositionCommon) {
        cell = [self tableView:tView commonCellForRow:indexPath.row];
    } else if (indexPath.section == UVDetailViewSectionPositionRelated) {
        cell = [self tableView:tView relatedCellForRow:indexPath.row];
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView encodingCellForRow:(NSInteger)row {
    UVCharEncodingTableViewCell *cell = (UVCharEncodingTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"UnicodeCharCellEncoding"];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"UVCharEncodingTableViewCell" owner:self options:nil];
        cell = charEncodingCell;
    }
    if (row == UVDetailViewEncodingPositionUnicode) {
        cell.encodingLable.text = @"Unicode: ";
        cell.valueLable.text    = [UVCharEncodingHelper toUnicodeHex: unicode];
    } else if (row == UVDetailViewEncodingPositionHtmlHex) {
        cell.encodingLable.text = @"HTML (hex): ";
        cell.valueLable.text    = [UVCharEncodingHelper toHtmlEntityHex: unicode];    
    } else if (row == UVDetailViewEncodingPositionHtmlDec) {
        cell.encodingLable.text = @"HTML (dec): ";
        cell.valueLable.text    = [UVCharEncodingHelper toHtmlEntityDec: unicode];    
    } else if (row == UVDetailViewEncodingPositionUtf8) {
        cell.encodingLable.text = @"UTF-8: ";
        cell.valueLable.text    = [UVCharEncodingHelper toUtf8Hex: unicode];    
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;

}

- (UITableViewCell *)tableView:(UITableView *)tableView commonCellForRow:(NSInteger)row {
    UVCharBlockTableViewCell *cell = (UVCharBlockTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"UnicodeCharCellBlock"];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"UVCharBlockTableViewCell" owner:self options:nil];
        cell = blockCell;
    }
    if (row == 0) {
        cell.blockName.text = self.charInfo.block.name;
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView relatedCellForRow:(NSInteger)row {
    UVRelatedCharTableViewCell *cell = (UVRelatedCharTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"UnicodeCharCellRelated"];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"UVRelatedCharTableViewCell" owner:self options:nil];
        cell = self.relatedCharCell;
    }
    UVRelatedChars *relatedChar = (UVRelatedChars *)[relatedChars objectAtIndex:row];
    cell.unicodeNameLabel.text  = relatedChar.related.name;
    cell.charLabel.text         = [UVCharEncodingHelper toNSString:[relatedChar.related.value intValue]];
    cell.charHexValueLabel.text = [NSString stringWithFormat:@"U+%04X", [relatedChar.related.value intValue]]; 
    if ([relatedChar.related hasFavorit]) {
        UIImage *favoritEgdeImage = [UIImage imageNamed:@"favorit-edge.png"];
        cell.favoritEdgeView.image = favoritEgdeImage;        
    }
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = @"";
    if (section == UVDetailViewSectionPositionEncoding) {
        title = @"Encoding";
    } else if (section == UVDetailViewSectionPositionCommon) {
        title = @"Common";
    } else if (section == UVDetailViewSectionPositionRelated) {
        title = @"See Also";    
    }
    return title;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == UVDetailViewSectionPositionCommon && indexPath.row == 0) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        UnicodeListViewController *listViewController = [[UnicodeListViewController alloc] initWithNibName:nil bundle:nil];
        listViewController.block = self.charInfo.block;
        [self.navigationController pushViewController:listViewController animated:YES];
        [listViewController release];
    }
    if (indexPath.section == UVDetailViewSectionPositionRelated) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        UnicodeDetailViewController *detailViewController = [[UnicodeDetailViewController alloc] initWithNibName:nil bundle:nil];
        UVRelatedChars *relatedChar = (UVRelatedChars *)[relatedChars objectAtIndex:indexPath.row];
        UVChar *cInfo = relatedChar.related;
        int c = [cInfo.value intValue];
        detailViewController.unicode  = c;
        detailViewController.charInfo = cInfo;
        detailViewController.delegate = self.delegate;
        
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == UVDetailViewSectionPositionRelated) {
        return CHAR_LIST_TABLE_VIEW_CELL_HEIGHT;
    } else {
        return 44;
    }
}

#pragma mark - The rest

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
