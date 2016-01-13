//
//  YouTubePlayer.m
//  VideoApp
//
//  Created by hb3 on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YouTubePlayer.h"
#import "eEducationAppDelegate.h"
#import "JSON.h"
#import <QuartzCore/QuartzCore.h>

#define SYSTEM_VERSION_LESS_THAN(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@implementation YouTubePlayer

@synthesize strMovieURL, strTitle, playedFromLocal,strVimeoID;
@synthesize isFromTabbar;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{	
	return NO;
}

- (void)viewDidLoad 
{	
	[super viewDidLoad];
	HUD = [MBProgressHUD showHUDAddedTo:[youTubePlayer superview] animated:YES];
	HUD.labelText = [eEducationAppDelegate getLocalvalue:@"Please wait"];
	isPlaying = FALSE;
	if (!SYSTEM_VERSION_LESS_THAN(@"4.0"))
	{
		youTubePlayer.allowsInlineMediaPlayback = TRUE;
	}
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.btnBack setTitle:[eEducationAppDelegate getLocalvalue:@"BackAtrás"] forState:UIControlStateNormal];
	[UIApplication sharedApplication].statusBarHidden=NO;
    if (!isPlaying)
	{
		[self adjustYouTube];
	}
}

-(IBAction)btnBackClicked:(id)sender
{
    [self removeView];
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)removeView{
    [self.navigationController.navigationBar viewWithTag:BUTTON_HOME_TAG].hidden=NO;
	[self.navigationController.navigationBar viewWithTag:BUTTON_LOGO_TAG].hidden=NO;
	[self.navigationController.navigationBar viewWithTag:BUTTON_SETTINGS_TAG].hidden=NO;
	[youTubePlayer setDelegate:nil];
	[youTubePlayer loadHTMLString:@"" baseURL:nil];
	[BtnBack removeFromSuperview];
}

-(void)viewWillDisappear:(BOOL)animated
{
}

- (UIButton *)findButtonInView:(UIView *)view
{
	UIButton *button = nil;
	if ([view isMemberOfClass:[UIButton class]])
	{
		return (UIButton *)view;
	}	
	if (view.subviews && [view.subviews count] > 0)
	{
		for (UIView *subview in view.subviews)
		{
			button = [self findButtonInView:subview];
			if (button) return button;
		}
	}		
	return button;
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView
{		
	UIButton *b = [self findButtonInView:_webView];
	[b sendActionsForControlEvents:UIControlEventTouchUpInside];
	 if([strMovieURL rangeOfString:@"flv"].location!=NSNotFound)
	 {
        UIAlertView *AlertView =  [[UIAlertView alloc]  initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"Video format is not supported."] delegate:self cancelButtonTitle:nil otherButtonTitles:[eEducationAppDelegate getLocalvalue:@"OK"], nil];
		 AlertView.tag=111;
		[AlertView show];
		[AlertView release];
	}
	[HUD hide:YES];
}

#pragma mark -
#pragma mark Other methods
- (BOOL)webView:(UIWebView *)myWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{	
	isPlaying = TRUE;
	return YES;
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	UIAlertView *AlertView =  [[UIAlertView alloc]  initWithTitle:alertTitle message:[error localizedDescription] delegate:self cancelButtonTitle:nil
												otherButtonTitles:[eEducationAppDelegate getLocalvalue:@"OK"], nil];
	AlertView.tag=111;
	[AlertView show];
	[AlertView release];
}

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if(alertView.tag = 111)
	{
        [self removeView];
		[self.navigationController popViewControllerAnimated:YES];
	}
}

