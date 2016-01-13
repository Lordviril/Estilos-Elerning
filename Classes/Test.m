    //
//  Test.m
//  eEducation
//
//  Created by HB 13 on 20/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


//
//  Test.m
//  eEducation
//
//  Created by HB 13 on 20/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Test.h"
#import "ModuleHomePage.h"
#import "ModulesList.h"
#import "ICourseList.h"
#import "DownloadedDocument.h"
#import "AttemptToTest.h"
#import <QuartzCore/QuartzCore.h>
#import "TestDetail.h"
#define TAG_TIME_COMPLETED 66

@implementation Test
@synthesize arrayQuestions = _arrayQuestions;
@synthesize labelQuestionType = _labelQuestionType;
@synthesize buttonSubmit = _buttonSubmit;
@synthesize imageQuestionbackground = _imageQuestionbackground;
@synthesize timeExamDuration = _timeExamDuration;
@synthesize test_id;
@synthesize labelElapsedTime = _labelElapsedTime;
@synthesize labelQuestionHead = _labelQuestionHead;
@synthesize givenTestDuration;
@synthesize buttomCourse = _buttomCourse;
@synthesize buttonModule = _buttonModule;
@synthesize buttonTest = _buttonTest;
@synthesize DicTest = _DicTest;

#pragma mark -
#pragma mark LoadView Method
- (void)viewDidLoad 
{
	[super viewDidLoad];
	objMyVariables = [myVariables sharedInstance];
	test_id = [[_DicTest objectForKey:@"test_id"] intValue];
	if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isNetworkAvailble"]){
		edition_id =[[_DicTest objectForKey:@"editonid"] intValue]; 
	}
	appDelegate=(eEducationAppDelegate*)[[UIApplication sharedApplication]delegate];
	appDelegate.delegate=self;
	[_buttonTest setTitle:[_DicTest objectForKey:@"test_name"] forState:UIControlStateNormal];
	givenTestDuration =0.0;
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"isNetworkAvailble"])
	{
		if([DataBase getCountOfQuestionDetail:test_id edition_id:[[[NSUserDefaults standardUserDefaults] objectForKey:@"editonid"] intValue]]){
			_arrayQuestions = [[NSMutableArray alloc] initWithArray:[DataBase readQuestionsForTestId:test_id _bool:FALSE vUploaded:0 edition_id:[[[NSUserDefaults standardUserDefaults] objectForKey:@"editonid"] intValue]]];
			[self.view addSubview:testView];
			[self hideAndShow:NO];
			questionNo = 0;
			[self refreshView:questionNo];
			[self currenttime];
		}else{	
			[self jsonRequestForQuestions];
		}
	}
	else 
	{
		[tab1 setHidden:YES];[tab2 setHidden:YES];[tab3 setHidden:YES];[tab4 setHidden:YES];[tab5 setHidden:YES];
		_arrayQuestions = [[NSMutableArray alloc] initWithArray:[DataBase readQuestionsForTestId:test_id _bool:FALSE vUploaded:1 edition_id:edition_id]];
		if ([_arrayQuestions count] > 0)
		{
			[self.view addSubview:testView];
			[self hideAndShow:NO];
			questionNo = 0;
			[self refreshView:questionNo];
			[self currenttime];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"No question available for this test"] delegate:self 
												  cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]  otherButtonTitles:nil];
			[alert show];
			alert.tag = TAG_NO_RECORD_FOUND;
			[alert release];
		}
	}
	[btnNext setImage:[eEducationAppDelegate GetLocalImage:@"btn_next"] forState:UIControlStateNormal];
	[btnNext setImage:[eEducationAppDelegate GetLocalImage:@"btn_next_h"] forState:UIControlStateHighlighted];
	[bntBack setImage:[eEducationAppDelegate GetLocalImage:@"btn_back"] forState:UIControlStateNormal];
	[bntBack setImage:[eEducationAppDelegate GetLocalImage:@"btn_back_h"] forState:UIControlStateHighlighted];
	[_buttonSubmit setImage:[eEducationAppDelegate GetLocalImage:@"submit"] forState:UIControlStateNormal];
	[_buttonSubmit setImage:[eEducationAppDelegate GetLocalImage:@"submit_h"] forState:UIControlStateHighlighted];
	[_buttonSave setImage:[eEducationAppDelegate GetLocalImage:@"btn_save"] forState:UIControlStateNormal];
	[_buttonSave setImage:[eEducationAppDelegate GetLocalImage:@"btn_save_h"] forState:UIControlStateHighlighted];
}

