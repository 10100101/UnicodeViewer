//
//  UVCharDataXMLImporterDelegate.h
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 22.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UVCharRepository.h"

@interface UVCharDataXMLImporterDelegate : NSObject <NSXMLParserDelegate>

@property (nonatomic, retain, readonly) UVCharRepository *repository;

- (id)initWithRepository:(UVCharRepository *)repository;

@end
