
#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "JSONParser.h"
#import "StringEncryption.h"
#import "MBProgressHUD.h"
#import "AsyncImageView.h"
#import "eEducationConstants.h"
#import "DataBase.h"

@class eEducationAppDelegate;
@class ReflectionView;

@interface ModulesList : UIViewController <iCarouselDataSource, iCarouselDelegate,UINavigationControllerDelegate>
{
	IBOutlet UIImageView *imageBackground;
	IBOutlet UIImageView *imagecoverFlow;
	IBOutlet UILabel *courses;
	IBOutlet UIImageView *imageThumb,*imageMainbackground;
	IBOutlet UILabel *lbl_Edition,*lbl_EditionValue,*lbl_EndDate,*lbl_EndDateValue,*lbl_Date,*lbl_DateValue;
	IBOutlet UITextView *textview,*txtModuleName;
	IBOutlet UIButton *btn_studyPlan,*btn_bibilography,*btn_tutiorial;
	IBOutlet UIScrollView *Scrollview;
	IBOutlet UIButton *tab1,*tab2,*tab3,*tab4,*tab5;
	eEducationAppDelegate *appDelegate;
	ReflectionView *reflectionView;
	
	NSMutableDictionary *_DicCourseDetails;
	UILabel *_labelCourseTitle;
	
	//For JSON Parsing
	JSONParser *objParser;
	NSMutableArray *DataSourceArray;
	MBProgressHUD *HUD;
	NSURLConnection *connection;
	NSMutableData  *appListData;
	NSString *pdfName;
	AsyncImageView *_imageAsynchronus;
	NSString *strTutorialURL;
}
@property (nonatomic, retain) NSMutableData *appListData;
@property (nonatomic,retain)NSURLConnection *connection;
@property (nonatomic, retain)  ReflectionView *reflectionView;
@property (nonatomic, retain) AsyncImageView *imageAsynchronus;
@property (nonatomic, retain) NSMutableDictionary *DicCourseDetails;
@property (nonatomic, retain) IBOutlet UILabel *labelCourseTitle;
@property (nonatomic, retain) IBOutlet iCarousel *carousel_modules;
@property (nonatomic, retain) NSString *strTutorialURL;

@property (nonatomic, retain) IBOutlet AsyncImageView *imgProfile;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle,*lblProfileGrayName,*lblProfileBlueName;
@property (nonatomic, retain) IBOutlet UIButton *btnBack;

-(IBAction)proImgClicked:(id)sender;
-(IBAction)btnStudentsClicked:(id)sender;
-(IBAction)btnSettingsClicked:(id)sender;
-(IBAction)btnLogoutClicked:(id)sender;
-(IBAction)btnBackClicked:(id)sender;

-(IBAction) btn_studyPlanPressed:(id)sender;
-(IBAction) btn_tutiorialPressed:(id)sender;
-(IBAction) btn_bibilographylPressed:(id)sender;
-(IBAction) TabarIndexSelected:(id)sender;

-(void)setLocalizedText;
-(void)jsonRequest;
-(void) refreshView;

-(double)doubleFromString:(NSString*)_strDate;
-(NSString *) GetPath:(NSString *)Path;
- (void)handleError:(NSError *)error;
-(void)downloadFile:(NSURL *)url;
-(BOOL)checkExistOfFile:(NSString*)fileName;
-(void)displayPDFDocumentView;


@end