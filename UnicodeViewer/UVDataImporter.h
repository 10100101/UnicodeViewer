//
//  UVDataImporter.h
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 14.07.11.
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
#import "UVBlockRepository.h"
#import "UVCharRepository.h"

@interface UVDataImporter : NSObject {
    
}

/**
 * Range and name informations about the blocks are read from a text file, which was 
 * provied by unicode.org. The name of this file is the first parameter of this 
 * method e.g. @"uni-blocks-6.0.0".
 */
+ (void) importBlockData:(NSString *) name withRepository:(UVBlockRepository *) repository;

/**
 * Name information about each char are read from a XML file. The name of this file is 
 * given via first parameter. 
 */
+ (void) importCharData:(NSString *) name withRepository:(UVCharRepository *) repository;

@end
