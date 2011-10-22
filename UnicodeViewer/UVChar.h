//
//  UVChar.h
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 21.10.11.
//  Copyright (c) 2011 10100101.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UVBlock, UVFavoritChar;

@interface UVChar : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * valueHex;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) UVBlock *block;
@property (nonatomic, retain) UVFavoritChar *favorit;

@end
