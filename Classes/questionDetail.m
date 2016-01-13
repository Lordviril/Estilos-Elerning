//
//  questionDetail.m
//  eEducation
//
//  Created by HB iMac on 07/01/12.
//  Copyright 2012 HiddenBrains. All rights reserved.
//

#import "questionDetail.h"
#import "DataBase.h"

@implementation questionDetail
@synthesize arrayQuestions =_arrayQuestions;
@synthesize test_id;
@synthesize delegate;
@synthesize remainingattempt;
@synthesize dictTestDetail=_dictTestDetail;
-(void)SubmitAnswer {

	NSString *str_answers = @""; 
	str_answers = [str_answers stringByAppendingFormat:@"<TestSubmitXml>"];
	for(int iCount = 0; iCount < [_arrayQuestions count]; iCount++)
	{
		str_answers = [str_answers stringByAppendingFormat:@"<AnswerDetails>"];
		str_answers = [str_answers stringByAppendingFormat:@"<user_id>%@</user_id>",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]];
		str_answers = [str_answers stringByAppendingFormat:@"<course_id>%@</course_id>",([_dictTestDetail objectForKey:@"course_id"])?[_dictTestDetail objectForKey:@"course_id"]:[[NSUserDefaults standardUserDefaults] objectForKey:@"course_id"]];
		str_answers = [str_answers stringByAppendingFormat:@"<editonid>%@</editonid>",([_dictTestDetail objectForKey:@"editonid"])?[_dictTestDetail objectForKey:@"editonid"]:[[NSUserDefaults standardUserDefaults] objectForKey:@"editonid"]];
		str_answers = [str_answers stringByAppendingFormat:@"<module_id>%@</module_id>",([_dictTestDetail objectForKey:@"module_id"])?[_dictTestDetail objectForKey:@"module_id"]:[[NSUserDefaults standardUserDefaults] objectForKey:@"module_id"]];
		str_answers = [str_answers stringByAppendingFormat:@"<exam_id>%@</exam_id>",[NSString stringWithFormat:@"%i",test_id]];
//		str_answers = [str_answers stringByAppendingFormat:@"<question_id>%@</question_id>",[[_arrayQuestions objectAtIndex:iCount] objectForKey:@"question_id"]];
//		str_answers = [str_answers stringByAppendingFormat:@"<Answer>%@</Answer>",[[[_arrayQuestions objectAtIndex:iCount] objectForKey:@"Answer"]  stringByReplacingOccurrencesOfString:@"," withString:@"||"]];
		str_answers = [str_answers stringByAppendingFormat:@"<Answer>%@</Answer>",[[_arrayQuestions objectAtIndex:iCount] objectForKey:@"Answer"]];
		str_answers = [str_answers stringByAppendingFormat:@"<TimeDuration>%@</TimeDuration>", [[NSUserDefaults standardUserDefaults] objectForKey:@"TimeDuration"]];
		str_answers = [str_answers stringByAppendingFormat:@"<remainingattempt>%@</remainingattempt>",([_dictTestDetail objectForKey:@"remainingattempt"])?[_dictTestDetail objectForKey:@"remainingattempt"]:remainingattempt];
		str_answers = [str_answers stringByAppendingFormat:@"<correctans>%@</correctans>", [[_arrayQuestions objectAtIndex:iCount] objectForKey:@"correctanswers"]];
//		str_answers = [str_answers stringByAppendingFormat:@"<question_title>%@</question_title>", [[_arrayQuestions objectAtIndex:iCount] objectForKey:@"question"]];
		str_answers = [str_answers stringByAppendingFormat:@"<question_id>%@</question_id>", [[_arrayQuestions objectAtIndex:iCount] objectForKey:@"question_id"]];
		str_answers = [str_answers stringByAppendingFormat:@"</AnswerDetails>"];
	}

	str_answers = [str_answers stringByAppendingFormat:@"</TestSubmitXml>"];
	NSData *data = [[NSData alloc] initWithData:[str_answers dataUsingEncoding:NSUTF8StringEncoding]];
 	NSString *filename = @"filename";
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[WebService getPostExamURL]stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionAllowLossy]]];
	[theRequest setHTTPMethod:@"POST"];
	NSString *boundary = @"---------------------------14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[theRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
	NSMutableData *postbody = [NSMutableData data];
	[postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
	[postbody appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postbody appendData:[NSData dataWithData:data]];
//	[data release];
	[postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[theRequest setHTTPBody:postbody];
	
	NSURLConnection *theConnection = [[[NSURLConnection alloc] initWithRequest:theRequest delegate:self] autorelease];
	if(theConnection){
		myWebData=[[NSMutableData alloc]  initWithLength:0];
	}
	///[objParser sendRequestToParse:strURL params:requestData];
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	for(int iCount = 0;iCount<[_arrayQuestions count];iCount++)
	{
		if([[_arrayQuestions objectAtIndex:iCount] objectForKey:@"Answer"])
			[DataBase addAnswerWithQuestionIdAndTestId:[[[_arrayQuestions objectAtIndex:iCount ] objectForKey:@"question_id"] intValue] 
												TestId:test_id answer:[[_arrayQuestions objectAtIndex:iCount ] objectForKey:@"Answer"] upload:0 edition_id:([_dictTestDetail objectForKey:@"editonid"])?[_dictTestDetail objectForKey:@"editonid"]:[[NSUserDefaults standardUserDefaults] objectForKey:@"editonid"]];
		//[DataBase addAnswerWithQuestionIdAndTestId: TestId:test_id answer:[[_arrayQuestions objectAtIndex:iCount ] objectForKey:@"Answer"] uploaded:];
	}
	if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(DidSubmitFail:)]){
		[self.delegate DidSubmitFail:@"0"];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	[myWebData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[myWebData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//int upload =0;
	NSString *str=[[NSString alloc] initWithBytes:[myWebData bytes] length:[myWebData length] encoding:NSStringEncodingConversionAllowLossy];
	SBJSON *json = [[SBJSON new] autorelease];	
	NSMutableArray *temp_array = [[NSMutableArray alloc] initWithArray:[json objectWithString:str error:nil]];
	if([temp_array count]>0 && [[[temp_array objectAtIndex:0] objectForKey:@"success"] isEqualToString:@"1"])
	{
			if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(DidSubmitSucesfully:)]){
				[self.delegate DidSubmitSucesfully:@"1"];
			}
			if(([[[temp_array objectAtIndex:0] valueForKey:@"attemptedcnt"] intValue])>=[[[temp_array objectAtIndex:0] valueForKey:@"totattempt"] intValue]){
				//delete question from data base
				
				[DataBase deleteQuestionData:test_id editionid:([_dictTestDetail objectForKey:@"editonid"])?[[_dictTestDetail objectForKey:@"editonid"] intValue]:[[[NSUserDefaults standardUserDefaults] objectForKey:@"editonid"]intValue]];
				//[DataBase deleteOfflineData:test_id isAttemptTest:YES];
			
			}else{
				//insert data into data base
				for(int iCount = 0;iCount<[_arrayQuestions count];iCount++)
				{
						[DataBase addAnswerWithQuestionIdAndTestId:[[[_arrayQuestions objectAtIndex:iCount ] objectForKey:@"question_id"] intValue] 
															TestId:test_id answer:@"" upload:2 edition_id:([_dictTestDetail objectForKey:@"editonid"])?[[_dictTestDetail objectForKey:@"editonid"] intValue]:[[[NSUserDefaults standardUserDefaults] objectForKey:@"editonid"] intValue]];
				}
			}
		
	}else{
        //Deleted MMM
//		[DataBase deleteQuestionData:[[[temp_array objectAtIndex:0] valueForKey:@"test_id"] intValue] editionid:([_dictTestDetail objectForKey:@"editonid"])?[[_dictTestDetail objectForKey:@"editonid"]intValue]:[[[NSUserDefaults standardUserDefaults] objectForKey:@"editonid"]intValue]];
		if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(DidSubmitSucesfully:)]){
			[self.delegate DidSubmitSucesfully:@"1"];
		}
	}
	[str release];	
	[temp_array release];
}

@end
