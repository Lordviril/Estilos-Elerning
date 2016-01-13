//
//  WebService.m
//  eEducation
//
//  Created by hb12 on 15/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebService.h"
#import "Reachability.h"

//#define BASE_URL @"http://www.comunicacionyformacion.es/formacion/iphone/"
//#define BASE_URL @"http://184.164.156.56/projects/educator/iphone/"
//#define BASE_URL @"http://192.168.34.53/ratina/iphone/"
//#define BASE_URL @"http://192.168.39.35/elearning/iphone/"

//#define BASE_URL @"http://184.164.156.56/projects/education_v2/iphone/"

#define BASE_URL @"http://www.comunicacionyformacion.es/formacion/native/"

@implementation WebService

+(NSString *) GetLoginXml
{
    return [BASE_URL stringByAppendingFormat:@"/User.asmx/login?data="];
}

+(NSString *) GetForgetPasswordXml
{
    return [BASE_URL stringByAppendingFormat:@"User.asmx/forgotpassword?data="];
}

+(NSString *) GetUnregisteredCourseListXml
{
    return [BASE_URL stringByAppendingFormat:@"course.asmx/courselist?data="];
}

+(NSString *) GetRegisteredUserCourseListXml
{
    return [BASE_URL stringByAppendingFormat:@"course.asmx/courselist?data="];

}
+(NSString *) GetSettingDataXml
{
    return [BASE_URL stringByAppendingFormat:@"User.asmx/getsettingview?data="];
}
+(NSString *) GetSettingEditDataXml
{
    return [BASE_URL stringByAppendingFormat:@"User.asmx/settingsedit?data="];
}
+(NSString *) GetVituvalLibraryDataXml
{
    return [BASE_URL stringByAppendingFormat:@"course.asmx/virtuallibrary?data="];
}
+(NSString *) GetVituvalVideosDataXml
{
    return [BASE_URL stringByAppendingFormat:@"course.asmx/virtuallibrary?data="];
}
+(NSString *) GetDocumentsListXml
{
    return [BASE_URL stringByAppendingFormat:@"module.asmx/getChapterDocuments?data="];
}
+(NSString *) GetChapterVideoListXml
{
    return [BASE_URL stringByAppendingFormat:@"module.asmx/getVideoList?data="];
}

+(NSString*)getForumList{
    return [BASE_URL stringByAppendingFormat:@"forum.asmx/getforumlist?data="];
}

+(NSString*)getForumDetail{
    return [BASE_URL stringByAppendingFormat:@"forum.asmx/getforumdetails?data="];
}

+(NSString*)getAlertList{
    return [BASE_URL stringByAppendingFormat:@"alerts.asmx/getalerts?data="];
}

+(NSString*)postFormData{
    return [BASE_URL stringByAppendingFormat:@"forum.asmx/postforum?data="];
}

+(NSString*)getMessageInboxList{
    return [BASE_URL stringByAppendingFormat:@"message.asmx/inbox?data="];
}
+(NSString*)getMessageSentboxList{
    return [BASE_URL stringByAppendingFormat:@"message.asmx/sent?data="];
}

+(NSString*)getComposeMail{
    return [BASE_URL stringByAppendingFormat:@"message.asmx/sendmessage?data="];
}

+(NSString*)getCalanderEvent{
    return [BASE_URL stringByAppendingFormat:@"module.asmx/getcalendar?data="];
}

+(NSString *) getCoursedetailsURL
{
    return [BASE_URL stringByAppendingFormat:@"module.asmx/getModuleList?data="];
}
+(NSString *) getPracticelistURL
{
    return [BASE_URL stringByAppendingFormat:@"module.asmx/getpracticelist?data="];
}
+(NSString *) getChapterListURL
{
    return [BASE_URL stringByAppendingFormat:@"module.asmx/getChapterList?data="];
}
+(NSString *) getexamlistURL
{
    return [BASE_URL stringByAppendingFormat:@"exam.asmx/getexamlist?data="];
}
+(NSString *) getdownloadexamURL
{
    return [BASE_URL stringByAppendingFormat:@"exam.asmx/downloadexam?data="];
}
+(NSString*)getDeleteMessage
{
    return [BASE_URL stringByAppendingFormat:@"message.asmx/itemdelete?data="];
}
+(NSString*)getReadMessage
{
    return [BASE_URL stringByAppendingFormat:@"message.asmx/readMsg?data="];
}

