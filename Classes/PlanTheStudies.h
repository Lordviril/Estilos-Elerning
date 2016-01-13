//
//  PlanTheStudies.h
//  eEducation
//
//  Created by Hidden Brains on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "ReaderDocument.h"
#import "ReaderContentView.h"
@class PlanTheStudies;
@class ReaderScrollView;
@interface PlanTheStudies : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate, ReaderContentViewDelegate>
{
	IBOutlet UIButton	*btn_pre;
	IBOutlet UIButton	*btn_next;
	IBOutlet UIButton   *btn_settings;
    NSInteger	indexValue;
	IBOutlet UILabel	*lblTitle;
	NSURL	*fileURL;
	IBOutlet UIImageView *Imgtopbar,*imglogo,*imgBackground,*imgSegment,*imgBottom;
	IBOutlet UILabel *lbl_head;
	IBOutlet UIButton *btn_ZoomPlus,*btn_Zoomminus,*btn_courses,*btn_PlanDeStudies;
	IBOutlet UIButton *btn_courses1,*btn_Module1,*btn_chapter1;
	NSString *Istype;
	ReaderDocument *document;
	IBOutlet ReaderScrollView *theScrollView;
	NSMutableDictionary *contentViews;		
	NSInteger currentPage;
	NSDate *lastHideTime;
	NSString *TitleOfPdfName;
	IBOutlet UIButton *BackBtn;
	BOOL isVisible;
    BOOL isFirstTime;
}
@property (retain, nonatomic)ReaderContentView *objContentView;
@property (retain, nonatomic) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) NSString *Istype;
@property (nonatomic,retain) NSString *TitleOfPdfName;
-(IBAction)btn_prePressed:(id)sender;
-(IBAction)btn_nextPressed:(id)sender;
-(IBAction)btn_coursesPressed:(id) sender;
-(IBAction)btn_ZoomPlusPressed:(id)sender;
-(IBAction)btn_ZoomminusPressed:(id)sender;
-(IBAction)btn_PlanDeStudiesPressed:(id)sender;
-(IBAction)btn_settingsPressed:(id)sender;
-(IBAction) btn_courses1Pressed:(id)sender;
-(IBAction) btn_Module1Pressed:(id)sender;
-(IBAction) btn_chapter1Pressed:(id)sender;
-(IBAction) BackBtnPressed:(id)sender;
-(void) updateBottomTitle;
- (void)decrementPageNumber;
- (void)incrementPageNumber;
- (id)initWithReaderDocument:(ReaderDocument *)object;
- (void)HideAndShowController:(BOOL)value;
@end



