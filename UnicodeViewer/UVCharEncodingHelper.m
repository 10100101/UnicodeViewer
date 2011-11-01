//
//  UVCharEncodingHelper.m
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 01.11.11.
//  Copyright 2011 10100101.com. All rights reserved.
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
