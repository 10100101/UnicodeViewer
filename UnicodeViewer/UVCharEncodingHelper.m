//
//  UVCharEncodingHelper.m
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 01.11.11.
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

#import "UVCharEncodingHelper.h"

@implementation UVCharEncodingHelper

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (NSString *) toHtmlEntityHex:(int) unicode {
    return [NSString stringWithFormat:@"&#x%X;", unicode];   
}

+ (NSString *) toHtmlEntityDec:(int) unicode {
    return [NSString stringWithFormat:@"&#%i;", unicode];    
}

+ (NSString *) toUnicodeHex:(int) unicode {
    return [NSString stringWithFormat:@"U+%04X", unicode];
}

+ (NSString *) toUtf8Hex:(int) unicode {
    if (unicode < 0) return @"";
    NSString *result = @""; 
    NSData *utf8Data = [UVCharEncodingHelper toUtf8Data:unicode];
    for (int i = 0; i < [utf8Data length]; i++) {
        result = [result stringByAppendingFormat:@" 0x%02X", ((const unsigned char *)[utf8Data bytes])[i]];
    }
    return [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSString *) toMojibakeString:(int) unicode {
    NSData *utf8Data = [UVCharEncodingHelper toUtf8Data:unicode];
    
    return [[[NSString alloc] initWithBytes:[utf8Data bytes] length:[utf8Data length] encoding:NSWindowsCP1252StringEncoding] autorelease];
}

+ (NSString *) toLatin1Utf8String:(int) unicode {
    NSString *result = @"";
    
    result = [[NSString alloc] initWithData:[UVCharEncodingHelper toUtf8Data:unicode] encoding:NSISOLatin1StringEncoding];
    
    return result;
}

+ (NSData *)   toUtf8Data:(int) unicode{
    NSData *data = nil;
    if (unicode < 0x80) {
        const unsigned char chars[] = {unicode};
        data = [NSData dataWithBytes:chars length:1];        
    } else if (unicode < 0x800) {
        const unsigned char chars[] = {(unicode >> 6 | 0xC0), ((unicode & 0x3f) | 0x80)};
        data = [NSData dataWithBytes:chars length:2];        
    } else if (unicode < 0x10000) {
        const unsigned char chars[] = {(unicode >> 12 | 0xE0), (((unicode >> 6) & 0x3f) | 0x80), ((unicode & 0x3f) | 0x80)};
        data = [NSData dataWithBytes:chars length:3];        
    } else if (unicode <= 0x1FFFFF) {
        const unsigned char chars[] = {(unicode >> 18 | 0xF0), (((unicode >> 12) & 0x3f) | 0x80), (((unicode >> 6) & 0x3f) | 0x80), ((unicode & 0x3f) | 0x80)};
        data = [NSData dataWithBytes:chars length:4];        
    }
    return data;
}


+ (NSString *) toNSString:(int) unicode {
    return [NSString stringWithUTF8String:[[UVCharEncodingHelper toUtf8Data:unicode] bytes]];
}


@end
