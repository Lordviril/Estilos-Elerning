//
//  ModulesList.m
//  eEducation
//
//  Created by Hidden Brains on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
#import "ModulesList.h"
#import "PlanTheStudies.h"
#import "Settings.h"
#import "ModuleHomePage.h"
#import"Message.h"
#import"Calender.h"
#import"Forum.h"
#import"Alert.h"
#import"PracticeList.h"
#import"VirtualLibrary.h"
#import "ReflectionView.h"
#import "SBJSON.h"
#import "YouTubePlayer.h"
#define NUMBER_OF_MODULES ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 10: 12)
#define ITEM_SPACING 150
#define USE_BUTTONS YES

@implementation ModulesList
@synthesize reflectionView;
@synthesize carousel_modules;
@synthesize imageAsynchronus = _imageAsynchronus;
@synthesize DicCourseDetails = _DicCourseDetails;
@synthesize labelCourseTitle = _labelCourseTitle;
@synthesize appListData;
@synthesize connection;
@synthesize strTutorialURL;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	imageThumb.hidden = YES;
	Scrollview.showsVerticalScrollIndicator=NO;
	_imageAsynchronus = [[AsyncImageView alloc] initWithFrame:CGRectMake(55,120,245,340)];
	[Scrollview addSubview:_imageAsynchronus];
	
	appDelegate=(eEducationAppDelegate *)[[UIApplication sharedApplication] delegate];
	CALayer *viewLayer = [_imageAsynchronus layer];
	[viewLayer setBorderWidth:2.0f];
	[viewLayer setBorderColor:[[UIColor blackColor]CGColor]];
	[viewLayer setMasksToBounds:TRUE];
	[viewLayer setCornerRadius:5.0];
	NSDateFormatter *_tempDateFormatter=[[NSDateFormatter alloc] init];
    [_tempDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
	[_tempDateFormatter setDateFormat:@"yyyy-MM-dd"];
	if(![[_DicCourseDetails objectForKey:@"edition_end"] isKindOfClass:[NSNull class]]){
		[_tempDateFormatter setDateFormat:@"dd-MM-yyyy"];
	}
	if(![[_DicCourseDetails objectForKey:@"edition_start"] isKindOfClass:[NSNull class]]){
		[_tempDateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSDate *_tempEditionDate = [_tempDateFormatter dateFromString:[_DicCourseDetails objectForKey:@"edition_start"]];
		[_tempDateFormatter setDateFormat:@"dd-MM-yyyy"];
		lbl_EndDateValue.text=[_tempDateFormatter stringFromDate:_tempEditionDate];
	}
	[_tempDateFormatter release];
	if(![[_DicCourseDetails objectForKey:@"edition"] isKindOfClass:[NSNull class]])
		lbl_EditionValue.text=[_DicCourseDetails objectForKey:@"edition"];
	
	if(![[_DicCourseDetails objectForKey:@"course_desc"] isKindOfClass:[NSNull class]])
		textview.text=[_DicCourseDetails objectForKey:@"course_desc"];
	
	if(!([[_DicCourseDetails objectForKey:@"study_plan"] isKindOfClass:[NSNull class]]) && ([_DicCourseDetails objectForKey:@"study_plan"]!=nil))
		([[_DicCourseDetails objectForKey:@"study_plan"] isEqualToString:@""]) ? (btn_studyPlan.enabled=NO) : (btn_studyPlan.enabled=YES);
	else 
		btn_studyPlan.enabled=NO;
    
	if(!([self.strTutorialURL isKindOfClass:[NSNull class]]) && (self.strTutorialURL != nil))
		([self.strTutorialURL isEqualToString:@""])? (btn_tutiorial.enabled=NO):(btn_tutiorial.enabled=YES);
	else 
		btn_tutiorial.enabled=NO;
	if(!([[_DicCourseDetails objectForKey:@"bibliography"] isKindOfClass:[NSNull class]]) && ([_DicCourseDetails objectForKey:@"bibliography"]!=nil))
		([[_DicCourseDetails objectForKey:@"bibliography"] isEqualToString:@""])?(btn_bibilography.enabled=NO):(btn_bibilography.enabled=YES);
	else 
		btn_bibilography.enabled=NO;
    
	 [self jsonRequest];
	 carousel_modules.type = iCarouselTypeCoverFlow;
}

-(void) viewWillAppear:(BOOL)animated
{
	[self setLocalizedText];
    self.navigationController.navigationBarHidden = YES;
    self.lblTitle.text = [[_DicCourseDetails objectForKey:@"course_name"] uppercaseString];
    self.lblProfileBlueName.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_name"];
    self.lblProfileGrayName.text = [eEducationAppDelegate getLocalvalue:@"WELCOME"];
    [self.imgProfile loadImageFromURL:[NSURL URLWithString:[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_profile_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:@"no-image-200x200.png"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.carousel_modules = nil;
	
}

#pragma mark - Other Methods
-(void)setLocalizedText
{
	lbl_Edition.text=[eEducationAppDelegate getLocalvalue:@"Course Edition"];
	lbl_EndDate.text=[eEducationAppDelegate getLocalvalue:@"Edition Start Date"];
	courses.text=[eEducationAppDelegate getLocalvalue:@"MODULES"];
	
    [self.btnBack setTitle:[eEducationAppDelegate getLocalvalue:@"COURSES"] forState:UIControlStateNormal];
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

-(double)doubleFromString:(NSString*)_strDate{
	NSDateFormatter *dateFormater=[[[NSDateFormatter alloc] init] autorelease];
    [dateFormater setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
	[dateFormater setDateFormat:@"yyyy-MM-dd"];
	return (double)[[dateFormater dateFromString:_strDate] timeIntervalSince1970];
}

-(void)jsonRequest
{
	HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[HUD setLabelText:[eEducationAppDelegate getLocalvalue:@"Please wait"]];
	[HUD show:YES];
	objParser = [[JSONParser alloc] init];
	objParser.delegate = self;
	NSString *strURL =[WebService getCoursedetailsURL];
	NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"course_id"],@"course_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language",
								 nil];
	[objParser sendRequestToParse:strURL params:requestData];
}

-(void) refreshView
{
	textview.text = [[DataSourceArray objectAtIndex:0] objectForKey:@"module_desc"];
	txtModuleName.text = [[DataSourceArray objectAtIndex:0] objectForKey:@"module_name"];
	NSURL *url = [[NSURL alloc]initWithString:[[[DataSourceArray objectAtIndex:0]objectForKey:@"moduleLarge_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[_imageAsynchronus loadImageFromURL:url imageName:@"no-image_s3-1.png"];
	[url release];
	[[NSUserDefaults standardUserDefaults] setObject:[[DataSourceArray objectAtIndex:0] objectForKey:@"module_id"] forKey:@"module_id"];
	[[NSUserDefaults standardUserDefaults] setObject:[[DataSourceArray objectAtIndex:0] objectForKey:@"module_name"] forKey:@"module_name"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
#pragma mark Topbar Action methods
-(IBAction)btnBackClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)proImgClicked:(id)sender{
    
}

-(IBAction)btnStudentsClicked:(id)sender{
}

-(IBAction)btnSettingsClicked:(id)sender{
    Settings *objSettings = [[Settings alloc] initWithNibName:@"Settings" bundle:nil];
	[self.navigationController pushViewController:objSettings animated:YES];
	[objSettings release];
}

-(IBAction)btnLogoutClicked:(id)sender{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"You're about to logout, are you sure?"] delegate:self	 cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"NO"]  otherButtonTitles:[eEducationAppDelegate getLocalvalue:@"YES"],nil];
	[alert show];
	alert.tag=TAG_ALERT_LOGOUT;
	[alert release];
}

#pragma mark -
#pragma mark Action methods
-(IBAction) TabarIndexSelected:(id)sender
{
	UIButton *btn=sender;
	int i=btn.tag/11;
    appDelegate=(eEducationAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate pushToTabbarWithSelection:i];
}

-(IBAction) btn_tutiorialPressed:(id)sender
{
	YouTubePlayer *objYouTubePlayer = [[YouTubePlayer alloc] initWithNibName:@"YouTubePlayer" bundle:nil];
	objYouTubePlayer.strMovieURL = self.strTutorialURL;
	objYouTubePlayer.strTitle = @"Tutorial Video";
	objYouTubePlayer.playedFromLocal=NO;
	[self.navigationController pushViewController:objYouTubePlayer animated:YES];
	[objYouTubePlayer release];
}
-(IBAction) btn_bibilographylPressed:(id)sender
{
	btn_bibilography.selected = YES;
	btn_studyPlan.selected = NO;
	UIWindow *mainWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	mainWindow.backgroundColor = [UIColor whiteColor];
	pdfName=[NSString stringWithFormat:@"%@.pdf",[eEducationAppDelegate UniqueNameGeneratorFromUrl:[_DicCourseDetails objectForKey:@"bibliography"]]];
	[pdfName retain];
	NSMutableDictionary *_tempDict=[[NSMutableDictionary alloc] init];
	
	if(![DataBase iscontainRecord:[[_DicCourseDetails objectForKey:@"course_id"]intValue]*100000 docName:@"Bibliography"])
	{
		[_tempDict setObject:@"Bibliography" forKey:@"doc_name"];
		[_tempDict setObject:[_DicCourseDetails objectForKey:@"bibliography"] forKey:@"doc_url"];
		[_tempDict setObject:[NSString stringWithFormat: @"%i",[[_DicCourseDetails objectForKey:@"course_id"]intValue]*100000] forKey:@"doc_id"];
		[_tempDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"module_name"] forKey:@"moduleName"];
	    [_tempDict setObject:[_DicCourseDetails objectForKey:@"course_name"] forKey:@"course_name"];
		[_tempDict setObject:@"PDF" forKey:@"doc_type"];
		[DataBase addDocumentDetailsToDB:_tempDict isVirtual:0];
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
		[self downloadFile:[NSURL URLWithString:[[_DicCourseDetails objectForKey:@"bibliography"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	}
	[mainWindow release];
}

-(IBAction) btn_studyPlanPressed:(id)sender
{
	btn_bibilography.selected = NO;
	btn_studyPlan.selected = YES;
	UIWindow *mainWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	mainWindow.backgroundColor = [UIColor whiteColor];
	pdfName=[NSString stringWithFormat:@"%@.pdf",[eEducationAppDelegate UniqueNameGeneratorFromUrl:[_DicCourseDetails objectForKey:@"study_plan"]]];
	[pdfName retain];
	NSMutableDictionary *_tempDict=[[NSMutableDictionary alloc] init];
	if(![DataBase iscontainRecord:[[_DicCourseDetails objectForKey:@"course_id"]intValue]*100000 docName:@"Study_Plan"])
	{
		[_tempDict setObject:@"Study_Plan" forKey:@"doc_name"];
		[_tempDict setObject:[_DicCourseDetails objectForKey:@"study_plan"] forKey:@"doc_url"];
	    [_tempDict setObject:[NSString stringWithFormat: @"%i",[[_DicCourseDetails objectForKey:@"course_id"]intValue]*100000] forKey:@"doc_id"];
		[_tempDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"module_name"] forKey:@"moduleName"];
	    [_tempDict setObject:[_DicCourseDetails objectForKey:@"course_name"] forKey:@"course_name"];
		[_tempDict setObject:@"PDF" forKey:@"doc_type"];
		[DataBase addDocumentDetailsToDB:_tempDict isVirtual:0];
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
		[self downloadFile:[NSURL URLWithString:[[_DicCourseDetails objectForKey:@"study_plan"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	}
	
	[mainWindow release];
}

-(IBAction) btn_coursePressed:(id)sender
{
}

-(IBAction) btn_practicaFinalPressed:(id)senders
{
	PracticeList *objPracticeList=[[PracticeList alloc] initWithNibName:@"PracticeList" bundle:nil];
	[self.navigationController pushViewController:objPracticeList animated:YES];
	[objPracticeList release];
}

#pragma mark -
#pragma mark pdfName
-(void)downloadFile:(NSURL *)url
{
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
	connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	NSAssert(self.connection != nil, @"Failure to create URL connection.");
	connection = nil;
}
-(BOOL)checkExistOfFile:(NSString*)fileName
{
	NSFileManager *fileManager=[NSFileManager defaultManager];
	return([fileManager fileExistsAtPath:[self GetPath:fileName]]);
}

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
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"No Connection Error"
															 forKey:NSLocalizedDescriptionKey];
        NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain
														 code:kCFURLErrorNotConnectedToInternet
													 userInfo:userInfo];
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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
														message:errorMessage
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
	[HUD hide:YES];
    [alertView show];
    [alertView release];
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
	return [DataSourceArray count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
	//create a numbered button
	reflectionView=[[ReflectionView alloc] initWithFrame:CGRectMake(0,0, 108, 138)];
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame=CGRectMake(0,0, 108, 138);
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	button.titleLabel.font = [button.titleLabel.font fontWithSize:50];
	[button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
	button.tag = index;
	AsyncImageView *async_iamge = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height)];
	if ([[[DataSourceArray objectAtIndex:index] objectForKey:@"module_image"]length])
	{
		[async_iamge loadImageFromURL:[NSURL URLWithString:[[[DataSourceArray objectAtIndex:index] objectForKey:@"module_image"]
															stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:@"no_image_s3-2.png"];
	}
	else
	{
		[async_iamge loadImageFromURL:[NSURL URLWithString:@""] imageName:@"no_image_s3-2.png"];
	}
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

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	//note: placeholder views are only displayed on some carousels if wrapping is disabled
	return 0;
}

- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSUInteger)index
{
	//create a placeholder view
	UIView *view = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image_s3-1.png"]] autorelease];
	UILabel *label = [[[UILabel alloc] initWithFrame:view.bounds] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment = UITextAlignmentCenter;
	label.font = [label.font fontWithSize:50];
	[view addSubview:label];
	return view;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    //limit the number of items views loaded concurrently (for performance reasons)
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
    transform.m34 = self.carousel_modules.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * carousel_modules.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    //wrap all carousels
    return NO;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
	[carousel_modules reloadData];
    
	textview.text = [[DataSourceArray objectAtIndex:carousel_modules.currentItemIndex] objectForKey:@"module_desc"];
	txtModuleName.text = [[DataSourceArray objectAtIndex:carousel_modules.currentItemIndex] objectForKey:@"module_name"];
	[[NSUserDefaults standardUserDefaults] setObject:[[DataSourceArray objectAtIndex:carousel_modules.currentItemIndex] objectForKey:@"module_id"] forKey:@"module_id"];
	if([[[DataSourceArray objectAtIndex:carousel_modules.currentItemIndex] objectForKey:@"module_name"] length]>0){
		[[NSUserDefaults standardUserDefaults] setObject:[[DataSourceArray objectAtIndex:carousel_modules.currentItemIndex] objectForKey:@"module_name"] forKey:@"module_name"];
	}else{
		[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"module_name"];
	}
	[_imageAsynchronus loadImageFromURL:[NSURL URLWithString:[[[DataSourceArray objectAtIndex:carousel_modules.currentItemIndex]objectForKey:@"moduleLarge_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:@"no-image_s3-1.png"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
#pragma mark JSONParser delegate method

- (void)parserDidFinishLoadingReturnData:(NSString *)responseString
{
	[HUD hide:YES];
	SBJSON *json = [[SBJSON new] autorelease];	
	DataSourceArray = [[NSMutableArray alloc] initWithArray:[json objectWithString:responseString error:nil]] ;
	if ([[[DataSourceArray objectAtIndex:0] valueForKey:@"message"] isEqualToString:@"No Record Found"] &&
		[[[DataSourceArray objectAtIndex:0] valueForKey:@"success"] isEqualToString:@"0"])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle 
											    message:[eEducationAppDelegate getLocalvalue:@"No module available for this course."] 
											    delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] 
												  otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
	else 
	{
		[self refreshView];
		[carousel_modules reloadData];
		[carousel_modules scrollToItemAtIndex:0 animated:NO];
	}
}

- (void)parserDidFailWithRestoreError:(NSError*)error
{
	[HUD setHidden:YES];
	NSString *strMsg = [eEducationAppDelegate getLocalvalue:@"The server cannot be reached. It could be down or busy. Please try again later."];
	UIAlertView *AlertView =  [[UIAlertView alloc]  initWithTitle:alertTitle message:strMsg delegate:nil 	cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil, nil];
	AlertView.tag=TAG_FailError;
	[AlertView show];
	[AlertView release];
}

#pragma mark -
#pragma mark  UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == TAG_ALERT_LOGOUT && buttonIndex == 1){
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == TAG_FailError)
	{
		if (buttonIndex == 0)
		{
			[appDelegate GoTOLoginScreen:NO];
		}
	}
}

#pragma mark -
#pragma mark orientation Life Cycle
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
	{	
	}
	else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
	{
		Scrollview.frame=CGRectMake(0, 56, 1024, 620);
		Scrollview.contentSize=CGSizeMake(1024, 845);
		tab1.frame=CGRectMake(252, 655, 80, 49);
		tab2.frame=CGRectMake(362, 655, 80, 49);
		tab3.frame=CGRectMake(472, 655, 80, 49);
		tab4.frame=CGRectMake(582, 655, 80 ,49);
		tab5.frame=CGRectMake(692, 655, 80,49);
		
		imagecoverFlow.frame=CGRectMake(148,570,734,221);
		imageBackground.frame=CGRectMake(0,0,1024,768);
		carousel_modules.frame=CGRectMake(169,605,695,157);
		courses.frame=CGRectMake(173, 580, 175, 21);
		
		imageThumb.frame=CGRectMake(174,41,275, 350);
		_imageAsynchronus.frame = CGRectMake(174,41,275, 350);
		imageMainbackground.frame=CGRectMake(148,20,733,525);
		textview.frame=CGRectMake(160, 408, 704, 70);
		
		btn_studyPlan.frame=CGRectMake(299, 490, 169, 45);
		btn_bibilography.frame=CGRectMake(477, 490, 121, 45);
		btn_tutiorial.frame=CGRectMake(607, 490, 101, 45);
		
		lbl_Edition.frame=CGRectMake(520, 142, 128, 22);
		lbl_EditionValue.frame=CGRectMake(711, 142, 135, 22);
		
		lbl_EndDate.frame=CGRectMake(520, 182, 170, 22);
		lbl_EndDateValue.frame=CGRectMake(711, 182, 110, 22);
		
		txtModuleName.frame = CGRectMake(510, 41, 330, 55);
	}	
}

#pragma mark -
#pragma mark Button tap event

- (void)buttonTapped:(UIButton *)sender
{
	ModuleHomePage *objModuleListHomePage=[[ModuleHomePage alloc] initWithNibName:@"ModuleHomePage" bundle:nil];
    objModuleListHomePage.arrModules = DataSourceArray;
	[self.navigationController pushViewController:objModuleListHomePage animated:YES];
	[objModuleListHomePage release];
}

- (void)dealloc
{
	[imageBackground release];imageBackground=nil;
	[imagecoverFlow release];imagecoverFlow=nil;
	[courses release];courses=nil;
	[imageThumb release];imageThumb=nil;
	[imageMainbackground release];imageMainbackground=nil;
	[lbl_Edition release];lbl_Edition=nil;
	[lbl_EditionValue release];lbl_EditionValue=nil;
	[lbl_EndDate release];lbl_EndDate=nil;
	[textview release];textview=nil;
	[btn_studyPlan release];btn_studyPlan=nil;
	[btn_bibilography release];btn_bibilography=nil;
	[Scrollview release];Scrollview=nil;
	[tab1 release];tab1=nil;
	[tab2 release];tab2=nil;
	[tab3 release];tab3=nil;
	[tab4 release];tab4=nil;
	[tab5 release];tab5=nil;
	[objParser release];objParser=nil;
    [carousel_modules release];
	[DataSourceArray release];DataSourceArray=nil;
	[_imageAsynchronus release];_imageAsynchronus = nil;
	[_DicCourseDetails release];_DicCourseDetails = nil;
	[_labelCourseTitle release];_labelCourseTitle=nil;
	[txtModuleName release];txtModuleName=nil;
    
    [_imgProfile release];_imgProfile=nil;
    [_lblTitle release];_lblTitle=nil;
    [_btnBack release];_btnBack=nil;
    [_lblProfileBlueName release];_lblProfileBlueName=nil;
    [_lblProfileGrayName release];_lblProfileGrayName=nil;
    
    [super dealloc];
}

@end
