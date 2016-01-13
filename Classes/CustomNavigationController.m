    //
//  CustomNavigationController.m
//  eEducation
//
//  Created by HB14 on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomNavigationController.h"
#import "ICourseList.h"
#import "Settings.h"
#import "DownloadedDocument.h"
@implementation CustomNavigationController

@synthesize btnLogo;
@synthesize lblHead;
@synthesize btnSettings;
@synthesize btnHome;
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	//[self.navigationBar setBackgroundColor:[UIColor blackColor]];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"topbar.png"]]];
    appDelegate=(eEducationAppDelegate *)[[UIApplication sharedApplication] delegate];
	//UIImageView *backimg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 44)];
	//backimg.image=[UIImage imageNamed:@"topbar.png"];
	//backimg.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
  //  [self.navigationBar addSubview:backimg];
	//[backimg release];
	[self.navigationBar setTintColor:[UIColor whiteColor]];
	if ([[UINavigationBar class] respondsToSelector:@selector(appearance)])
	{
		[[UINavigationBar appearance] setBackgroundColor:[UIColor whiteColor]];
	}
	btnLogo=[[UIImageView alloc] init];
	btnLogo.frame=CGRectMake(15, 2, 69, 40);
	btnLogo.tag=BUTTON_LOGO_TAG;
	[btnLogo setContentMode:UIViewContentModeCenter];
	[btnLogo setImage:[UIImage imageNamed:@"top-bar-logo.png"]];
	[self.navigationBar addSubview:btnLogo];
	
	lblHead=[[UILabel alloc] initWithFrame:CGRectMake(138, 0, 499, 44)];
	lblHead.tag=LABEL_TITLE_TAG;
	lblHead.textAlignment=UITextAlignmentCenter;
	lblHead.textColor=[UIColor blackColor];
	lblHead.font=[UIFont boldSystemFontOfSize:18.0];
	lblHead.backgroundColor=[UIColor clearColor];
	[self.navigationBar addSubview:lblHead];
	
	btnSettings=[UIButton buttonWithType:UIButtonTypeCustom];
	btnSettings.frame=CGRectMake(730, 13, 21, 20);
	btnSettings.tag=BUTTON_SETTINGS_TAG;
	[btnSettings setImage:[UIImage imageNamed:@"icon_setting_blue@2x.png"] forState:UIControlStateNormal];
	[btnSettings setImage:[UIImage imageNamed:@"icon_setting_blue_h@2x.png"] forState:UIControlStateHighlighted];
	[btnSettings addTarget:self action:@selector(btn_settingsPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.navigationBar addSubview:btnSettings];
	
	btnHome=[UIButton buttonWithType:UIButtonTypeCustom];
	btnHome.frame=CGRectMake(151, 8, 23, 28);
	btnHome.tag=BUTTON_HOME_TAG;
	[btnHome addTarget:self action:@selector(btnHome_Clicked:) forControlEvents:UIControlEventTouchUpInside];
	[btnHome setImage:[UIImage imageNamed:@"icon_home.png"] forState:UIControlStateNormal];
//	[self.navigationBar addSubview:btnHome];
	
}
-(void) viewWillAppear:(BOOL)animated
{	
	[self.visibleViewController viewWillAppear:YES];
//	[self willAnimateRotationToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0.2];
}
#pragma mark -
#pragma mark Action Method
-(IBAction)btnCourse_Clicked:(id)sender{
//Murali
//	[appDelegate.window addSubview:appDelegate.navigationController.view];
//	[appDelegate.tabBarController.view removeFromSuperview];
}

-(void) btn_settingsPressed:(id)sender
{
	Settings *objSettings=[[Settings alloc] initWithNibName:@"Settings" bundle:nil];
	objSettings.hidesBottomBarWhenPushed=YES;
	[self pushViewController:objSettings animated:YES];
	[objSettings release];
}
-(IBAction)btnHome_Clicked:(id)sender
{
	
//	NSArray *viewContrlls=[[appDelegate navigationController] viewControllers];
//	
//	for( int i=0;i<[ viewContrlls count];i++)
//	{
//		id obj=[viewContrlls objectAtIndex:i];
//		if([[NSUserDefaults standardUserDefaults] boolForKey:@"isNetworkAvailble"])
//		{
//			[appDelegate.window addSubview:appDelegate.navigationController.view];
//			[appDelegate.tabBarController.view removeFromSuperview];
//			if([obj isKindOfClass:[ICourseList class]] )
//			{
//				[[appDelegate navigationController] popToViewController:obj animated:YES];
//				return;
//			}
//		}
//		else 
//		{
//			if([obj isKindOfClass:[DownloadedDocument class]] )
//			{
//				[[appDelegate navigationController] popToViewController:obj animated:YES];
//				return;
//			}
//			
//		}
//		
//	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return NO;
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown )
	 {
		 btnLogo.frame=CGRectMake(10, 9, 111, 26);
		 lblHead.frame=CGRectMake(138, 0, 499, 44);
		 btnSettings.frame=CGRectMake(730, 8, 21, 20);
		 btnHome.frame=CGRectMake(144, 8, 23, 28);	 
	 }
	 else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight )
	 {
		 btnLogo.frame=CGRectMake(10, 9, 111, 26);
		 lblHead.frame=CGRectMake(138, 0, 755, 44);
		 btnSettings.frame=CGRectMake(986, 8, 21, 20);
		 btnHome.frame=CGRectMake(144, 8, 23, 28);	 
	 }
	
	if([self.visibleViewController respondsToSelector:@selector(willAnimateRotationToInterfaceOrientation:duration:)])
	{
		[self.visibleViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:0.2];
	}
}

#pragma mark -
#pragma mark Memory Management methods

- (void)didReceiveMemoryWarning 
{
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
	[lblHead release];
    [super dealloc];
}


@end