-(void)viewWillAppear:(BOOL)animated
{ 
	[self setLocalizedStrings];
	if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isNetworkAvailble"]){
		[tab1 setHidden:YES];
		[tab2 setHidden:YES];
		[tab3 setHidden:YES];
		[tab4 setHidden:YES];
		[tab5 setHidden:YES];
	}else{
		[tab1 setHidden:NO];
		[tab2 setHidden:NO];
		[tab3 setHidden:NO];
		[tab4 setHidden:NO];
		[tab5 setHidden:NO];
		
	}
	if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isNetworkAvailble"]){
		[_buttomCourse setTitle:[_DicTest objectForKey:@"course_name"] forState:UIControlStateNormal];
		[_buttonModule setTitle:[_DicTest objectForKey:@"module_name"] forState:UIControlStateNormal];
	}else{
		[_buttomCourse setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"course_name"] forState:UIControlStateNormal];
		[_buttonModule setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"module_name"] forState:UIControlStateNormal];
	}
	
	
	self.navigationController.navigationBar.hidden=NO;
	[self.navigationItem setHidesBackButton:YES];
	[self.navigationController.navigationBar viewWithTag:BUTTON_HOME_TAG].hidden=NO;
	[(UILabel *)[self.navigationController.navigationBar viewWithTag:LABEL_TITLE_TAG] setText:[eEducationAppDelegate getLocalvalue:@" "]];
	[self willAnimateRotationToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0.2];
}

-(void)viewWillDisappear:(BOOL)animated
{
	if(timer)
	{
		[timer invalidate];
		timer=nil;
	}
}

-(void)setLocalizedStrings
{
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
	_labelQuestionHead.text = [eEducationAppDelegate getLocalvalue:@"Question"];
	_labelElapsedTime.text = [eEducationAppDelegate getLocalvalue:@"Elapsed Time :"];
}

-(void)jsonRequestForQuestions
{
	test_id = [[_DicTest objectForKey:@"test_id"] intValue];
	[self hideAndShow:YES];
	HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[HUD setLabelText:[eEducationAppDelegate getLocalvalue:@"Please wait"]];
	[HUD show:YES];
	objParser = [[JSONParser alloc] init];
	objParser.delegate = self;
	NSString *strURL =[WebService getdownloadexamURL];
	NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] ,@"user_id",
								 [NSString stringWithFormat:@"%i",test_id], @"test_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language", nil];	
	[objParser sendRequestToParse:strURL params:requestData];
}

-(void)jsonRequestForPostAnswers
{
	HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[HUD setLabelText:[eEducationAppDelegate getLocalvalue:@"Please wait"]];
	[HUD show:YES];
	objParser = [[JSONParser alloc] init];
	objParser.delegate = self;
	questionDetail *objquestionDetail=[[[questionDetail alloc] init] autorelease];
	objquestionDetail.delegate=self;
	objquestionDetail.test_id=test_id;
	objquestionDetail.arrayQuestions=_arrayQuestions;
	objquestionDetail.dictTestDetail=_DicTest;
	NSString *remainingattempt = [NSString stringWithFormat:@"%d", ([[_DicTest valueForKey:@"totattempt"] intValue] - [[_DicTest valueForKey:@"attemptedcnt"] intValue]) - 1];
	objquestionDetail.remainingattempt = remainingattempt;
	[objquestionDetail SubmitAnswer];
}

#pragma mark -
#pragma mark Questions Display Method

