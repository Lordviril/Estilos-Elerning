//
//  AlertHandler.m
//  Court Finder
//
//  Created by hb hidden on 07/01/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AlertHandler.h"

#import "eEducationAppDelegate.h"
@implementation AlertHandler
UIAlertView *av;
UIActivityIndicatorView *actInd;

+(void)showAlertForProcess{
	if(av!=nil && [av retainCount]>0){ [av release]; av=nil; }
	if(actInd!=nil && [actInd retainCount]>0){ [actInd removeFromSuperview];[actInd release]; actInd=nil; }	
	av=[[UIAlertView alloc] initWithTitle:[eEducationAppDelegate getLocalvalue:@"Loading..."] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	actInd=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[actInd setFrame:CGRectMake(120, 50, 37, 37)];
	[actInd startAnimating];
	[av addSubview:actInd];
	[av show];
}

+(void)showAlertForProcesswithMessege:(NSString*)imessege{
	if(av!=nil && [av retainCount]>0){ [av release]; av=nil; }
	if(actInd!=nil && [actInd retainCount]>0){ [actInd removeFromSuperview];[actInd release]; actInd=nil; }	
	av=[[UIAlertView alloc] initWithTitle:imessege message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	//	[av setFrame:CGRectMake(120, 100, 37, 37)];
	actInd=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[actInd setFrame:CGRectMake(124, 64, 25,25)];
	[actInd startAnimating];
	[av addSubview:actInd];
	[av show];
}

+(void)hideAlert{
	[av dismissWithClickedButtonIndex:0 animated:YES];
	if(av!=nil && [av retainCount]>0){ [av release]; av=nil; }
	if(actInd!=nil && [actInd retainCount]>0){ [actInd removeFromSuperview];[actInd release]; actInd=nil; }	
}


+(void)ShowMessageBoxWithTitle:(NSString*)strTitle Message:(NSString*)strMessage Button:(NSString*)strButtonTitle{
	if(av!=nil && [av retainCount]>0){ [av release]; av=nil; }	
	av = [[UIAlertView alloc]initWithTitle:strTitle message:strMessage  delegate:nil cancelButtonTitle:strButtonTitle otherButtonTitles:nil];
	[av show];
}


@end
