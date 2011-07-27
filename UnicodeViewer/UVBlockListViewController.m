//
//  UVBlockListViewController.m
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 14.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UVBlockListViewController.h"
#import "UVDataImporter.h"
#import "UVCoreDataHelp.h"
#import "UVBlockRepository.h"
#import "UVCharRepository.h"
#import "UVBlock.h"
#import "UnicodeListViewController.h"

@implementation UVBlockListViewController

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
    [blocks release];
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
    
    UVBlockRepository *blockReposiory = [[UVBlockRepository alloc] initWithManagedObjectContext:[UVCoreDataHelp defaultContext]];
    blocks = [[blockReposiory listAllBlocks] retain]; 
    // Init Database
    /*
    UVCharRepository *charReposiory = [[UVCharRepository alloc] initWithManagedObjectContext:[UVCoreDataHelp defaultContext]];
    if (blocks == nil || [blocks count] == 0) {
        [UVDataImporter importBlockData:@"uni-blocks-6.0.0" withRepository:blockReposiory];
        blocks = [[blockReposiory listAllBlocks] retain];
        
        [UVDataImporter importCharData:@"uni-grouped-6.0.0" withRepository:charReposiory];
    }
    [blockReposiory release];
    [charReposiory release];
      */  
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [blocks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UVBlockCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    UVBlock *currentBlock = (UVBlock *)[blocks objectAtIndex:indexPath.row];
    cell.textLabel.text = currentBlock.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"U+%06X ... U+%06X", [currentBlock.rangeLower intValue], [currentBlock.rangeUpper intValue]];
    
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
    UnicodeListViewController *listViewController = [[UnicodeListViewController alloc] initWithNibName:nil bundle:nil];
    listViewController.block = [blocks objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:listViewController animated:YES];
    [listViewController release];
}

@end
