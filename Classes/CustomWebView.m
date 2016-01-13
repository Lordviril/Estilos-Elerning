//
//  CustomWebView.m
//  eEducation
//
//  Created by HB on 11/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomWebView.h"

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
@implementation CustomWebView


- (id)initWithFrame:(CGRect)frame andUrl:(NSString *)videoUrl 
{
	self = [super initWithFrame:frame];
	if (self) 
	{
		self.multipleTouchEnabled=YES;  
		self.exclusiveTouch=NO;
		//[self setOpaque:YES];
//		[self setBackgroundColor:[UIColor clearColor]];
		if (!SYSTEM_VERSION_LESS_THAN(@"4.0"))
		{
			self.allowsInlineMediaPlayback = TRUE;
		}
		[self adjustYouTube:videoUrl];
	}
	return self;
}

-(void)adjustYouTube:(NSString *)videoUrl
{
	self.delegate = self;
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	NSString *embedHTML = [NSString stringWithFormat:@"<html><head>"
						   "<body bgcolor=black><video controls=\"controls\" width=100%% height=96%%><source src=\"%@\" type=\"video/mp4\" /></video></body></html>",videoUrl];//UIWebViewNavigationTypeOther
	[self loadHTMLString:embedHTML baseURL:baseURL];
}
//width=100%% height=100%%  
- (BOOL)webView:(UIWebView *)myWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	//isPlaying = TRUE;
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
	HUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
	HUD.labelText = [eEducationAppDelegate getLocalvalue:@"Please wait"];
	[self addSubview:HUD];
	[HUD show:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
	[HUD hide:YES];
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[HUD hide:YES];
	UIAlertView *AlertView =  [[UIAlertView alloc]  initWithTitle:alertTitle message:[error localizedDescription] delegate:self cancelButtonTitle:nil 
												otherButtonTitles:[eEducationAppDelegate getLocalvalue:@"OK"], nil];
	AlertView.tag=111;
	[AlertView show];
	[AlertView release];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
}

- (void)dealloc 
{
	[super dealloc];
}

@end
