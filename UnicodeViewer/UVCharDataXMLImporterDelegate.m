//
//  UVCharDataXMLImporterDelegate.m
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 22.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
