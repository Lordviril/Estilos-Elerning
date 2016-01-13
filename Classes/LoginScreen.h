//
//  LoginScreen.h
//  eEducation
//
//  Created by Hidden Brains on 10/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@class Reachability;
@class myVariables;
@class eEducationAppDelegate;
@interface LoginScreen : UIViewController<UITextFieldDelegate,QuestionDelegate,UIGestureRecognizerDelegate>
{
	IBOutlet UIImageView *image_BackGround;
	IBOutlet UIButton *btn_Login;
	IBOutlet UITextField *txt_UserName,*txt_PassWord;
	IBOutlet UIImageView *image_logo,*image_lineForgot;
	Reachability* internetReachable;
	Reachability* hostReachable;
	myVariables *ObjmyVariables;
	eEducationAppDelegate *appDelegate;
	NSMutableDictionary *SettingsData;
    
	//For JSON Parsing
	
	JSONParser *objParser;
	NSMutableArray *ArrayResponse;
	MBProgressHUD *HUD;
	questionDetail *objquestionDetail;
    
    IBOutlet UIWebView *youTubePlayer;
	NSString *strMovieURL;
	NSString *strTitle;
	BOOL playedFromLocal;
	BOOL isPlaying;
    UITapGestureRecognizer *tapRec;
//    IBOutlet UIWebView *webtmp;
}

@property(nonatomic, strong) NSString *youtube_id;
@property(nonatomic, strong)  IBOutlet UILabel *lbl1,*lbl2,*lbl3;
-(IBAction) login_BtnPressed:(id) sender;
-(void)setLocalizedText;
@end