-(void) refreshView:(int)QuestionNumber
{
	if(QuestionNumber<[_arrayQuestions count])
	{		
		NSMutableDictionary *dic_temp = [[NSMutableDictionary alloc] initWithDictionary:[_arrayQuestions objectAtIndex:QuestionNumber]];
		[self noOfOptions:[dic_temp objectForKey:@"options"]];
		NSArray *array_answers = [[NSArray alloc] initWithArray:[[[_arrayQuestions objectAtIndex:QuestionNumber] objectForKey:@"Answer"] componentsSeparatedByString:@"@@"]];
		if([array_answers count]>0)
		{
			for(int iCount = 0; iCount < [array_answers count]; iCount++)
			{
				NSString *strAns = [array_answers objectAtIndex:iCount];
				NSArray *arOptionsID = [[dic_temp objectForKey:@"optionsid"] componentsSeparatedByString:@","];
				NSString *strObj = [[strAns componentsSeparatedByString:@"||"] objectAtIndex:0];
				for (int i = 0; i <[arOptionsID count]; i++)
				{
					NSString *strTemp = [[NSString stringWithFormat:@"%@", [arOptionsID objectAtIndex:i]] stringByReplacingOccurrencesOfString:@"," withString:@""];
					if ([strTemp isEqualToString:strObj])
					{
						[self tickAnswer:i];
						break;
					}
				}				
			}			
		}
		[array_answers release];
		array_answers=nil;
		lblQuestionNo.text = [NSString stringWithFormat:@"%i",QuestionNumber+1];
		lblQuestion.text = [dic_temp objectForKey:@"question"];
		NSString *_localString = [[[eEducationAppDelegate getLocalvalue:[[dic_temp objectForKey:@"question_type"] capitalizedString]]stringByAppendingString:@" "] stringByAppendingString:[eEducationAppDelegate getLocalvalue:@"Selection"]];
		if ([[[dic_temp objectForKey:@"question_type"] capitalizedString]isEqualToString:@"Single"])
		{
			NSString *strNew = [[[[dic_temp objectForKey:@"question_type"] capitalizedString]stringByAppendingString:@" "] stringByAppendingString:@"Selection"];
			_localString = [eEducationAppDelegate getLocalvalue:strNew];
		}
		_labelQuestionType.text = [NSString stringWithFormat:@"(%@)",_localString];
		[dic_temp release];
		dic_temp = nil;
	}
	[self updateNextAndPrevious];
}

-(void)tickAnswer:(int)tick
{
	for (UIButton *btnTemp in scrView.subviews)
	{
		if ([btnTemp isKindOfClass:[UIButton class]] && btnTemp.tag == tick)
		{
			btnTemp.selected = TRUE;
			[btnTemp setImage:[UIImage imageNamed:@"check-in.png"] forState:UIControlStateNormal];
			break;
		}
	}
}

