//
//  LoginScreen.m
//  eEducation
//
//  Created by Hidden Brains on 10/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import "LoginScreen.h"
#import "CourseList.h"
#import "ICourseList.h"
#import "myVariables.h"
#import "StringEncryption.h"

#define SYSTEM_VERSION_LESS_THAN(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@implementation LoginScreen

#pragma mark -
#pragma mark View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"IS_AUTO_LOGIN"] isEqualToString:@"YES"]) {
        ICourseList *objIcourseList=[[ICourseList alloc] initWithNibName:@"ICourseList" bundle:nil];
        [self.navigationController pushViewController:objIcourseList animated:NO];
        [objIcourseList release];
    }
    ObjmyVariables=[myVariables sharedInstance];
    appDelegate=(eEducationAppDelegate *)[[UIApplication sharedApplication] delegate];
    objParser = [[JSONParser alloc] init];
    objParser.delegate = self;
	objquestionDetail=[[questionDetail alloc] init];
	objquestionDetail.delegate=self;
    
    youTubePlayer.opaque = NO;
    youTubePlayer.scrollView.showsVerticalScrollIndicator =NO;
    youTubePlayer.scrollView.bounces = NO;
    
    isPlaying = FALSE;
	if (!SYSTEM_VERSION_LESS_THAN(@"4.0"))
	{
		youTubePlayer.allowsInlineMediaPlayback = TRUE;
	}
    tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    tapRec.delegate = self;
    [self.view addGestureRecognizer:tapRec];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerWillEnterFullscreen)
                                                 name:@"UIMoviePlayerControllerDidEnterFullscreenNotification"
                                               object:nil];
}

-(void) viewWillAppear:(BOOL)animated
{
	[self setLocalizedText];
	self.navigationController.navigationBarHidden=YES;
    if (!isPlaying)
	{
		[self loadVideoView];
	}
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
}

- (void)viewDidUnload {
    [self dealloc];
    [super viewDidUnload];
}

#pragma mark - Other methods
-(void)tap
{
    [self.view endEditing:YES];
}

/**
 *  Load text as per selected language
 */
-(void)setLocalizedText
{
    [btn_Login setTitle:[[eEducationAppDelegate getLocalvalue:@"LOGIN"] uppercaseString] forState:UIControlStateNormal];
    self.lbl1.text=[eEducationAppDelegate getLocalvalue:@"staticText1"];
    self.lbl2.text=[eEducationAppDelegate getLocalvalue:@"staticText2"];
	self.lbl3.text=[eEducationAppDelegate getLocalvalue:@"staticText3"];
    
	txt_UserName.placeholder=[eEducationAppDelegate getLocalvalue:@"USERNAME"];
	txt_PassWord.placeholder=[eEducationAppDelegate getLocalvalue:@"PASSWORD"];    
}

-(void)DidSubmitSucesfully:(NSString*)sucess{}
-(void)DidSubmitFail:(NSString*)error{}


-(void)playerWillEnterFullscreen{
    [self.view endEditing:YES];
}


-(void)releaseObjects {
    //    NSLog(@"Delete started");
    image_BackGround=nil;
    btn_Login=nil;
    txt_UserName=nil;
    txt_PassWord=nil;
    image_logo=nil;
    image_lineForgot=nil;
    internetReachable=nil;
    hostReachable=nil;
    ObjmyVariables=nil;
    appDelegate=nil;
    SettingsData=nil;
    objParser=nil;
    ArrayResponse=nil;
    HUD=nil;
    objquestionDetail=nil;
    youTubePlayer=nil;
    //    NSLog(@"Delete completed");
}

#pragma mark - Gesture recognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]] || [touch.view isKindOfClass:[UITextField class]] || [touch.view isKindOfClass:[UIWebView class]]) {
        return NO; // ignore the touch
    }
    [self.view endEditing:YES];
    return YES; // handle the touch
}

#pragma mark -
#pragma mark Action methods
/**
 *  Fires on click of Login button
 *
 *  @param sender btnLogin
 */
