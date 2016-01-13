    //
//  TestResults.m
//  eEducation
//
//  Created by Hidden Brains on 11/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestResults.h"
#import"TestResultCustomCell.h"
#import"Settings.h"
#import "ModuleHomePage.h"
#import "ModulesList.h"
#import "ICourseList.h"

@implementation TestResults
@synthesize timeDuration,starDate,endDate;
@synthesize arrayTestResult = _arrayTestResult;
@synthesize DicTest = _DicTest;

#pragma mark -
#pragma mark LoadView Method
- (void)viewDidLoad 
{
	[super viewDidLoad];
	appDelegate=(eEducationAppDelegate*)[[UIApplication sharedApplication]delegate];
	[tblView setBackgroundView:nil];
	[tblView setBackgroundView:[[[UIView alloc] init] autorelease]];	
	[tblView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[tblView setSeparatorColor:[UIColor clearColor]];
	[self jsonRequest];
}

-(void) viewWillAppear:(BOOL)animated
{   
	[self setlocalizedValues];
	self.navigationController.navigationBar.hidden=NO;
	[self.navigationItem setHidesBackButton:YES];
	[self.navigationController.navigationBar viewWithTag:BUTTON_HOME_TAG].hidden=NO;
	[(UILabel *)[self.navigationController.navigationBar viewWithTag:LABEL_TITLE_TAG] setText:[_DicTest objectForKey:@"test_name"]];
	[self willAnimateRotationToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0.2];
}
-(void) setlocalizedValues
{
	 lblendDate.text=[eEducationAppDelegate getLocalvalue:@"End Date"];
	 lblstartDate.text=[eEducationAppDelegate getLocalvalue:@"Start Date"];
	lblAchievMarks.text=[eEducationAppDelegate getLocalvalue:@"Marks Achieved"];
	 lblMarksPercent.text=[eEducationAppDelegate getLocalvalue:@"Your Score"];
	 lbltimeDuration.text=[eEducationAppDelegate getLocalvalue:@"Taken duration"];
	 totalMarks.text=[eEducationAppDelegate getLocalvalue:@"Total Marks"];
	[btnCourse setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"course_name"] forState:UIControlStateNormal];
	[btnModule setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"module_name"] forState:UIControlStateNormal];
	[btnTest setTitle:[eEducationAppDelegate getLocalvalue:@"Test"] forState:UIControlStateNormal];
	[tab1 setImage:[eEducationAppDelegate GetLocalImage:@"VirtualLibrary"] forState:0];
	[tab1 setImage:[eEducationAppDelegate GetLocalImage:@"VirtualLibrary_h"] forState:UIControlStateHighlighted];
	
	[tab2 setImage:[eEducationAppDelegate GetLocalImage:@"Forums"] forState:0];
	[tab2 setImage:[eEducationAppDelegate GetLocalImage:@"Forums_h"] forState:UIControlStateHighlighted];
	
	[tab3 setImage:[eEducationAppDelegate GetLocalImage:@"Alerts"] forState:0];
	[tab3 setImage:[eEducationAppDelegate GetLocalImage:@"Alerts_h"] forState:UIControlStateHighlighted];
	
	[tab4 setImage:[eEducationAppDelegate GetLocalImage:@"Calendar"] forState:0];
	[tab4 setImage:[eEducationAppDelegate GetLocalImage:@"Calendar_h"] forState:UIControlStateHighlighted];
	
	[tab5 setImage:[eEducationAppDelegate GetLocalImage:@"Messages"] forState:0];
	[tab5 setImage:[eEducationAppDelegate GetLocalImage:@"Messages_h"] forState:UIControlStateHighlighted];
	
	
	totalMarksValue.text = [_DicTest objectForKey:@"maxpunchuation"];
	NSDateFormatter *_dateFormatter=[[NSDateFormatter alloc] init];
    [_dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
	[_dateFormatter setDateFormat:@"MMM dd,yyyy"];
	[_dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
	NSDate *_tempstartDate=[_dateFormatter dateFromString:[_DicTest objectForKey:@"start_date"]];
	[_dateFormatter setDateFormat:@"dd-MM-YYYY"];
	lblstartDateValue.text=[_dateFormatter stringFromDate:_tempstartDate];
	
	lblAchievMarksValue.text = ([[_DicTest objectForKey:@"supunchuation"] isEqualToString:@"0.00"])?@"00":[_DicTest objectForKey:@"supunchuation"];
	
	[_dateFormatter setDateFormat:@"MMM dd,yyyy"];
	NSDate *_tempendtDate=[_dateFormatter dateFromString:[_DicTest objectForKey:@"end_date"]];
	[_dateFormatter setDateFormat:@"dd-MM-YYYY"];
	lblendDateValue.text=[_dateFormatter stringFromDate:_tempendtDate];
	NSString *user_score = [NSString stringWithFormat:@"%@",[_DicTest objectForKey:@"nota"]];
	[_dateFormatter release];
	//NSArray *ar = [user_score componentsSeparatedByString:@"/"];
	if ([user_score length]>0)
	{
		//int scored = ceil([[ar objectAtIndex:0] doubleValue]);
//		int fromMarks = ceil([[ar objectAtIndex:1] doubleValue]);
		lblMarksPercentValue.text =user_score; //[NSString stringWithFormat:@"%.2f%%", ((scored * 100.00) / fromMarks)];
	}
	else
	{
		lblMarksPercentValue.text = @"00";
	}
	lbltimeDurationValue.text = (![[_DicTest objectForKey:@"taken_duration"] isEqualToString:@"(null)"])?[_DicTest objectForKey:@"taken_duration"]:@"";
	
}

-(IBAction) TabarIndexSelected:(id)sender
{
//	UIButton *btn=sender;
//	int i=btn.tag/11;
//    appDelegate=(eEducationAppDelegate *)[[UIApplication sharedApplication] delegate];
//    [appDelegate setUpTabbarWithSelection:i];	
}

-(void)jsonRequest
{
	HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[HUD setLabelText:[eEducationAppDelegate getLocalvalue:@"Please wait"]];
	[HUD show:YES];
	objParser = [[JSONParser alloc] init];
	objParser.delegate = self;
	NSString *strURL = [WebService getpasttestdetailURL];
	
	NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:
								 [_DicTest objectForKey:@"test_id"], @"test_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"], @"user_id",
								 [_DicTest objectForKey:@"studentreport_id"], @"student_report_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language",
								 nil];
	[objParser sendRequestToParse:strURL params:requestData];
}

