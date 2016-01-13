//
//  DownloadedCustomCell.m
//  eEducation
//
//  Created by Hidden Brains on 11/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DownloadedCustomCell.h"


@implementation DownloadedCustomCell
@synthesize lblCourseName,lblDocName,lblModuleName,lblType,imgview;
@synthesize btnDelete=_btnDelete;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
	{
        
		lblCourseName=[[UILabel alloc]initWithFrame:CGRectMake(23, 12, 253, 21)];
		lblCourseName.backgroundColor=[UIColor clearColor];
		lblCourseName.lineBreakMode=UILineBreakModeMiddleTruncation;
		lblCourseName.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
		[self.contentView addSubview:lblCourseName];
		
		lblDocName=[[UILabel alloc]initWithFrame:CGRectMake(23, 35, 306, 21)];
		lblDocName.backgroundColor=[UIColor clearColor];
		lblDocName.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
		[self.contentView addSubview:lblDocName];
		
		lblModuleName=[[UILabel alloc]initWithFrame:CGRectMake(370, 12, 244, 21)];
		lblModuleName.backgroundColor=[UIColor clearColor];
		lblModuleName.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
		[self.contentView addSubview:lblModuleName];
		
		lblType=[[UILabel alloc]initWithFrame:CGRectMake(370, 35, 244, 21)];
		lblType.backgroundColor=[UIColor clearColor];
		lblType.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
		[self.contentView addSubview:lblType];
		
		imgview=[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-130, 25, 20, 20)];
		imgview.image=[UIImage imageNamed:@"arrow.png"];
		[self.contentView addSubview:imgview];
		
		_btnDelete=[UIButton buttonWithType:UIButtonTypeCustom];
		_btnDelete.frame=CGRectMake(self.frame.size.width-230, 17, 66, 36);
		
		[self.contentView addSubview:_btnDelete];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
    imgview.frame=CGRectMake(self.frame.size.width-130, 25, 20, 20);
	_btnDelete.frame=CGRectMake(self.frame.size.width-230, 17, 66, 36);
    [super setSelected:selected animated:animated];
    

}
-(void) layoutSubviews
{
	[super layoutSubviews];
	UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
	
	if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown )
	{
		lblCourseName.frame = CGRectMake(23, 12, 253, 21);
		lblDocName.frame = CGRectMake(23, 35, 306, 21);
		lblModuleName.frame=CGRectMake(370, 12, 244, 21);
		lblType.frame=CGRectMake(370, 35, 244, 21);
		
	}
	else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight )
	{
		lblCourseName.frame = CGRectMake(23, 12, 400, 21);
		lblDocName.frame = CGRectMake(23, 35, 516, 21);
		lblModuleName.frame=CGRectMake(606, 12, 244, 21);
		lblType.frame=CGRectMake(606, 35, 244, 21);
		
	}

}


- (void)dealloc 
{
    [super dealloc];
}


@end
