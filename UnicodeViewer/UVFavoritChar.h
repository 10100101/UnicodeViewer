//
//  UVFavoritChar.h
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 21.10.11.
//  Copyright (c) 2011 10100101.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UVChar;

@interface UVFavoritChar : NSManagedObject {
@private
}
@property (nonatomic, retain) UVChar *charInfo;

@end