-(IBAction) login_BtnPressed:(id) sender
{
    [self loadVideoView];
    if(![validations isValidData:txt_UserName.text] || ![validations isValidData:txt_PassWord.text])
    {
        NSString *alertMessage=@"";
        if(![validations isValidData:txt_UserName.text])
        {
            alertMessage=[eEducationAppDelegate getLocalvalue:@"Please enter username."];
            [txt_UserName becomeFirstResponder];
        }
        else if(![validations isValidData:txt_PassWord.text])
        {
            alertMessage=[eEducationAppDelegate getLocalvalue:@"Please enter password."];
            [txt_PassWord becomeFirstResponder];
        }
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
		[alert show];
		[alert release];
    }
	else
	{
		if([WebService checkForNetworkStatus])
		{
			HUD = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
			HUD.labelText=[eEducationAppDelegate getLocalvalue:@"Please wait"];
            
			NSString *strURL =[WebService GetLoginXml];
			NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:
                                         txt_PassWord.text, @"password",
                                         txt_UserName.text, @"username",
                                         nil];
			[objParser sendRequestToParse:strURL params:requestData];
		}
		else
		{
            UIAlertView *AlertView =  [[UIAlertView alloc]  initWithTitle:alertTitle
                                                                  message:[eEducationAppDelegate getLocalvalue:@"No internet connection. Please try later!"]
                                                                 delegate:nil
                                                        cancelButtonTitle:nil
                                                        otherButtonTitles:[eEducationAppDelegate getLocalvalue:@"OK"], nil];
            [AlertView show];
            [AlertView release];
		}
	}
}

#pragma mark -
#pragma mark JSONParser delegate method
- (void)parserDidFinishLoadingReturnData:(NSString *)responseString
{
    NSLog(@"%@",responseString);
    [HUD setHidden:YES];
	SBJSON *json = [[SBJSON new] autorelease];
	ArrayResponse = (NSMutableArray*) [json objectWithString:responseString error:nil];
	[ArrayResponse retain];
	if([ArrayResponse count]>0)
	{
		NSMutableDictionary *dict=[ArrayResponse objectAtIndex:0];
		if([[dict  objectForKey:@"message"] isEqualToString:@"You are successfully logged In."])
		{
			[[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"user_id"] forKey:@"user_id"];
            [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"name"] forKey:@"user_name"];
            [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"profile_image"] forKey:@"user_profile_image"];
            [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"user_type"] forKey:@"user_type"];
            [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"header_image"] forKey:@"header_image"];
			[[NSUserDefaults standardUserDefaults] synchronize];
            
            ICourseList *objIcourseList=[[ICourseList alloc] initWithNibName:@"ICourseList" bundle:nil];
            [self.navigationController pushViewController:objIcourseList animated:YES];
            [objIcourseList release];
		}
		else
		{
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:[dict  objectForKey:@"message"]] delegate:nil cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}
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

#pragma mark -
#pragma mark TextFeild Delegate methods
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (txt_UserName == textField) {
        [txt_PassWord becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
	return YES;
}

#pragma mark -
#pragma mark orientation Life Cycle

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
	}
	else {
	}
    if (!isPlaying)
	{
		[self loadVideoView];
	}
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

#pragma mark -
#pragma mark Memory Management methods
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark WebView Delegate methods
- (void)webViewDidFinishLoad:(UIWebView *)_webView
{
}

- (BOOL)webView:(UIWebView *)myWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	isPlaying = TRUE;
	return YES;
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	UIAlertView *AlertView =  [[UIAlertView alloc]  initWithTitle:alertTitle message:[error localizedDescription] delegate:nil cancelButtonTitle:nil
												otherButtonTitles:[eEducationAppDelegate getLocalvalue:@"OK"], nil];
	[AlertView show];
	[AlertView release];
}

/**
 *  Loads video to the webView
 */
-(void)loadVideoView
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"Formacin_Online" ofType:@"mp4"];
    
    NSString *embedHTML = [NSString stringWithFormat:@"<html>\
                           <head>\
                           <style type=\"text/css\">\
                           body {background-color:#000; margin:0;}\
                           </style>\
                           </head>\
                           <body>\
                           <video width=\"%f\" height=\"%f\" controls=\"controls\" id='videoSize'>\
                           <source src=\"%@\" type=\"video/mp4\" autoplay=\"autoplay\" />\
                           </video>\
                           </body>\
                           </html>", youTubePlayer.frame.size.width, youTubePlayer.frame.size.height, path];
    [youTubePlayer loadHTMLString:embedHTML baseURL:[NSURL fileURLWithPath:path]];
}

- (void)dealloc {
	[image_BackGround release];image_BackGround=nil;
	[txt_UserName release];txt_UserName=nil;
	[txt_PassWord release];txt_PassWord=nil;
	[image_logo release];image_logo=nil;
	[image_lineForgot release];image_lineForgot=nil;
	[SettingsData release];SettingsData=nil;
	[objParser release];objParser=nil;
	[ArrayResponse release];ArrayResponse=nil;
	[HUD release];HUD=nil;
	[objquestionDetail release];objquestionDetail=nil;
    [youTubePlayer release];youTubePlayer=nil;
    [tapRec release];tapRec=nil;
    [super dealloc];
}
@end