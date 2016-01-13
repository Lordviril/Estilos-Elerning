//
//  DataBase.m
//  eEducation
//
//  Created by HB 13 on 20/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataBase.h"
#import <sqlite3.h>


static sqlite3  *database = nil;
static sqlite3_stmt  *sqliteStatement = nil;
@implementation DataBase

+(NSString *)getDBPath
{
	NSString *databaseName=@"eEducation_DB.sqlite";
	NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDirectory, YES);
	NSString *documentsDir=[documentPaths objectAtIndex:0];
	NSString *databasePath=[documentsDir stringByAppendingPathComponent:databaseName];
	return databasePath;
}

#pragma mark -
#pragma mark Test DB Method
+(void)addTestDetails:(NSMutableArray *)arrayTest 
{
	for(int i =0 ;i<[arrayTest count];i++)
	{
		if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
			const char *sql;
			if([self test_Exists:[[[arrayTest objectAtIndex:i] objectForKey:@"test_id"]intValue]])
			{
				sqlite3_reset(sqliteStatement);
				sqliteStatement=nil;
				sqlite3_close(database);
				[self updateTestDetail:[arrayTest objectAtIndex:i]];
			}
			else
			{
				sql = "insert into TestDetails(test_id, test_name, test_details, totattempt, attemptedcnt, module_name, course_name,user_id,vLang_Id,timeDuration,course_id,module_id,edition_id,endDate,editionName) Values(?, ?, ?, ?, ?, ?, ?,?,?,?,?,?,?,?,?)";
				if(sqlite3_prepare_v2(database, sql, -1, &sqliteStatement, NULL) != SQLITE_OK)
					NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
				sqlite3_bind_int(sqliteStatement, 1, [[[arrayTest objectAtIndex:i] objectForKey:@"test_id"] intValue]);
				sqlite3_bind_text(sqliteStatement, 2, [[[arrayTest objectAtIndex:i] objectForKey:@"test_name"] UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(sqliteStatement, 3, [[eEducationAppDelegate removeIllegalCharters:[[arrayTest objectAtIndex:i] objectForKey:@"test_details"] ] UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_int(sqliteStatement, 4, [[[arrayTest objectAtIndex:i] objectForKey:@"totattempt"] intValue]);
				sqlite3_bind_int(sqliteStatement, 5, [[[arrayTest objectAtIndex:i] objectForKey:@"attemptedcnt"] intValue]);
				sqlite3_bind_text(sqliteStatement, 6, [[[NSUserDefaults standardUserDefaults] objectForKey:@"module_name"] UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(sqliteStatement, 7, [[[NSUserDefaults standardUserDefaults] objectForKey:@"course_name"] UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_int(sqliteStatement, 8, [[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"] intValue]);
				sqlite3_bind_int(sqliteStatement, 9, [[[NSUserDefaults standardUserDefaults]objectForKey:@"vLang"]intValue]);
				sqlite3_bind_text(sqliteStatement, 10, [[[NSUserDefaults standardUserDefaults] objectForKey:@"TimeDuration"] UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_int(sqliteStatement, 11, [[[NSUserDefaults standardUserDefaults] objectForKey:@"course_id"] intValue]);
				sqlite3_bind_int(sqliteStatement, 12, [[[NSUserDefaults standardUserDefaults] objectForKey:@"module_id"] intValue]);
				sqlite3_bind_int(sqliteStatement, 13, [[[NSUserDefaults standardUserDefaults] objectForKey:@"editonid"] intValue]);
				sqlite3_bind_text(sqliteStatement, 14, [[[arrayTest objectAtIndex:i] objectForKey:@"enddate"] UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(sqliteStatement, 15, [[[NSUserDefaults standardUserDefaults] objectForKey:@"edition"] UTF8String], -1, SQLITE_TRANSIENT);
		
				//int i=sqlite3_step(sqliteStatement);
				if(SQLITE_DONE != sqlite3_step(sqliteStatement))
					NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
				sqlite3_reset(sqliteStatement);
				sqliteStatement=nil;
			}
		}
	}
	sqlite3_close(database);
	[self readallAttemptedTest];
}


+(void)updateTestDetail:(NSMutableDictionary*)arrayTest{
	if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
		NSString *sqlNsStr = [NSString stringWithFormat:@"update  TestDetails set attemptedcnt = %i,test_details='%@',totattempt=%i,endDate='%@' where test_id = %i AND user_id =%i AND VLang_Id=%i AND edition_id = %i",[ [arrayTest objectForKey:@"attemptedcnt"]intValue],[arrayTest objectForKey:@"test_details"],[ [arrayTest objectForKey:@"totattempt"]intValue],[arrayTest objectForKey:@"enddate"],[[arrayTest objectForKey:@"test_id"] intValue],[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"]intValue],[[[NSUserDefaults standardUserDefaults]objectForKey:@"vLang"]intValue],[[[NSUserDefaults standardUserDefaults] objectForKey:@"editonid"] intValue]];
		const char *sqlStatement = [sqlNsStr cStringUsingEncoding:NSUTF8StringEncoding];
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &sqliteStatement, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
		if(SQLITE_DONE != sqlite3_step(sqliteStatement))
			NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
		sqlite3_reset(sqliteStatement);
		sqliteStatement=nil;
	}
	sqlite3_close(database);

}

+(BOOL)test_Exists:(NSInteger)_test_ID{
	BOOL _exists=FALSE;
	NSString *sqlNsStr = [NSString stringWithFormat:@"SELECT  * from TestDetails where user_id = %d AND test_id = %d AND vLang_Id = %i AND edition_id = %i",[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"] intValue],_test_ID,[[[NSUserDefaults standardUserDefaults]objectForKey:@"vLang"]intValue],[[[NSUserDefaults standardUserDefaults]objectForKey:@"editonid"]intValue]];
	const char *sqlStatement = [sqlNsStr cStringUsingEncoding:NSUTF8StringEncoding];
	if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &sqliteStatement, NULL) == SQLITE_OK) {
			while(sqlite3_step(sqliteStatement) == SQLITE_ROW) {
				_exists = TRUE;
			}
		}
			
		sqlite3_reset(sqliteStatement);
		sqliteStatement=nil;
		}
	sqlite3_close(database);
	return _exists;
}

+(NSMutableArray *)readalltestDetails
{
	NSMutableArray *ary_test  = [[NSMutableArray alloc] init];
	NSString *sqlNsStr = [NSString stringWithFormat:@"SELECT  * from TestDetails where user_id=%i AND vLang_Id=%i",[[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]intValue],[[[NSUserDefaults standardUserDefaults]objectForKey:@"vLang"]intValue]];
	const char *sqlStatement = [sqlNsStr cStringUsingEncoding:NSUTF8StringEncoding];
	if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &sqliteStatement, NULL) == SQLITE_OK) {
			while(sqlite3_step(sqliteStatement) == SQLITE_ROW) {
				NSMutableDictionary *dic = [[NSMutableDictionary alloc ]init];
				
				int testId = sqlite3_column_int(sqliteStatement, 7);
				NSString *testName =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 0)];
				NSString *test_details =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 1)];
				int totattempt = sqlite3_column_int(sqliteStatement, 2);
				int attemptedcnt = sqlite3_column_int(sqliteStatement, 3);
				NSString *module_name =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 4)];
				NSString *course_name =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 5)];
				int login = sqlite3_column_int(sqliteStatement, 6);
				int course_id=sqlite3_column_int(sqliteStatement,10);
				int module_id=sqlite3_column_int(sqliteStatement,11);
				int edition_id=sqlite3_column_int(sqliteStatement,12);
				NSString *editionName =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 14)];
				NSString *endDate= [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 13)];
				[dic setObject:[NSString stringWithFormat:@"%@",endDate] forKey:@"enddate"];
				[dic setObject:[NSString stringWithFormat:@"%i",course_id] forKey:@"course_id"];
				[dic setObject:[NSString stringWithFormat:@"%i",module_id] forKey:@"module_id"];
				[dic setObject:[NSString stringWithFormat:@"%i",edition_id] forKey:@"editonid"];
				[dic setObject:[NSString stringWithFormat:@"%i",testId] forKey:@"test_id"];
				[dic setObject:testName forKey:@"test_name"];
				[dic setObject:test_details forKey:@"test_details"];
				[dic setObject:module_name forKey:@"module_name"];
				[dic setObject:course_name forKey:@"course_name"];
				[dic setObject:[NSString stringWithFormat:@"%i",totattempt] forKey:@"totattempt"];
				[dic setObject:[NSString stringWithFormat:@"%i",attemptedcnt] forKey:@"attemptedcnt"];
				[dic setObject:[NSString stringWithFormat:@"%i",login] forKey:@"_LoginId"];
				[dic setObject:[NSString stringWithFormat:@"%@",editionName] forKey:@"edition"];
				[ary_test addObject:dic];
				[dic release];
			}
		}
		sqlite3_reset(sqliteStatement);
		sqliteStatement=nil;
	}
	sqlite3_close(database);
	return [ary_test autorelease];
}

