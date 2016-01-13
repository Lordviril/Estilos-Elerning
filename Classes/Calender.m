    //
//  Calender.m
//  eEducation
//
//  Created by hb12 on 07/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Calender.h"
#import"CalenderCustomCell.h"
#import "ICourseList.h"
#import"Settings.h"
#import"LoginScreen.h"
#import "WebService.h"
#import "CalendarLogicDelegate.h"
#import "CalendarViewControllerDelegate.h"


@implementation Calender

 - (void)viewDidLoad 
{
    [super viewDidLoad];
    self.viewShowDetails.hidden = YES;
	appDelegate=(eEducationAppDelegate*)[[UIApplication sharedApplication]delegate];

	strDate=[[NSMutableString alloc] initWithString:@""];
	testArray=[[NSMutableArray alloc] init];
	 
	objParser = [[JSONParser alloc] init];
	objParser.delegate = self;
	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
    HUD.labelText =[eEducationAppDelegate getLocalvalue:@"Please wait"];
    [self setLocalValues];
}

-(void) viewWillAppear:(BOOL)animated
{
    [HUD show:YES];
    for (UIView *v in self.viewBack.subviews) {
        if (![v isKindOfClass:[UIImageView class]] && v != self.viewShowDetails) {
            [v removeFromSuperview];
        }
    }
    
    [self.lblTopCourse setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"course_name"]];
    [self.lblTopDuration setText:[NSString stringWithFormat:RTLableText,[eEducationAppDelegate getLocalvalue:@"Begins "],[eEducationAppDelegate convertString:[[NSUserDefaults standardUserDefaults] valueForKey:@"edition_start"] fromFormate:@"yyyy-MM-dd" toFormate:@"dd MMMM yyyy"],[eEducationAppDelegate getLocalvalue:@"- Ends "],[eEducationAppDelegate convertString:[[NSUserDefaults standardUserDefaults] valueForKey:@"edition_end"] fromFormate:@"yyyy-MM-dd" toFormate:@"dd MMMM yyyy"]]];
    [self.imgProfile loadImageFromURL:[NSURL URLWithString:[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_profile_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:@"no-image-200x200.png"];
    self.lblProfileBlueName.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_name"];
    [self.imgLogo loadImageFromURL:[eEducationAppDelegate getTopCourseUrl] imageName:@"top-bar-logo.png"];
    [self.imgLogoStatic loadImageFromURL:[eEducationAppDelegate getTopStaticUrl] imageName:@"logo_top_static.png"];

	[self willAnimateRotationToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0.2];
	
	//parsing
	NSString *strURL = [WebService getCalanderEvent];
	NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:                                 
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],@"user_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"course_id"] ,@"course_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"editonid"],@"edition_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language",
								 nil];	
	
	[objParser sendRequestToParse:strURL params:requestData];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Topbar Action methods
-(IBAction)btnBackClicked:(id)sender{
    @try {
        [[validations getAppDelegateInstance].navigationController popToViewController:[[validations getAppDelegateInstance].navigationController.viewControllers objectAtIndex:2] animated:NO];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(IBAction)btnStudentsClicked:(id)sender{
    OtherStudents *objOtherStudents = [[OtherStudents alloc] initWithNibName:@"OtherStudents" bundle:nil];
    [[validations getAppDelegateInstance] removePresentVC];
	[[validations getAppDelegateInstance].navigationController pushViewController:objOtherStudents animated:NO];
	[objOtherStudents release];
}

-(IBAction)proImgClicked:(id)sender{
    [self btnSettingsClicked:nil];
}

-(IBAction)btnSettingsClicked:(id)sender{
    Settings *objSettings = [[Settings alloc] initWithNibName:@"Settings" bundle:nil];
    [[validations getAppDelegateInstance] removePresentVC];
	[[validations getAppDelegateInstance].navigationController pushViewController:objSettings animated:NO];
	[objSettings release];
}

-(IBAction)btnLogoutClicked:(id)sender{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"You're about to logout, are you sure?"] delegate:self	 cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"NO"]  otherButtonTitles:[eEducationAppDelegate getLocalvalue:@"YES"],nil];
	[alert show];
	alert.tag=TAG_ALERT_LOGOUT;
	[alert release];
}
-(IBAction)btnModuleClicked:(id)sender{
    ModuleHomePage *objModuleListHomePage=[[ModuleHomePage alloc] initWithNibName:@"ModuleHomePage" bundle:nil];
    [[validations getAppDelegateInstance] removePresentVC];
	[[validations getAppDelegateInstance].navigationController pushViewController:objModuleListHomePage animated:NO];
	[objModuleListHomePage release];
}

