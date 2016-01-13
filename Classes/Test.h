//
//  Test.h
//  eEducation
//
//  Created by HB 13 on 20/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//#import <UIKit/UIKit.h>
//#import "myVariables.h"
//#import "questionDetail.h"
//
//@interface Test : UIViewController <answersheetDelegate,QuestionDelegate>{
//
//	myVariables *objMyVariables;
//	IBOutlet UIButton *btnOption1,*btnOption2,*btnOption3,*btnOption4;
//	IBOutlet UIButton *btnNext,*bntBack;
//	IBOutlet UILabel *lblQuestion,*lblQuestionNo, *lblOption1,*lblOption2,*lblOption3,*lblOption4;
//	IBOutlet UIView *testView;
//	IBOutlet UILabel *lblTime;
//	NSMutableArray *_arrayQuestions;
//	int questionNo;
//	NSString *timeInDate,*startDate;
//	eEducationAppDelegate *appDelegate;
//	UIButton *_buttonSubmit;
//	UILabel *_labelQuestionType;
//	UIImageView *_imageQuestionbackground;
//	UILabel *_labelElapsedTime;
//	UILabel *_labelQuestionHead;
//	UIButton *_buttomCourse;
//	UIButton *_buttonModule;
//	UIButton *_buttonTest;
//	IBOutlet UIButton *_buttonSave;
//	
//	int test_id;
//	
//	NSDate *_timeExamDuration;
//	NSTimer *timer;
//	NSTimeInterval givenTestDuration;
//	
//	NSMutableDictionary *_DicTest;
// 	
//	//For JSON Parsing
//	JSONParser *objParser;
//	MBProgressHUD *HUD;
//	BOOL istestPresent;
//	NSMutableData *myWebData;
//	NSDate *startDt;
//}
//
//@property(nonatomic,retain) NSDate *timeExamDuration;
//@property(nonatomic,retain) IBOutlet UILabel *labelQuestionType;
//@property(nonatomic,retain) IBOutlet UIButton *buttonSubmit;
//@property(nonatomic,retain) IBOutlet UIImageView *imageQuestionbackground;
//@property(nonatomic,retain) IBOutlet UILabel *labelElapsedTime;
//@property(nonatomic,retain) IBOutlet UILabel *labelQuestionHead;
//@property(nonatomic,retain) NSMutableArray *arrayQuestions;
//@property(nonatomic,retain) IBOutlet UIButton *buttomCourse;
//@property(nonatomic,retain) IBOutlet UIButton *buttonModule;
//@property(nonatomic,retain) IBOutlet UIButton *buttonTest;
//@property(nonatomic,readwrite) int test_id;
//@property(nonatomic,readwrite) NSTimeInterval givenTestDuration;
//@property(nonatomic,retain) NSMutableDictionary *DicTest;
//-(IBAction)btnSubmit_Clicked:(id)sender;
//-(IBAction)btnOptions_Clicked:(id)sender;
//-(IBAction)btnNext_Clicked:(id)sender;
//-(IBAction)btnBack_Clicked:(id)sender;
//
//-(IBAction)btnTest_Clicked:(id)sender;
//
//-(IBAction)btnCourse_Clicked:(id)sender;
//-(IBAction)btnModule_Clicked:(id)sender;
//
//-(void)jsonRequestForQuestions;
//-(void)jsonRequestForPostAnswers;
//-(void)updateNextAndPrevious;
//-(void)tickAnswer:(int)tick;
//-(void)noOfOptions:(NSString *)dicText;
//-(void)hideAndShow:(BOOL)yesOrNo;
//-(void)refreshView:(int)QuestionNumber;
//-(void)currenttime;
//-(void)setLocalizedStrings;
//-(IBAction)SaveTest:(id)sender;
//
//@end

#import <UIKit/UIKit.h>
#import "myVariables.h"
#import "questionDetail.h"

@interface Test : UIViewController <answersheetDelegate,QuestionDelegate,UINavigationControllerDelegate>{
	
	myVariables *objMyVariables;
	IBOutlet UIButton *btnNext,*bntBack;
	IBOutlet UILabel *lblQuestion,*lblQuestionNo;
	IBOutlet UIView *testView;
	IBOutlet UILabel *lblTime;
	IBOutlet UIScrollView *scrView;
	NSMutableArray *_arrayQuestions;
	int questionNo;
	NSString *timeInDate,*startDate;
	eEducationAppDelegate *appDelegate;
	UIButton *_buttonSubmit;
	UILabel *_labelQuestionType;
	UIImageView *_imageQuestionbackground;
	UILabel *_labelElapsedTime;
	UILabel *_labelQuestionHead;
	UIButton *_buttomCourse;
	UIButton *_buttonModule;
	UIButton *_buttonTest;
	IBOutlet UIButton *_buttonSave;
	IBOutlet UIButton *tab1,*tab2,*tab3,*tab4,*tab5;
	int test_id;
	int edition_id;
	NSDate *_timeExamDuration;
	NSTimer *timer;
	NSTimeInterval givenTestDuration;
	
	NSMutableDictionary *_DicTest;
 	
	//For JSON Parsing
	JSONParser *objParser;
	MBProgressHUD *HUD;
	BOOL istestPresent;
	NSMutableData *myWebData;
	NSDate *startDt;
	UIInterfaceOrientation currentOrientation;
}

@property(nonatomic,retain) NSDate *timeExamDuration;
@property(nonatomic,retain) IBOutlet UILabel *labelQuestionType;
@property(nonatomic,retain) IBOutlet UIButton *buttonSubmit;
@property(nonatomic,retain) IBOutlet UIImageView *imageQuestionbackground;
@property(nonatomic,retain) IBOutlet UILabel *labelElapsedTime;
@property(nonatomic,retain) IBOutlet UILabel *labelQuestionHead;
@property(nonatomic,retain) NSMutableArray *arrayQuestions;
@property(nonatomic,retain) IBOutlet UIButton *buttomCourse;
@property(nonatomic,retain) IBOutlet UIButton *buttonModule;
@property(nonatomic,retain) IBOutlet UIButton *buttonTest;
@property(nonatomic,readwrite) int test_id;
@property(nonatomic,readwrite)int edition_id;
@property(nonatomic,readwrite) NSTimeInterval givenTestDuration;
@property(nonatomic,retain) NSMutableDictionary *DicTest;
-(IBAction)btnSubmit_Clicked:(id)sender;
-(IBAction)btnOptions_Clicked:(id)sender;
-(IBAction)btnNext_Clicked:(id)sender;
-(IBAction)btnBack_Clicked:(id)sender;

-(IBAction)btnTest_Clicked:(id)sender;

-(IBAction)btnCourse_Clicked:(id)sender;
-(IBAction)btnModule_Clicked:(id)sender;

-(void)jsonRequestForQuestions;
-(void)jsonRequestForPostAnswers;
-(void)updateNextAndPrevious;
-(void)tickAnswer:(int)tick;
-(void)noOfOptions:(NSString *)dicText;
-(void)hideAndShow:(BOOL)yesOrNo;
-(void)refreshView:(int)QuestionNumber;
-(void)currenttime;
-(void)setLocalizedStrings;
-(IBAction)SaveTest:(id)sender;
-(IBAction) TabarIndexSelected:(id)sender;
@end