//new  function  16 March
//get all offline uploaded question

+(void)readallOfflineUploadedTest{
	NSMutableArray *ary_test  = [[NSMutableArray alloc] init];
	NSString *sqlNsStr = [NSString stringWithFormat:@"select DISTINCT(QuestionsDetails.edition_id),TestDetails.attemptedcnt,TestDetails.totattempt,TestDetails.course_id,TestDetails.test_id,TestDetails.module_id,(TestDetails.totattempt - TestDetails.attemptedcnt) AS remainingAttempt from QuestionsDetails , TestDetails where QuestionsDetails.test_id = TestDetails.test_id AND QuestionsDetails.edition_id = TestDetails.edition_id AND TestDetails.user_id=%i AND QuestionsDetails.vUploaded=0",[[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]intValue]];
	const char *sqlStatement = [sqlNsStr cStringUsingEncoding:NSUTF8StringEncoding];
	if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &sqliteStatement, NULL) == SQLITE_OK) {
			while(sqlite3_step(sqliteStatement) == SQLITE_ROW) {
				NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
				int testId = sqlite3_column_int(sqliteStatement, 4);
				int attemptCnt=sqlite3_column_int(sqliteStatement, 1);
		 	    int tot_attempt=sqlite3_column_int(sqliteStatement,2);
				int course_id=sqlite3_column_int(sqliteStatement,3);
				int edition_id=sqlite3_column_int(sqliteStatement,0);
				int module_id=sqlite3_column_int(sqliteStatement,5);
				int remaining_attempt=sqlite3_column_int(sqliteStatement,6);
				[dic setObject:[NSString stringWithFormat:@"%i",course_id] forKey:@"course_id"];
				[dic setObject:[NSString stringWithFormat:@"%i",module_id] forKey:@"module_id"];
				[dic setObject:[NSString stringWithFormat:@"%i",edition_id] forKey:@"editonid"];
				[dic setObject:[NSString stringWithFormat:@"%i",remaining_attempt] forKey:@"remainingattempt"];
				[dic setObject:[NSString stringWithFormat:@"%i",testId] forKey:@"test_id"];
				[dic setObject:[NSString stringWithFormat:@"%i",attemptCnt] forKey:@"attemptedcnt"];
				[dic setObject:[NSString stringWithFormat:@"%i",tot_attempt] forKey:@"totattempt"];
				[ary_test addObject:dic];
				[dic release];
			}
		}
		sqlite3_reset(sqliteStatement);
		sqliteStatement=nil;
	}
	sqlite3_close(database);
	questionDetail *objquestionDetail=[[questionDetail alloc] init];
	for(int i=0;i<[ary_test count];i++){
			objquestionDetail.test_id=[[[ary_test objectAtIndex:i] valueForKey:@"test_id"]intValue];
			objquestionDetail.arrayQuestions=[self readQuestionsForTestId:[[[ary_test objectAtIndex:i] valueForKey:@"test_id"]intValue] _bool:TRUE vUploaded:0 edition_id:[[[ary_test objectAtIndex:i] valueForKey:@"editonid"]intValue]];
			objquestionDetail.dictTestDetail=[ary_test objectAtIndex:i];
			[objquestionDetail SubmitAnswer];
		}
	[ary_test release];
	[objquestionDetail release];
}

