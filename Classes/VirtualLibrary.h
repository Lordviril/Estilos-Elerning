//
//  VirtualLibrary.h
//  eEducation
//
//  Created by HB14 on 09/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"eEducationAppDelegate.h"
#import "downloadManager.h"
#import "RTLabel.h"
#import "AsyncImageView.h"

@class ModuleHomePage;
@interface VirtualLibrary : UIViewController <downloadManagerDelegate>
{
	eEducationAppDelegate *appDelegate;
	NSMutableString *pdfName,*epubName;
	MBProgressHUD *HUD;
	NSURLConnection *connection;
	NSMutableData  *appListData;
	int SelectedDownloadEpub;
	//JSON Parser
	JSONParser *objParser;
	NSMutableArray *BooksDataArray;
	NSMutableArray *EpubsDataArray;
	NSMutableArray *MainDataArray;
	BOOL Ispdf_switchPressed;
	NSData *_videoData;
	NSMutableArray *_urlArray;
	downloadManager *objDownloadManger;
}
@property (nonatomic, retain) IBOutlet UITableView *tblViewBooks,*tblViewVideos;

@property (nonatomic, retain) NSMutableData *appListData;
@property (nonatomic,retain) NSURLConnection *connection;

@property (nonatomic, retain) IBOutlet AsyncImageView *imgProfile,*imgLogo,*imgLogoStatic;
@property (nonatomic, retain) IBOutlet UILabel *lblProfileGrayName,*lblProfileBlueName,*lblTopCourse,*lblTitle,*lblBoxTitle;
@property (nonatomic, retain) IBOutlet RTLabel *lblTopDuration;
@property (nonatomic, retain) IBOutlet UIButton *btnPdf,*btnVideos,*btnHome,*btnModule;
//@property (nonatomic, retain) IBOutlet UIImageView *imgBack;

-(IBAction)proImgClicked:(id)sender;
-(IBAction)btnStudentsClicked:(id)sender;
-(IBAction)btnSettingsClicked:(id)sender;
-(IBAction)btnLogoutClicked:(id)sender;
-(IBAction)btnModuleClicked:(id)sender;

-(IBAction)btnVideos_clicked:(id)sender;
-(IBAction)btnPDF_clicked:(UIButton *)sender;

-(void)displayPDFDocumentView;
-(NSString *) GetPath:(NSString *)Path;
- (void)handleError:(NSError *)error;
-(void)downloadFile:(NSURL *)url;
-(BOOL)checkExistOfFile:(NSString*)fileName;
-(NSData *)getCurrentSavedVideoData:(NSArray*)pathArray;

@end
