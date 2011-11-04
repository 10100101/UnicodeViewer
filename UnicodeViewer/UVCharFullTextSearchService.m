//
//  UVCharFullTextSearchService.m
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 01.10.11.
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

#import "UVCharFullTextSearchService.h"
#import "RRFTS3ExtensionLoader.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"


@implementation UVCharFullTextSearchService

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.        
    }
    
    return self;
}

+ (NSArray*) findCharsWithNameOrHexValue:(NSString *) searchText {
    [RRFTS3ExtensionLoader loadFTS3];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    NSString *storePath = [basePath stringByAppendingPathComponent:@"UVDB.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:storePath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    
    FMResultSet *rs = [db executeQuery:@"select ZVALUE from ZUVCHAR_FTS where ZUVCHAR_FTS match ?", [searchText stringByAppendingString:@"*"]];
    NSMutableArray *resultIds = [[NSMutableArray alloc] init];
    while ([rs next]) {
        [resultIds addObject:[NSNumber numberWithInt:[rs intForColumn:@"ZVALUE"]]];
    }
    [rs close];
    [db close];
    [resultIds autorelease];
    return [NSArray arrayWithArray:resultIds];
}


@end
