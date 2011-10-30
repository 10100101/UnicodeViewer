//
//  UVCharEncodingTableViewCell.m
//  UnicodeViewer
//
//  Created by Ulrich von Poblotzki on 29.10.11.
//  Copyright 2011 10100101.com. All rights reserved.
//

#import "UVCharEncodingTableViewCell.h"

@implementation UVCharEncodingTableViewCell

@synthesize encodingLable; 
@synthesize valueLable;

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

    if (selected) {
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:self.frame inView:self.superview];
        [menu setMenuVisible:YES animated:YES];
        [self setSelected:NO animated:YES];
    }
}

//needed for the menu
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)resignFirstResponder {
    if (self.selected) {
        [self setSelected:NO animated:YES];
    }
    return YES;
}

//what to copy
- (void)copy:(id)sender {
	UIPasteboard *gpBoard = [UIPasteboard generalPasteboard];
    [gpBoard setString:self.valueLable.text];    
}

//what this cell can do: only copy
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return  (action == @selector(copy:));
}

@end