#pragma mark -
#pragma mark JSONParser delegate method

- (void)parserDidFinishLoadingReturnData:(NSString *)responseString
{
	[HUD hide:YES];
	SBJSON *json = [[SBJSON new] autorelease];	
	_arrayTestResult = [[NSMutableArray alloc] initWithArray:[json objectWithString:responseString error:nil]];
	if([_arrayTestResult count]>0&&[[[_arrayTestResult objectAtIndex:0] objectForKey:@"success"] isEqualToString:@"0"])
	{
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"No result available for this test"] delegate:self	 cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]  otherButtonTitles:nil];
		[alert show];
		alert.tag = TAG_NO_RECORD_FOUND;
		[alert release];
	}
	else
	{
		[tblView reloadData];
	}
}

- (void)parserDidFailWithRestoreError:(NSError*)error
{
	[HUD hide:YES];
	NSString *strMsg = [eEducationAppDelegate getLocalvalue:@"The server cannot be reached. It could be down or busy. Please try again later."];
	UIAlertView *AlertView =  [[UIAlertView alloc]  initWithTitle:alertTitle message:strMsg delegate:nil 	cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil, nil];
	AlertView.tag=TAG_FailError;
	[AlertView show];
	[AlertView release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if(alertView.tag==TAG_FailError)
	{
		if(buttonIndex==0)
		{
			[appDelegate GoTOLoginScreen:NO];
		}
	}
}

#pragma mark -
#pragma mark Action Method

-(IBAction)btnTest_Clicked:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnCourse_Clicked:(id)sender
{
	NSArray *viewContrlls=[[appDelegate navigationController] viewControllers];
	for( int i=0;i<[ viewContrlls count];i++)
	{
		id obj=[viewContrlls objectAtIndex:i];
		if([obj isKindOfClass:[ModulesList class]] )
		{
			[[appDelegate navigationController] popToViewController:obj animated:YES];
			return;
		}
	}
}
-(IBAction)btnModule_Clicked:(id)sender
{
	NSArray *viewContrlls=[[appDelegate navigationController] viewControllers];
	for( int i=0;i<[ viewContrlls count];i++)
	{
		id obj=[viewContrlls objectAtIndex:i];
		if([obj isKindOfClass:[ModuleHomePage class]] )
		{
			[[appDelegate navigationController] popToViewController:obj animated:YES];
			return;
		}
	}
}

#pragma mark -
#pragma mark tableView Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [_arrayTestResult count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"mycell";
	TestResultCustomCell *cell = (TestResultCustomCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) 
	{	
		cell=[[[TestResultCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}	
	UIImageView*imgview=[[UIImageView alloc]initWithFrame:CGRectMake(-28, 0, tableView.frame.size.width, 112)];
	imgview.image=[UIImage imageNamed:@"strip_s10C.png" ];
	cell.backgroundView = imgview;
	
	cell.backgroundColor=[UIColor clearColor];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	cell.lblScoretext.text=[eEducationAppDelegate getLocalvalue:@"Score :"];
	cell.lblAnswertext.text=[eEducationAppDelegate getLocalvalue:@"Your Answer: "];
	cell.lblCorrectAns.text=[eEducationAppDelegate getLocalvalue:@"Correct Answer: "];
	
	cell.lblQuestionNo.text=[NSString stringWithFormat:@"%i.",indexPath.section+1];
	cell.lblQuestion.text=[[_arrayTestResult objectAtIndex:indexPath.section] objectForKey:@"question"];
	if(![[[_arrayTestResult objectAtIndex:indexPath.section] objectForKey:@"correct_answer"] isKindOfClass:[NSNull class]])
	{
		if([[[_arrayTestResult objectAtIndex:indexPath.section] objectForKey:@"correct_answer"] isEqualToString:[[_arrayTestResult objectAtIndex:indexPath.section] objectForKey:@"user_answer"]])
		{
			cell.lblScore.text = [[_arrayTestResult objectAtIndex:indexPath.section] objectForKey:@"score"];
			if([self removeSpecialSymbils:[[_arrayTestResult objectAtIndex:indexPath.section] objectForKey:@"user_answer"]]){
				cell.lblAnswer.text = [self removeSpecialSymbils:[[_arrayTestResult objectAtIndex:indexPath.section] objectForKey:@"user_answer"]];
			}else{
				cell.lblAnswer.text=@"";
			}
			cell.lblCurrAnswer.text=[eEducationAppDelegate getLocalvalue:@"Correct Answer!"];
			
			[cell.lblCurrAnswer setTextColor:[UIColor colorWithRed:0/255.0 green:118/255.0 blue:8/255.0 alpha:1]];
			[cell.lblCorrectAns setHidden:YES];
			[cell.lblCorrectAnsValue setHidden:YES];
		}
		else
		{
			cell.lblScore.text = [[_arrayTestResult objectAtIndex:indexPath.section] objectForKey:@"score"];
			if(![[self removeSpecialSymbils:[[_arrayTestResult objectAtIndex:indexPath.section] objectForKey:@"user_answer"]] isEqualToString:@"(null)"]){
				cell.lblAnswer.text = [self removeSpecialSymbils:[[_arrayTestResult objectAtIndex:indexPath.section] objectForKey:@"user_answer"]]; 
			}else{
				cell.lblAnswer.text=@"";
			}
			cell.lblCurrAnswer.text=[eEducationAppDelegate getLocalvalue:@"Wrong Answer!"];
			cell.lblCorrectAnsValue.text = [self removeSpecialSymbils:[[_arrayTestResult objectAtIndex:indexPath.section] objectForKey:@"correct_answer"]];
			
			[cell.lblCurrAnswer setTextColor:[UIColor redColor]];
			[cell.lblCorrectAns setHidden:NO];
			[cell.lblCorrectAnsValue setHidden:NO];
		}
	}
	else 
	{
		cell.lblScore.text = @"00";
		cell.lblAnswer.text = [self removeSpecialSymbils:[[_arrayTestResult objectAtIndex:indexPath.section] objectForKey:@"user_answer"]];
		cell.lblCurrAnswer.text=[eEducationAppDelegate getLocalvalue:@"Wrong Answer!"];
		cell.lblCorrectAnsValue.text = [self removeSpecialSymbils:[[_arrayTestResult objectAtIndex:indexPath.section] objectForKey:@"correctanswers"]];
		
		[cell.lblCurrAnswer setTextColor:[UIColor redColor]];
		[cell.lblCorrectAns setHidden:NO];
		[cell.lblCorrectAnsValue setHidden:NO];
	}
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 107;
}

-(NSString *)removeSpecialSymbils:(NSString *)str_ans
{
	NSMutableArray *ary_ans = [[[NSMutableArray alloc] initWithArray:[str_ans componentsSeparatedByString:@","]] autorelease];
	for(int iCount = 0; iCount<[ary_ans count]; iCount++)
	{
		NSString *str = [ary_ans objectAtIndex:iCount];
		if([str rangeOfString:@"|||"].location!=NSNotFound)
		{
			str = [str substringFromIndex:([str rangeOfString:@"|||"].location+[str rangeOfString:@"|||"].length)];
		}
		else if([str rangeOfString:@"||"].location!=NSNotFound)
		{
			str = [str substringFromIndex:([str rangeOfString:@"||"].location+[str rangeOfString:@"||"].length)];
		}
		[ary_ans replaceObjectAtIndex:iCount withObject:str];
	}
	return [ary_ans componentsJoinedByString:@","];
}

#pragma mark -
#pragma mark orientation Life Cycle
-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown )
	{
		tab1.frame=CGRectMake(124, 911, 80, 49);
		tab2.frame=CGRectMake(234, 911, 80, 49);
		tab3.frame=CGRectMake(344, 911, 80, 49);
		tab4.frame=CGRectMake(454, 911, 80 ,49);
		tab5.frame=CGRectMake(564, 911, 80 ,49);		
		btnTest.frame=CGRectMake(467, 4, 149, 45);
		btnCourse.frame=CGRectMake(151, 4, 149, 45);
		btnModule.frame=CGRectMake(310, 4, 149, 45);
	}
	else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight )
	{
		tab1.frame=CGRectMake(252, 655, 80, 49);
		tab2.frame=CGRectMake(362, 655, 80, 49);
		tab3.frame=CGRectMake(472, 655, 80, 49);
		tab4.frame=CGRectMake(582, 655, 80 ,49);
		tab5.frame=CGRectMake(692, 655, 80,49);
		btnTest.frame=CGRectMake(626, 4, 149, 45);
		btnCourse.frame=CGRectMake(308, 4, 149, 45);
		btnModule.frame=CGRectMake(467, 4, 149, 45);
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	// Overriden to allow any orientation.
	return YES;
}

#pragma mark -
#pragma mark  UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag==TAG_NO_RECORD_FOUND)
	{
		[self.navigationController popViewControllerAnimated:YES];
	}
}

