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
#import "UVChar+Favorits.h"
#import "UVCharEncodingTableViewCell.h"
#import "UVCharEncodingHelper.h"

enum UVDetailViewEncodingPosition {
    UVDetailViewEncodingPositionUnicode = 0,
    UVDetailViewEncodingPositionUtf8    = 1,
    UVDetailViewEncodingPositionHtmlHex = 2,
    UVDetailViewEncodingPositionHtmlDec = 3,
    UVDetailViewEncodingPositionUtf16   = 4
};

@interface UnicodeDetailViewController(Private)

- (void) updateCharNameLabel:(NSString *) name;
        
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UVCharEncodingTableViewCell *cell = (UVCharEncodingTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"UnicodeCharCellEncoding"];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"UVCharEncodingTableViewCell" owner:self options:nil];
        cell = charEncodingCell;
    }
    if (indexPath.row == UVDetailViewEncodingPositionUnicode) {
        cell.encodingLable.text = @"Unicode: ";
        cell.valueLable.text    = [UVCharEncodingHelper toUnicodeHex: unicode];
    } else if (indexPath.row == UVDetailViewEncodingPositionHtmlHex) {
        cell.encodingLable.text = @"HTML (hex): ";
        cell.valueLable.text    = [UVCharEncodingHelper toHtmlEntityHex: unicode];    
    } else if (indexPath.row == UVDetailViewEncodingPositionHtmlDec) {
        cell.encodingLable.text = @"HTML (dec): ";
        cell.valueLable.text    = [UVCharEncodingHelper toHtmlEntityDec: unicode];    
    } else if (indexPath.row == UVDetailViewEncodingPositionUtf8) {
        cell.encodingLable.text = @"UTF-8: ";
        cell.valueLable.text    = [UVCharEncodingHelper toUtf8Hex: unicode];    
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Encoding";
}

#pragma mark - Table view delegate

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
*/


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
