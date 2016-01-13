//
//  eEducationAppDelegate.m
//  eEducation
//
//  Created by Hidden Brains on 10/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoadingScreen.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import <CommonCrypto/CommonDigest.h>
#import "LoginScreen.h"

@implementation eEducationAppDelegate

@synthesize window;
@synthesize atinternetloginStatus;
@synthesize delegate;
@synthesize screenWidth;

static NSBundle *myLocalizedBundle;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	myLocalizedBundle=[[NSBundle alloc] init];
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor clearColor]];
	[self checkForDatabase];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
	objMyVariables = [myVariables sharedInstance];
	objMyVariables.doAnswersPosted=TRUE;
    
	NSString *currentLangKey = @"";
	if([[NSUserDefaults standardUserDefaults] objectForKey:@"IS_SPANISH_LANG"] == nil)
	{
		[[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"IS_SPANISH_LANG"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"vLang"];
		[[NSUserDefaults standardUserDefaults] setObject:@"Spanish" forKey:@"vLanguage"];
	}
    currentLangKey=@"en";
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"IS_SPANISH_LANG"] isEqualToString:@"YES"]){
        currentLangKey=@"sp";
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [eEducationAppDelegate GetLangKey:currentLangKey];
        
	objquestionDetail=[[questionDetail alloc] init];
	objquestionDetail.delegate=self;
	
	self.objLoadingScreen = [[LoadingScreen alloc] initWithNibName:@"LoadingScreen" bundle:nil];
	self.navigationController=[[UINavigationController alloc] initWithRootViewController:self.objLoadingScreen];
    self.navigationController.navigationBarHidden = YES;
    self.window.rootViewController = self.navigationController;
	[self.window makeKeyAndVisible];
	[self checkInternetStatus];
	networkTimer = [[NSTimer scheduledTimerWithTimeInterval:10.0
                                                     target:self
                                                   selector:@selector(checkInternetStatus)
                                                   userInfo:nil
                                                    repeats:YES] retain];
    return YES;
}
-(void)checkForDatabase
{
	NSString *databaseName=@"eEducation_DB.sqlite";
	NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDirectory, YES);
	NSString *documentsDir=[documentPaths objectAtIndex:0];
	NSString *databasePath=[documentsDir stringByAppendingPathComponent:databaseName];
	BOOL success;
	NSFileManager *fileManager=[NSFileManager defaultManager];
	success =[fileManager fileExistsAtPath:databasePath];
	if(!success)
	{
		NSString *databasePathFromApp=[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"eEducation_DB.sqlite"];
		[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
	}
	
}
-(void)setApperenceSetUp
{
    
    if ([[UINavigationBar class] respondsToSelector:@selector(appearance)])
    {
        UIImage *gradientImage44 = [[UIImage imageNamed:@"topbar.png"]
                                    resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        UIImage *gradientImage32 = [[UIImage imageNamed:@"topbar.png"]
                                    resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        [[UINavigationBar appearance] setBackgroundImage:gradientImage44
                                           forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBackgroundImage:gradientImage32
                                           forBarMetrics:UIBarMetricsLandscapePhone];
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              [UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:1.0], UITextAttributeTextColor,
                                                              [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0], UITextAttributeTextShadowColor,
                                                              [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                                              [UIFont fontWithName:@"Arial" size:17], UITextAttributeFont, nil]];
        [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:3 forBarMetrics:UIBarMetricsDefault];
    }
}

-(void)DidSubmitSucesfully:(NSString*)sucess{}
-(void)DidSubmitFail:(NSString*)error{}

+(NSString*)convertString:(NSString*)strDate fromFormate:(NSString*)fFormate toFormate:(NSString*) tFormate{
    NSDateFormatter *tempDateFormatter = [[NSDateFormatter alloc] init];
    [tempDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [tempDateFormatter setDateFormat:fFormate];
    NSDate *_tempEditionDate = [tempDateFormatter dateFromString:strDate];
    [tempDateFormatter setDateFormat:tFormate];
    NSString *str = [tempDateFormatter stringFromDate:_tempEditionDate];
//    NSLog(@"eee : %@",str);
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"IS_SPANISH_LANG"] isEqualToString:@"YES"]) {
        [tempDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"es"]];
        [tempDateFormatter setDateFormat:tFormate];
