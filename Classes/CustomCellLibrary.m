//
//  CustomCellLibrary.m
//  eEducation
//
//  Created by HB14 on 09/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomCellLibrary.h"
#import "AsyncImageView.h"

@implementation CustomCellLibrary

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
	{
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void) layoutSubviews
{
	[super layoutSubviews];
	
}

- (void)dealloc
{
    [super dealloc];
}

@end
