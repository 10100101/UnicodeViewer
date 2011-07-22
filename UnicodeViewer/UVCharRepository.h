//
//  UVCharRepository.h
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 22.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UVChar.h"

@interface UVCharRepository : NSObject {

}
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

- (id) initWithManagedObjectContext:(NSManagedObjectContext *)context;

- (UVChar *) insertCharWithNumber:(NSNumber *) number name:(NSString *) name;
@end