#pragma mark - Other methods
-(void)setLocalValues{
    self.lblProfileGrayName.text = [eEducationAppDelegate getLocalvalue:@"WELCOME"];
    self.lblTitle.text = [[eEducationAppDelegate getLocalvalue:@"Calendar"] uppercaseString];//[_DicCourseDetails objectForKey:@"STUDENTS"];
    [self.btnHome setTitle:[eEducationAppDelegate getLocalvalue:@"HOME"] forState:UIControlStateNormal];
    [self.btnModule setTitle:[[eEducationAppDelegate getLocalvalue:@"Module"] uppercaseString] forState:UIControlStateNormal];
}

#pragma mark - Json parser Method
- (void)parserDidFinishLoadingReturnData:(NSString *)responseString
{
	SBJSON *json = [[SBJSON new] autorelease];	
	calArray = [[NSMutableArray alloc]initWithArray:[json objectWithString:responseString error:nil]];
	if([calArray count])
	{
		if([[[calArray objectAtIndex:0] objectForKey:@"success"] isEqualToString:@"0"])
		{
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"No event available for this user."] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
			alert.tag=104;
			[alert show];
			[alert release];
			 
		}
		[self setUpCalendarForDates:calArray];
	}
    
	else {
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"No event available for this user."] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
		alert.tag=103;
		[alert show];
		[alert release];
	}
	[HUD hide:YES];
}

- (void)parserDidFailWithRestoreError:(NSError*)error :(NSString*)msg
{
	[HUD setHidden:YES];
    if ([msg isEqualToString:@""]) {
        msg = [eEducationAppDelegate getLocalvalue:@"The server cannot be reached. It could be down or busy. Please try again later."];
    }
	UIAlertView *AlertView =  [[UIAlertView alloc]  initWithTitle:alertTitle message:msg delegate:nil 	cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil, nil];
	AlertView.tag=TAG_FailError;
	[AlertView show];
	[AlertView release];
}


#pragma mark - AlertView delegate method
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	if(alertView.tag==TAG_FailError){
		if(buttonIndex==0)
		[appDelegate GoTOLoginScreen:YES];
	}
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == TAG_ALERT_LOGOUT && buttonIndex == 1){
        @try {
            [[validations getAppDelegateInstance].navigationController popToViewController:[[validations getAppDelegateInstance].navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
    }
}

#pragma mark - CalendarLogic delegate
-(void)setUpCalendarForDates:(NSMutableArray*)arrDates
{
    NSDate *aDate = [CalendarLogic dateForToday];
	CalendarLogic *aCalendarLogic = [[CalendarLogic alloc] initWithDelegate:self referenceDate:aDate];
	self.calendarLogic = aCalendarLogic;

	CalendarMonth *aCalendarView = [[CalendarMonth alloc] initWithFrame:CGRectMake(15, 0, 560, 490) logic:self.calendarLogic :arrDates :self];
    aCalendarView.delegate = self;
	[aCalendarView selectButtonForDate:aDate];
    self.calendarView = aCalendarView;
	[self.viewBack addSubview:aCalendarView];
    
	self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.leftButton.frame = CGRectMake(15, 25, 40, 40);
	[self.leftButton setImage:[UIImage imageNamed:@"arrow_prev@2x.png"] forState:UIControlStateNormal];
	[self.leftButton addTarget:self.calendarLogic
                        action:@selector(selectPreviousMonth)
              forControlEvents:UIControlEventTouchUpInside];
	[self.viewBack addSubview:self.leftButton];
    
	self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.rightButton.frame = CGRectMake(515, 25, 40, 40);
	[self.rightButton setImage:[UIImage imageNamed:@"arrow_forw@2x.png"] forState:UIControlStateNormal];
	[self.rightButton addTarget:self.calendarLogic
                         action:@selector(selectNextMonth)
               forControlEvents:UIControlEventTouchUpInside];
	[self.viewBack addSubview:self.rightButton];
    self.rightButton.enabled = YES;
}

#pragma mark - CalendarLogic delegate
- (void)calendarLogic:(CalendarLogic *)aLogic dateSelected:(NSDate *)aDate
{
    self.selectedDate = aDate;
    if ([self.calendarLogic distanceOfDateFromCurrentMonth:self.selectedDate] == 0) {
		[self.calendarView selectButtonForDate:self.selectedDate];
	}
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setDateFormat:@"dd-MM-yyyy"];
}
-(void)btnDateSelected:(NSString *)selectedDate{
    
    NSString *str= [eEducationAppDelegate convertString:[NSString stringWithFormat:@"%@",selectedDate] fromFormate:@"yyyy-MM-dd HH:mm:ss zzz" toFormate:@"yyyy-MM-dd"];
//    NSLog(@"%@",str);
    if ([str isEqualToString:@""] || [str isKindOfClass:[NSNull class]] || [str isEqualToString:@"(null)"] || [str isEqualToString:@"null"] || str == nil) {
        str= [eEducationAppDelegate convertString:[NSString stringWithFormat:@"%@",selectedDate] fromFormate:@"yyyy-MM-dd hh:mm:ss a zzz" toFormate:@"yyyy-MM-dd"];
//        NSLog(@"%@",str);
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"self.date CONTAINS '%@'",str]];
    NSArray* filteredArray = [calArray filteredArrayUsingPredicate:predicate];
    if (filteredArray.count > 0) {
        NSString *strDate1 = [NSString stringWithFormat:@"%@ %@",[eEducationAppDelegate getLocalvalue:@"Date"],[eEducationAppDelegate convertString:[[filteredArray objectAtIndex:0] objectForKey:@"date"] fromFormate:@"yyyy-MM-dd" toFormate:@"dd/MM/yyyy"]];
        self.viewShowDetails.hidden = NO;
        [self.lblDateDetails setText:[NSString stringWithFormat:CalenderRTLableText,[[filteredArray objectAtIndex:0] valueForKey:@"title"],strDate1]];
    } else {
        self.viewShowDetails.hidden = YES;
    }
}

