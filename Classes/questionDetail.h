//
//  questionDetail.h
//  eEducation
//
//  Created by HB iMac on 07/01/12.
//  Copyright 2012 HiddenBrains. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"

@protocol QuestionDelegate <NSObject>
-(void)DidSubmitSucesfully:(NSString*)sucess;
-(void)DidSubmitFail:(NSString*)error;
@end

@interface questionDetail : NSObject {
	NSMutableData *myWebData;
	NSMutableArray *_arrayQuestions;
	NSInteger test_id;
	id<QuestionDelegate>delegate;
	NSString *remainingattempt;
	NSMutableDictionary *_dictTestDetail;
}
@property(nonatomic,retain)NSMutableDictionary *dictTestDetail;
@property (nonatomic,retain)NSMutableArray *arrayQuestions;
@property (nonatomic,retain)id<QuestionDelegate>delegate;
@property (nonatomic, retain) NSString *remainingattempt;
@property (readwrite)NSInteger test_id;

-(void)SubmitAnswer;

@end
