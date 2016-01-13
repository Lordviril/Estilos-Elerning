//
//  PracticeList.h
//  eEducation
//
//  Created by Hidden Brains on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class eEducationAppDelegate;
@interface PracticeList : UIViewController<UINavigationControllerDelegate>{

	IBOutlet UITableView *tblView;
	IBOutlet UIButton *btnPrectice,*btnCourse,*btnModule;
	IBOutlet UIButton *btnSetting;
	IBOutlet UIButton *tab1,*tab2,*tab3,*tab4,*tab5;
	eEducationAppDelegate *appDelegate;
	
	//For JSON Parsing
	JSONParser *objParser;
	NSMutableArray *practiceArray;
	MBProgressHUD *HUD;
}
-(IBAction)btnCourse_Clicked:(id)sender;
-(IBAction) TabarIndexSelected:(id)sender;
-(IBAction)btnModule_Clicked:(id)sender;
-(void)jsonRequest;
@end