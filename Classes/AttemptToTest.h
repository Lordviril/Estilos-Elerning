//
//  AttemptToTest.h
//  eEducation
//
//  Created by Hidden Brains on 11/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
BOOL isEndDate;
@class eEducationAppDelegate;
@interface AttemptToTest : UIViewController<UINavigationControllerDelegate> 
{
	IBOutlet UITableView *tblView;
	IBOutlet UIButton *btnTest,*btnCourse,*btnModule;
	eEducationAppDelegate *appDelegate;
	IBOutlet UIButton *tab1,*tab2,*tab3,*tab4,*tab5;
	NSMutableDictionary *_DicTest;	
}

@property(nonatomic,retain) NSMutableDictionary *DicTest;

-(IBAction)btnCourse_Clicked:(id)sender;
-(IBAction)btnModule_Clicked:(id)sender;
-(IBAction)btnTest_Clicked:(id)sender;
-(void)showAlert;
-(IBAction) TabarIndexSelected:(id)sender;
@end