//        NSLog(@"sssss : %@",[tempDateFormatter stringFromDate:_tempEditionDate]);
        return [tempDateFormatter stringFromDate:_tempEditionDate];
    } else {
        return str;
    }
}


+ (float)getLableHeight :(UILabel*)myLable
{
    CGSize labelSize = [myLable.text sizeWithFont:myLable.font constrainedToSize:CGSizeMake(myLable.frame.size.width, 300) lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize.height;
}

+(BOOL)userIsStudent{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"user_type"] isEqualToString:@"Student"]) {
        return YES;
    }
    return NO;
}

+(BOOL)checkLoggedInUser:(NSString*)name{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"user_name"] isEqualToString:name]) {
        return YES;
    }
    return NO;
}

-(void)removePresentVC{
    NSMutableArray *controllers = [[self.navigationController.viewControllers mutableCopy] autorelease];
    [controllers removeLastObject];
    self.navigationController.viewControllers = [NSArray arrayWithArray:controllers];
}

+(NSURL*)getTopStaticUrl{
    return [NSURL URLWithString:[[[NSUserDefaults standardUserDefaults] valueForKey:@"header_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

+(NSURL*)getTopCourseUrl{
    return [NSURL URLWithString:[[[NSUserDefaults standardUserDefaults] valueForKey:@"course_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

#pragma mark - check for key in dict
+(NSString*)getValurForKey :(NSMutableDictionary*)dict : (NSString*)key{
    if ([dict valueForKey:key] == nil || [[dict valueForKey:key] isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return [dict valueForKey:key];
}

#pragma mark -
#pragma mark Tabbar
-(void)CustomizeTabbarIpad{
    
    self.tabbarController =[[UITabBarController alloc] init];
    
    VirtualLibrary *objVirtualLibrary =[[VirtualLibrary alloc] initWithNibName:@"VirtualLibrary" bundle:nil];
    UINavigationController *navVirtualLibrary = [[UINavigationController alloc] initWithRootViewController:objVirtualLibrary];
    navVirtualLibrary.navigationBarHidden = YES;
    
    Alert *objAlert = [[Alert alloc] initWithNibName:@"Alert" bundle:nil];
    UINavigationController *navAlert = [[UINavigationController alloc] initWithRootViewController:objAlert];
    navAlert.navigationBarHidden = YES;
    
    Message *objMessage = [[Message alloc] initWithNibName:@"Message" bundle:nil];
    UINavigationController *navMessage = [[UINavigationController alloc] initWithRootViewController:objMessage];
    navMessage.navigationBarHidden = YES;
    
    Calender *objCalender =[[Calender alloc] initWithNibName:@"Calender" bundle:nil];
    UINavigationController *navCalender = [[UINavigationController alloc] initWithRootViewController:objCalender];
    navCalender.navigationBarHidden = YES;
    
    Forum *objForum =[[Forum alloc] initWithNibName:@"Forum" bundle:nil];
    UINavigationController *navForum = [[UINavigationController alloc] initWithRootViewController:objForum];
    navForum.navigationBarHidden = YES;
    
    [self.tabbarController setViewControllers:[NSArray arrayWithObjects:navVirtualLibrary,navForum,navAlert,navCalender,navMessage,nil]];
    
    for(UITabBarItem *item in self.tabbarController.tabBar.items){
        item.title=nil;
        item.image=nil;
        item.enabled = false;
    }
    
    [self.tabbarController.tabBar setBackgroundImage:[UIImage imageNamed:@"bottambar.png"]];
    [self.tabbarController.tabBar setContentMode:UIViewContentModeScaleToFill];
    self.tabbarController.tabBar.frame = CGRectMake(self.tabbarController.tabBar.frame.origin.x, self.window.frame.size.height-49, self.tabbarController.tabBar.frame.size.width, 49);
    self.tabbarController.tabBar.clipsToBounds = YES;
    
    UIButton *tab1=[UIButton buttonWithType:UIButtonTypeCustom];
    tab1.frame=CGRectMake(48, 0, 134, 49);
    tab1.tag=1;
    [tab1 addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchDown];
    
    img1=[[UIImageView alloc] initWithFrame:CGRectMake(48, 0, 134, 49)];
    img1.contentMode = UIViewContentModeRight;
    img1.image=[eEducationAppDelegate GetLocalImage:@"biblioteca@2x"];
    
    UIButton * tab2=[UIButton buttonWithType:UIButtonTypeCustom];
    tab2.frame=CGRectMake(182, 0, 134, 49);
    tab2.tag=2;
    [tab2 addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchDown];
    
    img2=[[UIImageView alloc] initWithFrame:CGRectMake(182, 0, 134, 49)];
    img2.contentMode = UIViewContentModeCenter;
    img2.image=[eEducationAppDelegate GetLocalImage:@"foro@2x"];
    
    UIButton * tab3=[UIButton buttonWithType:UIButtonTypeCustom];
    tab3.frame=CGRectMake(316, 0, 134, 49);
    tab3.tag=3;
    [tab3 addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchDown];
    img3=[[UIImageView alloc] initWithFrame:CGRectMake(316, 0, 134, 49)];
    img3.contentMode = UIViewContentModeLeft;
    img3.image=[eEducationAppDelegate GetLocalImage:@"avisos@2x"];
    
    UIButton * tab4=[UIButton buttonWithType:UIButtonTypeCustom];
    tab4.frame=CGRectMake(450, 0, 134, 49);
    tab4.tag=4;
    [tab4 addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchDown];
    img4=[[UIImageView alloc] initWithFrame:CGRectMake(450, 0, 134, 49)];
    img4.contentMode = UIViewContentModeLeft;
    img4.image=[eEducationAppDelegate GetLocalImage:@"calendario@2x"];

    UIButton * tab5=[UIButton buttonWithType:UIButtonTypeCustom];
    tab5.frame=CGRectMake(584, 0, 134, 49);
    tab5.tag=5;
    [tab5 addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchDown];
    img5=[[UIImageView alloc] initWithFrame:CGRectMake(584, 0, 134, 49)];
    img5.contentMode = UIViewContentModeLeft;
    img5.image=[eEducationAppDelegate GetLocalImage:@"mensajes@2x"];

    
    [self.tabbarController.tabBar addSubview:img1];
    [self.tabbarController.tabBar addSubview:img2];
    [self.tabbarController.tabBar addSubview:img3];
    [self.tabbarController.tabBar addSubview:img4];
    [self.tabbarController.tabBar addSubview:img5];
    
    [self.tabbarController.tabBar addSubview:tab1];
    [self.tabbarController.tabBar addSubview:tab2];
    [self.tabbarController.tabBar addSubview:tab3];
    [self.tabbarController.tabBar addSubview:tab4];
    [self.tabbarController.tabBar addSubview:tab5];
    
}

-(void)tabButtonClicked:(UIButton *)sender{
    
    if(sender.tag-1 == self.tabbarController.selectedIndex)
    {
        self.tabbarController.selectedIndex=sender.tag-1;
        UINavigationController *navController=[self.tabbarController.viewControllers objectAtIndex:sender.tag-1];
        [navController popToRootViewControllerAnimated:YES];
    }else {
        self.tabbarController.selectedIndex=sender.tag-1;
    }
    
    if(sender.tag ==1){
        img1.image=[eEducationAppDelegate GetLocalImage:@"biblioteca_h@2x"];
        img2.image=[eEducationAppDelegate GetLocalImage:@"foro@2x"];
        img3.image=[eEducationAppDelegate GetLocalImage:@"avisos@2x"];
        img4.image=[eEducationAppDelegate GetLocalImage:@"calendario@2x"];
        img5.image=[eEducationAppDelegate GetLocalImage:@"mensajes@2x"];
    }else if(sender.tag==2){
        img1.image=[eEducationAppDelegate GetLocalImage:@"biblioteca@2x"];
        img2.image=[eEducationAppDelegate GetLocalImage:@"foro_h@2x"];
        img3.image=[eEducationAppDelegate GetLocalImage:@"avisos@2x"];
        img4.image=[eEducationAppDelegate GetLocalImage:@"calendario@2x"];
        img5.image=[eEducationAppDelegate GetLocalImage:@"mensajes@2x"];
    }
    else if(sender.tag  == 3){
        img1.image=[eEducationAppDelegate GetLocalImage:@"biblioteca@2x"];
        img2.image=[eEducationAppDelegate GetLocalImage:@"foro@2x"];
        img3.image=[eEducationAppDelegate GetLocalImage:@"avisos_h@2x"];
        img4.image=[eEducationAppDelegate GetLocalImage:@"calendario@2x"];
        img5.image=[eEducationAppDelegate GetLocalImage:@"mensajes@2x"];
    }
    else if(sender.tag  == 4){
        img1.image=[eEducationAppDelegate GetLocalImage:@"biblioteca@2x"];
        img2.image=[eEducationAppDelegate GetLocalImage:@"foro@2x"];
        img3.image=[eEducationAppDelegate GetLocalImage:@"avisos@2x"];
        img4.image=[eEducationAppDelegate GetLocalImage:@"calendario_h@2x"];
        img5.image=[eEducationAppDelegate GetLocalImage:@"mensajes@2x"];
    }
    else if(sender.tag  == 5){
        img1.image=[eEducationAppDelegate GetLocalImage:@"biblioteca@2x"];
        img2.image=[eEducationAppDelegate GetLocalImage:@"foro@2x"];
        img3.image=[eEducationAppDelegate GetLocalImage:@"avisos@2x"];
        img4.image=[eEducationAppDelegate GetLocalImage:@"calendario@2x"];
        img5.image=[eEducationAppDelegate GetLocalImage:@"mensajes_h@2x"];
    }
}

-(void)setUpTabbar{
    self.tabbarController = [[UITabBarController alloc] init];
    self.tabbarController.delegate = self;
    [self.tabbarController.tabBar setBackgroundImage:[UIImage imageNamed:@"bottam-bar.png"]];
    
    VirtualLibrary *objVirtualLibrary =[[VirtualLibrary alloc] initWithNibName:@"VirtualLibrary" bundle:nil];
    UINavigationController *navVirtualLibrary = [[UINavigationController alloc] initWithRootViewController:objVirtualLibrary];
    navVirtualLibrary.navigationBarHidden = YES;
    
    Alert *objAlert = [[Alert alloc] initWithNibName:@"Alert" bundle:nil];
    UINavigationController *navAlert = [[UINavigationController alloc] initWithRootViewController:objAlert];
    navAlert.navigationBarHidden = YES;
    
    Message *objMessage = [[Message alloc] initWithNibName:@"Message" bundle:nil];
    UINavigationController *navMessage = [[UINavigationController alloc] initWithRootViewController:objMessage];
    navMessage.navigationBarHidden = YES;
    
    Calender *objCalender =[[Calender alloc] initWithNibName:@"Calender" bundle:nil];
    UINavigationController *navCalender = [[UINavigationController alloc] initWithRootViewController:objCalender];
    navCalender.navigationBarHidden = YES;
    
    Forum *objForum =[[Forum alloc] initWithNibName:@"Forum" bundle:nil];
    UINavigationController *navForum = [[UINavigationController alloc] initWithRootViewController:objForum];
    navForum.navigationBarHidden = YES;
    
    [self.tabbarController setViewControllers:[NSArray arrayWithObjects:navVirtualLibrary, navAlert,navMessage,navCalender,navForum,nil]];
    
    /**
     *	set up tabbar images
     */
    
    UITabBarItem *homeTabItem = [[UITabBarItem alloc] init];
    [homeTabItem setFinishedSelectedImage:[UIImage imageWithContentsOfFile:[self getImageForName:@"biblioteca_h@2x.png"]] withFinishedUnselectedImage:[UIImage imageWithContentsOfFile:[self getImageForName:@"biblioteca@2x.png"]]];
    navVirtualLibrary.tabBarItem = homeTabItem;
    
    UITabBarItem *addWebsiteTabItem = [[UITabBarItem alloc] init];
    [addWebsiteTabItem setFinishedSelectedImage:[UIImage imageWithContentsOfFile:[self getImageForName:@"foro_h@2x.png"]] withFinishedUnselectedImage:[UIImage imageWithContentsOfFile:[self getImageForName:@"foro@2x.png"]]];
    navAlert.tabBarItem = addWebsiteTabItem;
    
    UITabBarItem *newsTabItem = [[UITabBarItem alloc] init];
    [newsTabItem setFinishedSelectedImage:[UIImage imageWithContentsOfFile:[self getImageForName:@"avisos_h@2x.png"]] withFinishedUnselectedImage:[UIImage imageWithContentsOfFile:[self getImageForName:@"avisos@2x.png"]]];
    newsTabItem.badgeValue = @"3";
    navMessage.tabBarItem = newsTabItem;
    
    UITabBarItem *userTabItem =[[UITabBarItem alloc] init];
    [userTabItem setFinishedSelectedImage:[UIImage imageWithContentsOfFile:[self getImageForName:@"calendario_h@2x.png"]] withFinishedUnselectedImage:[UIImage imageWithContentsOfFile:[self getImageForName:@"calendario@2x.png"]]];
    navCalender.tabBarItem = userTabItem;
    
    UITabBarItem *profileTabItem = [[UITabBarItem alloc] init];
    [profileTabItem setFinishedSelectedImage:[UIImage imageWithContentsOfFile:[self getImageForName:@"mensajes_h@2x.png"]] withFinishedUnselectedImage:[UIImage imageWithContentsOfFile:[self getImageForName:@"mensajes@2x.png"]]];
    navForum.tabBarItem = profileTabItem;
}

-(NSString*)getImageForName:(NSString*)name{
    NSString *currentLangKey = @"en";
	if([[NSUserDefaults standardUserDefaults] objectForKey:@"IS_SPANISH_LANG"])
    {
        currentLangKey = @"sp";
    }
    NSString *imagePath = [[NSBundle bundleWithPath:[eEducationAppDelegate GetLangKey:currentLangKey]] pathForResource:name ofType:nil];
    return imagePath;
}

-(void)pushToTabbarWithSelection:(int)index
{
   [self CustomizeTabbarIpad];
    UIButton *tab1=[UIButton buttonWithType:UIButtonTypeCustom];
    tab1.tag=index;
     [self tabButtonClicked:tab1];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:self.tabbarController animated:NO];
}

#pragma mark -
#pragma mark UniqueNameGeneratorFromUrl
+(NSString *)UniqueNameGeneratorFromUrl:(NSString *)StringUrl
{
	const char *str = [StringUrl UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    return filename;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


- (void) checkInternetStatus
{
	Reachability *internetReachable =[Reachability reachabilityForInternetConnection];
	NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
	switch (internetStatus)
	{
		case NotReachable:
		{
			objMyVariables.isInternetAvailable = FALSE;
			break;
		}
		default:
		{
			objMyVariables.isInternetAvailable = TRUE;
		}
	}
}

-(void)GoTOLoginScreen:(BOOL)isTabBar {
	
	NSArray *viewContrlls=[[NSArray alloc] initWithArray:[self.navigationController viewControllers]];
	for( int i=0;i<[viewContrlls count];i++){
		id obj=[viewContrlls objectAtIndex:i];
		if([obj isKindOfClass:[LoginScreen class]] ){
			if(isTabBar){
			}
			[self.navigationController popToViewController:obj animated:YES];
			[viewContrlls release];
			return;
		}
	}
	[viewContrlls release];
}


#pragma mark Localization

+(NSString *)GetLangKey:(NSString *)Langkey
{
	NSString *tmpstr=[NSString stringWithFormat:@"%@",[[NSBundle mainBundle]pathForResource:@"LanguageResources" ofType:@"bundle"]];
	tmpstr =[tmpstr stringByAppendingString:@"/"];
	tmpstr=[tmpstr stringByAppendingString:Langkey];
	tmpstr =[tmpstr stringByAppendingString:@".lproj"];
	myLocalizedBundle=[NSBundle bundleWithPath:tmpstr];
	return tmpstr;
}

+(UIImage*)GetLocalImage:(NSString *)ImgName
{
	NSString *filepath= [myLocalizedBundle pathForResource:ImgName ofType:@"png"];
	UIImage *returnImg=[UIImage imageWithContentsOfFile:filepath];
	return returnImg;
}

+(UIImage*)GetLocalImage:(NSString *)ImgName Type:(NSString *)imgType
{
	NSString *filepath= [myLocalizedBundle pathForResource:ImgName ofType:imgType];
	UIImage *returnImg=[UIImage imageWithContentsOfFile:filepath];
	return returnImg;
}

+(NSString *)getLocalvalue:(NSString*)Key
{
	NSString *localValue=NSLocalizedStringFromTableInBundle(Key,@"Localized",myLocalizedBundle,@"");
	return localValue;
}

+(void)PlayVideo{
	
}

+(NSString *)removeIllegalCharters:(NSString *)string
{
	NSRange r;
    while ((r = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        string = [string stringByReplacingCharactersInRange:r withString:@""];
	string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@""];
	return string;
	
}

+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize andImage:(UIImage *) sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(targetSize, 1.0f, 0.0f);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
}
#pragma mark - LoadMore Table Data
#pragma mark
+ (NSInteger)loadMore : (NSInteger)numberOfItemsToDisplay arrayTemp:(NSMutableArray*)aryItems tblView:(UITableView*)tblList
{
    int count =0;
    NSUInteger i, totalNumberOfItems = [aryItems count];
    NSUInteger newNumberOfItemsToDisplay = MAX(kNumberOfItemsPerPage, numberOfItemsToDisplay + kNumberOfItemsPerPage);
    newNumberOfItemsToDisplay = MIN(totalNumberOfItems, newNumberOfItemsToDisplay);
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for (i=numberOfItemsToDisplay; i<newNumberOfItemsToDisplay; i++)
    {
        count++;
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    numberOfItemsToDisplay = newNumberOfItemsToDisplay;
    [tblList beginUpdates];
    [tblList insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
    if (newNumberOfItemsToDisplay == totalNumberOfItems)
        [tblList deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationLeft];
    NSIndexPath *scrollPointIndexPath;
    scrollPointIndexPath = (0 < 0)?[NSIndexPath indexPathForRow:numberOfItemsToDisplay-0 inSection:0]:[NSIndexPath indexPathForRow:i-count inSection:0];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 100000000), dispatch_get_main_queue(), ^(void){
        [tblList scrollToRowAtIndexPath:scrollPointIndexPath atScrollPosition:UITableViewScrollPositionNone  animated:YES];
    });
    return numberOfItemsToDisplay;
}
#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)dealloc {
	[myLocalizedBundle release];
	[self.navigationController release];
	[window release];
	[super dealloc];
}

@end

