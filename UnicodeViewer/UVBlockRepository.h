//
//  UVBlockRepository.h
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 16.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UVBlock.h"

@interface UVBlockRepository : NSObject {

}
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

- (id) initWithManagedObjectContext:(NSManagedObjectContext *)context;

- (NSArray *) listAllBlocks;

- (UVBlock *) insertBlockWithName: (NSString *) name from:(NSNumber *) from to:(NSNumber *)to;

@end
