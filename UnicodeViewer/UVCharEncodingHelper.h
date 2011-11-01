//
//  UVCharEncodingHelper.h
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 01.11.11.
//  Copyright 2011 10100101.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UVCharEncodingHelper : NSObject

+ (NSString *) toHtmlEntityHex:(int) unicode;
+ (NSString *) toHtmlEntityDec:(int) unicode;
+ (NSString *) toUnicodeHex:(int) unicode;
+ (NSString *) toUtf8Hex:(int) unicode;

@end