+(void)readallAttemptedTest{
	//NSMutableArray *ary_test  = [[[NSMutableArray alloc] init] autorelease];
	NSString  *testId=@"";

	NSString *sqlNsStr = [NSString stringWithFormat:@"SELECT GROUP_CONCAT(DISTINCT QuestionsDetails.edition_id) FROM QuestionsDetails, TestDetails WHERE QuestionsDetails.test_id = TestDetails.test_id AND QuestionsDetails.edition_id = TestDetails.edition_id AND TestDetails.totattempt <=TestDetails.attemptedcnt AND TestDetails.user_id=%i",[[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]intValue]];
	const char *sqlStatement = [sqlNsStr cStringUsingEncoding:NSUTF8StringEncoding];
	if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &sqliteStatement, NULL) == SQLITE_OK) {
			while(sqlite3_step(sqliteStatement) == SQLITE_ROW) {
				if(sqlite3_column_text(sqliteStatement, 0))
					testId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 0)];
			}
		}
		sqlite3_reset(sqliteStatement);
		sqliteStatement=nil;
	}
	sqlite3_close(database);
	//for(int i=0;i<[ary_test count];i++){
	if([testId length]>0)
		[self deleteattemptQuestionData:testId];
	//}
	//[self readallOfflineUploadedTest];
}


+(NSMutableArray *)readalltestDetailsWirhTestId:(int)testID edition:(int)editionId
{
	NSMutableArray *ary_test  = [[NSMutableArray alloc] init];
	NSString *sqlNsStr = [NSString stringWithFormat:@"SELECT  * from TestDetails WHERE test_id = %i AND user_id = %i AND vLang_Id=%i AND edition_id=%i",testID,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]intValue],[[[NSUserDefaults standardUserDefaults]objectForKey:@"vLang"]intValue],editionId];
	const char *sqlStatement = [sqlNsStr cStringUsingEncoding:NSUTF8StringEncoding];
	if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &sqliteStatement, NULL) == SQLITE_OK) {
			while(sqlite3_step(sqliteStatement) == SQLITE_ROW) {
				NSMutableDictionary *dic = [[NSMutableDictionary alloc ]init];
				
				int testId = sqlite3_column_int(sqliteStatement, 7);
				NSString *testName =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 0)];
				NSString *test_details =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 1)];
				int totattempt = sqlite3_column_int(sqliteStatement, 2);
				int attemptedcnt = sqlite3_column_int(sqliteStatement, 3);
				NSString *module_name =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 4)];
				NSString *course_name =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 5)];
				int login = sqlite3_column_int(sqliteStatement, 6);
				int course_id=sqlite3_column_int(sqliteStatement,10);
				int module_id=sqlite3_column_int(sqliteStatement,11);
				int edition_id=sqlite3_column_int(sqliteStatement,12);
				NSString *endDate= [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 13)];
				[dic setObject:[NSString stringWithFormat:@"%i",course_id] forKey:@"course_id"];
				[dic setObject:[NSString stringWithFormat:@"%i",module_id] forKey:@"module_id"];
				[dic setObject:[NSString stringWithFormat:@"%i",edition_id] forKey:@"editonid"];
				[dic setObject:[NSString stringWithFormat:@"%i",login] forKey:@"_LoginId"];
				[dic setObject:[NSString stringWithFormat:@"%i",testId] forKey:@"test_id"];
				[dic setObject:testName forKey:@"test_name"];
				[dic setObject:test_details forKey:@"test_details"];
				[dic setObject:module_name forKey:@"module_name"];
				[dic setObject:course_name forKey:@"course_name"];
				[dic setObject:[NSString stringWithFormat:@"%i",totattempt] forKey:@"totattempt"];
				[dic setObject:[NSString stringWithFormat:@"%i",attemptedcnt] forKey:@"attemptedcnt"];
				[dic setObject:[NSString stringWithFormat:@"%@",endDate] forKey:@"enddate"];
