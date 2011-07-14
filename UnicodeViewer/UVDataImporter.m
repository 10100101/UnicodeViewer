//
//  UVDataImporter.m
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 14.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UVDataImporter.h"


@implementation UVDataImporter


- (void) importBlockData:(NSString *) name {
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
            NSInteger lower = [[NSNumber numberWithUnsignedLong:rangeLower] integerValue];
            NSInteger upper = [[NSNumber numberWithUnsignedLong:rangeUpper] integerValue];
            NSLog(@"name %@, lower %X, upper %X", rangeName, lower, upper);
        }
    }
}


@end
