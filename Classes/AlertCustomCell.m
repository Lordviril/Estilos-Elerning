//
//  AlertCustomCell.m
//  eEducation
//
//  Created by hb12 on 07/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlertCustomCell.h"

@implementation AlertCustomCell
@synthesize lblAlert,lblDate,imgView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
	{
       
       //        lblAlert=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, 105, 35)];
//		lblAlert.backgroundColor=[UIColor clearColor];
//		lblAlert.lineBreakMode=UILineBreakModeWordWrap;
//		lblAlert.numberOfLines=2;
//		lblAlert.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
//		[self.contentView addSubview:lblAlert];
//		
//		lblDate=[[UILabel alloc]initWithFrame:CGRectMake(180, 20, 149, 35)];
//		lblDate.backgroundColor=[UIColor clearColor];
//		lblDate.lineBreakMode=UILineBreakModeWordWrap;
//		lblDate.numberOfLines=2;
//		lblDate.font=[UIFont fontWithName:@"ArialMT" size:15.0];
//		[self.contentView addSubview:lblDate];
//		
//		imgView=[[UIImageView alloc] initWithFrame:CGRectMake(270, 25, 20, 20)];
//		imgView.image=[UIImage imageNamed:@"arrow.png"];
//		[self.contentView addSubview:imgView];
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
//	UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
	
//	if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
//	{
//		lblAlert.frame=CGRectMake(10, 20, 105, 35);
//		lblDate.frame=CGRectMake(180, 20, 149, 35);
//		imgView.frame=CGRectMake(270, 25, 20, 20);
//	}
//	else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight ){
//		lblAlert.frame=CGRectMake(10, 20, 120, 35);
//		lblDate.frame=CGRectMake(200, 20, 150,35);
//		imgView.frame=CGRectMake(294, 25, 20, 20);
//	}
}
-(IBAction)btnViewAlertClicked:(UIButton*)sender
{
   

}
- (void)dealloc 
{
    [super dealloc];
}


@end