-(void)noOfOptions:(NSString *)dicText
{	
	for (UIView *vwTemp in scrView.subviews)
	{
		[vwTemp removeFromSuperview];
	}
	NSArray *arCount = [dicText componentsSeparatedByString:@"@@"];
	UIButton *btnOption;
	UILabel *lblOption;	
	float btnX = 20;
	float btnY = 17;
	float lblX = 43;
	float lblY = 9;
	float latestHeight = 0;
	
	BOOL newLine = FALSE;
	int rowCounter = 0;
	int curCounter = 0;
	float prevY = 0;
	for (int i =0; i < [arCount count]; i++)
	{		
		if (curCounter % 2 == 0)
		{
			rowCounter++;
			newLine = TRUE;
		}
		else
		{
			newLine = FALSE;
		}
		btnOption = [UIButton buttonWithType:UIButtonTypeCustom];
		[btnOption setImage:[UIImage imageNamed:@"check-out.png"] forState:UIControlStateNormal];
		[btnOption setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
		[btnOption setTag:i];
		[btnOption addTarget:self action:@selector(btnOptions_Clicked:) forControlEvents:UIControlEventTouchUpInside];
		[scrView addSubview:btnOption];
		
		lblOption = [[UILabel alloc] init];
		lblOption.text = [[dicText componentsSeparatedByString:@"@@"] objectAtIndex:i];
		lblOption.font = [UIFont fontWithName:@"Arial" size:14.0];
		lblOption.backgroundColor = [UIColor clearColor];
		[scrView addSubview:lblOption];
		[lblOption release];
		if (i == 0)
		{	//A
			if (currentOrientation == UIInterfaceOrientationLandscapeLeft || currentOrientation == UIInterfaceOrientationLandscapeRight)
			{
				btnOption.frame = CGRectMake(btnX, btnY, 139, 25);
				lblOption.frame = CGRectMake(lblX, lblY, 450, 41);
			}
			else 
			{
				btnOption.frame = CGRectMake(btnX, btnY, 139, 25);
				lblOption.frame = CGRectMake(lblX, lblY, 316, 41);
			}
			latestHeight = latestHeight + lblY;
		}
		else
		{
			if (i % 2 == 0)
			{
				float newY = 0;
				if (newLine)
				{
					newY = btnY + (((i - rowCounter) + 1 )* 50);
					prevY = newY;
				}
				else 
				{
					newY = prevY;
				}
				if (currentOrientation == UIInterfaceOrientationLandscapeLeft || currentOrientation == UIInterfaceOrientationLandscapeRight)
				{
					btnOption.frame = CGRectMake(btnX, newY, 139, 25);
					lblOption.frame = CGRectMake(lblX, newY - 7, 450, 41);
				}
				else 
				{
					btnOption.frame = CGRectMake(btnX, newY, 139, 25);
					lblOption.frame = CGRectMake(lblX, newY - 7, 316, 41);
				}
				latestHeight = newY;
			}
			else 
			{
				if (i == 1)
				{	//B
					if (currentOrientation == UIInterfaceOrientationLandscapeLeft || currentOrientation == UIInterfaceOrientationLandscapeRight)
					{
						btnOption.frame = CGRectMake(btnX + 480, btnY, 139, 25);			
						lblOption.frame = CGRectMake(lblX + 480, lblY, 445, 41);
					}
					else 
					{
						btnOption.frame = CGRectMake(btnX + 347, btnY, 139, 25);			
						lblOption.frame = CGRectMake(lblX + 350, lblY, 316, 41);
					}
				}
				else 
				{	// D
					float newY = 0;
					if (newLine)
					{
						newY = btnY + ((i - rowCounter)* 50);
						prevY = newY;
					}
					else 
					{
						if (prevY != 0)
						{
							newY = prevY;
						}
						else
						{
							newY = btnY + ((i - 2)* 50);
							prevY = newY;
						}
					}
					if (currentOrientation == UIInterfaceOrientationLandscapeLeft || currentOrientation == UIInterfaceOrientationLandscapeRight)
					{
						btnOption.frame = CGRectMake(btnX + 480, newY, 139, 25);			
						lblOption.frame = CGRectMake(lblX + 480, newY - 7, 445, 41);
					}
					else 
					{
						btnOption.frame = CGRectMake(btnX + 345, newY, 139, 25);			
						lblOption.frame = CGRectMake(lblX + 350, newY - 5, 316, 41);
					}
					latestHeight = newY;
				}
			}
		}
		curCounter++;
	}
	_imageQuestionbackground.frame = CGRectMake(_imageQuestionbackground.frame.origin.x, _imageQuestionbackground.frame.origin.y, _imageQuestionbackground.frame.size.width, latestHeight + 20.0);
	if (currentOrientation == UIInterfaceOrientationLandscapeRight || currentOrientation == UIInterfaceOrientationLandscapeLeft)
	{	
		if (latestHeight + 30 < 150)
		{
			
			testView.frame=CGRectMake(0, 58, 1024, latestHeight + 350.0);
		}
		else 
		{
			testView.frame=CGRectMake(0, 58, 1024, 600.0);
		}
		if (_imageQuestionbackground.frame.size.height > 300.0)
		{
			_imageQuestionbackground.frame = CGRectMake(_imageQuestionbackground.frame.origin.x, _imageQuestionbackground.frame.origin.y, 980, 450.0);
			scrView.frame = CGRectMake(24.0, 158.0, 972.0, 300.0);
			scrView.scrollEnabled = TRUE;
		}
		else 
		{
			_imageQuestionbackground.frame = CGRectMake(_imageQuestionbackground.frame.origin.x, _imageQuestionbackground.frame.origin.y, 980, latestHeight + 190.0);
			scrView.frame = CGRectMake(24.0, 158.0, 970.0, latestHeight + 40.0);
			scrView.scrollEnabled = FALSE;
		}		
	}
	else 
	{
		if (latestHeight + 30 > 1024)
		{
			testView.frame=CGRectMake(0, 58, 768, 1024);
		}
		else 
		{
			testView.frame=CGRectMake(0, 58, 768, latestHeight + 350.0);
		}
		if (_imageQuestionbackground.frame.size.height > 700)
		{
			_imageQuestionbackground.frame = CGRectMake(_imageQuestionbackground.frame.origin.x, _imageQuestionbackground.frame.origin.y, _imageQuestionbackground.frame.size.width, 700.0);
			scrView.frame = CGRectMake(22, 158, 724, 550.0);
			scrView.scrollEnabled = TRUE;
		}
		else 
		{
			_imageQuestionbackground.frame = CGRectMake(_imageQuestionbackground.frame.origin.x, _imageQuestionbackground.frame.origin.y, _imageQuestionbackground.frame.size.width, latestHeight + 190.0);
			scrView.frame = CGRectMake(22, 158, 724, latestHeight + 40.0);
			scrView.scrollEnabled = FALSE;
		}
	}
	scrView.contentSize = CGSizeMake(scrView.frame.size.width, latestHeight + 50.0);
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = _imageQuestionbackground.bounds;
	gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor lightGrayColor] CGColor], nil];
	[_imageQuestionbackground.layer insertSublayer:gradient atIndex:0];
	
	CALayer *c = [_imageQuestionbackground layer];
	[c setCornerRadius:10.0];
	[c setBorderColor:[[UIColor blackColor] CGColor]];
	[c setBorderWidth:3.0];
	[c setMasksToBounds:YES];
	bntBack.frame = CGRectMake(bntBack.frame.origin.x, _imageQuestionbackground.frame.size.height + 35, 107, 45);
	btnNext.frame = CGRectMake(btnNext.frame.origin.x, _imageQuestionbackground.frame.size.height + 35, 107, 44);
	_buttonSubmit.frame = CGRectMake(_buttonSubmit.frame.origin.x, _imageQuestionbackground.frame.size.height + 90, 109, 45);
	_buttonSave.frame = CGRectMake(_buttonSave.frame.origin.x, _imageQuestionbackground.frame.size.height + 90, 107, 45);
}

