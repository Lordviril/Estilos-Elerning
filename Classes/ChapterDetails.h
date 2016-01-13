//
//  ChapterDetails.h
//  eEducation
//
//  Created by Hidden Brains on 11/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "downloadManager.h"
#import "CustomWebView.h"
@class eEducationAppDelegate;
@class ReflectionView;
@interface ChapterDetails : UIViewController <UIScrollViewDelegate,iCarouselDataSource, iCarouselDelegate,UINavigationControllerDelegate,UIWebViewDelegate,downloadManagerDelegate>
{
	IBOutlet UIImageView *imageBackground;
	IBOutlet UIImageView *imagecoverFlow;
	IBOutlet UILabel *lbl_documents;
	IBOutlet UIImageView *imageTopbar,*imageMainbackground;
	IBOutlet UILabel *lbl_head;
	IBOutlet UIButton *btn_course,*btn_Module,*btn_Chapter;
	IBOutlet UIImageView *ImageLogo;
	IBOutlet UIButton *btn_settings,*btn_home;
	IBOutlet UIScrollView *Scrollview;
	IBOutlet UIImageView *coursesLine;
	//NSMutableArray *DataSourceArray;
	IBOutlet UIImageView *bottomBar;
	IBOutlet UIButton *tab1,*tab2,*tab3,*tab4,*tab5;
	eEducationAppDelegate *appDelegate;
	ReflectionView *reflectionView;
	IBOutlet UIWebView *Web_view;
	//For JSON Parsing
	JSONParser *objParser;
	BOOL isPdfDownload;
	NSMutableArray *ArrayResponse;
	//NSMutableDictionary *SelectedDictonary;
	MBProgressHUD *HUD;
	NSURLConnection *connection;
	NSMutableData  *appListData;
	NSMutableString *pdfName;
	UILabel *labelCourseName;
	IBOutlet UIActivityIndicatorView *ActIndicatorview;
	downloadManager *objDownloadManager;
	NSMutableArray *_urlArray;
	NSMutableData *_videoData;
	NSInteger icourselIndex;
	CustomWebView *_videoWebView;
	UIScrollView *webScrollView;
	NSInteger pageCount;
	int isDisapper;
	float pageHeight;
	NSTimer *loadWebViewTimer;
}

@property (nonatomic, retain) IBOutlet UILabel *labelCourseName;
@property (nonatomic, retain) NSMutableData *appListData;
@property (nonatomic,retain) NSURLConnection *connection;
@property (nonatomic, retain)  ReflectionView *reflectionView;
@property (nonatomic, retain) IBOutlet iCarousel *carousel_Chapters;
-(IBAction) btn_coursePressed:(id)sender;
-(IBAction) btn_ModulePressed:(id)sender;
-(IBAction) btn_ChapterPressed:(id)sender;
-(IBAction) TabarIndexSelected:(id)sender;
-(void) setLocalizedText;
-(NSString *) GetPath:(NSString *)Path;
- (void)handleError:(NSError *)error;
-(void)downloadFile:(NSURL *)url;
-(BOOL)checkExistOfFile:(NSString*)fileName;
-(void)displayPDFDocumentView;
-(void)refreshView;
-(void)ShowPdf:(NSString*)_pdfPath;
//-(void)ShowPdf:(NSString*)_pdfPath videoInfo:(NSMutableDictionary*)videoInfo;
-(NSData *)getCurrentSavedVideoData:(NSArray*)pathArray;
@end