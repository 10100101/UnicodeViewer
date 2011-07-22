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

- (UVBlock *) insertBlockWithName:(NSString *)name from:(NSNumber *)from to:(NSNumber *)to {
    UVBlock *block = (UVBlock *)[NSEntityDescription insertNewObjectForEntityForName:@"UVBlock" inManagedObjectContext:self.managedObjectContext];
    [block setName:name];
    [block setRangeLower:from];
    [block setRangeUpper:to];
    NSError *error = nil; 
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error saving managed objects: %@", error);
        return nil;
    }
    return block;
}

- (NSArray *) listAllBlocks {
    NSArray *result = nil;
    
    // Fetch Blocks
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"UVBlock" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"rangeLower" ascending:YES];
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