-(void)getAnswersListForCurrentQuestions:(int)questionNum
{
	NSMutableDictionary *dic_temp = [[NSMutableDictionary alloc] initWithDictionary:[_arrayQuestions objectAtIndex:questionNum]];
	NSString *str_answers = @"";
	NSString *strID = @"";
	int counter = 0;
	for (UIView *vwTemp in scrView.subviews)
	{
		if ([vwTemp isKindOfClass:[UIButton class]])
		{
			UIButton *btnTemp = (UIButton*) vwTemp;
			if (btnTemp.selected)
			{	
				if (counter == 0)
				{
					strID = @"";
					str_answers = [str_answers length]?[str_answers stringByAppendingFormat:@",%@",[[[dic_temp objectForKey:@"options"] componentsSeparatedByString:@"@@"] objectAtIndex:btnTemp.tag]]:[str_answers stringByAppendingFormat:@"%@",[[[dic_temp objectForKey:@"options"] componentsSeparatedByString:@"@@"] objectAtIndex:btnTemp.tag]];
					strID = [strID length] ? [strID stringByAppendingFormat:@",%@",[[[dic_temp objectForKey:@"optionsid"] componentsSeparatedByString:@","] objectAtIndex:btnTemp.tag]]:[strID stringByAppendingFormat:@"%@",[[[dic_temp objectForKey:@"optionsid"] componentsSeparatedByString:@","] objectAtIndex:btnTemp.tag]];
					str_answers = [strID stringByAppendingFormat:@"||%@", str_answers];					
				}
				else 
				{
					strID = @"";
					strID = [str_answers length]?[strID stringByAppendingFormat:@"@@%@",[[[dic_temp objectForKey:@"optionsid"] componentsSeparatedByString:@","] objectAtIndex:btnTemp.tag]]:[strID stringByAppendingFormat:@"%@",[[[dic_temp objectForKey:@"optionsid"] componentsSeparatedByString:@","] objectAtIndex:btnTemp.tag]];
					str_answers = [str_answers stringByAppendingFormat:@"%@||",strID];
					str_answers = [str_answers length]?[str_answers stringByAppendingFormat:@"%@",[[[dic_temp objectForKey:@"options"] componentsSeparatedByString:@"@@"] objectAtIndex:btnTemp.tag]]:[str_answers stringByAppendingFormat:@"%@",[[[dic_temp objectForKey:@"options"] componentsSeparatedByString:@"@@"] objectAtIndex:btnTemp.tag]];					
				}
				counter++;
			}
		}		
	}	
	[dic_temp setObject:str_answers forKey:@"Answer"];
	[_arrayQuestions replaceObjectAtIndex:questionNum withObject:dic_temp];
	[dic_temp release];dic_temp=nil;
}