-(void)adjustYouTube
{    
//    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:@"Mozilla/5.0 (iPhone; CPU iPhone OS 6_1_2 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Mobile/10B146 [FBAN/FBIOS;FBAV/6.5.1;FBBV/377040;FBDV/iPhone2,1;FBMD/iPhone;FBSN/iPhone OS;FBSV/6.1.2;FBSS/1; FBCR/o2-de;FBID/phone;FBLC/de_DE;FBOP/5]", @"User-Agent", nil];
//    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    NSString *embedHTML;
    if ([strMovieURL rangeOfString:@"youtu"].location != NSNotFound)
    {
        embedHTML = [NSString stringWithFormat:@"\
                     <html>\
                     <head>\
                     <style type=\"text/css\">\
                     iframe {position:absolute; align:center}\
                     body {background-color:#000; margin:0;}\
                     </style>\
                     </head>\
                     <body>\
                     <iframe width=\"%f\" height=\"%f\" src=\"%@\" id='videoSize' frameborder=\"0\" autoplay=\"autoplay\" allowfullscreen></iframe>\
                     </body>\
                     </html>", youTubePlayer.frame.size.width, youTubePlayer.frame.size.height, [self getFinalMediaUrl:strMovieURL]];
    }
    else
    {
        embedHTML = [NSString stringWithFormat:@"\
                     <html>\
                     <head>\
                     <style type=\"text/css\">\
                     iframe {position:absolute; align:center}\
                     body {background-color:#000; margin:0;}\
                     </style>\
                     </head>\
                     <body>\
                     <iframe src=\"http://comunicacionyformacion.es/formacion/content/video/free?id=%@\" width=\"%f\" height=\"%f\" frameborder=\"0\" webkitallowfullscreen mozallowfullscreen allowfullscreen ></iframe>\
                     </body>\
                     </html>",strMovieURL, youTubePlayer.frame.size.width, youTubePlayer.frame.size.height-self.navigationController.navigationBar.frame.size.height];
    }
    [youTubePlayer loadHTMLString:embedHTML baseURL:baseURL];
    
//    NSString *embedHTML = [NSString stringWithFormat:@"\
//                 <html>\
//                 <head>\
//                 <style type=\"text/css\">\
//                 iframe {position:absolute; align:center}\
//                 body {background-color:#000; margin:0;}\
//                 </style>\
//                 </head>\
//                 <body>\
//                 <iframe width=\"%f\" height=\"%f\" src=\"%@\" id='videoSize' frameborder=\"0\" autoplay=\"autoplay\" allowfullscreen></iframe>\
//                 </body>\
//                 </html>", youTubePlayer.frame.size.width, youTubePlayer.frame.size.height, [self getFinalMediaUrl:strMovieURL]];
//	[youTubePlayer loadHTMLString:embedHTML baseURL:baseURL];
}

- (NSString *)getFinalMediaUrl:(NSString *)strCurrentUrl
{
    if ([self.youtube_id length] > 0)
    {
        NSString *apiMethodStr = [NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/videos/%@?v=2&alt=json", self.youtube_id];
        NSString *fetchedProperies = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiMethodStr] encoding:NSUTF8StringEncoding error:nil];
        if (fetchedProperies)
        {
            return [NSString stringWithFormat:@"http://www.youtube.com/embed/%@", self.youtube_id];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"Unsupported youtube url."] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
			[alert show];
			[alert release];
        }
    }
    else
    {
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=v(=|/))([-a-zA-Z0-9_]+)|(?<=youtube/)([-a-zA-Z0-9_]+)" options: NSRegularExpressionCaseInsensitive error:&error];
        NSTextCheckingResult *match = [regex firstMatchInString:strCurrentUrl options:0 range:NSMakeRange(0, [strCurrentUrl length])];
        if (match)
        {
            NSRange videoIDRange = [match rangeAtIndex:0];
            NSString *videoID = [strCurrentUrl substringWithRange:videoIDRange];
            NSString *apiMethodStr = [NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/videos/%@?v=2&alt=json", videoID];
            NSString *fetchedProperies = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiMethodStr] encoding:NSUTF8StringEncoding error:nil];
            if (fetchedProperies)
            {
                return [NSString stringWithFormat:@"http://www.youtube.com/embed/%@", videoID];
            }
            else
            {
                return strCurrentUrl;
            }
        }
        else
        {
            return strCurrentUrl;
        }
    }
    return @"";
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
	if (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
	{
		youTubePlayer.frame = CGRectMake(0, 0, 1024, 748);
	}
	if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		youTubePlayer.frame = CGRectMake(0, 0, 768, 950);
	}
	if (!isPlaying)
	{
		[self adjustYouTube];
	}
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud
{
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
//	[HUD release];
}

#pragma mark -
#pragma mark Memory Management
- (void)didReceiveMemoryWarning 
{
	[super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
	[super viewDidUnload];
}

- (void)dealloc 
{
	[youTubePlayer release];
	youTubePlayer=nil;
	[super dealloc];	
}

@end
