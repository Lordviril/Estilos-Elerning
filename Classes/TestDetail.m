    //
//  TestDetail.m
//  eEducation
//
//  Created by Hidden Brains on 11/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestDetail.h"
#import"TestResults.h"
#import"AttemptToTest.h"
#import"Settings.h"
#import "ModuleHomePage.h"
#import "ModulesList.h"
#import "ICourseList.h"
#import "CustomCellFortestDetails.h"
#import "Test.h"
#import "DownloadedDocument.h"


#define TAG_TIME_COMPLETED 55
@implementation TestDetail
@synthesize buttonStart = _buttonStart;
@synthesize buttonCancel = _buttonCancel;
@synthesize arrayTestDetails = _arrayTestDetails;
@synthesize tableViewTest = _tableViewTest;
@synthesize buttomCourse = _buttomCourse;
@synthesize buttonModule = _buttonModule;
@synthesize buttonTest = _buttonTest;
@synthesize test_id;
@synthesize edition_id;
#pragma mark -
#pragma mark LoadView Method
- (void)viewDidLoad 
{
	[super viewDidLoad];
	appDelegate=(eEducationAppDelegate*)[[UIApplication sharedApplication]delegate];
	[_tableViewTest setBackgroundView:nil];
	UIView *_views =[[UIView alloc] init];
	[_tableViewTest setBackgroundView:_views];
	
	[_tableViewTest setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[_tableViewTest setSeparatorColor:[UIColor clearColor]];
	[_views release];
}

-(void) viewWillAppear:(BOOL)animated
{  
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"isNetworkAvailble"]){
		[self jsonRequest];
	}
	else {
		_arrayTestDetails = [[NSMutableArray alloc] initWithArray:[DataBase readalltestDetailsWirhTestId:test_id edition:edition_id]];
		[tab1 setHidden:YES];[tab2 setHidden:YES];[tab3 setHidden:YES];[tab4 setHidden:YES];[tab5 setHidden:YES];
	}	
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
	if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isNetworkAvailble"]){
		[_buttonModule setTitle:[[_arrayTestDetails objectAtIndex:0]objectForKey:@"module_name"] forState:UIControlStateNormal];
	}else{
		[_buttonModule setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"module_name"] forState:UIControlStateNormal];
	}
	[_buttomCourse setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"course_name"] forState:UIControlStateNormal];
	[_buttonTest setTitle:[eEducationAppDelegate getLocalvalue:@"Test"] forState:UIControlStateNormal];
	self.navigationController.navigationBar.hidden=NO;
	[self.navigationItem setHidesBackButton:YES];
	[self.navigationController.navigationBar viewWithTag:BUTTON_HOME_TAG].hidden=NO;
	[(UILabel *)[self.navigationController.navigationBar viewWithTag:LABEL_TITLE_TAG] setText:[eEducationAppDelegate getLocalvalue:@" "]];
	[self willAnimateRotationToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0.2];
}

-(void)jsonRequest
{
	HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[HUD setLabelText:[eEducationAppDelegate getLocalvalue:@"Please wait"]];
	[HUD show:YES];
	objParser = [[JSONParser alloc] init];
	objParser.delegate = self;
	NSString *strURL =[WebService getexamlistURL];
	NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] ,@"user_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"module_id"], @"module_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"course_id"],@"course_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"editonid"],@"edition_id",		 
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language",
								 nil];
	[objParser sendRequestToParse:strURL params:requestData];
}

-(IBAction) TabarIndexSelected:(id)sender
{
//	UIButton *btn=sender;
//	int i=btn.tag/11;
//    appDelegate=(eEducationAppDelegate *)[[UIApplication sharedApplication] delegate];
//    [appDelegate setUpTabbarWithSelection:i];
}


#pragma mark -
#pragma mark Action Method

-(IBAction)btnCancel_Clicked:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnTest_Clicked:(id)sender
{
	//[self.navigationController popViewControllerAnimated:YES];	
}