//				[dic setObject:course_name forKey:@"timeDuration"];
				[ary_test addObject:dic];
				[dic release];
			}
		}
		sqlite3_reset(sqliteStatement);
		sqliteStatement=nil;
	}
	sqlite3_close(database);
	return [ary_test autorelease];
}


+(int)getCountOfQuestionDetail:(int)testID edition_id:(int)edition_id{
	int count=0;
	if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
		NSString *sqlNsStr = [NSString stringWithFormat:@"select count(*) from QuestionsDetails where test_id = %i AND user_id = %i AND vUploaded = 0 AND edition_id=%i", testID,[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"]intValue],edition_id];
		const char *sqlStatement = [sqlNsStr cStringUsingEncoding:NSUTF8StringEncoding];
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &sqliteStatement, NULL) == SQLITE_OK) {
			while(sqlite3_step(sqliteStatement) == SQLITE_ROW) {
				if(sqlite3_column_text(sqliteStatement, 0))
					count = sqlite3_column_int(sqliteStatement, 0);
			}
		}
		sqlite3_reset(sqliteStatement);
		sqliteStatement=nil;
		sqlite3_close(database);
	}
	return count;
}


//Function add question modify march 17 HB

+(void)addQuestionsToDB:(NSMutableArray *)arrayQuestions  testId:(int)testID edition_id:(int)edition_id
{
	int count=0;
	//if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
//		NSString *sqlNsStr = [NSString stringWithFormat:@"select count(*) from QuestionsDetails where test_id = %i AND user_id = %i AND vUploaded = 0", testID,[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"]intValue]];
//		const char *sqlStatement = [sqlNsStr cStringUsingEncoding:NSUTF8StringEncoding];
//		if(sqlite3_prepare_v2(database, sqlStatement, -1, &sqliteStatement, NULL) == SQLITE_OK) {
//			while(sqlite3_step(sqliteStatement) == SQLITE_ROW) {
//				if(sqlite3_column_text(sqliteStatement, 0))
//					count = sqlite3_column_int(sqliteStatement, 0);
//			}
//		}
//		sqlite3_reset(sqliteStatement);
//		sqliteStatement=nil;
//		
//	}
	count=[self getCountOfQuestionDetail:testID edition_id:edition_id];
	
		if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
			NSString *sqlNsStr = [NSString stringWithFormat:@"delete from QuestionsDetails where test_id = %i AND user_id = %i AND  vUploaded <> 0 AND edition_id=%i", testID,[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"]intValue],edition_id];
			const char *sqlStatement = [sqlNsStr cStringUsingEncoding:NSUTF8StringEncoding];
			if(sqlite3_prepare_v2(database, sqlStatement, -1, &sqliteStatement, NULL) != SQLITE_OK){
				NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
			}
			if(SQLITE_DONE != sqlite3_step(sqliteStatement))
				NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
			sqlite3_reset(sqliteStatement);
			sqliteStatement=nil;
		}
		
	if(count==0)
	{
		//for(int i =0 ;i<[arrayQuestions count];i++)
//		{
//			if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
//				const char *sql = "insert into QuestionsDetails(question_id, test_id, question_type, question, options, correctanswers,user_id,vUploaded,optionsid) Values(?, ?, ?, ?, ?, ?,?,?,?)";
//				if(sqlite3_prepare_v2(database, sql, -1, &sqliteStatement, NULL) != SQLITE_OK){
//					NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
//				}
//				sqlite3_bind_int(sqliteStatement, 1, [[[arrayQuestions objectAtIndex:i] objectForKey:@"question_id"] intValue]);
//				sqlite3_bind_int(sqliteStatement, 2, testID);
//				sqlite3_bind_text(sqliteStatement, 3, [[[arrayQuestions objectAtIndex:i] objectForKey:@"question_type"] UTF8String], -1, SQLITE_TRANSIENT);
//				sqlite3_bind_text(sqliteStatement, 4, [[[arrayQuestions objectAtIndex:i] objectForKey:@"question"]UTF8String], -1, SQLITE_TRANSIENT );
//				sqlite3_bind_text(sqliteStatement, 5, [[[arrayQuestions objectAtIndex:i] objectForKey:@"options"]UTF8String], -1, SQLITE_TRANSIENT );
//				sqlite3_bind_text(sqliteStatement, 6, [[[arrayQuestions objectAtIndex:i] objectForKey:@"correctanswers"]UTF8String], -1, SQLITE_TRANSIENT);
//				sqlite3_bind_int(sqliteStatement, 7, [[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"] intValue]);
//				sqlite3_bind_int(sqliteStatement, 8, 1);
//				sqlite3_bind_text(sqliteStatement, 9, [[[arrayQuestions objectAtIndex:i] objectForKey:@"optionsid"]UTF8String], -1, SQLITE_TRANSIENT);
//				//int i=sqlite3_step(sqliteStatement);
//				if(SQLITE_DONE != sqlite3_step(sqliteStatement))
//					NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
//				sqlite3_reset(sqliteStatement);
//				sqliteStatement=nil;
//			}		
//		}

	//for multiple insertion check union query
		
		NSString *newSqlString=@"insert into QuestionsDetails(question_id, test_id, question_type, question, options, correctanswers,user_id,vUploaded,optionsid,edition_id)";
		for(int i =0 ;i<[arrayQuestions count];i++)
		{
			newSqlString=[newSqlString stringByAppendingFormat:@" SELECT '%@','%i','%@','%@','%@','%@','%@','1','%@','%i' UNION ALL ",[[arrayQuestions objectAtIndex:i] objectForKey:@"question_id"],
						  testID,[[arrayQuestions objectAtIndex:i] objectForKey:@"question_type"],[[arrayQuestions objectAtIndex:i] objectForKey:@"question"]
						  ,[[arrayQuestions objectAtIndex:i] objectForKey:@"options"],
						  [[arrayQuestions objectAtIndex:i] objectForKey:@"correctanswers"],
						  [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"],[[arrayQuestions objectAtIndex:i] objectForKey:@"optionsid"],edition_id];
		}
		
		newSqlString = [newSqlString stringByPaddingToLength:([newSqlString length]-[@"UNION" length]-5) withString: @"" startingAtIndex:0];
		if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
			const char *sql = [newSqlString cStringUsingEncoding:NSUTF8StringEncoding];
			if(sqlite3_prepare_v2(database, sql, -1, &sqliteStatement, NULL) != SQLITE_OK){
				NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
			}
			if(SQLITE_DONE != sqlite3_step(sqliteStatement))
				NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
			sqlite3_reset(sqliteStatement);
			sqliteStatement=nil;
		}		
	}
		sqlite3_close(database);
}

+(void)addAnswerWithQuestionIdAndTestId:(int)QuestyionId TestId:(int)testID answer:(NSString *)answerSting upload:(NSInteger)_uploaded edition_id:(int)edition_id
{
	if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
		NSString *sqlNsStr = [NSString stringWithFormat:@"update  QuestionsDetails set Answer = '%@',vUploaded = %i where question_id = %i and test_id = %i AND user_id =%i AND edition_id = %i", answerSting,_uploaded,QuestyionId,testID,[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"]intValue],edition_id];
		const char *sqlStatement = [sqlNsStr cStringUsingEncoding:NSUTF8StringEncoding];
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &sqliteStatement, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
		if(SQLITE_DONE != sqlite3_step(sqliteStatement))
			NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
		sqlite3_reset(sqliteStatement);
		sqliteStatement=nil;
	}
	sqlite3_close(database);
}

+(NSMutableArray *)readQuestionsForTestId:(int)testId _bool:(BOOL)_bool vUploaded:(NSInteger)vUploaded edition_id:(int)edition_id
{
	NSMutableArray *ary_questions  = [[NSMutableArray alloc] init];
	NSString *sqlNsStr =@"";
	if(_bool){
		sqlNsStr = [NSString stringWithFormat:@"SELECT  * from QuestionsDetails where test_id =%i AND vUploaded = %i AND user_id = %i AND edition_id=%i",testId,vUploaded,[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"]intValue],edition_id];
	}else{
		sqlNsStr = [NSString stringWithFormat:@"SELECT  * from QuestionsDetails where test_id = %i AND user_id = %i AND edition_id =%i",testId,[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"]intValue],edition_id];
	}
	const char *sqlStatement = [sqlNsStr cStringUsingEncoding:NSUTF8StringEncoding];
	if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &sqliteStatement, NULL) == SQLITE_OK) {
			while(sqlite3_step(sqliteStatement) == SQLITE_ROW) {
				NSMutableDictionary *dic = [[NSMutableDictionary alloc ]init];
				
				int question_id = sqlite3_column_int(sqliteStatement, 0);
				int testId = sqlite3_column_int(sqliteStatement, 1);
				NSString *question_type =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 2)];
				NSString *question =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 3)];
				NSString *options =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 4)];
				NSString *correctanswers =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 5)];
				NSString *Answer =@"";
				if(sqlite3_column_text(sqliteStatement, 6))
				{
					Answer = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 6)];
				}
				NSString *optionsId =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 9)];
				int uploaded = sqlite3_column_int(sqliteStatement, 8);
				int edition = sqlite3_column_int(sqliteStatement, 9);
				[dic setObject:[NSString stringWithFormat:@"%i",edition] forKey:@"editonid"];
				[dic setObject:[NSString stringWithFormat:@"%i",question_id] forKey:@"question_id"];
				[dic setObject:[NSString stringWithFormat:@"%i",testId] forKey:@"test_id"];
				[dic setObject:question_type forKey:@"question_type"];
				[dic setObject:question forKey:@"question"];
				[dic setObject:options forKey:@"options"];
				[dic setObject:correctanswers forKey:@"correctanswers"];
				[dic setObject:optionsId forKey:@"optionsid"];
				if([Answer length]>0)
				[dic setObject:Answer forKey:@"Answer"];
				[dic setObject:[NSString stringWithFormat:@"%i",uploaded] forKey:@"vUploaded"];
				//[dic setObject:Answer forKey:@"Answer"];
				
				[ary_questions addObject:dic];
				[dic release];
			}
		}
		sqlite3_reset(sqliteStatement);
		sqliteStatement=nil;
	}
	sqlite3_close(database);
	return [ary_questions autorelease];
}
#pragma mark -
#pragma mark Documents DB Method
+(void)addDocumentDetailsToDB:(NSMutableDictionary*)docDetails isVirtual:(int)isVirtual
{
	if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
		const char *sql = "insert into DocumentDetails(doc_name, doc_type, doc_url, course_name, module_name,doc_id,vLang_Id,_videoInfo) Values(?, ?, ?, ?, ?,?,?,?)";
		if(sqlite3_prepare_v2(database, sql, -1, &sqliteStatement, NULL) != SQLITE_OK){
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
		}
		sqlite3_bind_text(sqliteStatement, 1, [[docDetails objectForKey:@"doc_name"] UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(sqliteStatement, 2, [[docDetails objectForKey:@"doc_type"] UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(sqliteStatement, 3, [[docDetails objectForKey:@"doc_url"] UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(sqliteStatement, 4, [[[NSUserDefaults standardUserDefaults] objectForKey:@"course_name"] UTF8String], -1, SQLITE_TRANSIENT);
		NSString *module_string = @"";
		if(isVirtual==0){
			sqlite3_bind_text(sqliteStatement, 5, [[docDetails objectForKey:@"moduleName"] UTF8String], -1, SQLITE_TRANSIENT);
		}else{
			sqlite3_bind_text(sqliteStatement, 5, [module_string UTF8String], -1, SQLITE_TRANSIENT);
		}
		sqlite3_bind_int(sqliteStatement, 6, [[docDetails objectForKey:@"doc_id"] intValue]);
		sqlite3_bind_int(sqliteStatement, 7, [[[NSUserDefaults standardUserDefaults]objectForKey:@"vLang"]intValue]);
		if([docDetails objectForKey:@"_videoData"]){
			sqlite3_bind_blob(sqliteStatement, 8, [[docDetails objectForKey:@"_videoData"] bytes],[[docDetails objectForKey:@"_videoData"] length], NULL);
		}
		if(SQLITE_DONE != sqlite3_step(sqliteStatement))
			NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
		sqlite3_reset(sqliteStatement);
		sqliteStatement=nil;
	}
	sqlite3_close(database);
}

+(NSMutableArray *)readAllDocumentDetais
{
	NSMutableArray *ary_documents  = [[NSMutableArray alloc] init];
	NSString *sqlNsStr = [NSString stringWithFormat:@"SELECT  * from DocumentDetails where vLang_Id = %i",[[[NSUserDefaults standardUserDefaults]objectForKey:@"vLang"]intValue]];
	const char *sqlStatement = [sqlNsStr cStringUsingEncoding:NSUTF8StringEncoding];
	if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &sqliteStatement, NULL) == SQLITE_OK) {
			while(sqlite3_step(sqliteStatement) == SQLITE_ROW) {
				NSMutableDictionary *dic = [[NSMutableDictionary alloc ]init];
				NSString *doc_name = @"";
				if(sqlite3_column_text(sqliteStatement, 0))
					doc_name =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 0)];
				NSString *doc_type= @"";
				if(sqlite3_column_text(sqliteStatement, 1))
					doc_type =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 1)];
				NSString *doc_url = @"";
				if(sqlite3_column_text(sqliteStatement, 2))
					doc_url =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 2)];
				NSString *course_name=@"";
				if(sqlite3_column_text(sqliteStatement, 3))
					course_name =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 3)];
				NSString *module_name=@"";
				if(sqlite3_column_text(sqliteStatement, 4))
					module_name =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 4)];
				NSData *videoData=[[[NSData alloc] init] autorelease];
					
				if(sqlite3_column_blob(sqliteStatement,7)){
					videoData = [[[NSData alloc] initWithBytes:sqlite3_column_blob(sqliteStatement, 7) length:sqlite3_column_bytes(sqliteStatement, 7)] autorelease]; 
				}
				[dic setObject:doc_name forKey:@"doc_name"];
				[dic setObject:doc_type forKey:@"doc_type"];
				[dic setObject:doc_url forKey:@"doc_url"];
				[dic setObject:course_name forKey:@"course_name"];
				[dic setObject:module_name forKey:@"module_name"];
				[dic setObject:[NSString stringWithFormat:@"%i",sqlite3_column_int(sqliteStatement, 5)] forKey:@"doc_id"];
				[dic setObject:videoData forKey:@"_videoData"];
				[ary_documents addObject:dic];
				[dic release];
			}
		}
		sqlite3_reset(sqliteStatement);
		sqliteStatement=nil;
	}
	sqlite3_close(database);
	return [ary_documents autorelease];
}

