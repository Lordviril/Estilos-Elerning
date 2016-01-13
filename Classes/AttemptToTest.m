    //
//  AttemptToTest.m
//  eEducation
//
//  Created by Hidden Brains on 11/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AttemptToTest.h"
#import"TestDetail.h"
#import"ICourseList.h"
#import "ModulesList.h"
#import "ModuleHomePage.h"
#import "DownloadedDocument.h"
#import "Customcell_AttemptTest.h"
#import "Test.h"
#import "TestResultListing.h"
@implementation AttemptToTest
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
	isEndDate=FALSE;
}

-(double)doubleFromString:(NSString*)_strDate{
	NSDateFormatter *dateFormater=[[[NSDateFormatter alloc] init] autorelease];
    [dateFormater setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
	[dateFormater setDateFormat:@"yyyy-MM-dd"];
	NSDate* sourceDate = [dateFormater dateFromString:_strDate];
//	NSLog(@"%@",[dateFormater dateFromString:_strDate]);
	NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
	NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
	
	NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
	NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
	NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
//	NSLog(@"%f",interval);
	NSDate* destinationDate = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate] autorelease];
//	NSLog(@"%@",destinationDate);
	
	
	return (double)[destinationDate timeIntervalSince1970];
}

-(void) viewWillAppear:(BOOL)animated
{
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
	
	NSString *_endDate=[_DicTest objectForKey:@"enddate"];
	double d1 = [self doubleFromString:_endDate];

//	NSLog(@"%@",[NSDate date]);
	NSDateFormatter *dateFormater=[[[NSDateFormatter alloc] init] autorelease];
	[dateFormater setDateFormat:@"yyyy-MM-dd"]; 
	[dateFormater setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
//	 NSLog(@"%@",[dateFormater stringFromDate:[NSDate date]]);
	double d = [self doubleFromString:[dateFormater stringFromDate:[NSDate date]]];
//	NSLog(@"_endDate----%f presentDate-----%f",d1,d);
	if(d1>=d){
		isEndDate=TRUE;
	}else{
		isEndDate =FALSE;
	}
	//[_DicTest objectForKey:@"test_name"]
	if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isNetworkAvailble"]){
		[btnCourse setTitle:[_DicTest objectForKey:@"course_name"] forState:UIControlStateNormal];
		[btnModule setTitle:[_DicTest objectForKey:@"module_name"] forState:UIControlStateNormal];
	}else{
		[btnCourse setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"course_name"] forState:UIControlStateNormal];
		[btnModule setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"module_name"] forState:UIControlStateNormal];
	}
	[btnTest setTitle:[eEducationAppDelegate getLocalvalue:@"Test"] forState:UIControlStateNormal];
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

#pragma mark -
#pragma mark Action Method
-(IBAction)btnTest_Clicked:(id)sender
{
	[self.navigationController popViewControllerAnimated:TRUE];
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
			[appDelegate.navigationController popToViewController:[ary_viewController objectAtIndex:0] animated:YES];
			[self.view removeFromSuperview];
			[ary_viewController release];ary_viewController=nil;
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
			if([obj isKindOfClass:[ModuleHomePage class]] )
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
			[appDelegate.navigationController popToViewController:[ary_viewController objectAtIndex:0] animated:YES];
			[self.view removeFromSuperview];
			[ary_viewController release];ary_viewController=nil;
			return;
		}
		[ary_viewController release];ary_viewController=nil;
	}
}

#pragma mark -
#pragma mark tableView Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"isNetworkAvailble"]&&!isEndDate)
			return 2;
	else if([[NSUserDefaults standardUserDefaults] boolForKey:@"isNetworkAvailble"]&& isEndDate)
			return 1;
	else if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isNetworkAvailble"]&& isEndDate)
		return 1;
	 else 
		 return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	static NSString *CellIdentifier = @"mycell";
	Customcell_AttemptTest *cell =  (Customcell_AttemptTest*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{	
		cell=[[[Customcell_AttemptTest alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor=[UIColor clearColor];

		UIImageView*imgview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,tblView.frame.size.width, 70)];
		imgview.image=[UIImage imageNamed:@"strip_f4.png"];
		UIImageView*selimgview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, 70)];
		selimgview.image=[UIImage imageNamed:@"strip_f4_h.png"];
		[cell setSelectedBackgroundView:selimgview];
		[selimgview release];
		cell.backgroundView = imgview;
		[imgview release];
		cell.backgroundColor=[UIColor clearColor];
	}
	if (indexPath.section==0) 
	{
		cell.lblTest.text=[eEducationAppDelegate getLocalvalue:@"Attempt For Test"];
	}
	else 
	{
		cell.lblTest.text=[eEducationAppDelegate getLocalvalue:@"View Results"];
	}
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.section==0) 
	{		
			NSString *strEndDate = [NSString stringWithFormat:@"%@", [_DicTest objectForKey:@"enddate"]];
		        
			double dtDouble = [self doubleFromString:strEndDate];
			//NSComparisonResult result = [dtEnd compare:[NSDate date]];
			NSDateFormatter *dateFormater=[[[NSDateFormatter alloc] init] autorelease];
			[dateFormater setDateFormat:@"yyyy-MM-dd"]; 
			[dateFormater setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
			double d = [self doubleFromString:[dateFormater stringFromDate:[NSDate date]]];
			if (dtDouble < d )
			{
				UIAlertView *alt = [[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"Exam duration is over."] delegate:self
													cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
				[alt show];
				[alt release];
				return;
			}
		if([[_DicTest objectForKey:@"attemptedcnt"] intValue]>=[[_DicTest objectForKey:@"totattempt"] intValue])
		{			
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"You are reached maximum attempt count."] delegate:self	 
												cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]  otherButtonTitles:nil];
			alert.tag = 10;
			[alert show];
			[alert release];			
		}
		else
		{
			Test *_objTest = [[Test alloc] initWithNibName:@"Test" bundle:nil];
			[_objTest setDicTest:_DicTest];
			[self.navigationController pushViewController:_objTest animated:YES];
			[_objTest release];
		}		
	}
	else if(indexPath.section==1)
	{
		TestResultListing *_objTestResultListing = [[TestResultListing alloc] initWithNibName:@"TestResultListing" bundle:nil];
		[_objTestResultListing setDicTest:_DicTest];
		[self.navigationController pushViewController:_objTestResultListing animated:YES];
		[_objTestResultListing release];
	}
}

-(void)showAlert
{
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
		btnTest.frame=CGRectMake(467, 4, 149, 45);
		btnCourse.frame=CGRectMake(151, 4, 149, 45);
		btnModule.frame=CGRectMake(310, 4, 149, 45);
	}
	else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
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
    return NO;
}

#pragma mark -
#pragma mark Memory Management Method
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[tblView release];tblView=nil;
	[btnTest release];btnTest=nil;
	[btnCourse release];btnCourse=nil;
	[btnModule release];btnModule=nil;
	[tab1 release];tab1=nil;
	[tab2 release];tab2=nil;
	[tab3 release];tab3=nil;
	[tab4 release];tab4=nil;
	[tab5 release];tab5=nil;
	[_DicTest release];_DicTest=nil;
    [super dealloc];
}


@end
