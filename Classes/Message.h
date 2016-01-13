//
//  Message.h
//  eEducation
//
//  Created by Hidden Brains on 11/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJSON.h"
#import "StringEncryption.h"
#import "JSONParser.h"
#import "MBProgressHUD.h"
#import "AsyncImageView.h"
#import "RTLabel.h"
#import "CustomCellMessageDetail.h"
#import "CreateMessageOrReply.h"

@class eEducationAppDelegate;
@interface Message : UIViewController<UITextViewDelegate,UITextFieldDelegate,messageDelegate>
{    
	JSONParser *objParser;
	MBProgressHUD *HUD;

	NSMutableArray *msgDetailArray;
	BOOL istablefirsttimeReload;
    eEducationAppDelegate *appDelegate;
    NSString *newMsgOrReply;
    int selectedIndex;
}

@property (nonatomic, retain) NSMutableArray *arrInbox,*arrSent,*arrSelectedThread;
@property (nonatomic, retain) IBOutlet UITableView *tblViewInbox,*tblViewSent;
@property (nonatomic, retain) IBOutlet AsyncImageView *imgProfile,*imgLogo,*imgLogoStatic;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle,*lblProfileGrayName,*lblProfileBlueName,*lblTopCourse;
@property (nonatomic, retain) IBOutlet RTLabel *lblTopDuration;
@property (nonatomic, retain) IBOutlet UIButton *btnHome,*btnInbox,*btnSent,*btnCompose,*btnModule;
@property (nonatomic, retain) IBOutlet UIImageView *imgStrip;
@property (nonatomic,retain) NSString *fromDetail;

@property (nonatomic, retain) IBOutlet UIView *viewSlider,*viewMainContainer;
@property (nonatomic, retain) IBOutlet UITableView *tblConversation;
@property (nonatomic, retain) IBOutlet UIButton *btnPrev,*btnReply;
@property (nonatomic, retain) IBOutlet UILabel *lblSublect;

-(IBAction)proImgClicked:(id)sender;
-(IBAction)btnSettingsClicked:(id)sender;
-(IBAction)btnLogoutClicked:(id)sender;
-(IBAction)btnBackClicked:(id)sender;
-(IBAction)btnStudentsClicked:(id)sender;
-(IBAction)btnModuleClicked:(id)sender;

-(IBAction)btnInBoxClicked:(UIButton*)sender;
-(IBAction)btnSentClicked:(UIButton*)sender;
-(IBAction)btnComposeClicked:(id)sender;

-(IBAction)btnPrevClicked:(id)sender;
-(IBAction)btnReplyClicked:(id)sender;

-(void)getDataFromwebService:(NSInteger)selectedSegment;

@end
