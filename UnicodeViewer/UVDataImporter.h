//
//  UVDataImporter.h
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 14.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
