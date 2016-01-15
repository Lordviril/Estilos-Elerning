//
//  Alert.m
//  eEducation
//
//  Created by hb12 on 07/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Alert.h"
#import"AlertCustomCell.h"
#import"Settings.h"
#import"ICourseList.h"
#import"eEducationAppDelegate.h"
#import "WebService.h"
#import <QuartzCore/QuartzCore.h>
#import "ModuleHomePage.h"

@implementation Alert
- (void)viewDidLoad 
{
    [super viewDidLoad];
	appDelegate=(eEducationAppDelegate*)[[UIApplication sharedApplication]delegate];
	lblAlertDescription.text=@"";
	
	objParser = [[JSONParser alloc] init];
	objParser.delegate = self;
}

-(void) viewWillAppear:(BOOL)animated {
    [self.btnHome setTitle:[eEducationAppDelegate getLocalvalue:@"HOME"] forState:UIControlStateNormal];
    [self.btnPopUpCancel setTitle:[[eEducationAppDelegate getLocalvalue:@"Cancel"] uppercaseString] forState:UIControlStateNormal];

    [self.lblTopCourse setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"course_name"]];
    [self.lblTopDuration setText:[NSString stringWithFormat:RTLableText,[eEducationAppDelegate getLocalvalue:@"Begins "],[eEducationAppDelegate convertString:[[NSUserDefaults standardUserDefaults] valueForKey:@"edition_start"] fromFormate:@"yyyy-MM-dd" toFormate:@"dd MMMM yyyy"],[eEducationAppDelegate getLocalvalue:@"- Ends "],[eEducationAppDelegate convertString:[[NSUserDefaults standardUserDefaults] valueForKey:@"edition_end"] fromFormate:@"yyyy-MM-dd" toFormate:@"dd MMMM yyyy"]]];
    [self.imgProfile loadImageFromURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"user_profile_image"]] imageName:@"no-image-200x200.png"];
    self.lblProfileBlueName.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_name"];
    [self.imgLogo loadImageFromURL:[eEducationAppDelegate getTopCourseUrl] imageName:@"top-bar-logo.png"];
    [self.imgLogoStatic loadImageFromURL:[eEducationAppDelegate getTopStaticUrl] imageName:@"logo_top_static.png"];
    [self.btnModule setTitle:[[eEducationAppDelegate getLocalvalue:@"Module"] uppercaseString] forState:UIControlStateNormal];
    
	self.lblTitle.text = [[eEducationAppDelegate getLocalvalue:@"Alerts"] uppercaseString];
	
    [self callAlertsWs];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - Webservice Call
-(void)callAlertsWs{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
    HUD.labelText = [eEducationAppDelegate getLocalvalue:@"Please wait"];
	[HUD show:YES];

	NSString *strURL = [WebService getAlertList];
	NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"course_id"],@"course_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] ,@"user_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"editonid"],@"edition_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language",
								 nil];
	
	[objParser sendRequestToParse:strURL params:requestData];
}

