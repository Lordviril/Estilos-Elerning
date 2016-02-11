//  iCarouselExampleViewController.m
//  iCarouselExample
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//

#import "ICourseList.h"
#import "PlanTheStudies.h"
#import "ModulesList.h"
#import "ReflectionView.h"
#import"Message.h"
#import"Calender.h"
#import"Forum.h"
#import"Alert.h"
#import"VirtualLibrary.h"
#import "YouTubePlayer.h"
#define NUMBER_OF_COURSES ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 10: 12)
#define ITEM_SPACING 150
#define USE_BUTTONS YES
#define degreesToRadian(x) (M_PI * (x) / 180.0)
@implementation ICourseList
@synthesize reflectionView;
@synthesize carousel_courses;
@synthesize appListData;
@synthesize connection;
@synthesize imageAsynchronus = _imageAsynchronus;
- (void)dealloc
{
	[imageBackground release];imageBackground=nil;
	[imagecoverFlow release];imagecoverFlow=nil;
	[courses release];courses=nil;
	[imageThumb release];imageThumb=nil;
	[imageMainbackground release];imageMainbackground=nil;
	[image_leftThumb release];image_leftThumb=nil;
	[lbl_FinalMarks release];lbl_FinalMarks=nil;
	[lbl_FinalMarksValue release];lbl_FinalMarksValue=nil;
	[lbl_Edition release];lbl_Edition=nil;
	[lbl_EditionValue release];lbl_EditionValue=nil;
	[lbl_EndDate release];lbl_EndDate=nil;
	[textview release];textview=nil;
	[btn_studyPlan release];btn_studyPlan=nil;
	[btn_bibilography release];btn_bibilography=nil;
	[btn_tutiorial release];btn_tutiorial=nil;
	[Scrollview release];Scrollview=nil;
	[bottomBar release];bottomBar=nil;
	[tab1 release];tab1=nil;
	[tab2 release];tab2=nil;
	[tab3 release];tab3=nil;
	[tab4 release];tab4=nil;
	[tab5 release];tab5=nil;
	[DataSourceArray release];DataSourceArray=nil;
	[_tempDateFormatter release];_tempDateFormatter=nil;
	[carousel_courses release];
	[_imageAsynchronus release];_imageAsynchronus=nil;
    [txtViewCourseName release];txtViewCourseName=nil;
    [_imgProfile release];_imgProfile=nil;
    [_lblCourses release];_lblCourses=nil;
    [_lblProfileBlueName release];_lblProfileBlueName=nil;
    [_lblProfileGrayName release];_lblProfileGrayName=nil;

	[super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
    
	_tempDateFormatter=[[NSDateFormatter alloc] init];
    [_tempDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
	Scrollview.showsVerticalScrollIndicator=NO;
	DataSourceArray=[[NSMutableArray alloc] init];
	appDelegate=(eEducationAppDelegate *)[[UIApplication sharedApplication]delegate];
	
	_imageAsynchronus = [[AsyncImageView alloc] initWithFrame:CGRectMake(57,122,241,336)];
    
	[Scrollview addSubview:_imageAsynchronus];
	CALayer *viewLayer = [_imageAsynchronus layer];
	[viewLayer setCornerRadius:3.0];
    
	objParser = [[JSONParser alloc] init];
	objParser.delegate = self;
	HUD = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
	HUD.labelText=[eEducationAppDelegate getLocalvalue:@"Please wait"];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;

    self.lblProfileBlueName.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_name"];
    self.lblProfileGrayName.text = [eEducationAppDelegate getLocalvalue:@"WELCOME"];
    [self.imgProfile loadImageFromURL:[NSURL URLWithString:[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_profile_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:@"no-image-200x200.png"];
    
	if([[[NSUserDefaults standardUserDefaults] objectForKey:@"IS_SPANISH_LANG"] isEqualToString:@"YES"])
	{
		currentLangaugeCode=@"Spanish";
	}
	else
	{
		currentLangaugeCode=@"English";
	}
	if(![currentLangauge isEqualToString:currentLangaugeCode])
	{
		currentLangauge=currentLangaugeCode;
		NSString *strURL = [WebService GetRegisteredUserCourseListXml];
		NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:currentLangaugeCode, @"language",
									 [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],@"user_id",nil];
		[objParser sendRequestToParse:strURL params:requestData];
	}
    carousel_courses.type = iCarouselTypeCoverFlow;
	[self setLocalizedText];
    [self.imgLogo loadImageFromURL:[eEducationAppDelegate getTopCourseUrl] imageName:@"top-bar-logo.png"];
    [self.imgLogoStatic loadImageFromURL:[eEducationAppDelegate getTopStaticUrl] imageName:@"logo_top_static.png"];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	self.carousel_courses = nil;
}

#pragma mark - Other methods
/**
 *  Load text as per selected language
 */
-(void)setLocalizedText
{
    self.lblCourses.text=[eEducationAppDelegate getLocalvalue:@"COURSES"];
    
	lbl_FinalMarks.text=[eEducationAppDelegate getLocalvalue:@"Final Evaluation"];
	lbl_Edition.text=[eEducationAppDelegate getLocalvalue:@"Course Edition"];
	lbl_StartDate.text=[eEducationAppDelegate getLocalvalue:@"Start Date Edition"];
	lbl_EndDate.text=[eEducationAppDelegate getLocalvalue:@"End date Edition"];
	courses.text=[eEducationAppDelegate getLocalvalue:@"ACCESS COURSE"];
    
    [btn_studyPlan setTitle:[eEducationAppDelegate getLocalvalue:@"CURRICULAM"] forState:UIControlStateNormal];
    [btn_tutiorial setTitle:[eEducationAppDelegate getLocalvalue:@"TUTORIAL"] forState:UIControlStateNormal];
    [btn_bibilography setTitle:[eEducationAppDelegate getLocalvalue:@"REFERENCES"] forState:UIControlStateNormal];
	
	[tab1 setImage:[eEducationAppDelegate GetLocalImage:@"biblioteca@2x"] forState:0];
	[tab1 setImage:[eEducationAppDelegate GetLocalImage:@"biblioteca_h@2x"] forState:UIControlStateHighlighted];
	
	[tab2 setImage:[eEducationAppDelegate GetLocalImage:@"foro@2x"] forState:0];
	[tab2 setImage:[eEducationAppDelegate GetLocalImage:@"foro_h@2x"] forState:UIControlStateHighlighted];
    
	[tab3 setImage:[eEducationAppDelegate GetLocalImage:@"avisos@2x"] forState:0];
	[tab3 setImage:[eEducationAppDelegate GetLocalImage:@"avisos_h@2x"] forState:UIControlStateHighlighted];
    
	[tab4 setImage:[eEducationAppDelegate GetLocalImage:@"calendario@2x"] forState:0];
	[tab4 setImage:[eEducationAppDelegate GetLocalImage:@"calendario_h@2x"] forState:UIControlStateHighlighted];
    
	[tab5 setImage:[eEducationAppDelegate GetLocalImage:@"mensajes@2x"] forState:0];
	[tab5 setImage:[eEducationAppDelegate GetLocalImage:@"mensajes_h@2x"] forState:UIControlStateHighlighted];
}

/**
 *  Refresh view as per selected course in the coursel
 */
-(void) refreshView
{
    btn_bibilography.hidden = NO;
    btn_studyPlan.hidden = NO;
    btn_tutiorial.hidden = NO;

    btn_studyPlan.frame = CGRectMake(55, 45, 188, 39);
    btn_bibilography.frame = CGRectMake(255, 45, 143, 39);
    btn_tutiorial.frame = CGRectMake(414, 45, 143, 39);

	SelectedDictonary=[ArrayResponse objectAtIndex:0];
	[[NSUserDefaults standardUserDefaults] setObject:[SelectedDictonary  objectForKey:@"course_id"] forKey:@"course_id"];
	[[NSUserDefaults standardUserDefaults] setObject:[SelectedDictonary objectForKey:@"editonid"] forKey:@"editonid"];
	[[NSUserDefaults standardUserDefaults] setObject:[SelectedDictonary objectForKey:@"course_name"] forKey:@"course_name"];
    [[NSUserDefaults standardUserDefaults] setObject:[SelectedDictonary objectForKey:@"logo_header_image"] forKey:@"course_image"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	[_tempDateFormatter setDateFormat:@"yyyy-MM-dd"];
	if(![[SelectedDictonary objectForKey:@"edition_end"] isKindOfClass:[NSNull class]]){
		NSDate *_tempEditionDate = [_tempDateFormatter dateFromString:[SelectedDictonary objectForKey:@"edition_end"]];
		[_tempDateFormatter setDateFormat:@"dd-MM-yyyy"];
		lbl_EndDateValue.text=[_tempDateFormatter stringFromDate:_tempEditionDate];
	}
	if(![[SelectedDictonary objectForKey:@"assignedmark_date"] isKindOfClass:[NSNull class]])
		lbl_FinalMarksValue.text=[eEducationAppDelegate convertString:[SelectedDictonary objectForKey:@"assignedmark_date"] fromFormate:@"yyyy-MM-dd HH:mm:ss" toFormate:@"yyyy - MM - dd"];
	if(![[SelectedDictonary objectForKey:@"edition"] isKindOfClass:[NSNull class]])
		lbl_EditionValue.text=[SelectedDictonary objectForKey:@"edition"];
	if(![[SelectedDictonary objectForKey:@"edition_start"] isKindOfClass:[NSNull class]]){
		[_tempDateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSDate *_tempEditionDate = [_tempDateFormatter dateFromString:[SelectedDictonary objectForKey:@"edition_start"]];
		[_tempDateFormatter setDateFormat:@"dd-MM-yyyy"];
		lbl_StartDateValue.text=[_tempDateFormatter stringFromDate:_tempEditionDate];
	}
    
	if(![[SelectedDictonary objectForKey:@"course_desc"] isKindOfClass:[NSNull class]])
		textview.text=[SelectedDictonary objectForKey:@"course_desc"];
    _imageAsynchronus.contentMode = UIViewContentModeScaleAspectFit;
    [_imageAsynchronus loadImage:[UIImage imageNamed:@"logo_mindway.png"]];
	[_imageAsynchronus loadImageFromURL:[NSURL URLWithString:[[SelectedDictonary objectForKey:@"coursebig_image"] stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation]] imageName:@"logo_mindway.png"];
    
	if(!([[SelectedDictonary objectForKey:@"tutorial"] isKindOfClass:[NSNull class]]) && ([SelectedDictonary objectForKey:@"tutorial"]!=nil))
	{
		strTutorialURL = [SelectedDictonary objectForKey:@"tutorial"];
        if ([strTutorialURL isEqualToString:@""]) {
            btn_tutiorial.hidden = YES;
        } else{
            btn_tutiorial.hidden = NO;
        }
	}
	else
	{
		btn_tutiorial.hidden = YES;
	}
    
    if(([[SelectedDictonary objectForKey:@"bibliography"] isKindOfClass:[NSNull class]]) || ([SelectedDictonary objectForKey:@"bibliography"] == nil) || [[SelectedDictonary objectForKey:@"bibliography"] isEqualToString:@""]){
        btn_bibilography.hidden = YES;
        btn_tutiorial.center = btn_bibilography.center;
    }
	else
		btn_bibilography.hidden = NO;
    
    if([[SelectedDictonary objectForKey:@"study_plan"] isKindOfClass:[NSNull class]] || ([SelectedDictonary objectForKey:@"study_plan"] == nil) || [[SelectedDictonary objectForKey:@"study_plan"] isEqualToString:@""]){
        btn_studyPlan.hidden = YES;
        btn_tutiorial.center = btn_bibilography.center;
        btn_bibilography.center = btn_studyPlan.center;
    }
	else
		btn_studyPlan.hidden = NO;
    
    txtViewCourseName.text = [SelectedDictonary objectForKey:@"course_name"];
    self.lblTopCourse.text = [SelectedDictonary objectForKey:@"course_name"];
    [self.lblTopDuration setDelegate:self];
    [self.lblTopDuration setText:[NSString stringWithFormat:RTLableText,[eEducationAppDelegate getLocalvalue:@"Begins "],[eEducationAppDelegate convertString:[SelectedDictonary objectForKey:@"edition_start"] fromFormate:@"yyyy-MM-dd" toFormate:@"dd MMMM yyyy"],[eEducationAppDelegate getLocalvalue:@"- Ends "],[eEducationAppDelegate convertString:[SelectedDictonary objectForKey:@"edition_end"] fromFormate:@"yyyy-MM-dd" toFormate:@"dd MMMM yyyy"]]];
    [self.imgLogo loadImageFromURL:[eEducationAppDelegate getTopCourseUrl] imageName:@"top-bar-logo.png"];
    [self.imgLogoStatic loadImageFromURL:[eEducationAppDelegate getTopStaticUrl] imageName:@"logo_top_static.png"];
}

-(void)hideall
{
	btn_bibilography.hidden=YES;
	btn_tutiorial.hidden=YES;
	btn_studyPlan.hidden=YES;
}

#pragma mark -
#pragma mark JSONParser delegate method
- (void)parserDidFinishLoadingReturnData:(NSString *)responseString
{
	[HUD setHidden:YES];
	SBJSON *json = [[SBJSON new] autorelease];
	ArrayResponse = [[NSMutableArray alloc] initWithArray:[json objectWithString:responseString error:nil]];
    [[NSUserDefaults standardUserDefaults] setObject:[[ArrayResponse objectAtIndex:0] objectForKey:@"header_image"] forKey:@"header_image"];
    
	if([ArrayResponse count]==0 || ![[[ArrayResponse objectAtIndex:0] objectForKey:@"success"] isEqualToString:@"1"])
	{
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"course_id"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"editonid"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"edition"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"course_name"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"edition_start"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"edition_end"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"course_image"];
        [[NSUserDefaults standardUserDefaults] synchronize];	

		[self hideall];
		[ArrayResponse removeAllObjects];
		[carousel_courses reloadData];
        
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"Currently no course available for this user."] delegate:nil	 cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
        NSMutableDictionary *dict = [ArrayResponse objectAtIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:[dict  objectForKey:@"course_id"] forKey:@"course_id"];
        [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"editonid"] forKey:@"editonid"];
        [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"edition"] forKey:@"edition"];
        [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"course_name"] forKey:@"course_name"];
        [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"edition_start"] forKey:@"edition_start"];
        [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"edition_end"] forKey:@"edition_end"];
        [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"logo_header_image"] forKey:@"course_image"];
        [[NSUserDefaults standardUserDefaults] synchronize];

		[carousel_courses scrollToItemAtIndex:0 animated:NO];
		[carousel_courses reloadData];
		[self refreshView];
	}
}

