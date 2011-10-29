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


@implementation UnicodeDetailViewController

@synthesize unicode;
@synthesize charInfo;
@synthesize charLabel; 
@synthesize charNameLabel; 
@synthesize delegate;
@synthesize tableHeaderView;
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

    self.tableHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ios-fabric.png"]];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 267)];
    [bgView addSubview:self.tableHeaderView];
    self.tableView.tableHeaderView = bgView;
    [bgView release];
                      
    self.navigationItem.backBarButtonItem.title = @"Unicodes";
    
    charLabel.text      = [NSString stringWithFormat:@"%C", unicode];
    if (charInfo) {
        charNameLabel.text = charInfo.name;
    } else {
        charNameLabel.text = @"";
    }

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UVCharEncodingTableViewCell *cell = (UVCharEncodingTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"UnicodeCharCellEncoding"];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"UVCharEncodingTableViewCell" owner:self options:nil];
        cell = charEncodingCell;
    }
    if (indexPath.row == 0) {
        cell.encodingLable.text = @"Unicode: ";
        cell.valueLable.text    = [NSString stringWithFormat:@"U+%06X", unicode];
    } else {
        cell.encodingLable.text = @"Html: ";
        cell.valueLable.text    = [NSString stringWithFormat:@"&#x%X;", unicode];    
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

#pragma mark - Table view delegate

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
*/


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
