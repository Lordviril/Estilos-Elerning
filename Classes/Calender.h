//
//  Calender.h
//  eEducation
//
//  Created by hb12 on 07/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KLCalendarView.h"
#import "CheckmarkTile.h"
#import "SBJSON.h"
#import "StringEncryption.h"
#import "JSONParser.h"
#import "MBProgressHUD.h"
#import "RTLabel.h"
#import "AsyncImageView.h"

#import "CalendarLogic.h"
#import "CalendarMonth.h"

@class CalendarLogic;
@class eEducationAppDelegate;

@interface Calender : UIViewController<CalendarLogicDelegate,CalendarMonthDelegate>
{
	NSMutableArray *calArray;
	NSMutableArray *testArray;
	NSMutableString *strDate;
    
	eEducationAppDelegate *appDelegate;
	JSONParser *objParser;
	MBProgressHUD *HUD;
	int count;
}

@property (nonatomic, retain) IBOutlet AsyncImageView *imgProfile,*imgLogo,*imgLogoStatic;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle,*lblProfileGrayName,*lblProfileBlueName,*lblTopCourse;
@property (nonatomic, retain) IBOutlet RTLabel *lblTopDuration,*lblDateDetails;
@property (nonatomic, retain) IBOutlet UIButton *btnHome,*btnModule;
@property (nonatomic, retain) IBOutlet UIView *viewBack,*viewShowDetails;

@property (nonatomic, strong) CalendarLogic *calendarLogic;
@property (nonatomic, retain) CalendarMonth *calendarView;
@property (nonatomic, strong) CalendarMonth *calendarViewNew;

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) NSDate *selectedDate;

-(IBAction)proImgClicked:(id)sender;
-(IBAction)btnSettingsClicked:(id)sender;
-(IBAction)btnLogoutClicked:(id)sender;
-(IBAction)btnBackClicked:(id)sender;
-(IBAction)btnStudentsClicked:(id)sender;

@end
