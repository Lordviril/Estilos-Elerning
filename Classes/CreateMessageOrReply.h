//
//  CreateMessageOrReply.h
//  eEducation
//
//  Created by Hidden Brains on 28/11/13.
//
//

#import <UIKit/UIKit.h>
#import "OtherStudents.h"
#import "Settings.h"
#import "CustomTextField.h"
#import "UIPlaceHolderTextView.h"
#import "JSON.h"
#import "MBProgressHUD.h"

@class ModuleHomePage;
@protocol messageDelegate <NSObject>
-(void)messagePosted:(NSString*)msg;
@end

@interface CreateMessageOrReply : UIViewController<UIGestureRecognizerDelegate>{
    JSONParser *objParser;
	MBProgressHUD *HUD;
}
@property (nonatomic,retain) id <messageDelegate> delegate;
@property (nonatomic, retain) IBOutlet AsyncImageView *imgProfile,*imgLogo,*imgLogoStatic;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle,*lblProfileGrayName,*lblProfileBlueName,*lblTopCourse,*lblTime,*lblTitleForRply;
@property (nonatomic, retain) IBOutlet RTLabel *lblTopDuration;
@property (nonatomic, retain) IBOutlet UIButton *btnHome,*btnCancel,*btnOkay,*btnModule;
@property (nonatomic, retain) IBOutlet CustomTextField *txtTitle;
@property (nonatomic, retain) IBOutlet UIPlaceHolderTextView *txtComment;
@property (nonatomic, retain) NSMutableDictionary *dictReceived;
@property (nonatomic) BOOL isNewMessage;

-(IBAction)proImgClicked:(id)sender;
-(IBAction)btnSettingsClicked:(id)sender;
-(IBAction)btnLogoutClicked:(id)sender;
-(IBAction)btnBackClicked:(id)sender;
-(IBAction)btnStudentsClicked:(id)sender;
-(IBAction)btnModuleClicked:(id)sender;

-(IBAction)btnCancelClicked:(id)sender;
-(IBAction)btnOkayClicked:(id)sender;

@end
