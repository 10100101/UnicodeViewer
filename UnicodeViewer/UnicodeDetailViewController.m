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


@implementation UnicodeDetailViewController

@synthesize unicode;
@synthesize charInfo;
@synthesize charLabel; 
@synthesize charNameLabel; 
@synthesize hexLabel; 
@synthesize htmlEntityLabe;
@synthesize delegate;

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
        if ([charInfo.isFavorit boolValue]) {
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
    self.navigationItem.backBarButtonItem.title = @"Unicodes";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ios-fabric.png"]];
    
    charLabel.text      = [NSString stringWithFormat:@"%C", unicode];
    if (charInfo) {
        charNameLabel.text = charInfo.name;
    } else {
        charNameLabel.text = @"";
    }
    hexLabel.text       = [NSString stringWithFormat:@"U+%06X", unicode];
    htmlEntityLabe.text = [NSString stringWithFormat:@"&#x%X;", unicode];    

    NSString *imageName = @"heart-l";
    if (charInfo) {
        if ([charInfo.isFavorit boolValue]) {
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
