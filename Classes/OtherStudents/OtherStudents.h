//
//  OtherStudents.h
//  eEducation
//
//  Created by Hidden Brains on 21/11/13.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "eEducationAppDelegate.h"
#import "AsyncImageView.h"
#import "Settings.h"
#import "GMGridView.h"
#import "GMGridViewLayoutStrategies.h"
#import "StudentsCell.h"
#import "RTLabel.h"
#import "TSPopoverController.h"
#import "JSONParser.h"
#import "MBProgressHUD.h"

@class ModuleHomePage;
@interface OtherStudents : UIViewController<GMGridViewDataSource,GMGridViewActionDelegate,UIScrollViewDelegate,MFMailComposeViewControllerDelegate>{
    JSONParser *objParser;
	MBProgressHUD *HUD;
}

@property (nonatomic, retain) IBOutlet AsyncImageView *imgProfile,*imgLogo,*imgLogoStatic;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle,*lblProfileGrayName,*lblProfileBlueName,*lblTopCourse;
@property (nonatomic, retain) IBOutlet RTLabel *lblTopDuration;
@property (nonatomic, retain) IBOutlet UIButton *btnHome,*btnModule;
@property (nonatomic, retain) IBOutlet UIButton *tab1,*tab2,*tab3,*tab4,*tab5;
@property (nonatomic, retain)  IBOutlet GMGridView *gridStudets;
@property (nonatomic, retain) NSMutableArray *arrStudents;


-(IBAction)proImgClicked:(id)sender;
-(IBAction)btnSettingsClicked:(id)sender;
-(IBAction)btnLogoutClicked:(id)sender;
-(IBAction)btnBackClicked:(id)sender;
-(IBAction)btnModuleClicked:(id)sender;
-(IBAction) TabarIndexSelected:(id)sender;

@end
