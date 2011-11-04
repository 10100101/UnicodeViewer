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

#import "UnicodeDetailViewController.h"
#import "UnicodeListViewController.h"
#import "UVChar+Favorits.h"
#import "UVCharEncodingTableViewCell.h"
#import "UVCharBlockTableViewCell.h"
#import "UVCharEncodingHelper.h"
#import "UVBlock.h"

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

@interface UnicodeDetailViewController(Private)

- (void) updateCharNameLabel:(NSString *) name;
- (UITableViewCell *)tableView:(UITableView *)tableView encodingCellForRow:(NSInteger)row;
- (UITableViewCell *)tableView:(UITableView *)tableView commonCellForRow:(NSInteger)row;
- (UITableViewCell *)tableView:(UITableView *)tableView relatedCellForRow:(NSInteger)row;
        
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
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Actions

- (IBAction) addToFavorites:(id) sender {
    NSString *imageName = @"heart-d";
    if (charInfo) {
        if ([charInfo hasFavorit]) {
            imageName = @"heart-l";
        }
    }    
    self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:imageName];
    
    if (delegate) {
        [delegate favoriteStateDidChange:self forCharWithNumber:[NSNumber numberWithInt:unicode]];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSBundle mainBundle] loadNibNamed:@"UVDetailTableViewHeader" owner:self options:nil];

    self.tableHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ios-fabric@2x.png"]];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 310)];
    [bgView addSubview:self.tableHeaderView];
    self.tableView.tableHeaderView = bgView;
    [bgView release];
                      
    self.navigationItem.backBarButtonItem.title = @"Unicodes";
    
    charLabel.text      = [NSString stringWithFormat:@"%C", unicode];
    [self updateCharNameLabel:charInfo.name];

    NSString *imageName = @"heart-l";
    if (charInfo) {
        if ([charInfo hasFavorit]) {
            imageName = @"heart-d";
        }
    }
    
    UIBarButtonItem *addToFavs = 
    [[UIBarButtonItem alloc] 
        initWithImage:[UIImage 
        imageNamed:imageName] 
        style:UIBarButtonItemStylePlain 
        target:self 
        action:@selector(addToFavorites:)];
    self.navigationItem.rightBarButtonItem = addToFavs;
    [addToFavs release];
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
    return nil;
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
