//
//  UVCharRepository.h
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

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UVChar.h"

@interface UVCharRepository : NSObject {

}
@property (nonatomic, retain, readonly) NSManagedObjectContext* managedObjectContext;

- (id) initWithManagedObjectContext:(NSManagedObjectContext*)context;

- (UVChar*) insertCharWithNumber:(NSNumber*) number name:(NSString*) name;

- (NSArray*) listCharsFrom:(NSNumber*) from to:(NSNumber*) to;

- (NSArray*) findFavorites;

- (UVChar*) toggleFavForCharWithNumer:(NSNumber*) number;

- (UVChar*) findCharWithNumber:(NSNumber*) number;

@end
