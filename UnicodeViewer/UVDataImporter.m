//
//  UVDataImporter.m
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

#import "UVDataImporter.h"
#import "UVBlock.h"
#import "UnicodeViewerAppDelegate.h"
#import "UVCharDataXMLImporterDelegate.h"

@implementation UVDataImporter


+ (void) importBlockData:(NSString *) name withRepository:(UVBlockRepository *)repository {
    NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:name ofType:@"txt"];
    NSLog(@"Reading file %@, path %@", name, infoSouceFile);
    NSString *blocksRaw = [NSString stringWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:NULL];
    
    // Scanner for lines
    NSScanner *scanner = [NSScanner scannerWithString:blocksRaw];
    NSString *line;
    while ([scanner scanUpToString:@"\n" intoString:&line]) {
        if (![line hasPrefix:@"#"]) {
            NSLog(@"Line: %@", line);
            NSArray *rangeAndName = [line componentsSeparatedByString:@"; "];
            NSString *rangeName = [rangeAndName objectAtIndex:1];
            NSArray *range = [[rangeAndName objectAtIndex:0] componentsSeparatedByString:@".."];
            unsigned long long rangeLower;
            unsigned long long rangeUpper;
            [[NSScanner scannerWithString:[range objectAtIndex:0]] scanHexLongLong:&rangeLower];
            [[NSScanner scannerWithString:[range objectAtIndex:1]] scanHexLongLong:&rangeUpper];
            NSNumber *lower = [NSNumber numberWithUnsignedLong:rangeLower];
            NSNumber *upper = [NSNumber numberWithUnsignedLong:rangeUpper];
            
            UVBlock *block = [repository insertBlockWithName:rangeName from:lower to:upper];
            NSLog(@"inserted block %@", block);
        }
    }
}

+ (void) importCharData:(NSString *)name withRepository:(UVCharRepository *)repository {
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:name withExtension:@"xml"]];
    UVCharDataXMLImporterDelegate *delegate = [[UVCharDataXMLImporterDelegate alloc] initWithRepository:repository];
    [parser setDelegate:delegate];
    
    // start parsing
    if (![parser parse]) {
        NSLog(@"Error parsing xml: %@", [parser parserError]);
    }
    [delegate release];
}


@end
