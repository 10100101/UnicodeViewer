//
//  UVChar.h
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 14.07.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UVChar : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSString * valueHEx;
@property (nonatomic, retain) NSNumber * isFavorit;

@end