-(void)updateNextAndPrevious
{
	bntBack.enabled = (questionNo > 0);
	btnNext.enabled = (questionNo < _arrayQuestions.count-1);
}

-(void)hideAndShow:(BOOL)yesOrNo
{
	lblQuestion.hidden = yesOrNo;
	lblQuestionNo.hidden = yesOrNo;
	lblQuestion.hidden = yesOrNo;
	btnNext.hidden = yesOrNo;
	bntBack.hidden = yesOrNo;
	_buttonSubmit.hidden = yesOrNo;
	_labelElapsedTime.hidden = yesOrNo;
	_labelQuestionType.hidden = yesOrNo;
	_imageQuestionbackground.hidden = yesOrNo;
	lblTime.hidden = yesOrNo;
}

- (void)updateTimer
{
	NSDate *currentDate = [NSDate date];
	NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:startDt];
	NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
	[dateFormatter setDateFormat:@"HH:mm:ss"];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
	NSString *timeString=[dateFormatter stringFromDate:timerDate];
	lblTime.text = timeString;
	[dateFormatter release];
}

-(void)currenttime
{
	startDt = [[NSDate date]retain];
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

#pragma mark -
#pragma mark Button Action Method

-(IBAction)btnNext_Clicked:(id)sender
{
	[self getAnswersListForCurrentQuestions:questionNo];
	questionNo=questionNo+1;
	questionNo = (questionNo>[_arrayQuestions count])?[_arrayQuestions count]:questionNo;
	[self refreshView:questionNo];
}

-(IBAction)btnBack_Clicked:(id)sender
{
	[self getAnswersListForCurrentQuestions:questionNo];	
	questionNo=questionNo-1;
	questionNo = (questionNo<0)?0:questionNo;
	[self refreshView:questionNo];
}

-(IBAction)btnOptions_Clicked:(id)sender
{
	UIButton *btnCurrent = (UIButton*) sender;
	if([[[_arrayQuestions objectAtIndex:questionNo] objectForKey:@"question_type"] isEqualToString:@"single"])
	{
		for (UIView *vwTemp in scrView.subviews)
		{
			if ([vwTemp isKindOfClass:[UIButton class]])
			{		
				UIButton *btnTemp = (UIButton*) vwTemp;
				if ([btnTemp isEqual:btnCurrent])
				{					
					if (btnTemp.selected)
					{				
						[btnTemp setImage:[UIImage imageNamed:@"check-out.png"] forState:UIControlStateNormal];
						btnTemp.selected = FALSE;
					}
					else 
					{
						[btnTemp setImage:[UIImage imageNamed:@"check-in.png"] forState:UIControlStateNormal];
						btnTemp.selected = TRUE;
					}
				}
				else 
				{
					[btnTemp setImage:[UIImage imageNamed:@"check-out.png"] forState:UIControlStateNormal];
					btnTemp.selected=FALSE;
				}
			}
		}
	}
	else 
	{
		for (UIView *vwTemp in scrView.subviews)
		{
			if ([vwTemp isKindOfClass:[UIButton class]])
			{		
				UIButton *btnTemp = (UIButton*) vwTemp;
				if ([btnTemp isEqual:btnCurrent])
				{					
					if (btnTemp.selected)
					{
						[btnTemp setImage:[UIImage imageNamed:@"check-out.png"] forState:UIControlStateNormal];
						btnTemp.selected = NO;
						
					}
					else 
					{
						[btnTemp setImage:[UIImage imageNamed:@"check-in.png"] forState:UIControlStateNormal];
						btnTemp.selected = YES;
					}
				}
			}
		}
	}
}

-(IBAction)btnTest_Clicked:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnCourse_Clicked:(id)sender
{
	
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"isNetworkAvailble"])
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
	else
	{
		NSArray *ary_navigationControllerViews = [[NSArray alloc] initWithArray:[appDelegate.navigationController viewControllers]];
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.class.description == %@", [[DownloadedDocument class] description]];
		NSArray *ary_viewController = [[NSArray alloc] initWithArray:[ary_navigationControllerViews filteredArrayUsingPredicate:predicate]];
		[ary_navigationControllerViews release];ary_navigationControllerViews=nil;
		if ([ary_viewController count] > 0) 
		{
			[self.navigationController popToViewController:[ary_viewController objectAtIndex:0] animated:YES];
			[ary_viewController release];ary_viewController=nil;
			return;
		}
		[ary_viewController release];ary_viewController=nil;
	}
}
-(IBAction)btnModule_Clicked:(id)sender
{
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"isNetworkAvailble"])
	{
		NSArray *viewContrlls=[[appDelegate navigationController] viewControllers];
		for( int i=0;i<[ viewContrlls count];i++)
		{
			id obj=[viewContrlls objectAtIndex:i];
			if([obj isKindOfClass:[ModuleHomePage class]])
			{
				[[appDelegate navigationController] popToViewController:obj animated:YES];
				return;
			}
		}
	}
	else
	{
		NSArray *ary_navigationControllerViews = [[NSArray alloc] initWithArray:[appDelegate.navigationController viewControllers]];
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.class.description == %@", [[DownloadedDocument class] description]];
		NSArray *ary_viewController = [[NSArray alloc] initWithArray:[ary_navigationControllerViews filteredArrayUsingPredicate:predicate]];
		[ary_navigationControllerViews release];ary_navigationControllerViews=nil;
		if ([ary_viewController count] > 0) 
		{
			[self.navigationController popToViewController:[ary_viewController objectAtIndex:0] animated:YES];
			[ary_viewController release];ary_viewController=nil;
			return;
		}
		[ary_viewController release];
	}
}
-(IBAction)btnSubmit_Clicked:(id)sender
{
	if(timer)
	{
		[timer invalidate];
		timer = nil;
	}
	[[NSUserDefaults standardUserDefaults] setObject:lblTime.text forKey:@"TimeDuration"];
	[self getAnswersListForCurrentQuestions:questionNo];
	if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isNetworkAvailble"])
	{
		for(int iCount = 0;iCount<[_arrayQuestions count];iCount++)
		{
			if([[_arrayQuestions objectAtIndex:iCount] objectForKey:@"Answer"])
			{
				[DataBase addAnswerWithQuestionIdAndTestId:[[[_arrayQuestions objectAtIndex:iCount] objectForKey:@"question_id"] intValue] 
													TestId:test_id answer:[[_arrayQuestions objectAtIndex:iCount ] objectForKey:@"Answer"] upload:0 edition_id:edition_id];
			}
		}
		objMyVariables.doAnswersPosted = FALSE;
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"Submitted data will be stored in database,it will be automatically resend when network is available."] delegate:self	 cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]  otherButtonTitles:nil];
		[alert show];
		alert.tag = TAG_TIME_COMPLETED;
		[alert release];
	}
	else 
	{
		[self jsonRequestForPostAnswers];
	}
}
#pragma mark -
#pragma mark orientation Life Cycle
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{	
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		tab1.frame=CGRectMake(124, 911, 80, 49);
		tab2.frame=CGRectMake(234, 911, 80, 49);
		tab3.frame=CGRectMake(344, 911, 80, 49);
		tab4.frame=CGRectMake(454, 911, 80 ,49);
		tab5.frame=CGRectMake(564, 911, 80 ,49);
		_buttonTest.frame=CGRectMake(457, 4, 149, 45);
		_buttomCourse.frame=CGRectMake(141, 4, 149, 45);
		_buttonModule.frame=CGRectMake(300, 4, 149, 45);
		testView.frame=CGRectMake(0, 58, 768, 400);
	}
	else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
	{
		tab1.frame=CGRectMake(252, 655, 80, 49);
		tab2.frame=CGRectMake(362, 655, 80, 49);
		tab3.frame=CGRectMake(472, 655, 80, 49);
		tab4.frame=CGRectMake(582, 655, 80 ,49);
		tab5.frame=CGRectMake(692, 655, 80,49);
		_buttonTest.frame=CGRectMake(626, 4, 149, 45);
		_buttomCourse.frame=CGRectMake(308, 4, 149, 45);
		_buttonModule.frame=CGRectMake(467, 4, 149, 45);
		testView.frame=CGRectMake(0, 58, 1024, 400);
	}
	currentOrientation = toInterfaceOrientation;
	[self refreshView:questionNo];
}


