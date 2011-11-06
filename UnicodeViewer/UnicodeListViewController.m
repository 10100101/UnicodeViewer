//
//  UnicodeListViewController.m
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
#import "UnicodeListViewController.h"
#import "UnicodeDetailViewController.h"
#import "UVCharRepository.h"
#import "UVCoreDataHelp.h"
#import "UVCharListTableViewCell.h"

@implementation UnicodeListViewController

@synthesize block;
@synthesize charListCell;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [charInfos release];
    [block release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem.title = @"Blocks";
    self.navigationItem.title = block.name;

    self.tableView.rowHeight = CHAR_LIST_TABLE_VIEW_CELL_HEIGHT;
    
    // Init char infos
    //UVCharRepository *repository = [[UVCharRepository alloc] initWithManagedObjectContext:[UVCoreDataHelp defaultContext]];
    //NSArray *chars = [repository listCharsFrom:block.rangeLower to:block.rangeUpper];    
    NSArray *chars = [[block chars] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"value" ascending:YES]]];
    charInfos = [[NSMutableDictionary alloc] initWithCapacity:[chars count]];
    for (int i = 0; i < [chars count]; i++) {
        [charInfos setObject:[chars objectAtIndex:i] forKey:[(UVChar*)[chars objectAtIndex:i] value]];
    }
    //[repository release];
    //[chars release];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    return [charInfos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UnicodeCharCell";
    
    UVCharListTableViewCell *cell = (UVCharListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"UVCharListTableViewCell" owner:self options:nil];
        cell = charListCell;
    }
    int c = indexPath.row + [block.rangeLower intValue];
    UVChar *charInfo = (UVChar *)[charInfos objectForKey:[NSNumber numberWithInt:c]];
    if (charInfo) {
        NSString *name = charInfo.name == nil ? @"": charInfo.name;
        cell.unicodeNameLabel.text = name; 
    } else {
        cell.unicodeNameLabel.text = @"";     
    }
    cell.charLabel.text         = [NSString stringWithFormat:@"%C", c];
    cell.charHexValueLabel.text = [NSString stringWithFormat:@"U+%04X", c]; 
        
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Favorite state delegate

- (void) favoriteStateDidChange:(UnicodeDetailViewController *)controller forCharWithNumber:(NSNumber *)number {
    UVCharRepository *repository = [[UVCharRepository alloc] initWithManagedObjectContext:[UVCoreDataHelp defaultContext]];
    UVChar *charInfo = [repository toggleFavForCharWithNumer:number];
    if (charInfo) {
        [charInfos setObject:charInfo forKey:number];
    }
    [repository release];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UnicodeDetailViewController *detailViewController = [[UnicodeDetailViewController alloc] initWithNibName:nil bundle:nil];
    int c = [block.rangeLower intValue] + indexPath.row;
    UVChar *charInfo = (UVChar *)[charInfos objectForKey:[NSNumber numberWithInt:c]];
    detailViewController.unicode  = c;
    detailViewController.charInfo = charInfo;
    detailViewController.delegate = self;

    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

@end