- (void)calendarLogic:(CalendarLogic *)aLogic monthChangeDirection:(NSInteger)aDirection
{
    
	BOOL animate = self.isViewLoaded;
	CGFloat distance = 545;
	if (aDirection < 0) {
		distance = -distance;
	}
	self.leftButton.userInteractionEnabled = NO;
	self.rightButton.userInteractionEnabled = NO;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setDateFormat:@"yyyyMM"];
    NSString *str1= [formatter stringFromDate:aLogic.referenceDate];
    NSString *str2= [formatter stringFromDate:[NSDate date]];
    NSDate *date1 =[formatter dateFromString:str1];
    NSDate *date2 =[formatter dateFromString:str2];
    if(([date1 compare:date2] == NSOrderedDescending)) {
    }else {
        self.rightButton.enabled = YES;
    }
    if(([date1 compare:date2] == NSOrderedSame)){
    }
    
	CalendarMonth *aCalendarView = [[CalendarMonth alloc] initWithFrame:CGRectMake(15, 0, 560, 490) logic:aLogic :calArray :self];
    aCalendarView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
    aCalendarView.delegate = self;
	aCalendarView.userInteractionEnabled = NO;
	if ([self.calendarLogic distanceOfDateFromCurrentMonth:self.selectedDate] == 0) {
		[aCalendarView selectButtonForDate:self.selectedDate];
	}
	[self.viewBack insertSubview:aCalendarView belowSubview:self.calendarView];
    self.calendarViewNew = aCalendarView;
    
	if (animate)
    {
		[UIView beginAnimations:NULL context:self.viewBack];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationMonthSlideComplete)];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	}
    
	if (animate)
    {
		[UIView commitAnimations];
	}
    else
    {
		[self animationMonthSlideComplete];
	}
}

- (void)animationMonthSlideComplete
{
	[self.calendarView removeFromSuperview];
	self.calendarView = self.calendarViewNew;
	self.calendarViewNew = nil;
	self.leftButton.userInteractionEnabled = YES;
	self.rightButton.userInteractionEnabled = YES;
	self.calendarView.userInteractionEnabled = YES;
}

#pragma mark -
#pragma mark orientation Life Cycle
-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return NO;
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc 
{
	[objParser release];objParser=nil;
	[HUD release];HUD=nil;
	[strDate release];strDate=nil;
	[testArray release];testArray=nil;
	[calArray release];calArray=nil;
    [self.leftButton release];self.leftButton=nil;
    [self.rightButton release];self.rightButton=nil;
    
    [super dealloc];
}
@end
