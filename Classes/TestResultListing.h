//
//  TestResultListing.h
//  eEducation
//
//  Created by HB 13 on 27/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TestResultListing : UIViewController <UINavigationControllerDelegate>{
	
	eEducationAppDelegate *appDelegate;
	
	UITableView *_tableTestResult;
	UIButton *_buttomCourse;
	UIButton *_buttonModule;
	UIButton *_buttonTest;
	IBOutlet UIButton *tab1,*tab2,*tab3,*tab4,*tab5;
	NSMutableArray *_arrayTestResult;
	NSMutableDictionary *_DicTest;
	
	NSDateFormatter *_dateFormatter;
		//For JSON Parsing
	JSONParser *objParser;
	MBProgressHUD *HUD;
}
@property(nonatomic,retain) IBOutlet UIButton *buttomCourse;
@property(nonatomic,retain) IBOutlet UIButton *buttonModule;
@property(nonatomic,retain) IBOutlet UIButton *buttonTest;
@property(nonatomic,retain) IBOutlet UITableView *tableTestResult;
@property(nonatomic,retain) NSMutableArray *arrayTestResult;
@property(nonatomic,retain) NSMutableDictionary *DicTest;
-(IBAction) TabarIndexSelected:(id)sender;
-(IBAction)btnCourse_Clicked:(id)sender;
-(IBAction)btnModule_Clicked:(id)sender;
-(IBAction)btnTest_Clicked:(id)sender;
-(void)jsonRequest;

@end
