//
//  UVBlockRepository.m
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 16.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UVBlockRepository.h"


@implementation UVBlockRepository

@synthesize managedObjectContext=__managedObjectContext;

- (id) initWithManagedObjectContext:(NSManagedObjectContext *)context {
    self = [super init];
    if (self) {
        __managedObjectContext = [context retain];
    }
    return self;
}


- (NSArray *) listAllBlocks {
    NSArray *result = nil;
    
    // Fetch Blocks
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"UVBlock" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"range_lower" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [sortDescriptor release];
    
    NSError *error = nil;
    result = [self.managedObjectContext executeFetchRequest:request error:&error];

    return result;
}


- (void) dealloc {
    [__managedObjectContext release];
    [super dealloc];
}

@end