+(NSString*)addNewtopic
{
    return [BASE_URL stringByAppendingFormat:@"forum.asmx/addtopic?data="];
}
+(NSString *) getpastexamlistURL
{
    return [BASE_URL stringByAppendingFormat:@"exam.asmx/getpastexamlist?data="];
}
+(NSString *) getpasttestdetailURL
{
    return [BASE_URL stringByAppendingFormat:@"exam.asmx/pasttestdetail?data="];
}
+(NSString *) getPostExamURL
{
    return [BASE_URL stringByAppendingFormat:@"exam.asmx/addExam"];
}
+(NSString *) getOtherStudentsURL
{
    return [BASE_URL stringByAppendingFormat:@"User.asmx/getotherstudentlist?data="];
}
+(NSString *) getTeachersURL
{
    return [BASE_URL stringByAppendingFormat:@"User.asmx/module_masters?data="];
}

/**
 *  Url change
 *
 *  @return 
 */

//+(NSString *) GetLoginXml
//{
//	return @"http://184.164.156.56/projects/educator/iphone//User.asmx/login?data=";
////	return @"http://www.comunicacionyformacion.es/formacion/iphone//User.asmx/login?data=";
//}
//
//+(NSString *) GetForgetPasswordXml
//{	
//	return @"http://184.164.156.56/projects/educator/iphone/User.asmx/forgotpassword?data=";
////	return @"http://www.comunicacionyformacion.es/formacion/iphone/User.asmx/forgotpassword?data=";
//}
//
//+(NSString *) GetUnregisteredCourseListXml
//{
//	return @"http://184.164.156.56/projects/educator/iphone/course.asmx/courselist?data=";
////	return @"http://www.comunicacionyformacion.es/formacion/iphone/course.asmx/courselist?data=";
//}
//
//+(NSString *) GetRegisteredUserCourseListXml
//{
//	return @"http://184.164.156.56/projects/educator/iphone/course.asmx/courselist?data=";
////	return @"http://www.comunicacionyformacion.es/formacion/iphone/course.asmx/courselist?data=";
//    
//}
//+(NSString *) GetSettingDataXml
//{
//    return @"http://184.164.156.56/projects/educator/iphone/User.asmx/getsettingview?data=";
////	return @"http://www.comunicacionyformacion.es/formacion/iphone/User.asmx/getsettingview?data=";
//	
//}
//+(NSString *) GetSettingEditDataXml
//{
//    
//    return @"http://184.164.156.56/projects/educator/iphone/User.asmx/settingsedit?data=";
////    return @"http://www.comunicacionyformacion.es/formacion/iphone/User.asmx/settingsedit?data=";
//	
//}
//+(NSString *) GetVituvalLibraryDataXml
//{
//	
//    return @"http://184.164.156.56/projects/educator/iphone/course.asmx/virtuallibrary?data=";
////	return @"http://www.comunicacionyformacion.es/formacion/iphone/course.asmx/virtuallibrary?data=";
//	
//}
//+(NSString *) GetVituvalVideosDataXml
//{
//	
//	return @"http://184.164.156.56/projects/educator/iphone/course.asmx/virtuallibrary?data=";
////	return @"http://www.comunicacionyformacion.es/formacion/iphone/course.asmx/virtuallibrary?data=";
//	
//}
//+(NSString *) GetDocumentsListXml
//{
//	return @"http://184.164.156.56/projects/educator/iphone/module.asmx/getChapterDocuments?data=";
////	return @"http://www.comunicacionyformacion.es/formacion/iphone/module.asmx/getChapterDocuments?data=";
//}
//+(NSString *) GetChapterVideoListXml
//{
//    return @"http://184.164.156.56/projects/educator/iphone/module.asmx/getVideoList?data=";
////	return @"http://www.comunicacionyformacion.es/formacion/iphone/module.asmx/getVideoList?data=";
//}
//
//+(NSString*)getForumList{
//	return @"http://184.164.156.56/projects/educator/iphone/forum.asmx/getforumlist?data=";
////	return @"http://www.comunicacionyformacion.es/formacion/iphone/forum.asmx/getforumlist?data=";
//}
//
//+(NSString*)getForumDetail{
//	return @"http://184.164.156.56/projects/educator/iphone/forum.asmx/getforumdetails?data=";
////	return @"http://www.comunicacionyformacion.es/formacion/iphone/forum.asmx/getforumdetails?data=";
//}
//
//+(NSString*)getAlertList{
//	return @"http://184.164.156.56/projects/educator/iphone/alerts.asmx/getalerts?data=";
////	return @"http://www.comunicacionyformacion.es/formacion/iphone/alerts.asmx/getalerts?data=";
//}
//
//+(NSString*)postFormData{
//	return @"http://184.164.156.56/projects/educator/iphone/forum.asmx/postforum?data=";
////	return @"http://www.comunicacionyformacion.es/formacion/iphone/forum.asmx/postforum?data=";
//}
//
//+(NSString*)getMessageInboxList{
//	return @"http://184.164.156.56/projects/educator/iphone/message.asmx/inbox?data=";
////	return @"http://www.comunicacionyformacion.es/formacion/iphone/message.asmx/inbox?data=";
//	
//}
//+(NSString*)getMessageSentboxList{
//	return	@"http://184.164.156.56/projects/educator/iphone/message.asmx/sent?data=";
////	return @"http://www.comunicacionyformacion.es/formacion/iphone/message.asmx/sent?data=";
//}
//
//+(NSString*)getComposeMail{
//	return @"http://184.164.156.56/projects/educator/iphone/message.asmx/compose?data=";
////	return @"http://www.comunicacionyformacion.es/formacion/iphone/message.asmx/compose?data=";
//}
//
//+(NSString*)getCalanderEvent{
//	return @"http://184.164.156.56/projects/educator/iphone/module.asmx/getcalendar?data=";
////	return @"http://www.comunicacionyformacion.es/formacion/iphone/module.asmx/getcalendar?data=";
//}
//
//+(NSString *) getCoursedetailsURL
//{
//	return @"http://184.164.156.56/projects/educator/iphone/module.asmx/getModuleList?data=";
////	return @"http://www.comunicacionyformacion.es/formacion/iphone/module.asmx/getModuleList?data=";
//}
//+(NSString *) getPracticelistURL
//{
//	return @"http://184.164.156.56/projects/educator/iphone/module.asmx/getpracticelist?data=";
//	//return @"http://www.comunicacionyformacion.es/formacion/iphone/module.asmx/getpracticelist?data=";
//}
//+(NSString *) getChapterListURL
//{
//	return @"http://184.164.156.56/projects/educator/iphone/module.asmx/getChapterList?data=";
//	//return @"http://www.comunicacionyformacion.es/formacion/iphone/module.asmx/getChapterList?data=";
//}
//+(NSString *) getexamlistURL
//{
//	return @"http://184.164.156.56/projects/educator/iphone/exam.asmx/getexamlist?data=";
//	//return @"http://www.comunicacionyformacion.es/formacion/iphone/exam.asmx/getexamlist?data=";
//}
//+(NSString *) getdownloadexamURL
//{
//	return @"http://184.164.156.56/projects/educator/iphone/exam.asmx/downloadexam?data=";
//	//return @"http://www.comunicacionyformacion.es/formacion/iphone/exam.asmx/downloadexam?data=";
//}
//+(NSString*)getDeleteMessage
//{
//	return @"http://184.164.156.56/projects/educator/iphone/message.asmx/itemdelete?data=";
//	//return @"http://www.comunicacionyformacion.es/formacion/iphone/message.asmx/itemdelete?data=";
//}
//
//+(NSString*)addNewtopic
//{
//    return @"http://184.164.156.56/projects/educator/iphone/forum.asmx/addtopic?data=";
//	//return @"http://www.comunicacionyformacion.es/formacion/iphone/forum.asmx/addtopic?data=";
//}
//+(NSString *) getpastexamlistURL
//{
//	return @"http://184.164.156.56/projects/educator/iphone/exam.asmx/getpastexamlist?data=";
//	//return @"http://www.comunicacionyformacion.es/formacion/iphone/exam.asmx/getpastexamlist?data=";
//}
//+(NSString *) getpasttestdetailURL
//{
//	return @"http://184.164.156.56/projects/educator/iphone/exam.asmx/pasttestdetail?data=";
//	//return @"http://www.comunicacionyformacion.es/formacion/iphone/exam.asmx/pasttestdetail?data=";
//}
//+(NSString *) getPostExamURL
//{
//    return @"http://184.164.156.56/projects/educator/iphone/exam.asmx/addExam";
//	//return @"http://www.comunicacionyformacion.es/formacion/iphone/exam.asmx/addExam";
//}

+(BOOL)checkForNetworkStatus
{
	Reachability *reachability = [Reachability reachabilityForInternetConnection];
	NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];	
	if(remoteHostStatus == NotReachable) 
	{
		return NO;
    }else {
		return YES;
	}
}
@end
