    //
//  TestResultListing.m
//  eEducation
//
//  Created by HB 13 on 27/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestResultListing.h"
#import "ModuleHomePage.h"
#import "ModulesList.h"
#import "ICourseList.h"
#import "CustomCellForTestResultsListing.h"
#import "DownloadedDocument.h"
#import "TestResults.h"

@implementation TestResultListing
@synthesize buttomCourse = _buttomCourse;
@synthesize buttonModule = _buttonModule;
@synthesize buttonTest = _buttonTest;
@synthesize tableTestResult = _tableTestResult;
@synthesize arrayTestResult = _arrayTestResult; 
@synthesize DicTest = _DicTest;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	[super viewDidLoad];
	appDelegate = (eEducationAppDelegate*)[[UIApplication sharedApplication]delegate];
	_dateFormatter=[[NSDateFormatter alloc] init];
	[_dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
	[_tableTestResult setBackgroundView:nil];
	[_tableTestResult setBackgroundView:[[[UIView alloc] init] autorelease]];
	[_tableTestResult setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[_tableTestResult setSeparatorColor:[UIColor clearColor]]; 	
	[self jsonRequest];	
}

-(void)viewWillAppear:(BOOL)animated
{
	[_buttomCourse setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"course_name"] forState:UIControlStateNormal];
	[_buttonModule setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"module_name"] forState:UIControlStateNormal];
	[_buttonTest setTitle:[eEducationAppDelegate getLocalvalue:@"Test"] forState:UIControlStateNormal];
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
	
	self.navigationController.navigationBar.hidden=NO;
	[self.navigationItem setHidesBackButton:YES];
	[self.navigationController.navigationBar viewWithTag:BUTTON_HOME_TAG].hidden=NO;
	[(UILabel *)[self.navigationController.navigationBar viewWithTag:LABEL_TITLE_TAG] setText:[_DicTest objectForKey:@"test_name"]];
	[self willAnimateRotationToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0.2];
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
	NSString *strURL =[WebService getpastexamlistURL];
	
	NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] ,@"user_id",  
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"module_id"], @"module_id",
								 [_DicTest objectForKey:@"test_id"],@"test_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"editonid"],@"edition_id",
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
	_arrayTestResult = [[NSMutableArray alloc] initWithArray:[json objectWithString:responseString error:nil]] ;
	if([_arrayTestResult count]>0&&[[[_arrayTestResult objectAtIndex:0] objectForKey:@"success"] isEqualToString:@"0"])
	{
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"No result available for this test"] delegate:self	 cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]  otherButtonTitles:nil];
		[alert show];
		alert.tag = TAG_NO_RECORD_FOUND;
		[alert release];
	}
	else
	{
		[_tableTestResult reloadData];
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
-(IBAction)btnCourse_Clicked:(id)sender
{
	if(appDelegate.atinternetloginStatus == YES)
	{
		NSArray *viewContrlls=[[appDelegate navigationController] viewControllers];
		for( int i=0;i<[ viewContrlls count];i++)
		{
			id obj=[viewContrlls objectAtIndex:i];
			if([obj isKindOfClass:[ModulesList class]])
			{
				[[appDelegate navigationController] popToViewController:obj animated:YES];
				return;
			}
		}
	}
	else
	{
		NSArray *viewContrlls=[[appDelegate navigationController] viewControllers];
		for( int i=0;i<[ viewContrlls count];i++)
		{
			id obj=[viewContrlls objectAtIndex:i];
			if([obj isKindOfClass:[DownloadedDocument class]])
			{
				[[appDelegate navigationController] popToViewController:obj animated:YES];
				return;
			}
		}
	}
}
-(IBAction)btnModule_Clicked:(id)sender
{
	if(appDelegate.atinternetloginStatus == YES)
	{
	    NSArray *viewContrlls=[[appDelegate navigationController] viewControllers];
		for( int i=0;i<[viewContrlls count];i++)
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
		NSArray *viewContrlls=[[appDelegate navigationController] viewControllers];
		for( int i=0;i<[ viewContrlls count];i++)
		{
			id obj=[viewContrlls objectAtIndex:i];
			if([obj isKindOfClass:[DownloadedDocument class]])
			{
				[[appDelegate navigationController] popToViewController:obj animated:YES];
				return;
			}
		}
	}
}

-(IBAction)btnTest_Clicked:(id)sender{
	[self.navigationController popViewControllerAnimated:YES];
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
	CustomCellForTestResultsListing *cell = (CustomCellForTestResultsListing*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{	
		cell=[[[CustomCellForTestResultsListing alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		UIImageView*imgview=[[UIImageView alloc]initWithFrame:CGRectMake(-28, 0, 734, 70)];
		imgview.image=[UIImage imageNamed:@"strip_f4.png"];
		UIImageView*selimgview=[[UIImageView alloc]initWithFrame:CGRectMake(-28, 0, 734, 70)];
		selimgview.image=[UIImage imageNamed:@"strip_f4_h.png"];
		[cell setSelectedBackgroundView:selimgview];
		[selimgview release];
		cell.backgroundView = imgview;
		[imgview release];
	}
	cell.labelTestNameValue.text=[[_arrayTestResult objectAtIndex:indexPath.section] objectForKey:@"test_name"];
	[_dateFormatter setDateFormat:@"MMM dd,yyyy"];
	NSDate *_tempstartDate=[_dateFormatter dateFromString:[[_arrayTestResult objectAtIndex:indexPath.section] objectForKey:@"start_date"]];
	[_dateFormatter setDateFormat:@"dd-MM-YYYY"];
	cell.labelStartDateValue.text=[_dateFormatter stringFromDate:_tempstartDate];//[[_arrayTestResult objectAtIndex:indexPath.section] objectForKey:@"start_date"];
	cell.labelStatusValue.text = [eEducationAppDelegate getLocalvalue:[[_arrayTestResult objectAtIndex:indexPath.section] objectForKey:@"Status"]];
	[_dateFormatter setDateFormat:@"MMM dd,yyyy"];
	NSDate *_tempendtDate=[_dateFormatter dateFromString:[[_arrayTestResult objectAtIndex:indexPath.section] objectForKey:@"end_date"]];
	[_dateFormatter setDateFormat:@"dd-MM-YYYY"];
	cell.labelEndDateValue.text=[_dateFormatter stringFromDate:_tempendtDate]; 
	cell.backgroundColor=[UIColor clearColor];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if([[[_arrayTestResult objectAtIndex:indexPath.section] objectForKey:@"Status"] isEqualToString:@"Not Declared"])
	{
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"This test result not declared yet"] delegate:self	 cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else 
	{
		TestResults *_objTestResults = [[TestResults alloc] initWithNibName:@"TestResults" bundle:nil];
		[_objTestResults setDicTest:[_arrayTestResult objectAtIndex:indexPath.section]];
		[self.navigationController pushViewController:_objTestResults animated:YES];
		[_objTestResults release];
	}

	[tableView deselectRowAtIndexPath:indexPath animated:YES];
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
		_buttonTest.frame=CGRectMake(457, 4, 149, 45);
		_buttomCourse.frame=CGRectMake(141, 4, 149, 45);
		_buttonModule.frame=CGRectMake(300, 4, 149, 45);
	}
	else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight )
	{
		tab1.frame=CGRectMake(252, 655, 80, 49);
		tab2.frame=CGRectMake(362, 655, 80, 49);
		tab3.frame=CGRectMake(472, 655, 80, 49);
		tab4.frame=CGRectMake(582, 655, 80 ,49);
		tab5.frame=CGRectMake(692, 655, 80,49);
		_buttonTest.frame=CGRectMake(626, 4, 149, 45);
		_buttomCourse.frame=CGRectMake(308, 4, 149, 45);
		_buttonModule.frame=CGRectMake(467, 4, 149, 45);
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
	[_dateFormatter release];_dateFormatter=nil;
	[_buttomCourse release]; _buttomCourse = nil;
	[_buttonModule release];_buttonModule = nil;
	[_buttonTest release]; _buttonTest = nil;
	[_tableTestResult release]; _tableTestResult.delegate = nil; 
	_tableTestResult.dataSource = nil; _tableTestResult = nil;
	[_arrayTestResult release]; _arrayTestResult = nil;
	[_DicTest release]; _DicTest=nil;
	[super dealloc];
}

@end
