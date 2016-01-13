//
//  Settings.h
//  eEducation
//
//  Created by HB14 on 05/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomPicker.h"
#import "AsyncImageView.h"
#import "eEducationAppDelegate.h"
#import "OtherStudents.h"
#import "JSON.h"
#import "RTLabel.h"

@interface Settings : UIViewController<UIAlertViewDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate,CustomPickerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate>
{
//    UIActionSheet *actionSheet;
    UIPopoverController *popoverImages;
	IBOutlet UIScrollView *scrlView;
	IBOutlet UILabel *lbl_heading;
	//General Settings
	
	IBOutlet UILabel *lbl_generalSettings;
	
	IBOutlet UILabel *lbl_autoLogin;
	IBOutlet UILabel *lbl_setAlerts;
    IBOutlet UILabel *lbl_setLang;
	IBOutlet UIButton *btn_autoLogin;
	IBOutlet UIButton *btn_setAlerts;
	IBOutlet UIButton *btn_Language;
	//Profile settings
	IBOutlet UILabel *lbl_profileSettings;
	
	IBOutlet UILabel *lbl_firstName;
	IBOutlet UILabel *lbl_lastName;
	IBOutlet UILabel *lbl_eMail;
	IBOutlet UILabel *lbl_username;
	IBOutlet UILabel *lbl_DOB;
	IBOutlet UILabel *lbl_city;
	IBOutlet UILabel *lbl_province;
	IBOutlet UILabel *lbl_country;
	IBOutlet UILabel *lbl_telephone;
	
	IBOutlet UITextField *txt_firstNameValue;
	IBOutlet UITextField *txt_lastNameValue;
	IBOutlet UITextField *txt_eMailValue;
	IBOutlet UILabel *lbl_usernameValue;
	IBOutlet UILabel *lbl_DOBValue;
	IBOutlet UITextField *txt_cityValue;
	IBOutlet UITextField *txt_provinceValue;
	IBOutlet UITextField *txt_countryValue;
	IBOutlet UITextField *txt_telephoneValue;
	
	IBOutlet UIButton *btn_DOB;
	
	//Password settings
	IBOutlet UILabel *lbl_passwordSettings;
	
	IBOutlet UILabel *lbl_currentPwd;
	IBOutlet UILabel *lbl_newPwd;
	IBOutlet UILabel *lbl_reEnterPwd;
	
	IBOutlet UITextField *txt_currentPwdValue;
	IBOutlet UITextField *txt_newPwdValue;
	IBOutlet UITextField *txt_reEnterPwdValue;
	
	IBOutlet UIButton *tab1,*tab2,*tab3,*tab4,*tab5;
	
	// Remaining
	IBOutlet UIButton *btn_Save;
	UITextField *currentTxtField;
	bool isReturned;
	
	UIActionSheet *actionSheet;
	UIToolbar *pickerToolbar;
	UIPopoverController *popoverController;
	UIDatePicker *datePicker;
	NSString *str_previousValue;
	eEducationAppDelegate *appDelegate;
	
	//JSON Parser
	JSONParser *objParser;
	NSMutableArray *ArrayResponse;
	NSMutableDictionary *SettingsDict;
	MBProgressHUD *HUD;
    BOOL didLangClick;
}

@property (nonatomic, retain) IBOutlet AsyncImageView *imgProfile,*imgBig,*imgLogo,*imgLogoStatic;
@property (nonatomic, retain) IBOutlet UILabel *lblProfileGrayName,*lblProfileBlueName,*lblTopCourse;
@property (nonatomic, retain) IBOutlet RTLabel *lblTopDuration;
@property (nonatomic, retain) IBOutlet UIButton *btnHome,*btnModule,*btnOtherStudents;
@property (nonatomic, retain) IBOutlet UIButton *btnProfileUpload;
@property (nonatomic, retain) IBOutlet UIImageView *imgModuleArrow;
@property (nonatomic, retain) UITapGestureRecognizer *tap;
@property (strong, nonatomic) UICustomPicker *objPicker;
@property (nonatomic,retain) NSData *dataPic;

-(IBAction)btnStudentsClicked:(id)sender;
-(IBAction)btnLogoutClicked:(id)sender;

-(IBAction) TabarIndexSelected:(id)sender;
-(IBAction) btn_HomePressed:(id)sender;
-(IBAction) btn_SavePressed:(id)sender;
-(IBAction) btChangePhotoPressed:(id)sender;

-(void)MakeValidation;
-(void)btnDOB_clicked:(id)sender;
-(void)cancel_clicked:(id)sender;
-(void)done_clicked:(id)sender;
-(void)tabOnOff_clicked:(id)sender;
-(void) ReloadSettingsData;
-(void)setLocalizedText;
-(IBAction)btnModuleClicked:(id)sender;

@end
