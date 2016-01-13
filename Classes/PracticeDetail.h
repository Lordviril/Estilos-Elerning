//
//  PracticeDetail.h
//  eEducation
//
//  Created by Hidden Brains on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class eEducationAppDelegate;
@interface PracticeDetail : UIViewController<UINavigationControllerDelegate>
{
	IBOutlet UIView *uploadView;
	IBOutlet UIView *notUploadView;
	IBOutlet UIButton *btnPrecticeDocument,*btnCourse,*btnModule,*btnPrectice;
	IBOutlet UIButton *btnSetting,*btnUpload;
	IBOutlet UIImageView *notUploadImgView;
	IBOutlet UIImageView *UploadImgView;
	IBOutlet UIButton *_buttonModule;
	bool isUploaded;
	eEducationAppDelegate *appDelegate;
	IBOutlet UIButton *tab1,*tab2,*tab3,*tab4,*tab5;
	IBOutlet UILabel *lbl_name_uploadView,*lbl_startDate_uploadView,*lbl_Description_uploadView,*lbl_EndDate_uploadView,*lbl_colon1,*lbl_colon2;
	IBOutlet UILabel *lbl_nameDetails_uploadView,*lbl_startDateDetails_uploadView,*lbl_EndDateDetails_uploadView,*lbl_MarksDetails_uploadView,*lbl_DateDetails_uploadView,*lbl_marks_uploadView,*lbl_Date_uploadView;
	IBOutlet UITextView *txt_DescriptionDetails_uploadView;
	
	IBOutlet UILabel *lbl_name_notUploadView,*lbl_startDate_notUploadView,*lbl_Description_notUploadView,*lbl_EndDate_notUploadView;
	IBOutlet UILabel *lbl_nameDetails_notUploadView,*lbl_startDateDetails_notUploadView,*lbl_EndDateDetails_notUploadView;
	IBOutlet UITextView *txt_DescriptionDetails_notUploadView;
	NSString *pdfName;
	NSURLConnection *connection;
	NSMutableData *appListData;
	
	NSMutableDictionary *_dicPracticeList;
	UIButton *_buttonViewUploadPriceList;
	MBProgressHUD *HUD;
	
	float height;
}

@property(nonatomic,retain)UIButton *buttonModule;
@property(nonatomic,retain) NSMutableDictionary *dicPracticeList;
@property(nonatomic,retain) NSMutableData *appListData; 
@property(nonatomic,retain) NSURLConnection *connection;
@property(nonatomic,assign)bool isUploaded;
@property(nonatomic,retain) IBOutlet UIButton *buttonViewUploadPriceList;

-(float)heightOfView:(NSString*)_description text_width:(float)_textWidth;
-(IBAction)btnCourse_Clicked:(id)sender;
-(IBAction)btnModule_Clicked:(id)sender;
-(IBAction)btnPractice_Clicked:(id)sender;
-(IBAction)btnPrectice:(id)sender;
-(IBAction)btnViewPractice_Clicked:(id)sender;
-(void)setLocalizedText;
-(NSString *)getProperDate:(NSString *)date_string;
-(IBAction) TabarIndexSelected:(id)sender;
//Extended Functinality Checking PDF Path IF Not Found Download it
-(IBAction)buttonModuleClick:(id)sender;
-(NSString *) GetPath:(NSString *)Path;
- (void)handleError:(NSError *)error;
-(void)downloadFile:(NSURL *)url;
-(BOOL)checkExistOfFile:(NSString*)fileName;
-(void)displayPDFDocumentView;
@end