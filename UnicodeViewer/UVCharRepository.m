//
//  UVCharRepository.m
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 22.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UVCharRepository.h"

@implementation UVCharRepository

@synthesize managedObjectContext=__managedObjectContext;

- (id) initWithManagedObjectContext:(NSManagedObjectContext *)context {
    self = [super init];
    if (self) {
        __managedObjectContext = [context retain];
    }
    
    return self;
}

- (UVChar *) insertCharWithNumber:(NSNumber *) number name:(NSString *) name {
    UVChar *charInfo = (UVChar *)[NSEntityDescription insertNewObjectForEntityForName:@"UVChar" inManagedObjectContext:self.managedObjectContext];
    charInfo.value = number;
    charInfo.valueHex = [NSString stringWithFormat:@"%06C"];
    charInfo.name = name;
    charInfo.isFavorit = NO;
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error saving managed object: %@", error);
        return nil;
    }
    return charInfo;
    return nil;
}

- (NSArray *) listCharsFrom:(NSNumber *) from to:(NSNumber *) to {
    NSManagedObjectContext *moc = self.managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"UVChar" inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(value >= %@) AND (value <= %@)", from, to];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"value" ascending:YES];
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



@end
