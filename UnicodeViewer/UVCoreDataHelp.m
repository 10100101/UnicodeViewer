//
//  UVCoreDataHelp.m
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 22.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UVCoreDataHelp.h"
#import "UnicodeViewerAppDelegate.h"

@implementation UVCoreDataHelp

+ (NSManagedObjectContext *) defaultContext {
    return [(UnicodeViewerAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];    
} 

@end