+(BOOL) iscontainThisRecord:(int) doc_id
{
	BOOL isContainsdocid = NO;
	NSString *sqlNsStr = [NSString stringWithFormat:@"SELECT  * from DocumentDetails where doc_id=%i AND vLang_Id=%i",doc_id,[[[NSUserDefaults standardUserDefaults]objectForKey:@"vLang"]intValue]];
	const char *sqlStatement = [sqlNsStr cStringUsingEncoding:NSUTF8StringEncoding];
	if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &sqliteStatement, NULL) == SQLITE_OK) 
		{
			while(sqlite3_step(sqliteStatement) == SQLITE_ROW) 
			{
				isContainsdocid = YES;
				break;
			}
		}
		sqlite3_reset(sqliteStatement);
		sqliteStatement=nil;
	}
	sqlite3_close(database);
	return isContainsdocid;
	
	
}

+(BOOL) iscontainRecord:(int) doc_id docName:(NSString*)doc_Name
{
	BOOL isContainsdocid = NO;
	NSString *sqlNsStr = [NSString stringWithFormat:@"SELECT  * from DocumentDetails where doc_id=%i AND vLang_Id=%i AND doc_name=%@",doc_id,[[[NSUserDefaults standardUserDefaults]objectForKey:@"vLang"]intValue],doc_Name];
	const char *sqlStatement = [sqlNsStr cStringUsingEncoding:NSUTF8StringEncoding];
	if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &sqliteStatement, NULL) == SQLITE_OK) 
		{
			while(sqlite3_step(sqliteStatement) == SQLITE_ROW) 
			{
				isContainsdocid = YES;
				break;
			}
		}
		sqlite3_reset(sqliteStatement);
		sqliteStatement=nil;
	}
	sqlite3_close(database);
	return isContainsdocid;
}


