//
//  TestDetail.h
//  eEducation
//
//  Created by Hidden Brains on 11/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TestDetail : UIViewController<UINavigationControllerDelegate> 
{
	
	eEducationAppDelegate *appDelegate;
	
	UIButton *_buttonStart;
	UIButton *_buttonCancel;
	UIButton *_buttomCourse;
	UIButton *_buttonModule;
	UIButton *_buttonTest;
	UITableView *_tableViewTest;
	int test_id;
	int edition_id;
	NSMutableArray *_arrayTestDetails;
	
	//For JSON Parsing
	JSONParser *objParser;
	MBProgressHUD *HUD;
	IBOutlet UIButton *tab1,*tab2,*tab3,*tab4,*tab5;
	
}
-(IBAction)btnCancel_Clicked:(id)sender;
-(IBAction)btnTest_Clicked:(id)sender;
-(IBAction)btnCourse_Clicked:(id)sender;
-(IBAction)btnModule_Clicked:(id)sender;
-(IBAction) TabarIndexSelected:(id)sender;
@property(nonatomic,retain) IBOutlet UIButton *buttonStart;
@property(nonatomic,retain) IBOutlet UIButton *buttonCancel;
@property(nonatomic,retain) IBOutlet UIButton *buttomCourse;
@property(nonatomic,retain) IBOutlet UIButton *buttonModule;
@property(nonatomic,retain) IBOutlet UIButton *buttonTest;
@property(nonatomic,retain) IBOutlet UITableView *tableViewTest;
@property(nonatomic,retain) NSMutableArray *arrayTestDetails;
@property(nonatomic,readwrite) int test_id;
@property(nonatomic,readwrite) int edition_id;
//-(void) setlocalizedValues;
-(void)jsonRequest;

@end
