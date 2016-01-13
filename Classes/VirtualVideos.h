//
//  VirtualVideos.h
//  eEducation
//
//  Created by HB14 on 09/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "AsyncImageView.h"
#import "RTLabel.h"

@class ReflectionView;
@class ModuleHomePage;

@interface VirtualVideos : UIViewController<iCarouselDataSource, iCarouselDelegate> 
{
	IBOutlet UILabel *lbl_Videos;
//	IBOutlet UILabel *lbl_Duration;
	IBOutlet UILabel *lbl_VideoName;
//	IBOutlet UILabel *lbl_DurationValue;
	IBOutlet UILabel *lbl_VideoNameValue;
	IBOutlet UITextView *txt_Description, *txt_desc;
	
	IBOutlet UILabel *lbl_videoDescription,*lbl_col2,*lbl_speckerDescription,*lbl_col3;
	
	eEducationAppDelegate *appDelegate;
	ReflectionView *reflectionView;

	IBOutlet UIImageView *image_Video;

	JSONParser *objParser;
	NSMutableArray *videoArray;
	MBProgressHUD *HUD;
	AsyncImageView *_imageAsynchronus;
	NSTimer *_timerForFlash;
}
@property (nonatomic,retain) UIImageView *imageViewIndicator;
@property (nonatomic,retain) UIButton *btn_Play;
@property (nonatomic, retain) IBOutlet AsyncImageView *imgProfile,*imgLogo,*imgLogoStatic;
@property (nonatomic, retain) IBOutlet UILabel *lblProfileGrayName,*lblProfileBlueName,*lblTopCourse,*lblTitle,*lblBoxTitle;
@property (nonatomic, retain) IBOutlet RTLabel *lblTopDuration;
@property (nonatomic, retain) IBOutlet UIButton *btnPdf,*btnVideos,*btnHome,*btnModule;

-(IBAction)btnBackClicked:(id)sender;
-(IBAction)proImgClicked:(id)sender;
-(IBAction)btnStudentsClicked:(id)sender;
-(IBAction)btnSettingsClicked:(id)sender;
-(IBAction)btnLogoutClicked:(id)sender;
-(IBAction)btnModuleClicked:(id)sender;

@property (nonatomic, retain) AsyncImageView *imageAsynchronus;
@property (nonatomic, retain)  ReflectionView *reflectionView;
@property (nonatomic, retain) IBOutlet iCarousel *carousel_VirtualVideos;
@property (nonatomic, retain) NSTimer *timerForFlash;

-(void)setLocalizedText;
-(void) refreshview;
-(void) Hideall;
-(void) UnhideAll;
@end
