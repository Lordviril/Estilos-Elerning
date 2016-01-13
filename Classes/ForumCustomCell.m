//
//  ForumCustomCell.m
//  eEducation
//
//  Created by hb12 on 07/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ForumCustomCell.h"


@implementation ForumCustomCell

@synthesize lblTopic,lblTopicValue,lblTotalComment,lblPostedBy,lblPostedDate,lblTotalCommentValue,lblPostedByValue,lblPostedDateValue;
@synthesize lblcol1,lblcol2,lblcol3,lblcol4,imgview;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
	if (self) 
	{
		lblTopic=[[UILabel alloc]initWithFrame:CGRectMake(20, 12, 115, 21)];
		lblTopic.backgroundColor=[UIColor clearColor];
		lblTopic.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
		[self.contentView addSubview:lblTopic];
		
		lblcol1=[[UILabel alloc]initWithFrame:CGRectMake(140, 12,5, 21)];
		lblcol1.backgroundColor=[UIColor clearColor];
		lblcol1.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
		lblcol1.text=@":";
		[self.contentView addSubview:lblcol1];
		
		lblTopicValue=[[UILabel alloc]initWithFrame:CGRectMake(155, 12, 190, 21)];
		lblTopicValue.numberOfLines=1;
		lblTopicValue.backgroundColor=[UIColor clearColor];
		lblTopicValue.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
		[self.contentView addSubview:lblTopicValue];
	
		
		lblTotalComment=[[UILabel alloc]initWithFrame:CGRectMake(375, 12, 130, 21)];
		lblTotalComment.backgroundColor=[UIColor clearColor];
		lblTotalComment.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
		[self.contentView addSubview:lblTotalComment];
		
		lblcol2=[[UILabel alloc]initWithFrame:CGRectMake(510, 12,5, 21)];
		lblcol2.backgroundColor=[UIColor clearColor];
		lblcol2.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
		lblcol2.text=@":";
		[self.contentView addSubview:lblcol2];
		
		lblTotalCommentValue=[[UILabel alloc]initWithFrame:CGRectMake(525, 12, 155, 21)];
		lblTotalCommentValue.backgroundColor=[UIColor clearColor];
		lblTotalCommentValue.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
		
		[self.contentView addSubview:lblTotalCommentValue];
		
		lblPostedBy=[[UILabel alloc]initWithFrame:CGRectMake(20, 35, 115, 21)];
		lblPostedBy.backgroundColor=[UIColor clearColor];
		lblPostedBy.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
		[self.contentView addSubview:lblPostedBy];
		
		lblcol3=[[UILabel alloc]initWithFrame:CGRectMake(140, 35,5, 21)];
		lblcol3.backgroundColor=[UIColor clearColor];
		lblcol3.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
		lblcol3.text=@":";
		[self.contentView addSubview:lblcol3];
		
		lblPostedByValue=[[UILabel alloc]initWithFrame:CGRectMake(155, 35, 150, 21)];
		lblPostedByValue.backgroundColor=[UIColor clearColor];
		lblPostedByValue.font=[UIFont fontWithName:@"ArialMT" size:15.0];
		[self.contentView addSubview:lblPostedByValue];
		
		lblPostedDate=[[UILabel alloc]initWithFrame:CGRectMake(375, 35, 130, 21)];
		lblPostedDate.backgroundColor=[UIColor clearColor];
		lblPostedDate.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
		[self.contentView addSubview:lblPostedDate];
		
		lblcol4=[[UILabel alloc]initWithFrame:CGRectMake(510, 35,5, 21)];
		lblcol4.backgroundColor=[UIColor clearColor];
		lblcol4.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
		lblcol4.text=@":";
		[self.contentView addSubview:lblcol4];
		
		lblPostedDateValue=[[UILabel alloc]initWithFrame:CGRectMake(525, 35, 155, 21)];
		lblPostedDateValue.backgroundColor=[UIColor clearColor];
		lblPostedDateValue.font=[UIFont fontWithName:@"ArialMT" size:15.0];
		[self.contentView addSubview:lblPostedDateValue];
		
		imgview=[[UIImageView alloc] initWithFrame:CGRectMake(690, 25, 20, 20)];
		imgview.image=[UIImage imageNamed:@"arrow.png"];
		[self.contentView addSubview:imgview];
		
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
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		lblTopicValue.frame=CGRectMake(155, 12, 190, 21);
		lblPostedByValue.frame=CGRectMake(155, 35, 150, 21);
		lblTotalComment.frame=CGRectMake(350, 12, 155, 21);
		lblTotalCommentValue.frame=CGRectMake(525, 12, 150, 21);
		lblPostedDate.frame=CGRectMake(350, 35, 155, 21);
		lblPostedDateValue.frame=CGRectMake(525, 35, 155, 21);
		lblcol1.frame=CGRectMake(140, 12,5, 21);
		lblcol2.frame=CGRectMake(510, 12,5, 21);
		lblcol3.frame=CGRectMake(140, 35, 115, 21);
		lblcol4.frame=CGRectMake(510, 35,5, 21);
		imgview.frame=CGRectMake(690, 25, 20, 20);
	}
	else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight )
	{
		lblTopicValue.frame=CGRectMake(155, 12, 420, 21);
		lblTotalComment.frame=CGRectMake(580, 12, 155, 21);
		lblTotalCommentValue.frame=CGRectMake(760, 12, 200, 21);
											  
		lblPostedDate.frame=CGRectMake(580, 35, 155, 21);
		lblPostedDateValue.frame=CGRectMake(760, 35, 344, 21);
		lblPostedByValue.frame=CGRectMake(155, 35, 150, 21);
		lblcol1.frame=CGRectMake(140, 12,5, 21);
		lblcol2.frame=CGRectMake(740, 12,5, 21);
		lblcol3.frame=CGRectMake(140, 35, 115, 21);
		lblcol4.frame=CGRectMake(740, 35,5, 21);
		imgview.frame=CGRectMake(948, 25, 20, 20);
	}
	
}
- (void)dealloc 
{
	[lblTopic release];
	[lblcol1 release];
	[lblTopicValue release];
	[lblTotalComment release];
	[lblcol2 release];
	[lblTotalCommentValue release];
	[lblPostedBy release];
	[lblcol3 release];
	[lblPostedByValue release];
	[lblPostedDate release];
	[lblcol4 release];
	[lblPostedDateValue release];
	[imgview release];
    [super dealloc];
}


@end
