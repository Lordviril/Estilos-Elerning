    //
//  LoadingScreen.m
//  eEducation
//
//  Created by Hidden Brains on 10/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoadingScreen.h"
#import "LoginScreen.h"

@implementation LoadingScreen

#pragma mark -
#pragma mark View Life Cycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.navigationController.navigationBar.hidden=YES;
    [lblLoading setText:[eEducationAppDelegate getLocalvalue:@"Loading"]];
	[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(LoginScreenPressed:) userInfo:nil repeats:NO];
}

-(void) viewWillAppear:(BOOL)animated {
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Action methods 

-(void) LoginScreenPressed:(id) sender
{
	LoginScreen *objLoginScreen=[[LoginScreen alloc] initWithNibName:@"LoginScreen" bundle:nil];
	[self.navigationController pushViewController:objLoginScreen animated:YES];
	[objLoginScreen release];
}

#pragma mark -
#pragma mark orientation Life Cycle

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}


#pragma mark -
#pragma mark Memory Management methods
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [super dealloc];
}


@end