#pragma mark -
#pragma mark Search DB Method

+(NSMutableArray *)readDocumentSearchResults:(NSString *)str_query
{
	NSMutableArray *ary_documents  = [[NSMutableArray alloc] init];
	NSString *sqlNsStr = [NSString stringWithString:str_query];
	const char *sqlStatement = [sqlNsStr cStringUsingEncoding:NSUTF8StringEncoding];
	if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &sqliteStatement, NULL) == SQLITE_OK) {
			while(sqlite3_step(sqliteStatement) == SQLITE_ROW) {
				NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
				NSString *doc_name = @"";
				if(sqlite3_column_text(sqliteStatement, 0))
					doc_name =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 0)];
				NSString *doc_type= @"";
				if(sqlite3_column_text(sqliteStatement, 1))
					doc_type =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 1)];
				NSString *doc_url = @"";
				if(sqlite3_column_text(sqliteStatement, 2))
					doc_url =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 2)];
				NSString *course_name=@"";
				if(sqlite3_column_text(sqliteStatement, 3))
					course_name =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 3)];
				NSString *module_name=@"";
				if(sqlite3_column_text(sqliteStatement, 4))
					module_name =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 4)];
				[dic setObject:doc_name forKey:@"doc_name"];
				[dic setObject:doc_type forKey:@"doc_type"];
				[dic setObject:doc_url forKey:@"doc_url"];
				[dic setObject:course_name forKey:@"course_name"];
				[dic setObject:module_name forKey:@"module_name"];
				[dic setObject:[NSString stringWithFormat:@"%i",sqlite3_column_int(sqliteStatement, 5)] forKey:@"doc_id"];
				[ary_documents addObject:dic];
				[dic release];
			}
		}
		sqlite3_reset(sqliteStatement);
		sqliteStatement=nil;
	}
	sqlite3_close(database);
	return [ary_documents autorelease];
}
+(NSMutableArray *)readTestSearchResults:(NSString *)str_query
{
	NSMutableArray *ary_test  = [[NSMutableArray alloc] init];
	NSString *sqlNsStr = [NSString stringWithString:str_query];
	const char *sqlStatement = [sqlNsStr cStringUsingEncoding:NSUTF8StringEncoding];
	if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &sqliteStatement, NULL) == SQLITE_OK) {
			while(sqlite3_step(sqliteStatement) == SQLITE_ROW) {
				NSMutableDictionary *dic = [[NSMutableDictionary alloc ]init];
				
				int testId = sqlite3_column_int(sqliteStatement, 0);
				NSString *testName =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 1)];
				NSString *test_details =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 2)];
				int totattempt = sqlite3_column_int(sqliteStatement, 3);
				int attemptedcnt = sqlite3_column_int(sqliteStatement, 4);
				NSString *module_name =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 5)];
				NSString *course_name =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 6)];
				int edition_id = sqlite3_column_int(sqliteStatement, 12);
				NSString *editionName =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 14)];
				[dic setObject:[NSString stringWithFormat:@"%i",testId] forKey:@"test_id"];
				[dic setObject:testName forKey:@"test_name"];
				[dic setObject:test_details forKey:@"test_details"];
				[dic setObject:module_name forKey:@"module_name"];
				[dic setObject:course_name forKey:@"course_name"];
				[dic setObject:[NSString stringWithFormat:@"%i",totattempt] forKey:@"totattempt"];
				[dic setObject:[NSString stringWithFormat:@"%i",attemptedcnt] forKey:@"attemptedcnt"];
				[dic setObject:[NSString stringWithFormat:@"%i",edition_id] forKey:@"editionid"];
				[dic setObject:[NSString stringWithFormat:@"%@",editionName] forKey:@"edition"];
				[ary_test addObject:dic];
				[dic release];
			}
		}
		sqlite3_reset(sqliteStatement);
		sqliteStatement=nil;
	}
	sqlite3_close(database);
	return [ary_test autorelease];
}

