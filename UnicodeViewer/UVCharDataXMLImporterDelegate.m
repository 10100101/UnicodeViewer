//
//  UVCharDataXMLImporterDelegate.m
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

#import "UVCharDataXMLImporterDelegate.h"

@implementation UVCharDataXMLImporterDelegate

@synthesize repository =__repository;

- (id)initWithRepository:(UVCharRepository *)repository {
    self = [super init];
    if (self) {
        __repository=[repository retain];
    }
    
    return self;
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"char"]) {
        NSString *na1 = [attributeDict objectForKey:@"na1"];
        NSString *na  = [attributeDict objectForKey:@"na"];
        NSString *charName = na != NULL?na:na1;
        NSString *hexValue = [attributeDict objectForKey:@"cp"];
        if (hexValue) {
            NSLog(@"Found char %@ (%@)", charName, hexValue);
            NSScanner *scanner = [NSScanner scannerWithString:hexValue];
            unsigned long long charValue;
            [scanner scanHexLongLong:&charValue];
            [self.repository insertCharWithNumber:[NSNumber numberWithUnsignedLong:charValue] name:charName];
        }
    }
}

- (void) dealloc {
    [__repository release];
    [super dealloc];
}

@end
