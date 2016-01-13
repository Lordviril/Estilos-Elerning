//
//  eEducationAppDelegate.h
//  eEducation
//
//  Created by Hidden Brains on 10/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingScreen.h"
#import "CustomTabbarController.h"
#import "CustomNavigationController.h"
#import "myVariables.h"
#import "questionDetail.h"
#import"Message.h"
#import"Calender.h"
#import"Forum.h"
#import"Alert.h"
#import"VirtualLibrary.h"

@protocol answersheetDelegate

- (void) postAnsewersheet;

@end

@interface eEducationAppDelegate : NSObject <UIApplicationDelegate,UITabBarControllerDelegate,UINavigationControllerDelegate,QuestionDelegate> {
    
    UIWindow *window;
    //    UINavigationController *navigationController;
	UIImageView *VirtualLibraryImg, *ForumsImg, *AlertsImg, *calenderImg, *messageImg, *imgTab;
	CustomTabbarController *tabBarController1;
	int selelcted;
    //	LoadingScreen *objLoadingScreen;
	int	screenWidth;
	NSTimer *networkTimer;
	BOOL atinternetloginStatus;
	id<answersheetDelegate>delegate;
	myVariables *objMyVariables ;
	questionDetail *objquestionDetail;
    UIImageView *img1,*img2,*img3,*img4,*img5;
}

@property (nonatomic ,readwrite) BOOL atinternetloginStatus;
@property (nonatomic,retain)LoadingScreen *objLoadingScreen;
@property (nonatomic,readwrite)	int	screenWidth;
@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
//@property (nonatomic,retain) IBOutlet CustomTabbarController *tabBarController;
@property (strong,nonatomic) IBOutlet UITabBarController *tabbarController;
//localization
+(NSString *)GetLangKey:(NSString *)Langkey;
+(UIImage*)GetLocalImage:(NSString *)ImgName;
+(UIImage*)GetLocalImage:(NSString *)ImgName Type:(NSString *)imgType;
+(NSString *)getLocalvalue:(NSString*)Key;
+(NSString *)UniqueNameGeneratorFromUrl:(NSString *)StringUrl;
+(NSString *)removeIllegalCharters:(NSString *)string;
-(void)checkForDatabase;
-(void)GoTOLoginScreen:(BOOL)isTabBar;
+(void)PlayVideo;
- (void) checkInternetStatus;

-(void)pushToTabbarWithSelection:(int)index;
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize andImage:(UIImage *) sourceImage;
+(NSString*)convertString:(NSString*)strDate fromFormate:(NSString*)fFormate toFormate:(NSString*) tFormate;

+ (NSInteger)loadMore : (NSInteger)numberOfItemsToDisplay arrayTemp:(NSMutableArray*)aryItems tblView:(UITableView*)tblList;
+(BOOL)userIsStudent;
+(BOOL)checkLoggedInUser:(NSString*)name;

+(NSString*)getValurForKey :(NSMutableDictionary*)dict : (NSString*)key;
-(void)removePresentVC;
+(NSURL*)getTopStaticUrl;
+(NSURL*)getTopCourseUrl;
+ (float)getLableHeight :(UILabel*)myLable;

@end

