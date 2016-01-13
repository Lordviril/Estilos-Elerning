//
//  Forum.h
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
#import "RTLabel.h"
#import "ForumCellHeader.h"
#import "ForumCell.h"
#import "AsyncImageView.h"
#import "ForumDetailCustomCell.h"
#import "CustomTextField.h"
#import "UIPlaceHolderTextView.h"

@class eEducationAppDelegate;

@interface Forum : UIViewController<UITextViewDelegate> 
{
    NSInteger endSection;
    NSInteger didSection;
    BOOL ifOpen;
	eEducationAppDelegate *appDelegate;
	JSONParser *objParser;
	MBProgressHUD *HUD;
	UIPopoverController *popoverController;
	UITextView	*textViewComment;
	UIToolbar *pickerToolbar;
	UILabel *labPlaceholder;
	BOOL isPostData;
	NSDateFormatter *_dateFormater;
    BOOL isNewForum,isPopUpOpened;
    NSString *selectedForumId,*selectedForumTitle;
    BOOL postedCommentOrForum;
}
@property(nonatomic,retain) NSMutableArray *documentArray,*arrSelectedForumComments;
@property(nonatomic,retain) IBOutlet UITableView *tblView;
@property (nonatomic, retain) IBOutlet AsyncImageView *imgProfile,*imgLogo,*imgLogoStatic;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle,*lblProfileGrayName,*lblProfileBlueName,*lblTopCourse,*lblNumberOfForums;
@property (nonatomic, retain) IBOutlet RTLabel *lblTopDuration;
@property (nonatomic, retain) IBOutlet UIButton *btnHome,*btnCreateNewForum,*btnReply,*btnOkay,*btnCancel,*btnTemp,*btnModule;
@property (nonatomic, retain) UIView *viewHead;
@property (nonatomic, retain) IBOutlet UIView *replyCell,*viewCommentBox;
@property (nonatomic, retain) IBOutlet CustomTextField *txtTitle;
@property (nonatomic, retain) IBOutlet UIPlaceHolderTextView *txtComment;

-(IBAction)proImgClicked:(id)sender;
-(IBAction)btnSettingsClicked:(id)sender;
-(IBAction)btnLogoutClicked:(id)sender;
-(IBAction)btnBackClicked:(id)sender;
-(IBAction)btnStudentsClicked:(id)sender;
-(IBAction)btnReplyClicked:(id)sender;

-(IBAction)btnCancelClicked:(id)sender;
-(IBAction)btnOkayClicked:(id)sender;

-(IBAction)btnCreateNewForumClicked:(id)sender;

-(void)createPopover;
-(void)postcommentinJson;
-(double)ConvertStingdateToDouble:(NSString *)str_date;

@end
