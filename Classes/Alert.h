//
//  Alert.h
//  eEducation
//
//  Created by hb12 on 07/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJSON.h"
#import "StringEncryption.h"
#import "JSONParser.h"
#import "MBProgressHUD.h"

@class ModuleHomePage;
@interface Alert : UIViewController
{
	IBOutlet UITableView *tblView;
    
	NSMutableArray *alertArray;
	IBOutlet UIView *AlertDetailView,*alertBox;

	IBOutlet UILabel *lblAlertName,*lblAlertDate;
	IBOutlet UITextView *lblAlertDescription;
	int index;
	eEducationAppDelegate *appDelegate;

	JSONParser *objParser;
	MBProgressHUD *HUD;
	BOOL istable_reloadfirsttime;
	NSIndexPath *selectedIndex;
}

@property(nonatomic,retain) IBOutlet UIView *viewLoadMore;
@property(nonatomic,retain) IBOutlet UIButton *btnHome,*btnPopUpCancel,*btnModule;

@property (nonatomic, retain) IBOutlet AsyncImageView *imgProfile,*imgLogo,*imgLogoStatic;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle,*lblProfileGrayName,*lblProfileBlueName,*lblTopCourse;
@property (nonatomic, retain) IBOutlet RTLabel *lblTopDuration;

-(IBAction)btnCancelViewalert:(UIButton*)sender;
-(IBAction)btnModuleClicked:(id)sender;
@end
