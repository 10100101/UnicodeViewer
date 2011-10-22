//
//  UVFavoritCharRepository.m
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 22.10.11.
//  Copyright 2011 10100101.com. All rights reserved.
//

#import "UVFavoritCharRepository.h"
#import "UVChar.h"
#import "UVFavoritChar.h"

@implementation UVFavoritCharRepository


@synthesize managedObjectContext=__managedObjectContext;

- (id) initWithManagedObjectContext:(NSManagedObjectContext *)context {
    self = [super init];
    if (self) {
        __managedObjectContext = [context retain];
    }
    
    return self;
}

- (UVFavoritChar*) insertFavoritForChar:(UVChar*) charInfo {
    if (charInfo == nil) return nil;
    UVFavoritChar *favorit = (UVFavoritChar *)[NSEntityDescription insertNewObjectForEntityForName:@"UVFavoritChar" inManagedObjectContext:self.managedObjectContext];
    favorit.charInfo = charInfo;
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error saving managed object: %@", error);
        return nil;
    }
    return favorit;
}

- (NSArray*) findFavorites {
    NSManagedObjectContext *moc = self.managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"UVFavoritChar" inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
        
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"charInfo.value" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [sortDescriptor release];
    
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    if (array == nil)
    {
        NSLog(@"Error fetching chars: %@", error);
        return nil;
    }
    return array;
}

- (void) dealloc {
    [__managedObjectContext release];
    [super dealloc];
}


@end