#pragma mark - Parser delegate method
-(void)parserDidFinishLoadingReturnData:(NSString *)responseString
{
	SBJSON *json = [SBJSON new];	
	alertArray = [[NSMutableArray alloc] initWithArray:[json objectWithString:responseString error:nil]];
	if([alertArray count]){
		if([[[alertArray objectAtIndex:0] objectForKey:@"success"] isEqualToString:@"0"]){
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"No alerts available for this user."] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
			alert.tag=104;
			[alert show];
			alertArray=nil;
		}
		else{
			NSDateFormatter *_dateFormater=[[NSDateFormatter alloc] init];
            [_dateFormater setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
			[_dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
			NSDate *date=[_dateFormater dateFromString:[[alertArray objectAtIndex:0] objectForKey:@"calendar_date"]];
			[_dateFormater setDateFormat:@"dd-MM-yyyy"];
			if([[[alertArray objectAtIndex:0] objectForKey:@"calendar_date"] length]>0){
				lblAlertName.text=[[[alertArray objectAtIndex:0] objectForKey:@"alert_name"]stringByAppendingFormat:@" (%@)",[_dateFormater stringFromDate:date]];
			}else{
				lblAlertName.text=[[alertArray objectAtIndex:0] objectForKey:@"alert_name"];
			}
            
			istable_reloadfirsttime=FALSE;
			lblAlertDescription.text=[[[alertArray objectAtIndex:0] objectForKey:@"description"]stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
			
			float height=0;
			NSString *description=@"";
			description=[[[alertArray objectAtIndex:0] objectForKey:@"description"]stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
			
			CGSize  textSize = {200, 10000.0};
			CGSize size = [description sizeWithFont:[UIFont boldSystemFontOfSize:13]
								  constrainedToSize:textSize 
									  lineBreakMode:UILineBreakModeCharacterWrap];
			
			height = size.height;
			NSArray *arr = [description componentsSeparatedByString:@"\n"];
			NSInteger count = [arr count];
			if (count>1) {
				count=count-1;
			}
			height=count*10+50+height;
			if([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown ){
				if(height<69){
					height=78;
				}else if(height>=660){
					height=660;
				}
			}else{
				if(height<69){
					height=78;
				}else if(height>=430){
					height=430;
				}
			}
			lblAlertDescription.frame=CGRectMake(lblAlertDescription.frame.origin.x, lblAlertDescription.frame.origin.y, lblAlertDescription.frame.size.width,height);
			[tblView reloadData];
            [tblView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
		}
	}
	else {
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"No alerts available for this user."] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
		alert.tag=103;
		[alert show];
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
}


#pragma mark -
#pragma mark Action Method

-(IBAction)btnCourse_Clicked:(id)sender
{
}

-(IBAction)btnCancelViewalert:(UIButton*)sender
{

        [UIView beginAnimations:@"removeFromSuperviewWithAnimation" context:nil];
        
        [UIView setAnimationDelegate:self];
        
        [UIView setAnimationDuration:0.4];
        [AlertDetailView setAlpha:0];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView commitAnimations];
}

-(IBAction)btnRemove_Clicked:(id)sender
{
	UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"Are you sure to delete selected alert.?"] delegate:self	 cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"NO"]  otherButtonTitles:[eEducationAppDelegate getLocalvalue:@"YES"],nil];
	[alert show];
	alert.tag=99;
}

-(void)btnViewAlertClicked:(UIButton*)sender
{
    selectedIndex = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    [self tableView:tblView didSelectRowAtIndexPath:selectedIndex];
}

#pragma mark - Other methods
- (void)animationDidStop:(NSString *)animationID
                finished:(NSNumber *)finished
                 context:(void *)context {
    if ([animationID isEqualToString:@"removeFromSuperviewWithAnimation"]) {
        [AlertDetailView removeFromSuperview];
        [AlertDetailView setAlpha:1];
    }
}

- (void)presentWithSuperview:(UIView *)superview {
    // Set initial location at bottom of superview
    CGRect frame ;
    frame = CGRectMake(0, 0, 768, 1024);
    frame.origin = CGPointMake(0.0, 1024);
    alertBox.layer.cornerRadius = 5;
    
    [AlertDetailView setBackgroundColor:[UIColor colorWithWhite:0.000 alpha:0.700]];
    AlertDetailView.frame = frame;
    [superview addSubview:AlertDetailView];
    
    alertBox.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        alertBox.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // do something once the animation finishes, put it here
    }];
    frame.origin = CGPointZero;
    AlertDetailView.frame = frame;
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark  UIAlertViewDelegate methods 
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	if(alertView.tag==TAG_FailError){
		if(buttonIndex==0)
			[appDelegate GoTOLoginScreen:NO];
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
    } else 	if(alertView.tag==99 && buttonIndex!=0)
	{
		if ([alertArray count]>0) 
		{
			[alertArray removeObjectAtIndex:index];
			
			if ([alertArray count]>0) 
			{
				lblAlertDate.text=[[alertArray objectAtIndex:0] objectForKey:@"alert_date"];
				lblAlertName.text=[[alertArray objectAtIndex:0] objectForKey:@"alert_name"];
				lblAlertDescription.text=[[[alertArray objectAtIndex:0] objectForKey:@"description"]stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
			}
			index=0;
			[tblView reloadData]; 
		}
	}
}