- (void)parserDidFailWithRestoreError:(NSError*)error :(NSString*)msg
{
	[HUD setHidden:YES];
    if ([msg isEqualToString:@""]) {
        msg = [eEducationAppDelegate getLocalvalue:@"The server cannot be reached. It could be down or busy. Please try again later."];
    }
	UIAlertView *AlertView =  [[UIAlertView alloc]  initWithTitle:alertTitle message:msg delegate:nil 	cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil, nil];
	AlertView.tag=TAG_FailError;
	[AlertView show];
	[AlertView release];
}

#pragma mark -
#pragma mark Topbar Action methods
/**
 *  Fires on click of Profile picture
 *
 *  @param sender btnProfilPic
 */
-(IBAction)proImgClicked:(id)sender{
    [self btnSettingsClicked:nil];
}

/**
 *  Fires on click of students
 *
 *  @param sender btnStudents  
 */
-(IBAction)btnStudentsClicked:(id)sender{
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"course_id"] isEqualToString:@""]) {
        OtherStudents *objOtherStudents = [[OtherStudents alloc] initWithNibName:@"OtherStudents" bundle:nil];
        [self.navigationController pushViewController:objOtherStudents animated:NO];
        [objOtherStudents release];
    }
}

/**
 *  Fires on click of Settings icon
 *
 *  @param sender btnSettings
 */