#pragma mark -
#pragma mark Login DB Method

+(NSMutableArray *)readUserDetailsWithMailId:(NSString *)str_mail
{
	NSMutableArray *ary_logindetails  = [[NSMutableArray alloc] init];
	NSString *sqlNsStr = [NSString stringWithFormat:@"SELECT  * from LoginDetails where user_emialId = '%@'",str_mail];
	const char *sqlStatement = [sqlNsStr cStringUsingEncoding:NSUTF8StringEncoding];
	if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &sqliteStatement, NULL) == SQLITE_OK) {
			while(sqlite3_step(sqliteStatement) == SQLITE_ROW) {
				NSMutableDictionary *dic = [[NSMutableDictionary alloc ]init];
				
				//int question_id = sqlite3_column_int(sqliteStatement, 0);
				NSString *user_emialId =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 0)];
				NSString *user_password =[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 1)];
				NSInteger use_id =sqlite3_column_int(sqliteStatement, 2);
				[dic setObject:user_emialId forKey:@"user_emialId"];
				[dic setObject:user_password forKey:@"user_password"];
				[dic setObject:[NSString stringWithFormat:@"%i",use_id] forKey:@"user_id"];
				[ary_logindetails addObject:dic];
				[dic release];
			}
		}
		sqlite3_reset(sqliteStatement);
		sqliteStatement=nil;
	}
	sqlite3_close(database);
	return [ary_logindetails autorelease];
}

