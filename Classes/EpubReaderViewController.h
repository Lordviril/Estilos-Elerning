

#import <UIKit/UIKit.h>
#import "ZipArchive.h" 
#import "XMLHandler.h"
#import "EpubContent.h"

@interface EpubReaderViewController : UIViewController<XMLHandlerDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
	IBOutlet UIWebView *_webview;
	IBOutlet UIImageView *_backGroundImage;
    IBOutlet UILabel *_pageNumberLbl;
	XMLHandler *_xmlHandler;
	EpubContent *_ePubContent;
	NSString *_pagesPath;
	NSString *_rootPath;
	NSString *_strEpubFilePath;
	NSString *_titleName;
	int _pageNumber;
	IBOutlet UILabel *lbl_head;
	IBOutlet UIButton *btn_Left,*btn_right,*btn_back,*btn_zoomIn,*btn_zoomOut;
	IBOutlet UIImageView *img_background,*topImage,*bottomImage;
	UIScrollView *scrollview;
    BOOL firstTap;
}

@property (nonatomic, retain)EpubContent *_ePubContent;
@property (nonatomic, retain)NSString *_rootPath;
@property (nonatomic, retain)NSString *_strEpubFilePath;
@property (nonatomic, retain)NSString *_titleName;
-(IBAction)Btn_zoomInPressed:(id)sender;
-(IBAction)Btn_zoomOutPressed:(id)sender;
- (void)unzipAndSaveFile;
- (NSString *)applicationDocumentsDirectory; 
- (void)loadPage;
- (NSString*)getRootFilePath;
- (IBAction)onPreviousOrNext:(id)sender;
- (IBAction)onBack:(id)sender;
-(void)updateNextPreviousButtons;
- (void)hideAndShowController:(BOOL)Value;
-(void)fadeOut:(UIView*)viewToDissolve withDuration:(NSTimeInterval)duration   andWait:(NSTimeInterval)wait;
-(void)fadeIn:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration         andWait:(NSTimeInterval)wait;
@end

