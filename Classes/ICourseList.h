
#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "iCarousel.h"
#import "GBPathImageView.h"
#import "Settings.h"
#import "AsyncImageView.h"
#import "JSONParser.h"
#import "MBProgressHUD.h"
#import "ModuleHomePage.h"
#import "OtherStudents.h"

@class eEducationAppDelegate;
@class ReflectionView;
@interface ICourseList : UIViewController <iCarouselDataSource, iCarouselDelegate,UINavigationControllerDelegate,RTLabelDelegate>
{
	IBOutlet UIImageView *imageBackground;
	IBOutlet UIImageView *imagecoverFlow;
	IBOutlet UILabel *courses;
	IBOutlet UIImageView *imageThumb,*imageMainbackground,*image_leftThumb;
	IBOutlet UILabel *lbl_FinalMarks,*lbl_FinalMarksValue,*lbl_Edition,*lbl_EditionValue,*lbl_EndDate,*lbl_EndDateValue,*lbl_StartDate,*lbl_StartDateValue;
	IBOutlet UITextView *textview,*txtViewCourseName;
	IBOutlet UIButton *btn_studyPlan,*btn_bibilography,*btn_tutiorial;
	IBOutlet UIScrollView *Scrollview;
	NSMutableArray *DataSourceArray;
	IBOutlet UIImageView *bottomBar;
	IBOutlet UIButton *tab1,*tab2,*tab3,*tab4,*tab5;
	eEducationAppDelegate *appDelegate;
	ReflectionView *reflectionView;
    
	//For JSON Parsing
	JSONParser *objParser;
	NSMutableArray *ArrayResponse;
	NSMutableDictionary *SelectedDictonary;
	MBProgressHUD *HUD;
	NSURLConnection *connection;
	NSMutableData  *appListData;
	NSMutableString *pdfName;
	AsyncImageView *_imageAsynchronus;
	NSString *currentLangaugeCode;
	NSString *currentLangauge;
	NSString *strTutorialURL;
	NSDateFormatter *_tempDateFormatter;
//    IBOutlet RTLabel *lblTopDuration;
}

@property (nonatomic, retain)  ReflectionView *reflectionView;
@property (nonatomic, retain) IBOutlet iCarousel *carousel_courses;
@property (nonatomic, retain) NSMutableData *appListData;
@property (nonatomic,retain) NSURLConnection *connection;
@property (nonatomic, retain) AsyncImageView *imageAsynchronus;

@property (nonatomic, retain) IBOutlet AsyncImageView *imgProfile,*imgLogo,*imgLogoStatic;
@property (nonatomic, retain) IBOutlet UILabel *lblCourses,*lblProfileGrayName,*lblProfileBlueName,*lblTopCourse;
@property (nonatomic, retain) IBOutlet RTLabel *lblTopDuration;

-(IBAction) btn_studyPlanPressed:(id)sender;
-(IBAction) btn_tutiorialPressed:(id)sender;
-(IBAction) btn_bibilographylPressed:(id)sender;
-(IBAction) TabarIndexSelected:(id)sender;

-(IBAction)proImgClicked:(id)sender;
-(IBAction)btnStudentsClicked:(id)sender;
-(IBAction)btnSettingsClicked:(id)sender;
-(IBAction)btnLogoutClicked:(id)sender;

-(void)setLocalizedText;

-(NSString *) GetPath:(NSString *)Path;
- (void)handleError:(NSError *)error;
-(void)downloadFile:(NSURL *)url;
-(BOOL)checkExistOfFile:(NSString*)fileName;
-(void)displayPDFDocumentView;
-(void) refreshView;
-(void)hideall;

@end
