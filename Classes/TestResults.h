//
//  TestResults.h
//  eEducation
//
//  Created by Hidden Brains on 11/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TestResultCustomCell,eEducationAppDelegate;

@interface TestResults : UIViewController<UINavigationControllerDelegate>
{
	IBOutlet UITableView *tblView;
	NSMutableArray *_arrayTestResult;
	NSString *timeDuration,*starDate,*endDate;
	IBOutlet UILabel *totalMarks,*lblAchievMarks,*lblMarksPercent;
	IBOutlet UILabel *lbltimeDuration,*lblstartDate,*lblendDate;
	IBOutlet UILabel *totalMarksValue,*lblAchievMarksValue,*lblMarksPercentValue;
	IBOutlet UILabel *lbltimeDurationValue,*lblstartDateValue,*lblendDateValue;
	IBOutlet UIButton *btnTest,*btnCourse,*btnModule;
	int achieveMarks;
	eEducationAppDelegate *appDelegate;
	NSMutableDictionary *_DicTest;
	IBOutlet UIButton *tab1,*tab2,*tab3,*tab4,*tab5;
	//For JSON Parsing
	JSONParser *objParser;
	MBProgressHUD *HUD;
}
@property(nonatomic,retain)NSMutableArray *arrayTestResult;
@property(nonatomic,retain)NSString *timeDuration,*starDate,*endDate;
@property(nonatomic,retain) NSMutableDictionary *DicTest;
-(IBAction) TabarIndexSelected:(id)sender;
-(void) setlocalizedValues;
-(void)jsonRequest;

-(NSString *)removeSpecialSymbils:(NSString *)str_ans;

-(IBAction)btnTest_Clicked:(id)sender;
-(IBAction)btnCourse_Clicked:(id)sender;
-(IBAction)btnModule_Clicked:(id)sender;

@end
