//
//  DataBase.h
//  eEducation
//
//  Created by HB 13 on 20/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "questionDetail.h"

@interface DataBase : NSObject<QuestionDelegate> {

}
+(NSString *)getDBPath;

#pragma mark -
#pragma mark Test DB Method
+(void)addTestDetails:(NSMutableArray *)arrayTest;
+(NSMutableArray *)readalltestDetails;
+(void)addQuestionsToDB:(NSMutableArray *)arrayQuestions  testId:(int)testID edition_id:(int)edition_id;
+(void)addAnswerWithQuestionIdAndTestId:(int)QuestyionId TestId:(int)testID answer:(NSString *)answerSting upload:(NSInteger)_uploaded;
+(void)addAnswerWithQuestionIdAndTestId:(int)QuestyionId TestId:(int)testID answer:(NSString *)answerSting upload:(NSInteger)_uploaded edition_id:(int)edition_id;
//+(NSMutableArray *)readQuestionsForTestId:(int)testId _bool:(BOOL)_bool;
+(NSMutableArray *)readalltestDetailsWirhTestId:(int)testID edition:(int)editionId;
+(void)updateTestDetail:(NSMutableDictionary*)arrayTest;
+(int)getCountOfQuestionDetail:(int)testID edition_id:(int)edition_id;
+(void)readallAttemptedTest;
+(void)deleteattemptQuestionData:(NSString*)test_Id;
+(void)readallOfflineUploadedTest;
#pragma mark -
#pragma mark Documents DB Method
+(void)addDocumentDetailsToDB:(NSMutableDictionary*)docDetails isVirtual:(int)isVirtual;
+(NSMutableArray *)readAllDocumentDetais;
+(BOOL) iscontainThisRecord:(int) doc_id;
+(BOOL) iscontainRecord:(int) doc_id docName:(NSString*)doc_Name;
#pragma mark -
#pragma mark Search DB Method
+(NSMutableArray *)readDocumentSearchResults:(NSString *)str_query;
+(NSMutableArray *)readTestSearchResults:(NSString *)str_query;


#pragma mark -
#pragma mark Login DB Method
+(NSMutableArray *)readUserDetailsWithMailId:(NSString *)str_mail;
+(void)addUserDetails:(NSString *)str_userName password:(NSString *)str_password;
+(BOOL)test_Exists:(NSInteger)_test_ID;

+(NSMutableArray *)readQuestionsForTestId:(int)testId _bool:(BOOL)_bool vUploaded:(NSInteger)vUploaded edition_id:(int)edition_id;

//delete data offline
+(void)deleteOfflineData:(NSInteger)document_Id isAttemptTest:(BOOL)_isAttemptTest editionId:(int)editionid;
+(void)deleteQuestionData:(NSInteger)test_Id editionid:(int)edition_id;



@end
