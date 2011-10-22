//
//  UVBlock.h
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 21.10.11.
//  Copyright (c) 2011 10100101.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UVChar;

@interface UVBlock : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * rangeLower;
@property (nonatomic, retain) NSNumber * rangeUpper;
@property (nonatomic, retain) NSSet *chars;
@end

@interface UVBlock (CoreDataGeneratedAccessors)

- (void)addCharsObject:(UVChar *)value;
- (void)removeCharsObject:(UVChar *)value;
- (void)addChars:(NSSet *)values;
- (void)removeChars:(NSSet *)values;

@end
