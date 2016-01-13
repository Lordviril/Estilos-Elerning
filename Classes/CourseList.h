//
//  CourseList.h
//  eEducation
//
//  Created by Hidden Brains on 10/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
@class ReflectionView;
@interface CourseList : UIViewController <iCarouselDataSource, iCarouselDelegate>
{
	IBOutlet UIImageView *imageBackground;
	IBOutlet UIImageView *imagecoverFlow;
	IBOutlet UILabel *courses,*lbl_head;
	IBOutlet UIImageView *imageTopbar,*imageThumb,*imageMainbackground,*image_leftThumb;
	IBOutlet UITextView *textview;
	IBOutlet UIButton *btn_studyPlan,*btn_bibilography,*btn_tutiorial;
	IBOutlet UIImageView *ImageLogo;
	IBOutlet UIButton *btn_Lock;
	IBOutlet UIScrollView *Scrollview;
	IBOutlet UIImageView *coursesLine;
	NSMutableArray *DataSourceArray;
	ReflectionView *reflectionView;
    
	//JSON Parser
	JSONParser *objParser;
	NSMutableArray *ArrayResponse;
	MBProgressHUD *HUD;
    eEducationAppDelegate *appDelegate;
	NSURLConnection *connection;
	NSMutableData  *appListData;
	NSMutableString *pdfName;
	NSMutableDictionary *SelectedDictonary;
	AsyncImageView *_imageAsynchronus;
	UILabel *_labelCourseName;
	NSString *microSiteUrl;
	IBOutlet UIButton *_btnmicrositeUrl;	
}

@property (nonatomic, retain) IBOutlet UILabel *labelCourseName;
@property (nonatomic, retain)  ReflectionView *reflectionView;
@property (nonatomic, retain) IBOutlet iCarousel *carousel_unregisteredCourses;
@property (nonatomic, retain) NSMutableData *appListData;
@property (nonatomic,retain)NSURLConnection *connection;
@property (nonatomic, retain) AsyncImageView *imageAsynchronus;
-(IBAction) btn_studyPlanPressed:(id)sender;
-(IBAction) btn_tutiorialPressed:(id)sender;
-(IBAction) btn_bibilographylPressed:(id)sender;
-(IBAction) btn_LockPressed:(id)sender;
-(void)setLocalizedText;
//Extended Functinality Checking PDF Path IF Not Found Download it
-(IBAction)goToMicrositeUrl:(id)sender;
-(NSString *) GetPath:(NSString *)Path;
- (void)handleError:(NSError *)error;
-(void)downloadFile:(NSURL *)url;
-(BOOL)checkExistOfFile:(NSString*)fileName;
-(void)displayPDFDocumentView;
-(void) refreshView;
@end
