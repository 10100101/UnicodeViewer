//
//  UnicodeDetailViewController.m
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 03.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UnicodeDetailViewController.h"


@implementation UnicodeDetailViewController

@synthesize unicode;
@synthesize name;
@synthesize charLabel; 
@synthesize charNameLabel; 
@synthesize hexLabel; 
@synthesize htmlEntityLabe;

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
    //TODO implementieren
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem.title = @"Unicodes";
    
    charLabel.text      = [NSString stringWithFormat:@"%C", unicode];
    if (name) {
        charNameLabel.text = name;
    } else {
        charNameLabel.text = @"";
    }
    hexLabel.text       = [NSString stringWithFormat:@"U+%06X", unicode];
    htmlEntityLabe.text = [NSString stringWithFormat:@"&#x%X;", unicode];    

    UIBarButtonItem *addToFavs = 
    [[UIBarButtonItem alloc] 
        initWithImage:[UIImage 
        imageNamed:@"heart-l"] 
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
