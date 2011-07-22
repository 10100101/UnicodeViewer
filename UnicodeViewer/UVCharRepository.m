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


@end