+(void)addUserDetails:(NSString *)str_userName password:(NSString *)str_password
{
	int count=0;
	if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
		NSString *sqlNsStr = [NSString stringWithFormat:@"select count(*) from LoginDetails where user_emialId = '%@'", str_userName];
		const char *sqlStatement = [sqlNsStr cStringUsingEncoding:NSUTF8StringEncoding];
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &sqliteStatement, NULL) == SQLITE_OK) {
			while(sqlite3_step(sqliteStatement) == SQLITE_ROW) {
				if(sqlite3_column_text(sqliteStatement, 0))
					count = sqlite3_column_int(sqliteStatement, 0);			
			}
		}
		sqlite3_reset(sqliteStatement);
		sqliteStatement=nil;
		
	}
	if(count>0)
	{
		if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
			NSString *sqlNsStr = [NSString stringWithFormat:@"update  LoginDetails set user_emialId = '%@', user_password = '%@' where user_id = %i", str_userName,str_password,[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"] intValue]];
			const char *sqlStatement = [sqlNsStr cStringUsingEncoding:NSUTF8StringEncoding];
			if(sqlite3_prepare_v2(database, sqlStatement, -1, &sqliteStatement, NULL) != SQLITE_OK)
				NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
			if(SQLITE_DONE != sqlite3_step(sqliteStatement))
				NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
			sqlite3_reset(sqliteStatement);
			sqliteStatement=nil;
		}
	}
	else 
	{
		if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
			const char *sql = "insert into LoginDetails(user_emialId, user_password,user_id) Values(?, ?,?)";
			if(sqlite3_prepare_v2(database, sql, -1, &sqliteStatement, NULL) != SQLITE_OK){
				NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
			}
			sqlite3_bind_text(sqliteStatement, 1, [str_userName  UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(sqliteStatement, 2, [str_password  UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_int(sqliteStatement,3,[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"] intValue]);
			
			if(SQLITE_DONE != sqlite3_step(sqliteStatement))
				NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
			sqlite3_reset(sqliteStatement);
			sqliteStatement=nil;
		}
		
	}
	sqlite3_close(database);
}

+(void)deleteOfflineData:(NSInteger)document_Id isAttemptTest:(BOOL)_isAttemptTest editionId:(int)editionid{
	if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
	 NSString *sqlNsStr=@"";
		if(_isAttemptTest){
			sqlNsStr = [NSString stringWithFormat:@"delete from TestDetails WHERE test_id = %i AND vLang_Id=%i AND edition_id=%i", document_Id,[[[NSUserDefaults standardUserDefaults]objectForKey:@"vLang"]intValue],editionid];
			[self deleteQuestionData:document_Id editionid:editionid];
		}else{
			sqlNsStr = [NSString stringWithFormat:@"delete from DocumentDetails where doc_id=%i AND vLang_Id=%i", document_Id,[[[NSUserDefaults standardUserDefaults]objectForKey:@"vLang"]intValue]];
		}
		const char *sqlStatement = [sqlNsStr cStringUsingEncoding:NSUTF8StringEncoding];
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &sqliteStatement, NULL) != SQLITE_OK){
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
		}
		if(SQLITE_DONE != sqlite3_step(sqliteStatement))
			NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
		sqlite3_reset(sqliteStatement);
		sqliteStatement=nil;
	}
		sqlite3_close(database);
}

+(void)deleteattemptQuestionData:(NSString*)test_Id{
	
	if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
		NSString *sqlNsStr = [NSString stringWithFormat:@"delete from QuestionsDetails where edition_id IN( %@)", test_Id];
		const char *sqlStatement = [sqlNsStr cStringUsingEncoding:NSUTF8StringEncoding];
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &sqliteStatement, NULL) != SQLITE_OK){
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
		}
		if(SQLITE_DONE != sqlite3_step(sqliteStatement))
			NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
		sqlite3_reset(sqliteStatement);
		sqliteStatement=nil;
	}
	sqlite3_close(database);
}


+(void)deleteQuestionData:(NSInteger)test_Id editionid:(int)edition_id{
	
	if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
			NSString *sqlNsStr = [NSString stringWithFormat:@"delete from QuestionsDetails where test_id = %i AND edition_id=%i", test_Id,edition_id];
		const char *sqlStatement = [sqlNsStr cStringUsingEncoding:NSUTF8StringEncoding];
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &sqliteStatement, NULL) != SQLITE_OK){
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
		}
		if(SQLITE_DONE != sqlite3_step(sqliteStatement))
			NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
		sqlite3_reset(sqliteStatement);
		sqliteStatement=nil;
	}
	sqlite3_close(database);
}


@end
