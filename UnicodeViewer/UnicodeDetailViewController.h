//
//  UnicodeDetailViewController.h
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 03.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UnicodeDetailViewController : UIViewController {

}

@property(nonatomic, assign) IBOutlet UILabel *charLabel; 
@property(nonatomic, assign) IBOutlet UILabel *charNameLabel; 
@property(nonatomic, assign) IBOutlet UILabel *hexLabel; 
@property(nonatomic, assign) IBOutlet UILabel *htmlEntityLabe; 

@property(nonatomic, assign) int unicode;
@property(nonatomic, assign) NSString *name;

@end
