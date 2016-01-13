//
//  WebService.h
//  eEducation
//
//  Created by hb12 on 15/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WebService : NSObject 
+(NSString *) GetLoginXml;
+(NSString *) GetForgetPasswordXml;
+(NSString *) GetUnregisteredCourseListXml;
+(NSString *) GetRegisteredUserCourseListXml;
+(NSString *) GetSettingDataXml;
+(NSString *) GetSettingEditDataXml;
+(NSString *) GetVituvalLibraryDataXml;
+(NSString *) GetVituvalVideosDataXml;
+(NSString *) GetChapterVideoListXml;
+(NSString *) GetDocumentsListXml;

+(NSString*)getForumList;
+(NSString*)getForumDetail;
+(NSString*)getAlertList;
+(NSString*)postFormData;
+(NSString*)getMessageInboxList;
+(NSString*)getMessageSentboxList;
+(NSString*)getComposeMail;
+(NSString*)getCalanderEvent;
+(NSString*)getDeleteMessage;
+(NSString*)getReadMessage;
+(NSString*)addNewtopic;


+(NSString *) getCoursedetailsURL;
+(NSString *) getPracticelistURL;
+(NSString *) getChapterListURL;
+(NSString *) getexamlistURL;
+(NSString *) getdownloadexamURL;
+(NSString *) getpastexamlistURL;
+(NSString *) getpasttestdetailURL;
+(NSString *) getPostExamURL;
+(NSString *) getOtherStudentsURL;
+(NSString *) getTeachersURL;
+(BOOL)checkForNetworkStatus;

@end
