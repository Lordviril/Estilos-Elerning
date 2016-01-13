

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "JSONParser.h"
#import "MBProgressHUD.h"
#import "ChaptersCell.h"
#import "PracticesCell.h"
#import "VideosCell.h"
#import "GMGridView.h"
#import "validations.h"
#import "UICustomPicker.h"
#import "OtherStudents.h"
#import "SMPageControl.h"
#import "MasterCell.h"

@class eEducationAppDelegate;
@class ReflectionView;

@interface ModuleHomePage : UIViewController <CustomPickerDelegate,UINavigationControllerDelegate,GMGridViewDataSource,GMGridViewActionDelegate,UIScrollViewDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate,answersheetDelegate,QuestionDelegate>
{
	IBOutlet UIButton *tab1,*tab2,*tab3,*tab4,*tab5;
	eEducationAppDelegate *appDelegate;
	JSONParser *objParser;
	NSMutableArray *ChapterListArray,*VideoListArray,*PracticesArray,*TestArray,*TeachersArray,*ExamQuesArray,*ResultArray;
	MBProgressHUD *HUD;
	NSURLConnection *connection;
	BOOL IsModulesListLoaded,IsCompletedChapterListing,isVideosLoaded,isPracticesLoaded,isTestsLoaded,isMastersLoaded;
    
    NSMutableString *pdfName;
    NSMutableData *appListData;
    int selectedChapter;
    int questionNo;
    BOOL isPractPdf,pdfHavingVideos,isReqForExam,isReqForResult;
    NSDate *startDt;
    NSTimer *timer;
}
@property (nonatomic,retain) IBOutlet UILabel *lblTimer,*lblTimerStatic,*lblMasterOfModule;
@property (nonatomic, retain) NSMutableArray *arrModules;
@property (nonatomic, retain) NSMutableDictionary *dictSelectedModule,*dictSelectedPractice,*dictSelctedTest,*dictPastExamDetails;
@property (strong, nonatomic) UICustomPicker *objPicker,*objPractStautsPicker,*objTestStatusPicker;
@property (nonatomic, retain) IBOutlet UIScrollView *scrlView;
@property (nonatomic, retain) IBOutlet AsyncImageView *imgProfile,*imgLogo,*imgLogoStatic;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle,*lblProfileGrayName,*lblProfileBlueName;
@property (nonatomic, retain) IBOutlet UIButton *btnBack;

@property (nonatomic,retain)  IBOutlet UIButton *btnModulesDropDown,*btnObjectives,*btnTableOfContets,*btnCheckList,*btnPractStatus,*btnTestStatus;

@property (nonatomic, strong)  IBOutlet GMGridView *gridChapters,*gridPractices,*gridTest,*gridVideos,*gridTeachers;
@property (nonatomic, retain)  IBOutlet UIPageControl *pcChapters,*pcPractices,*pcTest,*pcVideos,*pcTeacher;
@property (nonatomic, retain)  IBOutlet UILabel *lblBlockTitle,*lblTopCourse;
@property (nonatomic, retain)  IBOutlet UILabel *lblNoChapter,*lblNoPract,*lblNoTest,*lblNoVideo,*lblNoTeacher;
@property (nonatomic, retain)  IBOutlet RTLabel *lblTopDuration,*lblChapterCountTitle,*lblPractCountTitle,*lblTestCountTitle,*lblVIdeosCountTitle;

@property (nonatomic, retain)  IBOutlet UIView *opendView,*viewPracticeSlide,*practPdfSlide;
@property (nonatomic, retain)  IBOutlet UILabel *lblPractSlideTitle,*lblPracatSlideDate,*lblPractSlideDescription;
@property (nonatomic, retain)  IBOutlet UITextView *txtPractSlideDescription;
@property (nonatomic, retain)  IBOutlet RTLabel *lblPractSlideStartDate,*lblPractSlideEndDate;
@property (nonatomic, retain)  IBOutlet UIButton *btnPractDescription,*btnPracticeDocument;
@property (nonatomic, retain)  IBOutlet UIWebView *webViewPdf;

@property (nonatomic, retain)  IBOutlet UIView *viewStartExamSlide,*viewQue,*viewQuesInnerView,*viewAnsSlide,*viewAnsViewInnerSlide;
@property (nonatomic, retain)  IBOutlet UIImageView *imgQuesInnerView,*imgAnsInnerView;
@property (nonatomic, retain)  IBOutlet UILabel *lblTestTitle,*lblTestCompletionDate,*lblTestBlueTitle;
@property (nonatomic, retain)  IBOutlet UITextView *txtTestDiscr;
@property (nonatomic, retain)  IBOutlet UIButton *btnStartExam,*btnNext,*btnQueBack,*btnReply;

@property (nonatomic, retain)  IBOutlet UILabel *lblQues,*lblTestNameQuesSlide,*lblTestTitleQueSlide;
@property (nonatomic, retain)  IBOutlet RTLabel *lblTimeSpent,*lblRating,*lblMarks;
@property (nonatomic, retain)  IBOutlet UILabel *lblAnswerdQues,*lblTestTitleAnsSlide;
@property (nonatomic, retain)  IBOutlet UIButton *btAnsnPrev,*btnAnsNext;
@property (nonatomic) BOOL isFromTabDetails;

@property (nonatomic,retain) NSURLConnection *connection;

-(IBAction)proImgClicked:(id)sender;
-(IBAction)btnStudentsClicked:(id)sender;
-(IBAction)btnSettingsClicked:(id)sender;
-(IBAction)btnLogoutClicked:(id)sender;
-(IBAction)btnBackClicked:(id)sender;

-(void)btnPageControlValueChanged:(UIPageControl*) sender;

-(IBAction)btnObjectivesClicked:(id)sender;
-(IBAction)btnTableOfContentsClicked:(id)sender;
-(IBAction)btnCheckListClicked:(id)sender;

-(IBAction)btnPractCloseClicked:(id)sender;
-(IBAction)btnPractDiscriptionClicked:(id)sender;
-(IBAction)btnPractDocumentClicked:(id)sender;

-(IBAction)btnPractStatusClicked:(id)sender;
-(IBAction)btnTestStatusClicked:(id)sender;
-(IBAction) TabarIndexSelected:(id)sender;
-(IBAction) btnModulesDropDownClicked:(id)sender;

-(IBAction) btnStartExamClickedClicked:(id)sender;
-(IBAction)btnSubmitClicked:(id)sender;

-(IBAction)btnAnsPrevClicked:(id)sender;
-(IBAction)btnAnsNextClicked:(id)sender;

-(void)setLocalizedText;

@end