//
//  UVCharBlockTableView.m
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 04.11.11.
//  Copyright 2011 10100101.com. All rights reserved.
//

#import "UVCharBlockTableViewCell.h"

@implementation UVCharBlockTableViewCell

@synthesize blockName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