-(IBAction) TabarIndexSelected:(id)sender
{
//	UIButton *btn=sender;
//	int i=btn.tag/11;
//    appDelegate=(eEducationAppDelegate *)[[UIApplication sharedApplication] delegate];
//    [appDelegate setUpTabbarWithSelection:i];
}

#pragma mark -
#pragma mark JSONParser delegate method

- (void)parserDidFinishLoadingReturnData:(NSString *)responseString
{
	[HUD hide:YES];
	SBJSON *json = [[SBJSON new] autorelease];	
	_arrayQuestions = [[NSMutableArray alloc] initWithArray:[json objectWithString:responseString error:nil]];
	if([_arrayQuestions count]>0 && [[[_arrayQuestions objectAtIndex:0] objectForKey:@"success"] isEqualToString:@"0"])
	{
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"No question available for this test"] delegate:self 
											cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]  otherButtonTitles:nil];
		[alert show];
		alert.tag = TAG_NO_RECORD_FOUND;
		[alert release];
	}
	else
	{
		
		[DataBase addQuestionsToDB:_arrayQuestions testId:test_id edition_id:[[[NSUserDefaults standardUserDefaults] objectForKey:@"editonid"] intValue]];
		
		[self.view addSubview:testView];
		[self hideAndShow:NO];
		questionNo = 0;
		[self refreshView:questionNo];
		[self currenttime];
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

-(void)DidSubmitSucesfully:(NSString*)sucess
{
	[HUD hide:YES];
	if([sucess isEqualToString:@"1"])
	{
		objMyVariables.doAnswersPosted=TRUE;
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"Your test uploaded successfully"] delegate:self	 cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]  otherButtonTitles:nil];
		[alert show];
		alert.tag = 600;
		[alert release];
	}
	else
	{
		objMyVariables.doAnswersPosted=FALSE;
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[eEducationAppDelegate getLocalvalue:@"Failed to upload test"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:[eEducationAppDelegate getLocalvalue:@"OK"],nil];
		[alert show];
		alert.tag=500;
		[alert release];
	}
}