#pragma mark -
#pragma mark tableView Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (alertArray.count == 0){
        return 0;
    }
    else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if (section == 0){
        return alertArray.count;
    }
    else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell addSubview:self.viewLoadMore];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
	static NSString *CellIdentifier = @"AlertCustomCelll";
	AlertCustomCell *cell = (AlertCustomCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{	
	   cell = (AlertCustomCell*)[[[NSBundle mainBundle] loadNibNamed:@"AlertCustomCell" owner:self options:nil] lastObject];
        [cell.btnViewAlert setTitle:[eEducationAppDelegate getLocalvalue:@"SEE ALERT"] forState:UIControlStateNormal];
        [cell.btnViewAlert setTitle:[eEducationAppDelegate getLocalvalue:@"SEE ALERT"] forState:UIControlStateHighlighted];
        [cell.btnViewAlert addTarget:self action:@selector(btnViewAlertClicked:) forControlEvents:UIControlEventTouchUpInside];
	}
    cell.btnViewAlert.tag = indexPath.row;
	cell.lblAlert.text=[[alertArray objectAtIndex:indexPath.row] objectForKey:@"alert_name"];
	cell.lblDate.text=[NSString stringWithFormat:@"%@ %@",[eEducationAppDelegate getLocalvalue:@"Date"],[eEducationAppDelegate convertString:[[alertArray objectAtIndex:indexPath.row] objectForKey:@"alert_date"] fromFormate:@"yyyy-MM-dd HH:mm:ss" toFormate:@"dd/MM/yyyy"]];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        return 45;
    }
	return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        [self callAlertsWs];
    } else{
        [self presentWithSuperview:self.tabBarController.view];
        selectedIndex=indexPath;
        if([[[alertArray objectAtIndex:indexPath.row] objectForKey:@"calendar_date"] length]>0){
            lblAlertName.text=[[alertArray objectAtIndex:indexPath.row] objectForKey:@"alert_name"];
        }else{
            lblAlertName.text=[[alertArray objectAtIndex:indexPath.row] objectForKey:@"alert_name"];
        }
        lblAlertDescription.text=[[[alertArray objectAtIndex:indexPath.row] objectForKey:@"description"] stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        lblAlertDate.text = [eEducationAppDelegate convertString:[[alertArray objectAtIndex:indexPath.row] objectForKey:@"alert_date"] fromFormate:@"yyyy-MM-dd HH:mm:ss" toFormate:@"dd/MM/yyyy"];
        ////
        float height=0;
        NSString *description=@"";
        description=[[[alertArray objectAtIndex:indexPath.row] objectForKey:@"description"]stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        
        CGSize  textSize = { 200, 10000.0 };
        CGSize size = [description sizeWithFont:[UIFont boldSystemFontOfSize:13]
                              constrainedToSize:textSize
                                  lineBreakMode:UILineBreakModeCharacterWrap];
        
        height = size.height;
        NSArray *arr = [description componentsSeparatedByString:@"\n"];
        NSInteger count = [arr count];
        if (count>1) {
            count=count-1;
        }
        height=count*10+50+height;
        if([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown ){
            if(height<69){
                height=78;
            }else if(height>=660){
                height=660;
            }
        }else{
            if(height<69){
                height=78;
            }else if(height>=430){
                height=430;
            }
        }	
        index=indexPath.section;
    }
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
}

-(IBAction)proImgClicked:(id)sender{
    [self btnSettingsClicked:nil];
}

-(IBAction)btnSettingsClicked:(id)sender{
    Settings *objSettings = [[Settings alloc] initWithNibName:@"Settings" bundle:nil];
    [[validations getAppDelegateInstance] removePresentVC];
	[[validations getAppDelegateInstance].navigationController pushViewController:objSettings animated:NO];
}

-(IBAction)btnLogoutClicked:(id)sender{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"You're about to logout, are you sure?"] delegate:self	 cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"NO"]  otherButtonTitles:[eEducationAppDelegate getLocalvalue:@"YES"],nil];
	[alert show];
	alert.tag=TAG_ALERT_LOGOUT;
}

-(IBAction)btnModuleClicked:(id)sender{
    ModuleHomePage *objModuleListHomePage=[[ModuleHomePage alloc] initWithNibName:@"ModuleHomePage" bundle:nil];
    [[validations getAppDelegateInstance] removePresentVC];
	[[validations getAppDelegateInstance].navigationController pushViewController:objModuleListHomePage animated:NO];
}

-(void)btnDescClicked:(UIButton*)sender{
    AsyncImageView *cell = (AsyncImageView*)[self.view viewWithTag:(sender.tag-9900)];
    UIViewController *tableViewController = [[UIViewController alloc] init];
    tableViewController.view.frame = CGRectMake(0,0, 280, 100); // height should be dynamic
    
    UITextView *txtDesc = [[UITextView alloc] initWithFrame:CGRectMake(0,0, 280, 80)];
    txtDesc.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna taur cillium adipisicing pecu";
    txtDesc.font = [UIFont fontWithName:@"HelveticaNeue" size:38];
    txtDesc.userInteractionEnabled = NO;
    txtDesc.backgroundColor = [UIColor clearColor];
    txtDesc.textColor = [UIColor whiteColor];
    txtDesc.scrollEnabled = true;
    [tableViewController.view addSubview:txtDesc];
    
    TSPopoverController *popoverController = [[TSPopoverController alloc] initWithContentViewController:tableViewController];
    popoverController.cornerRadius = 5;
    popoverController.titleText = @"Nomber de Estudiante";
    popoverController.popoverBaseColor = [UIColor colorWithRed:0.369 green:0.772 blue:0.904 alpha:0.900];
    popoverController.popoverGradient= NO;
    [popoverController showPopoverInView:cell];
}

#pragma mark -
#pragma mark orientation Life Cycle
-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown )
	{
		lblAlertName.frame=CGRectMake(31, 32, 392,44);
	}
	else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
	{
		lblAlertName.frame=CGRectMake(31, 32, 560,44);
	}
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
}

@end