-(IBAction)btnCourse_Clicked:(id)sender
{
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"isNetworkAvailble"])
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
		NSArray *ary_navigationControllerViews = [[NSArray alloc] initWithArray:[appDelegate.navigationController viewControllers]];
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.class.description == %@", [[DownloadedDocument class] description]];
		NSArray *ary_viewController = [[NSArray alloc] initWithArray:[ary_navigationControllerViews filteredArrayUsingPredicate:predicate]];
		[ary_navigationControllerViews release];
		ary_navigationControllerViews=nil;
		if ([ary_viewController count] > 0) 
		{
			[self.navigationController popToViewController:[ary_viewController objectAtIndex:0] animated:YES];
			[ary_viewController release];
			ary_viewController=nil;
			return;
		}
		[ary_viewController release];
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

-(void)StartButtonClick:(UIButton *)btn
{
	Test *_objTest = [[Test alloc] initWithNibName:@"Test" bundle:nil];
	_objTest.test_id = [[[_arrayTestDetails objectAtIndex:btn.tag] objectForKey:@"test_id"] intValue];
	_objTest.givenTestDuration = 60.0;
	[self.navigationController pushViewController:_objTest animated:YES];
	[_objTest release];
}

#pragma mark -
#pragma mark orientation Life Cycle
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
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	return YES;
}

#pragma mark -
#pragma mark JSONParser delegate method

- (void)parserDidFinishLoadingReturnData:(NSString *)responseString
{
	[HUD hide:YES];
	SBJSON *json = [[SBJSON new] autorelease];
	_arrayTestDetails = [[NSMutableArray alloc] initWithArray:[json objectWithString:responseString error:nil]];
	if( [_arrayTestDetails count]>0 && [[[_arrayTestDetails objectAtIndex:0] objectForKey:@"success"] isEqualToString:@"1"])
	{
		[DataBase addTestDetails:_arrayTestDetails];
		[_tableViewTest reloadData];
	}
	else {
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"No data available for test"] delegate:self	 cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]  otherButtonTitles:nil];
		[alert show];
		alert.tag = TAG_NO_RECORD_FOUND;
		[alert release];
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

#pragma mark -
#pragma mark  UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag==TAG_FailError)
	{
		if(buttonIndex==0)
		{
			[appDelegate GoTOLoginScreen:NO];
		}
	}
	else if(alertView.tag==TAG_NO_RECORD_FOUND)
	{
		[self.navigationController popViewControllerAnimated:YES];
	}
	else if(alertView.tag==TAG_TIME_COMPLETED)
	{
		if(buttonIndex==0)
		{
			[self.navigationController popViewControllerAnimated:YES];
		}
		else
		{
			[self.navigationController popViewControllerAnimated:YES];
		}
	}
}

#pragma mark -
#pragma mark tableView Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [_arrayTestDetails count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"mycell";
	CustomCellFortestDetails *cell = (CustomCellFortestDetails*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) 
	{	
		cell=[[[CustomCellFortestDetails alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}	
	cell.labelTestName.text = [[_arrayTestDetails objectAtIndex:indexPath.section] objectForKey:@"test_name"];
	NSString *strDetails = [eEducationAppDelegate removeIllegalCharters:[[_arrayTestDetails objectAtIndex:indexPath.section] objectForKey:@"test_details"]];
	cell.textViewTestDes.text = [strDetails stringByReplacingOccurrencesOfString:@"<br>" withString:@" "];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 140;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	AttemptToTest *objTest=[[AttemptToTest alloc] initWithNibName:@"AttemptToTest" bundle:nil];
	[objTest setDicTest:[_arrayTestDetails objectAtIndex:indexPath.section]];
	[self.navigationController pushViewController:objTest animated:YES];
	[objTest release];
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
	[_buttonStart release];_buttonStart = nil;
	[_buttonCancel release];_buttonCancel = nil;
	[_arrayTestDetails release];_arrayTestDetails = nil;
	[_tableViewTest release];_tableViewTest=nil;
	[_buttomCourse release]; _buttomCourse = nil;
	[_buttonModule release];_buttonModule = nil;
	[_buttonTest release]; _buttonTest = nil;
	[super dealloc];
}

@end
