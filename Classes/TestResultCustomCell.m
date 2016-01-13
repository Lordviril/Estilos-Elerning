//
//  TestResultCustomCell.m
//  eEducation
//
//  Created by Hidden Brains on 11/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestResultCustomCell.h"


@implementation TestResultCustomCell
@synthesize lblQuestionNo,lblQuestion,lblScore,lblAnswer,lblCurrAnswer,lblScoretext;
@synthesize lblCorrectAns,lblCorrectAnsValue,lblAnswertext;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) 
	{		
		lblQuestionNo=[[UILabel alloc]initWithFrame:CGRectMake(15, 19, 30, 21)];
		lblQuestionNo.backgroundColor=[UIColor clearColor];
		lblQuestionNo.text=@"Armani Delux Room";
		lblQuestionNo.font=[UIFont fontWithName:@"ArialMT" size:13.0];
		[self.contentView addSubview:lblQuestionNo];
		
		lblQuestion=[[UILabel alloc]initWithFrame:CGRectMake(32, 19, 530, 21)];
		lblQuestion.backgroundColor=[UIColor clearColor];
		lblQuestion.text=@"Armani Delux Room";
		lblQuestion.font=[UIFont fontWithName:@"ArialMT" size:14.0];
		[self.contentView addSubview:lblQuestion];
		
		lblScore=[[UILabel alloc]initWithFrame:CGRectMake(660, 19, 35, 21)];
		lblScore.backgroundColor=[UIColor clearColor];
		lblScore.font=[UIFont fontWithName:@"ArialMT" size:14.0];
		[lblScore setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
		[lblScore setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
		[self.contentView addSubview:lblScore];
		
		lblScoretext=[[UILabel alloc]initWithFrame:CGRectMake(505, 19, 150, 21)];
		lblScoretext.backgroundColor=[UIColor clearColor];
		lblScoretext.textAlignment=UITextAlignmentRight;
		lblScoretext.text=[eEducationAppDelegate getLocalvalue:@"Score :"];
		lblScoretext.font=[UIFont fontWithName:@"ArialMT" size:14.0];
		
		[self.contentView addSubview:lblScoretext];
		
		lblAnswertext=[[UILabel alloc]initWithFrame:CGRectMake(35, 38, 200, 21)];
		lblAnswertext.backgroundColor=[UIColor clearColor];
		lblAnswertext.text=[eEducationAppDelegate getLocalvalue:@"Your Answer: "];
		lblAnswertext.font=[UIFont fontWithName:@"Arial-BoldMT" size:14.0];
		[self.contentView addSubview:lblAnswertext];
		
		lblAnswer=[[UILabel alloc]initWithFrame:CGRectMake(135, 38, 470, 21)];
		lblAnswer.backgroundColor=[UIColor clearColor];
		lblAnswer.text=@"Armani Delux Room";
		lblAnswer.font=[UIFont fontWithName:@"ArialMT" size:14.0];
		[self.contentView addSubview:lblAnswer];
				
		lblCurrAnswer=[[UILabel alloc]initWithFrame:CGRectMake(32, 58, 250, 21)];
		lblCurrAnswer.backgroundColor=[UIColor clearColor];
		lblCurrAnswer.textColor=[UIColor colorWithRed:0/255.0 green:118/255.0 blue:8/255.0 alpha:1];
		lblCurrAnswer.text=[eEducationAppDelegate getLocalvalue:@"Correct Answer!"];
		lblCurrAnswer.font=[UIFont fontWithName:@"ArialMT" size:14.0];
		[self.contentView addSubview:lblCurrAnswer];
		
		lblCorrectAns=[[UILabel alloc]initWithFrame:CGRectMake(32, 76, 255, 21)];
		lblCorrectAns.backgroundColor=[UIColor clearColor];
		lblCorrectAns.text=[eEducationAppDelegate getLocalvalue:@"Correct Answer: "];
		lblCorrectAns.font=[UIFont fontWithName:@"Arial-BoldMT" size:14.0];
		lblCorrectAns.hidden=TRUE;
		[self.contentView addSubview:lblCorrectAns];
		
		lblCorrectAnsValue=[[UILabel alloc]initWithFrame:CGRectMake(180, 77, 470, 21)];
		lblCorrectAnsValue.backgroundColor=[UIColor clearColor];
		lblCorrectAnsValue.textColor=[UIColor colorWithRed:0/255.0 green:118/255.0 blue:8/255.0 alpha:1];
		lblCorrectAnsValue.font=[UIFont fontWithName:@"ArialMT" size:14.0];
		lblCorrectAnsValue.hidden=TRUE;
		[self.contentView addSubview:lblCorrectAnsValue];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
	[super setSelected:selected animated:animated];
}

- (void)layoutSubviews 
{	
	[super layoutSubviews];
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		lblQuestion.frame=CGRectMake(32, 19, 540, 21);
		lblAnswer.frame = CGRectMake(135, 38, 500, 21);
		lblScoretext.frame = CGRectMake(585, 19, 90, 21);
		lblScore.frame =CGRectMake(680, 20, 50, 21);
		lblCorrectAnsValue.frame=CGRectMake(180, 77, 503, 21);
	}
	else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight )
	{
		lblQuestion.frame=CGRectMake(32, 19, 790, 21);
		lblAnswer.frame = CGRectMake(135, 38, 750, 21);
		lblScoretext.frame=CGRectMake(835, 19, 90, 21);
		lblScore.frame=CGRectMake(930, 20, 50, 21);
		lblCorrectAnsValue.frame=CGRectMake(180, 77, 752, 21);
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	// Overriden to allow any orientation.
	return YES;
}

- (void)dealloc 
{
	[super dealloc];
}


@end