-(void)DidSubmitFail:(NSString*)error
{
	[HUD hide:YES];
	objMyVariables.doAnswersPosted=FALSE;
	NSString *strMsg = [eEducationAppDelegate getLocalvalue:@"The server cannot be reached. It could be down or busy. Please try again later."];
	UIAlertView *AlertView =  [[UIAlertView alloc]  initWithTitle:alertTitle message:strMsg delegate:nil 	cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil, nil];
	AlertView.tag=TAG_FailError;
	[AlertView show];
	[AlertView release];
}

#pragma mark -
#pragma mark  UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag==600 || alertView.tag==500 || alertView.tag==400)
	{
		NSArray *viewContrlls=[[NSArray alloc] initWithArray:[[self navigationController] viewControllers]];
		for (int i = 0; i < [viewContrlls count]; i++)
		{
			id obj=[viewContrlls objectAtIndex:i];
			if([obj isKindOfClass:[TestDetail class]])
			{
				[[self navigationController] popToViewController:obj animated:YES];
				[viewContrlls release];
				return;
			}
		}
		[viewContrlls release];
	}	
	else if(alertView.tag==TAG_NO_RECORD_FOUND)
	{
		[self.navigationController popViewControllerAnimated:YES];
	}
	else if(alertView.tag==TAG_TIME_COMPLETED)
	{
		[self.navigationController popViewControllerAnimated:YES];
	}
	else if(alertView.tag==TAG_FailError)
	{
		if (buttonIndex == 0)
		{
			[appDelegate GoTOLoginScreen:NO];
		}
	}
}

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
	[_labelElapsedTime release];_labelElapsedTime=nil;
	[_labelQuestionHead release]; _labelQuestionHead = nil;
	[_arrayQuestions release]; _arrayQuestions = nil;
	[_labelQuestionType release]; _labelQuestionType = nil;
	[_buttonSubmit release]; _buttonSubmit = nil;
	[_imageQuestionbackground release]; _imageQuestionbackground=nil;
	[_buttomCourse release]; _buttomCourse = nil;
	[_buttonModule release];_buttonModule = nil;
	[_buttonTest release]; _buttonTest = nil;
	[_DicTest release]; _DicTest = nil;
	[super dealloc];
}

@end
