//
//  CalenderCustomCell.m
//  eEducation
//
//  Created by Hidden Brains on 11/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalenderCustomCell.h"


@implementation CalenderCustomCell
@synthesize lblDate,lblDescription;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
	{
		lblDate=[[UILabel alloc]initWithFrame:CGRectMake(23, 10,700, 21)];
		lblDate.backgroundColor=[UIColor clearColor];
		lblDate.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
		[self.contentView addSubview:lblDate];
		
		lblDescription=[[UILabel alloc]initWithFrame:CGRectMake(23, 30, 610, 30)];
		lblDescription.backgroundColor=[UIColor clearColor];
		lblDescription.numberOfLines=3;
		lblDescription.font=[UIFont fontWithName:@"ArialMT" size:13];
		[self.contentView addSubview:lblDescription];
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
	UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
	
	if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		lblDescription.frame=CGRectMake(23, 30, 610,30);	
	}
	else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight )
	{
		lblDescription.frame=CGRectMake(23, 30, 862,30);
	}
}

- (void)dealloc 
{
	[lblDate release];
	[lblDescription release];
    [super dealloc];
}
@end
