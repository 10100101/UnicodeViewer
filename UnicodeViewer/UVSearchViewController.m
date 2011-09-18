//
//  UVSearchViewController.m
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 02.09.11.
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

#import "UVSearchViewController.h"
#import "UVCharRepository.h"
#import "UVCoreDataHelp.h"
#import "UVChar.h"

@interface UVSearchViewController(Private)

- (void) searchFor:(NSString *) searchText;
- (void) updateData:(NSMutableArray *) data;
    
@end

@implementation UVSearchViewController

@synthesize charInfos;
@synthesize charListCell;
@synthesize operationQueue;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void) searchFor:(NSString *) searchText {
    NSMutableArray *charInfoData = nil;    
    if ([searchText length] == 1) {
        UVCharRepository *repository = [[UVCharRepository alloc] initWithManagedObjectContext:[UVCoreDataHelp defaultContext]];
        
        NSNumber *c = [NSNumber numberWithInt:[searchText characterAtIndex:0]];
        NSLog(@"Searched for %X", [c intValue]);
        UVChar *charInfo = [repository findCharWithNumber:c];
        charInfoData = [NSMutableArray arrayWithObject:[charInfo objectID]];
        [repository release];
    } else if ([searchText length] > 1) {
        UVCharRepository *repository = [[UVCharRepository alloc] initWithManagedObjectContext:[UVCoreDataHelp defaultContext]];
        
        NSLog(@"Searched for %@", searchText);
        NSArray *chars = [repository findCharsWithNameOrHexValue:searchText];
        if (chars) {
            charInfoData = [[NSMutableArray alloc] initWithCapacity:[chars count]];
            for (NSInteger i = 0; i < [chars count]; i++) {
                [charInfoData addObject:[[chars objectAtIndex:i] objectID]];
            }            
        }
        [repository release];    
    }
    // Update Data
    [self performSelectorOnMainThread:@selector(updateData:) withObject:charInfoData waitUntilDone:YES];
}

- (void) updateData:(NSMutableArray *)data {
    NSLog(@"Updating tableView with data");
    if (data) {
        UVCharRepository *repository = [[UVCharRepository alloc] initWithManagedObjectContext:[UVCoreDataHelp defaultContext]];
        NSMutableArray *charInfosData = [[NSMutableArray alloc] initWithCapacity:[data count]];
        for (NSInteger i = 0; i < [data count]; i++) {
            [charInfosData addObject:[repository findCharWithID:[data objectAtIndex:i]]];
        }
        [repository release];
        self.charInfos = charInfosData;        
    } else {
        self.charInfos = [[NSMutableArray alloc] init];    
    }
    [self.searchDisplayController.searchResultsTableView reloadData];
    
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
    
    UVCharListTableViewCell *cell = (UVCharListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"UVCharListTableViewCell" owner:self options:nil];
        cell = charListCell;
    }
    UVChar *charInfo = (UVChar *)[charInfos objectAtIndex:indexPath.row];
    int c = [charInfo.value intValue];
    cell.charLabel.text = [NSString stringWithFormat:@"%C", c];     
    if (charInfo) {
        NSString *name = charInfo.name == nil ? @"": charInfo.name;
        cell.unicodeNameLabel.text = name; 
    } else {
        cell.unicodeNameLabel.text = @""; 
    }
    cell.charHexValueLabel.text = [NSString stringWithFormat:@"U+%06X", c]; 
    
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UnicodeDetailViewController *detailViewController = [[UnicodeDetailViewController alloc] initWithNibName:nil bundle:nil];
    UVChar *charInfo = (UVChar *)[charInfos objectAtIndex:indexPath.row];
    detailViewController.unicode  = [charInfo.value intValue];
    detailViewController.charInfo = charInfo;
    detailViewController.delegate = self;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

#pragma mark - UiSearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (!self.operationQueue) {
        self.operationQueue = [[NSOperationQueue alloc] init];
        [self.operationQueue setMaxConcurrentOperationCount:1];
    }
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(searchFor:) object:searchText];
    [self.operationQueue cancelAllOperations];
    [self.operationQueue addOperation:operation];
    [operation release];
}

#pragma mark - Favorite state delegate

- (void) favoriteStateDidChange:(UnicodeDetailViewController *)controller forCharWithNumber:(NSNumber *)number {
    UVCharRepository *repository = [[UVCharRepository alloc] initWithManagedObjectContext:[UVCoreDataHelp defaultContext]];
    [repository toggleFavForCharWithNumer:number];
    [repository release];
}


- (void) dealloc {
    [charInfos release];
    [operationQueue release];

    [super dealloc];
}

@end
