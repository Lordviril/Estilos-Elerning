//
//  CustomCellForTestResultsListing.m
//  eEducation
//
//  Created by HB 13 on 28/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomCellForTestResultsListing.h"


@implementation CustomCellForTestResultsListing
@synthesize labelTestName = _labelTestName; 
@synthesize labelTestNameValue = _labelTestNameValue; 
@synthesize labelStartDate = _labelStartDate; 
@synthesize labelStartDateValue = _labelStartDateValue; 
@synthesize labelEndDate = _labelEndDate; 
@synthesize labelEndDateValue = _labelEndDateValue; 
@synthesize labelStatus = _labelStatus; 
@synthesize labelStatusValue = _labelStatusValue; 
@synthesize imageDisclouser = _imageDisclouser;
@synthesize lblcol1,lblcol2,lblcol3,lblcol4;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		_labelTestName=[[UILabel alloc]initWithFrame:CGRectMake(20, 12, 115, 21)];
		_labelTestName.backgroundColor=[UIColor clearColor];
		_labelTestName.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
		[self.contentView addSubview:_labelTestName];
		
		lblcol1=[[UILabel alloc]initWithFrame:CGRectMake(140, 12,5, 21)];
		lblcol1.backgroundColor=[UIColor clearColor];
		lblcol1.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
		lblcol1.text=@":";
		[self.contentView addSubview:lblcol1];
		
		_labelTestNameValue=[[UILabel alloc]initWithFrame:CGRectMake(155, 12, 180, 21)];
		_labelTestNameValue.numberOfLines=1;
		_labelTestNameValue.backgroundColor=[UIColor clearColor];
		_labelTestNameValue.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
		[self.contentView addSubview:_labelTestNameValue];
		
		
		_labelStartDate=[[UILabel alloc]initWithFrame:CGRectMake(375, 12, 130, 21)];
		_labelStartDate.backgroundColor=[UIColor clearColor];
		_labelStartDate.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
		[self.contentView addSubview:_labelStartDate];
		
		lblcol2=[[UILabel alloc]initWithFrame:CGRectMake(510, 12,5, 21)];
		lblcol2.backgroundColor=[UIColor clearColor];
		lblcol2.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
		lblcol2.text=@":";
		[self.contentView addSubview:lblcol2];
		
		_labelStartDateValue=[[UILabel alloc]initWithFrame:CGRectMake(525, 12, 155, 21)];
		_labelStartDateValue.backgroundColor=[UIColor clearColor];
		_labelStartDateValue.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
		[self.contentView addSubview:_labelStartDateValue];
		
		_labelStatus=[[UILabel alloc]initWithFrame:CGRectMake(20, 35, 115, 21)];
		_labelStatus.backgroundColor=[UIColor clearColor];
		_labelStatus.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
		[self.contentView addSubview:_labelStatus];
		
		lblcol3=[[UILabel alloc]initWithFrame:CGRectMake(140, 35,5, 21)];
		lblcol3.backgroundColor=[UIColor clearColor];
		lblcol3.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
		lblcol3.text=@":";
		[self.contentView addSubview:lblcol3];
		
		_labelStatusValue=[[UILabel alloc]initWithFrame:CGRectMake(155, 35, 150, 21)];
		_labelStatusValue.backgroundColor=[UIColor clearColor];
		_labelStatusValue.font=[UIFont fontWithName:@"ArialMT" size:15.0];
		[self.contentView addSubview:_labelStatusValue];
		
		_labelEndDate=[[UILabel alloc]initWithFrame:CGRectMake(375, 35, 130, 21)];
		_labelEndDate.backgroundColor=[UIColor clearColor];
		_labelEndDate.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
		[self.contentView addSubview:_labelEndDate];
		
		lblcol4=[[UILabel alloc]initWithFrame:CGRectMake(510, 35,5, 21)];
		lblcol4.backgroundColor=[UIColor clearColor];
		lblcol4.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
		lblcol4.text=@":";
		[self.contentView addSubview:lblcol4];
		
		_labelEndDateValue=[[UILabel alloc]initWithFrame:CGRectMake(525, 35, 155, 21)];
		_labelEndDateValue.backgroundColor=[UIColor clearColor];
		_labelEndDateValue.font=[UIFont fontWithName:@"ArialMT" size:15.0];
		[self.contentView addSubview:_labelEndDateValue];
		
		_imageDisclouser=[[UIImageView alloc] initWithFrame:CGRectMake(690, 25, 20, 20)];
		_imageDisclouser.image=[UIImage imageNamed:@"arrow.png"];
		[self.contentView addSubview:_imageDisclouser];
    }
    return self;
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	_labelStartDateValue.font=[UIFont fontWithName:@"Arial" size:15.0];
	_labelTestName.text=[eEducationAppDelegate getLocalvalue:@"Test Name"];
	_labelStartDate.text=[eEducationAppDelegate getLocalvalue:@"Start Date"];
	_labelStatus.text=[eEducationAppDelegate getLocalvalue:@"Test Status"];
	_labelEndDate.text=[eEducationAppDelegate getLocalvalue:@"End Date"];
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		_labelTestNameValue.frame=CGRectMake(190, 12, 180, 21);
		_labelStatusValue.frame=CGRectMake(190, 35, 150, 21);
		_labelStartDate.frame=CGRectMake(380, 12, 155, 21);
		_labelStartDateValue.frame=CGRectMake(555, 12, 150, 21);
		_labelEndDate.frame=CGRectMake(380, 35, 155, 21);
		_labelEndDateValue.frame=CGRectMake(555, 35, 155, 21);
		lblcol1.frame=CGRectMake(175, 12,5, 21);
		lblcol2.frame=CGRectMake(540, 12,5, 21);
		lblcol3.frame=CGRectMake(175, 35, 115, 21);
		lblcol4.frame=CGRectMake(540, 35,5, 21);
		_imageDisclouser.frame=CGRectMake(690, 25, 20, 20);
		
		_labelStatus.frame = CGRectMake(20, 35, 160, 21);
		_labelTestName.frame =CGRectMake(20, 12, 160, 21);
	}
	else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight )
	{
		_labelTestNameValue.frame=CGRectMake(190, 12, 250, 21);
		_labelStartDate.frame=CGRectMake(620, 12, 155, 21);
		_labelStartDateValue.frame=CGRectMake(800, 12, 200, 21);
		_labelEndDate.frame=CGRectMake(620, 35, 155, 21);
		_labelEndDateValue.frame=CGRectMake(800, 35, 244, 21);
		_labelStatusValue.frame=CGRectMake(190, 35, 150, 21);
		lblcol1.frame=CGRectMake(175, 12,5, 21);
		lblcol2.frame=CGRectMake(780, 12,5, 21);
		lblcol3.frame=CGRectMake(175, 35, 115, 21);
		lblcol4.frame=CGRectMake(780, 35,5, 21);
		_imageDisclouser.frame=CGRectMake(948, 25, 20, 20);
		
		_labelStatus.frame = CGRectMake(20, 35, 160, 21);
		_labelTestName.frame =CGRectMake(20, 12, 160, 21);
	}
	
	
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
	[_labelTestName release]; _labelTestName = nil;
	[_labelTestNameValue release]; _labelTestNameValue= nil;
	[_labelStartDate release]; _labelStartDate=nil;
	[_labelStartDateValue release]; _labelStartDateValue = nil;
	[_labelEndDate release]; _labelEndDate = nil;
	[_labelEndDateValue release]; _labelEndDateValue = nil;
	[_labelStatus release]; _labelStatus = nil;
	[_labelStatusValue release]; _labelStatusValue = nil;
	[_imageDisclouser release]; _imageDisclouser = nil;
	
	[lblcol1 release];
	[lblcol2 release];
	[lblcol3 release];
	[lblcol4 release];
    [super dealloc];
}


@end
