//
//  CustomNavigationController.h
//  eEducation
//
//  Created by HB14 on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class eEducationAppDelegate;


@interface CustomNavigationController : UINavigationController 
{
	UIImageView *btnLogo;
	UILabel *lblHead;
	UIButton *btnSettings;
	UIButton *btnHome;
	eEducationAppDelegate *appDelegate;
}
@property (nonatomic,retain) UIImageView *btnLogo;
@property (nonatomic,retain) UILabel *lblHead;
@property (nonatomic,retain) UIButton *btnSettings;
@property (nonatomic,retain) UIButton *btnHome;
-(void) btn_settingsPressed:(id)sender;
-(IBAction)btnHome_Clicked:(id)sender;
@end
