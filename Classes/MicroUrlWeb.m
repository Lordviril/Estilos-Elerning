    //
//  MicroUrlWeb.m
//  eEducation
//
//  Created by HB iMac on 15/02/12.
//  Copyright 2012 HiddenBrains. All rights reserved.
//

#import "MicroUrlWeb.h"


@implementation MicroUrlWeb

@synthesize microUrlString=_microUrlString;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad {
    [super viewDidLoad];
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	HUD.labelText=[eEducationAppDelegate getLocalvalue:@"Please wait"];
	[Web_view setDelegate:self];
	[HUD show:YES];
	[_btnBack setImage:[eEducationAppDelegate GetLocalImage:@"btn-back"] forState:0];
	[_btnBack setImage:[eEducationAppDelegate GetLocalImage:@"btn-back_h"] forState:1];
	NSURL *url =[NSURL URLWithString:[self.microUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[Web_view loadRequest:requestObj];
	[Web_view setScalesPageToFit:YES];
}


- (void)viewWillDisappear:(BOOL)animated {
	[Web_view loadRequest:nil];
//    [Web_view loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
}


- (void)webViewDidStartLoad:(UIWebView *)webViews{
	
}

- (void)webViewDidFinishLoad:(UIWebView *)webViews{
	[HUD hide:YES];
}
- (void)webView:(UIWebView *)webViews didFailLoadWithError:(NSError *)error{
	[HUD hide:YES];
}

-(IBAction)gotoBack:(id)sender{
	[self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return NO;
}


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
	[Web_view release];
	[HUD release];
    [super dealloc];
}


@end
