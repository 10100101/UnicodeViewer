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
    if (unicode < 0x80) {
        return [NSString stringWithFormat:@"0x%02X", unicode];
    } else if (unicode < 0x800) {
        NSString *utf8String = [NSString stringWithFormat:@"0x%02X", (unicode >> 6 | 0xC0)];
        utf8String = [utf8String stringByAppendingFormat:@" 0x%02X", ((unicode & 0x3f) | 0x80)];
        return utf8String;
    } else if (unicode < 0x10000) {
        NSString *utf8String = [NSString stringWithFormat:@"0x%02X", (unicode >> 12 | 0xE0)];
        utf8String = [utf8String stringByAppendingFormat:@" 0x%02X", (((unicode >> 6) & 0x3f) | 0x80)];
        utf8String = [utf8String stringByAppendingFormat:@" 0x%02X", ((unicode & 0x3f) | 0x80)];
        return utf8String;
    } else if (unicode <= 0x1FFFFF) {
        NSString *utf8String = [NSString stringWithFormat:@"0x%02X", (unicode >> 18 | 0xF0)];
        utf8String = [utf8String stringByAppendingFormat:@" 0x%02X", (((unicode >> 12) & 0x3f) | 0x80)];
        utf8String = [utf8String stringByAppendingFormat:@" 0x%02X", (((unicode >> 6) & 0x3f) | 0x80)];
        utf8String = [utf8String stringByAppendingFormat:@" 0x%02X", ((unicode & 0x3f) | 0x80)];
        return utf8String;
    }
    return @"";
}


@end
