//
//  Created by uli on 28.10.11.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "UVChar+Favorits.h"
#import "UVChar.h"


@implementation UVChar (Favorits)

- (BOOL) hasFavorit {
    return [self favorit] != nil;
}

@end