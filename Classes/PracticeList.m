    //
//  PracticeList.m
//  eEducation
//
//  Created by Hidden Brains on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PracticeList.h"
#import"PrecticeListCustomCell.h"
#import"PracticeDetail.h"
#import"Settings.h"
#import"LoginScreen.h"
#import"ICourseList.h"
#import "ModulesList.h"
#import "ModuleHomePage.h"
#import "DownloadedDocument.h"



@implementation PracticeList

#pragma mark -
#pragma mark LoadView Method
- (void)viewDidLoad 
{
	[super viewDidLoad];
	appDelegate=(eEducationAppDelegate*)[[UIApplication sharedApplication]delegate];
	NSMutableDictionary *practiceDict=[[NSMutableDictionary alloc] init];	
	[practiceDict setObject:@"Practice1" forKey:@"practice"];
	[practiceDict setObject:@"Uploaded" forKey:@"status"];
	[practiceArray addObject:practiceDict];
	[practiceDict release];
	practiceDict=[[NSMutableDictionary alloc] init];	
	[practiceDict setObject:@"Practice2" forKey:@"practice"];
	[practiceDict setObject:@"Not Uploaded" forKey:@"status"];
	[practiceArray addObject:practiceDict];
	[practiceDict release];

	[tblView setBackgroundView:nil];
	[tblView setBackgroundView:[[[UIView alloc] init] autorelease]];

	[tblView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[tblView setSeparatorColor:[UIColor clearColor]];
	[self jsonRequest];

}

-(void) viewWillAppear:(BOOL)animated
{
	[btnModule setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"module_name"] forState:UIControlStateNormal];
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
	
	[btnCourse setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"course_name"] forState:UIControlStateNormal];
	[btnPrectice setTitle:[eEducationAppDelegate getLocalvalue:@"Practices"] forState:UIControlStateNormal];
    self.navigationController.navigationBar.hidden=NO;
	[self.navigationItem setHidesBackButton:YES];
	[self.navigationController.navigationBar viewWithTag:BUTTON_HOME_TAG].hidden=NO;
	[(UILabel *)[self.navigationController.navigationBar viewWithTag:LABEL_TITLE_TAG] setText:[eEducationAppDelegate getLocalvalue:@" "]];
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
	NSString *strURL =[WebService getPracticelistURL];
	NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] ,@"user_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"module_id"], @"module_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"course_id"],@"course_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"editonid"],@"edition_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language",
								 nil];	
	[objParser sendRequestToParse:strURL params:requestData];
}
#pragma mark -
#pragma mark Action Method

-(IBAction)btnCourse_Clicked:(id)sender
{
	
	NSArray *viewContrlls=[[appDelegate navigationController] viewControllers];
	for( int i=0;i<[ viewContrlls count];i++)
	{
		id obj=[viewContrlls objectAtIndex:i];
		if(appDelegate.atinternetloginStatus == YES )
		{
			if([obj isKindOfClass:[ModulesList class]] )
			{
				[[appDelegate navigationController] popToViewController:obj animated:YES];
				return;
			}
		}
		else 
		{
			if([obj isKindOfClass:[DownloadedDocument class]])
			{
				[[appDelegate navigationController] popToViewController:obj animated:YES];
				return;
			}
			
		}
		
	}
}

#pragma mark -
#pragma mark tableView Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return [practiceArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"mycell";
	PrecticeListCustomCell *cell =  (PrecticeListCustomCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{	
		cell=[[[PrecticeListCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		UIImageView*imgview=[[UIImageView alloc]initWithFrame:CGRectMake(-28, 0, 734, 70)];
		imgview.image=[UIImage imageNamed:@"strip_f4.png"];
		UIImageView*selimgview=[[UIImageView alloc]initWithFrame:CGRectMake(-28, 0, 734, 70)];
		selimgview.image=[UIImage imageNamed:@"strip_f4_h.png"];
		[cell setSelectedBackgroundView:selimgview];
		[selimgview release];
		cell.backgroundView = imgview;
		[imgview release];
	}
	
	cell.backgroundColor=[UIColor clearColor];
	cell.lblPrecticeName.text=[[practiceArray objectAtIndex:indexPath.section] objectForKey:@"practice_name"];
	cell.lblStatusValue.text=[eEducationAppDelegate getLocalvalue:[[practiceArray objectAtIndex:indexPath.section] objectForKey:@"status"]];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	PracticeDetail *objPracticeDetail=[[PracticeDetail alloc] initWithNibName:@"PracticeDetail" bundle:nil];
	[objPracticeDetail setDicPracticeList:[practiceArray objectAtIndex:indexPath.section]];
	[self.navigationController pushViewController:objPracticeDetail animated:YES];
	[objPracticeDetail release];	
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
		btnPrectice.frame=CGRectMake(457, 4, 149, 45);
		btnCourse.frame=CGRectMake(141, 4, 149, 45);
		btnModule.frame=CGRectMake(300, 4, 149, 45);
		//btnPrectice.frame=CGRectMake(401, 4, 149, 45);
//		btnCourse.frame=CGRectMake(218, 4, 149, 45);
	}
	else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight )
	{
		tab1.frame=CGRectMake(252, 655, 80, 49);
		tab2.frame=CGRectMake(362, 655, 80, 49);
		tab3.frame=CGRectMake(472, 655, 80, 49);
		tab4.frame=CGRectMake(582, 655, 80 ,49);
		tab5.frame=CGRectMake(692, 655, 80,49);
		btnPrectice.frame=CGRectMake(626, 4, 149, 45);
		btnCourse.frame=CGRectMake(308, 4, 149, 45);
		btnModule.frame=CGRectMake(467, 4, 149, 45);
		//btnPrectice.frame=CGRectMake(529, 4, 149, 45);
//		btnCourse.frame=CGRectMake(346, 4, 149, 45);
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

#pragma mark -
#pragma mark JSONParser delegate method

- (void)parserDidFinishLoadingReturnData:(NSString *)responseString
{
	[HUD hide:YES];
	SBJSON *json = [[SBJSON new] autorelease];	
	practiceArray = [[NSMutableArray alloc] initWithArray:[json objectWithString:responseString error:nil]] ;
	if([[[practiceArray objectAtIndex:0] objectForKey:@"success"] isEqualToString:@"1"])
		[tblView reloadData];
	else {
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"No Practice found for this course."] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]  otherButtonTitles:nil];
		alert.tag=TAG_NO_RECORD_FOUND;
		[alert show];
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
#pragma mark  UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	
	if(alertView.tag==TAG_NO_RECORD_FOUND)
	{
		[self.navigationController popViewControllerAnimated:YES];
	}else if(alertView.tag==TAG_FailError){
		if(buttonIndex==0)
		[appDelegate GoTOLoginScreen:NO];
	}
	
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
	[tblView release],tblView=nil;
	[btnPrectice release],btnPrectice=nil;
	[btnCourse release],btnCourse=nil;[btnModule release],btnModule=nil;
	[btnSetting release],btnSetting=nil;
	[tab1 release],tab1=nil;[tab2 release],tab2=nil;[tab3 release],tab3=nil;[tab4 release],tab4=nil;[tab5 release],tab5=nil;
	[objParser release],objParser=nil;
	[practiceArray release],practiceArray=nil;
	[HUD release],HUD=nil;
	[super dealloc];
}


@end
