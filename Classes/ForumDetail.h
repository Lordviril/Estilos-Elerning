//
//  ForumDetail.h
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
#import "ForumDetailCustomCell.h"
@class eEducationAppDelegate;
@interface ForumDetail : UIViewController<UITextViewDelegate>
{
	IBOutlet UITableView *tblView;
	NSMutableArray *documentArray;
	IBOutlet UIImageView *titleImgView;
	IBOutlet UILabel *lblTitle;
	NSMutableArray *testArray;
	IBOutlet UIButton *btnCourse,*btnForum,*btnThread;
	eEducationAppDelegate *appDelegate;
	NSString *_stringTopicId;
	JSONParser *objParser;
	MBProgressHUD *HUD;
	IBOutlet UIButton *buttonResponder;
	
	//add comment
	UIPopoverController *popoverController;
	UITextView	*textViewComment;
	UIToolbar *pickerToolbar;
	UILabel *labPlaceholder;
	NSMutableData *webData;
	BOOL isPostData;
	BOOL isalertShow;
	NSString *string_ForumName;
	NSDateFormatter *_dateFormater;
	//float hight;
	
	NSString *description;
}
@property(nonatomic,retain)NSString *_stringTopicId;
@property(nonatomic,retain)NSString *string_ForumName;
-(void)alertShow;
-(void)postcommentinJson;
-(void)createPopover;
-(IBAction)btnForum_Clicked:(id)sender;
-(IBAction)btnCourse_Clicked:(id)sender;
-(IBAction)btnResponder:(id)sender;
-(void)callWebService;
- (void)setLayer:(UIImageView *)imageView;
-(ForumDetailCustomCell*)setMessageDetailCell:(ForumDetailCustomCell *)cell _indexPath:(NSIndexPath*)_indexPath;
@end
