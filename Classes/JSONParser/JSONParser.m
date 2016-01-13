//
//  JSONParser.m
//  Scanner
//
//  Created by hb3 on 27/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JSONParser.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

#define DELEGATE_CALLBACK(X, Y) if (self.delegate && [self.delegate respondsToSelector:@selector(X)]) [self.delegate performSelector:@selector(X) withObject:Y];

@implementation JSONParser

@synthesize urlString;
@synthesize delegate;

- (void) sendRequestToParse:(NSString*)StrURL params:(NSDictionary*)parameters
{
    if(![WebService checkForNetworkStatus])
    {
        if ([delegate respondsToSelector:@selector(parserDidFailWithRestoreError::)]) {
            [delegate parserDidFailWithRestoreError:nil :[eEducationAppDelegate getLocalvalue:@"No internet connection. Please try later!"]];
        } else {
            [delegate parserDidFailWithRestoreError:nil];
        }
        return;
    }
	self.urlString = StrURL;
//	NSLog(@"URL:- %@",self.urlString);
	
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES;	
  	
	NSString *httpBody = @"";
	NSArray *KeyArray = [parameters allKeys];
	for ( int i = 0 ; i < [KeyArray count]; i++ )
	{
		httpBody = [httpBody stringByAppendingFormat:@"&%@=%@" , [KeyArray objectAtIndex:i] , [parameters objectForKey:[KeyArray objectAtIndex:i] ]];
	}
//    NSLog(@"Parameters : %@",httpBody);
	ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:self.urlString]];
	[request appendPostData:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
	[request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
	[request setRequestMethod:@"POST"];
	[request setDelegate:self];
	//[request setTimeOutSeconds:60]; 
	[request startAsynchronous];
}

- (void) sendRequestToPostImage:(NSString*)StrURL params:(NSDictionary*)parameters :(NSData*)data
{
	self.urlString = StrURL;
//    NSLog(@"%@",self.urlString);
	NSArray *KeyArray = [parameters allKeys];
    self.request_fromdata = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    self.request_fromdata.timeOutSeconds = 180;
    for(int i=0; i<[KeyArray count]; i++)
    {
        [ self.request_fromdata addPostValue:[parameters objectForKey:[KeyArray objectAtIndex:i]] forKey:[KeyArray objectAtIndex:i]];
    }
    [self.request_fromdata setData:data forKey:@"userImage"];
	[ self.request_fromdata setDelegate:self];
	[ self.request_fromdata startAsynchronous];
}

#pragma mark - ASIHTTPRequest delegate
- (void)requestFinished:(ASIHTTPRequest *)request 
{
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = NO;	
	// Use when fetching text data
	NSData *webData = [[NSData alloc] initWithData:[request responseData]];
	NSString *strEr =  [[[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding] autorelease];
	[webData release];
	//DO something with webData
    if ([delegate respondsToSelector:@selector(parserDidFinishLoadingReturnData:wsName:)]) {
        [delegate parserDidFinishLoadingReturnData:strEr wsName:self.wsName];
    } else {
        [delegate parserDidFinishLoadingReturnData:strEr];
    }
}

/*
 The async request to get new data failed
 */
- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
//    NSLog(@"%@", error);
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = NO;
	
    if ([delegate respondsToSelector:@selector(parserDidFailWithRestoreError::)]) {
        [delegate parserDidFailWithRestoreError:nil :@""];
    } else {
        [delegate parserDidFailWithRestoreError:error];
    }

}

@end