-(IBAction)btnSettingsClicked:(id)sender{
    Settings *objSettings = [[Settings alloc] initWithNibName:@"Settings" bundle:nil];
	[self.navigationController pushViewController:objSettings animated:NO];
	[objSettings release];
}

/**
 *  Fires on click of Logout button
 *
 *  @param sender btnLogout
 */
-(IBAction)btnLogoutClicked:(id)sender{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"You're about to logout, are you sure?"] delegate:self	 cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"NO"]  otherButtonTitles:[eEducationAppDelegate getLocalvalue:@"YES"],nil];
	[alert show];
	alert.tag=TAG_ALERT_LOGOUT;
	[alert release];
}

#pragma mark -
#pragma mark Action methods
/**
 *  Fires on click of any of the bottom bar buttons
 *
 *  @param sender selectedButton   
 */
-(IBAction) TabarIndexSelected:(id)sender
{
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"course_id"] isEqualToString:@""]) {
        UIButton *btn=sender;
        int i=btn.tag/11;
        appDelegate=(eEducationAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate pushToTabbarWithSelection:i];
    }
}

/**
 *  Fires on click of StudyPlane options
 *
 *  @param sender btnStudyPlane
 */
-(IBAction) btn_studyPlanPressed:(id)sender
{
	btn_studyPlan.selected = YES;
	btn_bibilography.selected = NO;
	UIWindow *mainWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	mainWindow.backgroundColor = [UIColor whiteColor];
	pdfName=[NSString stringWithFormat:@"%@.pdf",[eEducationAppDelegate UniqueNameGeneratorFromUrl:[SelectedDictonary objectForKey:@"study_plan"]]];
	[pdfName retain];
	NSMutableDictionary *_tempDict=[[NSMutableDictionary alloc] init];
	
	if(![DataBase iscontainRecord:[[SelectedDictonary objectForKey:@"course_id"]intValue]*100000 docName:@"Study_Plan"])
	{
		[_tempDict setObject:@"Study_Plan" forKey:@"doc_name"];
		[_tempDict setObject:[SelectedDictonary objectForKey:@"study_plan"] forKey:@"doc_url"];
		[_tempDict setObject:[NSString stringWithFormat: @"%i",[[SelectedDictonary objectForKey:@"course_id"]intValue]*100000] forKey:@"doc_id"];
	    [_tempDict setObject:[SelectedDictonary objectForKey:@"course_name"] forKey:@"course_name"];
		[_tempDict setObject:@"PDF" forKey:@"doc_type"];
		[DataBase addDocumentDetailsToDB:_tempDict isVirtual:1];
	}
	[_tempDict release];
	_tempDict=nil;
	if([self checkExistOfFile:pdfName])
	{
		[self displayPDFDocumentView];
	}
	else
	{
		HUD = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
		HUD.labelText = [eEducationAppDelegate getLocalvalue:@"Loading PDF..."];
		HUD.detailsLabelText = [eEducationAppDelegate getLocalvalue:@"Please wait"];
		[self downloadFile:[NSURL URLWithString:[[SelectedDictonary objectForKey:@"study_plan"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	}
	[mainWindow release];
}

/**
 *  Fires on click of Tutorial option
 *
 *  @param sender btnTutorial 
 */
-(IBAction) btn_tutiorialPressed:(id)sender
{
	YouTubePlayer *objYouTubePlayer = [[YouTubePlayer alloc] initWithNibName:@"YouTubePlayer" bundle:nil];
	objYouTubePlayer.strMovieURL = strTutorialURL;
	objYouTubePlayer.strTitle = @"Tutorial Video";
	objYouTubePlayer.playedFromLocal=NO;
	[self.navigationController pushViewController:objYouTubePlayer animated:YES];
	[objYouTubePlayer release];
}

/**
 *  Fires on click of Bibilography option
 *
 *  @param sender btnBibilograpthy 
 */
-(IBAction) btn_bibilographylPressed:(id)sender
{
	btn_studyPlan.selected = NO;
	btn_bibilography.selected = YES;
	UIWindow *mainWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	mainWindow.backgroundColor = [UIColor whiteColor];
	pdfName=[NSString stringWithFormat:@"%@.pdf",[eEducationAppDelegate UniqueNameGeneratorFromUrl:[SelectedDictonary objectForKey:@"bibliography"]]];
	[pdfName retain];
	NSMutableDictionary *_tempDict=[[NSMutableDictionary alloc] init];
	
	if(![DataBase iscontainRecord:[[SelectedDictonary objectForKey:@"course_id"]intValue]*100000 docName:@"Bibliography"])
	{
		[_tempDict setObject:@"Bibliography" forKey:@"doc_name"];
		[_tempDict setObject:[SelectedDictonary objectForKey:@"bibliography"] forKey:@"doc_url"];
		[_tempDict setObject:[NSString stringWithFormat: @"%i",[[SelectedDictonary objectForKey:@"course_id"]intValue]*100000] forKey:@"doc_id"];
	    [_tempDict setObject:[SelectedDictonary objectForKey:@"course_name"] forKey:@"course_name"];
		[_tempDict setObject:@"PDF" forKey:@"doc_type"];
		[DataBase addDocumentDetailsToDB:_tempDict isVirtual:1];
	}
	[_tempDict release];
	_tempDict=nil;
	if([self checkExistOfFile:pdfName])
	{
		[self displayPDFDocumentView];
	}
	else
	{
		HUD = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
		HUD.labelText = [eEducationAppDelegate getLocalvalue:@"Loading PDF..."];
		HUD.detailsLabelText = [eEducationAppDelegate getLocalvalue:@"Please wait"];
		[self downloadFile:[NSURL URLWithString:[[SelectedDictonary objectForKey:@"bibliography"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	}
	
	[mainWindow release];
}

#pragma mark -
#pragma mark pdfName
/**
 *  Download PDF file
 *
 *  @param url URL of the PDF file 
 */
-(void)downloadFile:(NSURL *)url
{
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
	connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	NSAssert(self.connection != nil, @"Failure to create URL connection.");
	connection = nil;
}

/**
 *  Checks whether the file is already downloaded or not
 *
 *  @param fileName FileName
 *
 *  @return Yes/No
 */
-(BOOL)checkExistOfFile:(NSString*)fileName
{
	NSFileManager *fileManager=[NSFileManager defaultManager];
	return([fileManager fileExistsAtPath:[self GetPath:fileName]]);
}

/**
 *  Gives Path of the downloaded file
 *
 *  @param Path
 *
 *  @return Path of the file
 */
-(NSString *) GetPath:(NSString *)Path
{
	NSString *pathString =@"";
	pathString = [NSString stringWithFormat: @"/%@/PDFBOOKS/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], [[pdfName componentsSeparatedByString:@"."] objectAtIndex:0]];
	[[NSFileManager defaultManager] createDirectoryAtPath:pathString withIntermediateDirectories:NO attributes:NO error:nil];
	if(![[NSFileManager defaultManager] fileExistsAtPath:pathString])
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:pathString withIntermediateDirectories:YES attributes:nil error:nil];
	}
	
	NSString *str=[pathString stringByAppendingPathComponent:Path];
	return str;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	self.appListData = [NSMutableData data];
}

-(void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)recievedData
{
	if (appListData==nil)
	{
		appListData =[[NSMutableData alloc] initWithCapacity:2048];
	}
	[appListData appendData:recievedData];
}

/**
 *  Fires after after file is downloaded
 *
 *  @param theConnection NSUrl connection
 */
-(void)connectionDidFinishLoading:(NSURLConnection*)theConnection
{
	[HUD hide:YES];
	[connection release];
	connection=nil;
	
	NSString *path=[self GetPath:pdfName];
	if([appListData length]<=1000)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
															message:[eEducationAppDelegate getLocalvalue:@"Requested PDF is not found in server please try again."]
														   delegate:nil
												  cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]
												  otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
	else
	{
		[appListData writeToFile:path atomically:YES];
		[appListData release];
		appListData=nil;
		[self displayPDFDocumentView];
	}
}

/**
 *  Displays selected PDF  
 */
-(void)displayPDFDocumentView
{
	NSString *filePath =[self GetPath:pdfName];
	ReaderDocument *document = [[[ReaderDocument alloc] initWithFilePath:filePath password:nil] autorelease];
	
	if (document != nil) // Must have a valid ReaderDocument object in order to proceed
	{
		PlanTheStudies *objPlanTheStudies=[[PlanTheStudies alloc] initWithReaderDocument:document];
		if(btn_studyPlan.selected)
			objPlanTheStudies.Istype=@"PlanTheStudies";
		else
			objPlanTheStudies.Istype=@"bibilography";
		[self.navigationController pushViewController:objPlanTheStudies animated:YES];
		[objPlanTheStudies release];
	}
	else
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
															message:[eEducationAppDelegate getLocalvalue:@"Selected Pdf is not loaded properly."]
														   delegate:nil
												  cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]
												  otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	if ([error code] == kCFURLErrorNotConnectedToInternet)
	{
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"No Connection Error" forKey:NSLocalizedDescriptionKey];
		NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain code:kCFURLErrorNotConnectedToInternet userInfo:userInfo];
		[self handleError:noConnectionError];
	}
	else
	{
		[self handleError:error];
	}
	self.connection = nil;
}

- (void)handleError:(NSError *)error
{
	NSString *errorMessage = [error localizedDescription];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:errorMessage delegate:nil cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
	[HUD hide:YES];
	[alertView show];
	[alertView release];
}

#pragma mark -
#pragma mark iCarousel methods
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [ArrayResponse count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
	NSMutableDictionary *Dict=[ArrayResponse objectAtIndex:index];
	reflectionView=[[ReflectionView alloc] initWithFrame:CGRectMake(0,0, 108,138)];
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame=CGRectMake(0, 0, reflectionView.frame.size.width, reflectionView.frame.size.height);
	[button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
	button.tag = index;
	AsyncImageView *async_iamge = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height)];
    async_iamge.contentMode = UIViewContentModeScaleAspectFit;
	[async_iamge loadImageFromURL:[NSURL URLWithString:[[Dict objectForKey:@"coursesmall_image"] stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation]] imageName:@"logo_mindway.png"];
    
    async_iamge.backgroundColor = [UIColor whiteColor];
	CALayer *viewLayer = [async_iamge layer];
	[viewLayer setBorderWidth:1.0f];
	[viewLayer setBorderColor:[[UIColor blackColor]CGColor]];
	[viewLayer setMasksToBounds:TRUE];
	[self.reflectionView addSubview:async_iamge];
	[async_iamge release];
	[self.reflectionView addSubview:button];
	[self.reflectionView updateReflection];
	return [reflectionView autorelease];
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    return 10;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    //slightly wider than item view
    return ITEM_SPACING;
}

- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
{
    //implement 'flip3D' style carousel
    
    //set opacity based on distance from camera
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    
    //do 3d transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = self.carousel_courses.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * carousel_courses.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    //wrap all carousels
    return NO;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    btn_bibilography.hidden = NO;
    btn_studyPlan.hidden = NO;
    btn_tutiorial.hidden = NO;
    
    btn_studyPlan.frame = CGRectMake(55, 45, 188, 39);
    btn_bibilography.frame = CGRectMake(255, 45, 143, 39);
    btn_tutiorial.frame = CGRectMake(414, 45, 143, 39);
    
    if ([ArrayResponse count] == 0){
        [self hideall];
        return;
    }
	[carousel_courses reloadData];
    if (ArrayResponse.count > 0) {
        SelectedDictonary=[ArrayResponse objectAtIndex:carousel_courses.currentItemIndex];
    } else {
        return;
    }
    
	[[NSUserDefaults standardUserDefaults] setObject:[SelectedDictonary  objectForKey:@"course_id"] forKey:@"course_id"];
	[[NSUserDefaults standardUserDefaults] setObject:[SelectedDictonary objectForKey:@"editonid"] forKey:@"editonid"];
	[[NSUserDefaults standardUserDefaults] setObject:[SelectedDictonary objectForKey:@"edition"] forKey:@"edition"];
	[[NSUserDefaults standardUserDefaults] setObject:[SelectedDictonary objectForKey:@"course_name"] forKey:@"course_name"];
    [[NSUserDefaults standardUserDefaults] setObject:[SelectedDictonary objectForKey:@"logo_header_image"] forKey:@"course_image"];
    [[NSUserDefaults standardUserDefaults] setObject:[SelectedDictonary objectForKey:@"edition_start"] forKey:@"edition_start"];
	[[NSUserDefaults standardUserDefaults] setObject:[SelectedDictonary objectForKey:@"edition_end"] forKey:@"edition_end"];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
	if(![[SelectedDictonary objectForKey:@"edition_end"] isKindOfClass:[NSNull class]]){
		[_tempDateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSDate *_tempEditionDate = [_tempDateFormatter dateFromString:[SelectedDictonary objectForKey:@"edition_end"]];
		[_tempDateFormatter setDateFormat:@"dd-MM-yyyy"];
		lbl_EndDateValue.text=[_tempDateFormatter stringFromDate:_tempEditionDate];
	}
	if(![[SelectedDictonary objectForKey:@"assignedmark_date"] isKindOfClass:[NSNull class]])
		lbl_FinalMarksValue.text=[eEducationAppDelegate convertString:[SelectedDictonary objectForKey:@"assignedmark_date"] fromFormate:@"yyyy-MM-dd HH:mm:ss" toFormate:@"yyyy - MM - dd"];
	if(![[SelectedDictonary objectForKey:@"edition"] isKindOfClass:[NSNull class]])
		lbl_EditionValue.text=[SelectedDictonary objectForKey:@"edition"];
	if(![[SelectedDictonary objectForKey:@"edition_start"] isKindOfClass:[NSNull class]]){
		[_tempDateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSDate *_tempEditionDate = [_tempDateFormatter dateFromString:[SelectedDictonary objectForKey:@"edition_start"]];
		[_tempDateFormatter setDateFormat:@"dd-MM-yyyy"];
		lbl_StartDateValue.text=[_tempDateFormatter stringFromDate:_tempEditionDate];
	}
	
	if(![[SelectedDictonary objectForKey:@"course_desc"] isKindOfClass:[NSNull class]])
		textview.text=[SelectedDictonary objectForKey:@"course_desc"];
	if([[SelectedDictonary objectForKey:@"coursebig_image"] length]>0){
        [_imageAsynchronus loadImage:[UIImage imageNamed:@"logo_mindway.png"]];
        [_imageAsynchronus loadImageFromURL:[NSURL URLWithString:[[SelectedDictonary objectForKey:@"coursebig_image"] stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation]] imageName:@"logo_mindway.png"];
        _imageAsynchronus.contentMode = UIViewContentModeScaleAspectFit;
    }
	else{
        [_imageAsynchronus loadImage:[UIImage imageNamed:@"logo_mindway.png"]];
        [_imageAsynchronus loadImageFromURL:[NSURL URLWithString:[[SelectedDictonary objectForKey:@"coursebig_image"] stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation]] imageName:@"logo_mindway.png"];
        _imageAsynchronus.contentMode = UIViewContentModeScaleAspectFit;
    }
    if ([strTutorialURL isEqualToString:@""] || strTutorialURL == nil)
    {
        btn_tutiorial.hidden = YES;
    }
	else
	{
		btn_tutiorial.hidden = NO;
	}
    
    if(([[SelectedDictonary objectForKey:@"bibliography"] isKindOfClass:[NSNull class]]) || ([SelectedDictonary objectForKey:@"bibliography"] == nil) || [[SelectedDictonary objectForKey:@"bibliography"] isEqualToString:@""]){
        btn_bibilography.hidden = YES;
        btn_tutiorial.center = btn_bibilography.center;
    }
	else
		btn_bibilography.hidden = NO;
    
	if([[SelectedDictonary objectForKey:@"study_plan"] isKindOfClass:[NSNull class]] || ([SelectedDictonary objectForKey:@"study_plan"] == nil) || [[SelectedDictonary objectForKey:@"study_plan"] isEqualToString:@""]){
        btn_studyPlan.hidden = YES;
        btn_tutiorial.center = btn_bibilography.center;
        btn_bibilography.center = btn_studyPlan.center;
    }
	else
		btn_studyPlan.hidden = NO;
    
    txtViewCourseName.text = [SelectedDictonary objectForKey:@"course_name"];
    self.lblTopCourse.text = [SelectedDictonary objectForKey:@"course_name"];
    [self.lblTopDuration setDelegate:self];
    [self.lblTopDuration setText:[NSString stringWithFormat:RTLableText,[eEducationAppDelegate getLocalvalue:@"Begins "],[eEducationAppDelegate convertString:[SelectedDictonary objectForKey:@"edition_start"] fromFormate:@"yyyy-MM-dd" toFormate:@"dd MMMM yyyy"],[eEducationAppDelegate getLocalvalue:@"- Ends "],[eEducationAppDelegate convertString:[SelectedDictonary objectForKey:@"edition_end"] fromFormate:@"yyyy-MM-dd" toFormate:@"dd MMMM yyyy"]]];
    
    [self.imgLogo loadImageFromURL:[eEducationAppDelegate getTopCourseUrl] imageName:@"top-bar-logo.png"];
    [self.imgLogoStatic loadImageFromURL:[eEducationAppDelegate getTopStaticUrl] imageName:@"logo_top_static.png"];
}

#pragma mark -
#pragma mark  UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag==TAG_NO_RECORD_FOUND)
	{
		[self.navigationController popViewControllerAnimated:YES];
	} else if(alertView.tag == TAG_ALERT_LOGOUT && buttonIndex == 1){
        [self.navigationController popViewControllerAnimated:YES];
    } else if(alertView.tag == TAG_ALERT_LOGOUT && buttonIndex == 1){
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if(alertView.tag==TAG_FailError)
	{
		if(buttonIndex==0)
		{
			[appDelegate GoTOLoginScreen:NO];
		}
	} 
}

#pragma mark -
#pragma mark orientation Life Cycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
	{
	}
	else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
	{
		Scrollview.frame=CGRectMake(0, 1, 1024, 655);
		Scrollview.contentSize=CGSizeMake(1024, 845);
		tab1.frame=CGRectMake(252, 655, 80, 49);
		tab2.frame=CGRectMake(362, 655, 80, 49);
		tab3.frame=CGRectMake(472, 655, 80, 49);
		tab4.frame=CGRectMake(582, 655, 80 ,49);
		tab5.frame=CGRectMake(692, 655, 80,49);
		
		imagecoverFlow.frame=CGRectMake(148,624,734,221);
		imageBackground.frame=CGRectMake(0,0,1024,768);
		carousel_courses.frame=CGRectMake(169,664,695,162);
		courses.frame=CGRectMake(171, 631, 403, 21);
        
		_imageAsynchronus.frame = CGRectMake(174,41,275, 350);
		imageMainbackground.frame=CGRectMake(148,20,733,578);
		image_leftThumb.frame=CGRectMake(520,105,320,178);
		textview.frame=CGRectMake(160, 403, 709, 127);
		btn_studyPlan.frame=CGRectMake(304, 537, 169, 45);
		btn_bibilography.frame=CGRectMake(481, 537, 121, 45);
		btn_tutiorial.frame=CGRectMake(611, 537, 101, 45);
		
		
		lbl_FinalMarks.frame=CGRectMake(540, 122, 128, 22);
		lbl_FinalMarksValue.frame=CGRectMake(701, 122, 110, 22);
		
		lbl_Edition.frame=CGRectMake(540, 162, 128, 22);
		lbl_EditionValue.frame=CGRectMake(701, 162, 110, 22);
		
		lbl_EndDate.frame=CGRectMake(540, 202, 143, 22);
		lbl_EndDateValue.frame=CGRectMake(701, 202, 135, 22);
		
		lbl_StartDate.frame=CGRectMake(540, 242, 128, 22);
		lbl_StartDateValue.frame=CGRectMake(701, 242, 110, 22);
	}
}

#pragma mark -
#pragma mark Button tap event
- (void)buttonTapped:(UIButton *)sender
{
    ModuleHomePage *objModuleListHomePage=[[ModuleHomePage alloc] initWithNibName:@"ModuleHomePage" bundle:nil];
    objModuleListHomePage.arrModules = DataSourceArray;
	[self.navigationController pushViewController:objModuleListHomePage animated:NO];
	[objModuleListHomePage release];
}

@end
