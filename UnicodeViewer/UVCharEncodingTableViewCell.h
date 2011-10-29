//
//  UVCharEncodingTableViewCell.h
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 29.10.11.
//  Copyright 2011 10100101.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UVCharEncodingTableViewCell : UITableViewCell

@property(nonatomic, assign) IBOutlet UILabel *encodingLable; 
@property(nonatomic, assign) IBOutlet UILabel *valueLable;

@end
