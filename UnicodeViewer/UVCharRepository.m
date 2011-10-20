//
//  UVCharRepository.m
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 22.07.11.
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
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error saving managed object: %@", error);
        return nil;
    }
    return charInfo;
    return nil;
}

- (UVChar *) findCharWithNumber:(NSNumber *) number {
    NSManagedObjectContext *moc = self.managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"UVChar" inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"value == %@", number];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    if (array == nil)
    {
        NSLog(@"Error fetching chars: %@", error);
        return nil;
    }
    if ([array count] > 0) {
        return [array objectAtIndex:0];
    } else {
        return nil;
    }
}


- (NSArray*) findCharsWithNumbers:(NSArray*) numbers {
    NSManagedObjectContext *moc = self.managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"UVChar" inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"value IN %@", numbers];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    if (array == nil)
    {
        NSLog(@"Error fetching chars: %@", error);
        return nil;
    }
    if ([array count] > 0) {
        return array;
    } else {
        return nil;
    }
}


- (NSArray*) findFavorites {
    NSManagedObjectContext *moc = self.managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"UVChar" inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFavorit == YES"];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"value" ascending:YES];
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

- (UVChar *) toggleFavForCharWithNumer:(NSNumber *) number {
    UVChar *charInfo = [self findCharWithNumber:number];
    if (!charInfo) {
        charInfo = [self insertCharWithNumber:number name:nil];
    }
    //TODO add new implementation
    //[charInfo setIsFavorit:[NSNumber numberWithBool:![charInfo.isFavorit boolValue]]];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error saving managed object: %@", error);
        return nil;
    }
    return charInfo;
}

- (UVChar*) findCharWithID:(NSManagedObjectID *) objectID {
    return (UVChar*)[self.managedObjectContext objectWithID:objectID];
}

- (NSArray *) findCharsWithNameOrHexValue:(NSString *) searchText {
    NSManagedObjectContext *moc = self.managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"UVChar" inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(valueHex contains[cd] %@) OR (name contains[cd] %@)", searchText, searchText];
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