#pragma mark -
#pragma mark Memory Management Method

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
	[super viewDidUnload];
}

- (void)dealloc 
{
	[tblView release];tblView=nil;
	[totalMarks release];totalMarks=nil;
	[lblAchievMarks release];lblMarksPercent=nil;
	[lblMarksPercent release];lblMarksPercent=nil;
	[lbltimeDuration release];lbltimeDuration=nil;
	[lblstartDate release];lblstartDate=nil;
	[lblendDate release];lblendDate=nil;
	[totalMarksValue release];totalMarksValue=nil;
	[lblAchievMarksValue release];lblAchievMarksValue=nil;
	[lblMarksPercentValue release];lblMarksPercentValue=nil;
	[lbltimeDurationValue release];lbltimeDurationValue=nil;
	[lblstartDateValue release];lblstartDateValue=nil;
	[lblendDateValue release];lblendDateValue=nil;
	[btnTest release];btnTest=nil;
	[btnCourse release];btnCourse=nil;
	[btnModule release];btnModule=nil;
	[tab1 release];tab1=nil;
	[tab2 release];tab2=nil;
	[tab3 release];tab3=nil;
	[tab4 release];tab4=nil;
	[tab5 release];tab5=nil;
	[_arrayTestResult release];_arrayTestResult=nil;
	[_DicTest release]; _DicTest=nil;
	[super dealloc];
}

@end
