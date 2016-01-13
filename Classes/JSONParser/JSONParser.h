//
//  JSONParser.h
//  Scanner
//
//  Created by hb3 on 27/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@protocol JSONParserDelegate <NSObject>
@optional
- (void)parserDidFinishLoadingReturnData:(NSString *)responseString;
- (void)parserDidFinishLoadingReturnData:(NSString *)responseString wsName:(NSString*)wsName;
- (void)parserDidFailWithRestoreError:(NSError*)error;
- (void)parserDidFailWithRestoreError:(NSError*)error :(NSString*)msg;

@end

@interface JSONParser : NSObject 
{
	NSURLResponse *response;
	NSString *urlString;
	NSURLConnection *urlconnection;
	id <JSONParserDelegate> delegate;
	NSString *reasonToFail;
}
@property (nonatomic,retain) ASIFormDataRequest *request_fromdata;
@property (retain) NSString *urlString;
@property (nonatomic,retain) NSString *wsName;
@property (retain) id delegate;

- (void) sendRequestToParse:(NSString*)StrURL params:(NSDictionary*)parameters;
- (void) sendRequestToPostImage:(NSString*)StrURL params:(NSDictionary*)parameters :(NSData*)data;

@end
