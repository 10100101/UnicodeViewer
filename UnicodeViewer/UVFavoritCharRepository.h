//
//  UVFavoritCharRepository.h
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 22.10.11.
//  Copyright 2011 10100101.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UVChar;
@class UVFavoritChar;

@interface UVFavoritCharRepository : NSObject

@property (nonatomic, retain, readonly) NSManagedObjectContext* managedObjectContext;

- (id) initWithManagedObjectContext:(NSManagedObjectContext*)context;

- (NSArray*) findFavorites;

- (UVFavoritChar*) insertFavoritForChar:(UVChar*) charInfo;

@end
