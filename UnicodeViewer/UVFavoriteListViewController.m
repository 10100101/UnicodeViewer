//
//  UVFavoriteListViewController.m
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UVUIConstants.h"
#import "UVFavoriteListViewController.h"
#import "UnicodeDetailViewController.h"
#import "UVFavoritCharRepository.h"
#import "UVCharRepository.h"
#import "UVChar.h"
#import "UVCharEncodingHelper.h"
#import "UVFavoritChar.h"
#import "UVCoreDataHelp.h"

@interface UVFavoriteListViewController(Private) 

-(void) loadData;

@end


@implementation UVFavoriteListViewController

@synthesize charListCell;


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

-(void) loadData {
    // Init char infos
    UVFavoritCharRepository *repository = [[UVFavoritCharRepository alloc] initWithManagedObjectContext:[UVCoreDataHelp defaultContext]];
    NSArray *staticCharInfos = [repository findFavorites];
    charInfos = [[NSMutableArray alloc] initWithCapacity:[staticCharInfos count]];
    [charInfos addObjectsFromArray:staticCharInfos];
    [repository release];
    [self.tableView reloadData];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
    
    self.tableView.rowHeight = CHAR_LIST_TABLE_VIEW_CELL_HEIGHT;

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
    [self loadData];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    UVFavoritChar *favorit = (UVFavoritChar *)[charInfos objectAtIndex:indexPath.row];
    UVChar *charInfo = favorit.charInfo;
    int c = [charInfo.value intValue];
    
    cell.charLabel.text = [UVCharEncodingHelper toNSString:c];     
    if (charInfo) {
        NSString *name = charInfo.name == nil ? @"": charInfo.name;
        cell.unicodeNameLabel.text = name; 
    } else {
        cell.unicodeNameLabel.text = @""; 
    }
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
    [repository toggleFavForCharWithNumer:number];
    [repository release];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UnicodeDetailViewController *detailViewController = [[UnicodeDetailViewController alloc] initWithNibName:nil bundle:nil];
    
    UVFavoritChar *favorit = (UVFavoritChar *)[charInfos objectAtIndex:indexPath.row];
    UVChar *charInfo = favorit.charInfo;
    detailViewController.unicode  = [charInfo.value intValue];
    detailViewController.charInfo = charInfo;
    detailViewController.delegate = self;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

@end
