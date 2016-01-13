//
//  iCarouselExampleViewController.m
//  iCarouselExample
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//

#import "CourseList.h"
#import "PlanTheStudies.h"
#import "ReflectionView.h"
#import "ReaderDocument.h"
#import "MicroUrlWeb.h"
#import "YouTubePlayer.h"
#define NUMBER_OF_COURSES ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 10: 12)
#define ITEM_SPACING 150
#define USE_BUTTONS YES
@implementation CourseList

@synthesize carousel_unregisteredCourses;
@synthesize reflectionView;
@synthesize appListData;
@synthesize connection;
@synthesize imageAsynchronus = _imageAsynchronus;
@synthesize labelCourseName = _labelCourseName;
#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	Scrollview.showsVerticalScrollIndicator=NO;
	
	appDelegate=(eEducationAppDelegate *)[[UIApplication sharedApplication] delegate];
	objParser = [[JSONParser alloc] init];
	objParser.delegate = self;
	
	_imageAsynchronus = [[AsyncImageView alloc] initWithFrame:CGRectMake(53,54,275,350)];
	[Scrollview addSubview:_imageAsynchronus];
	CALayer *viewLayer = [_imageAsynchronus layer];
	[viewLayer setBorderWidth:2.0f];
	[viewLayer setBorderColor:[[UIColor blackColor]CGColor]];
	[viewLayer setMasksToBounds:TRUE];
	[viewLayer setCornerRadius:5.0];
	
	
	HUD = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
	HUD.labelText=[eEducationAppDelegate getLocalvalue:@"Please wait"];
	NSString *currentLangauge=@"";
	if([[[NSUserDefaults standardUserDefaults] objectForKey:@"IS_SPANISH_LANG"] isEqualToString:@"YES"])
	{
		currentLangauge=@"Spanish";
	}
	else
	{
		currentLangauge=@"English";
	}

	NSString *strURL = [WebService GetUnregisteredCourseListXml];
	NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:                                 
								 currentLangauge, @"language",
								 @"", @"user_id",
								 nil];
    
	[objParser sendRequestToParse:strURL params:requestData];
    carousel_unregisteredCourses.type = iCarouselTypeCoverFlow;
	[btn_studyPlan setImage:[eEducationAppDelegate GetLocalImage:@"btn_studyplan"] forState:UIControlStateNormal];
	[btn_studyPlan setImage:[eEducationAppDelegate GetLocalImage:@"btn_studyplan_h"] forState:UIControlStateHighlighted];
	[btn_bibilography setImage:[eEducationAppDelegate GetLocalImage:@"btn_Bibliography1"] forState:UIControlStateNormal];
	[btn_bibilography setImage:[eEducationAppDelegate GetLocalImage:@"btn_Bibliography1_h"] forState:UIControlStateHighlighted];
	[_btnmicrositeUrl setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_btnmicrositeUrl setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
}
-(void) viewWillAppear:(BOOL)animated
{
	[self setLocalizedText];
	[self willAnimateRotationToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0.2];
}

-(void)setLocalizedText
{
	courses.text=[eEducationAppDelegate getLocalvalue:@"COURSES"];
	lbl_head.text=[[eEducationAppDelegate getLocalvalue:@"COURSES"] uppercaseString];
	[_btnmicrositeUrl setTitle:[eEducationAppDelegate getLocalvalue:@"Visit Microsite"] forState:UIControlStateNormal];
	[_btnmicrositeUrl setTitle:[eEducationAppDelegate getLocalvalue:@"Visit Microsite"] forState:UIControlStateHighlighted];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.carousel_unregisteredCourses = nil;
}

#pragma mark -
#pragma mark JSONParser delegate method

- (void)parserDidFinishLoadingReturnData:(NSString *)responseString
{
	[HUD setHidden:YES];
	SBJSON *json = [[SBJSON new] autorelease];	
	ArrayResponse = [[NSMutableArray alloc] initWithArray:[json objectWithString:responseString error:nil]];
	if([ArrayResponse count]==0||![[[ArrayResponse objectAtIndex:0] objectForKey:@"success"] isEqualToString:@"1"])
	{
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"Currently no course available for this user."] delegate:self	 cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		[carousel_unregisteredCourses reloadData];
		[carousel_unregisteredCourses scrollToItemAtIndex:0 animated:NO];
		[self refreshView];
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

-(void) refreshView
{
	SelectedDictonary=[ArrayResponse objectAtIndex:0];
	if(![[SelectedDictonary objectForKey:@"course_desc"] isKindOfClass:[NSNull class]])
		textview.text=[SelectedDictonary objectForKey:@"course_desc"];
	
	[_imageAsynchronus loadImageFromURL:[NSURL URLWithString:[[SelectedDictonary objectForKey:@"coursebig_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:@"no-image_s3-1.png"];
	if(!([[SelectedDictonary objectForKey:@"study_plan"] isKindOfClass:[NSNull class]]) && ([SelectedDictonary objectForKey:@"study_plan"]!=nil))
		([[SelectedDictonary objectForKey:@"study_plan"] isEqualToString:@""]) ? (btn_studyPlan.enabled=NO) : (btn_studyPlan.enabled=YES);
	else
		btn_studyPlan.enabled=NO;
    
	if(!([[SelectedDictonary objectForKey:@"tutorial"] isKindOfClass:[NSNull class]]) && ([SelectedDictonary objectForKey:@"tutorial"]!=nil))
		([[SelectedDictonary objectForKey:@"tutorial"] isEqualToString:@""])? (btn_tutiorial.enabled=NO):(btn_tutiorial.enabled=YES);
	else
		btn_tutiorial.enabled=NO;
	if(!([[SelectedDictonary objectForKey:@"bibliography"] isKindOfClass:[NSNull class]]) && ([SelectedDictonary objectForKey:@"bibliography"]!=nil))
		([[SelectedDictonary objectForKey:@"bibliography"] isEqualToString:@""])?(btn_bibilography.enabled=NO):(btn_bibilography.enabled=YES);
	else
		btn_bibilography.enabled=NO;
	_labelCourseName.text = [SelectedDictonary objectForKey:@"course_name"];
	[[NSUserDefaults standardUserDefaults] setObject:[SelectedDictonary objectForKey:@"course_name"] forKey:@"course_name"];
	if([[[ArrayResponse objectAtIndex:0] objectForKey:@"microsite_url"] length]){
		microSiteUrl=[[NSString alloc]initWithString:[[ArrayResponse objectAtIndex:0] objectForKey:@"microsite_url"]];
		image_leftThumb.hidden=NO;
		_btnmicrositeUrl.hidden=NO;
	}else{
		image_leftThumb.hidden=YES;
		_btnmicrositeUrl.hidden=YES;
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
		Scrollview.frame=CGRectMake(0, 45, 768, 895);
		Scrollview.contentSize=CGSizeMake(768, 841);
		carousel_unregisteredCourses.frame=CGRectMake(41,714,695,162);
		imagecoverFlow.frame=CGRectMake(20,674,734,221);
		imageBackground.frame=CGRectMake(0,0,768,1004);
		courses.frame=CGRectMake(43, 681, 403, 21);
		coursesLine.frame=CGRectMake(46, 707, 681, 2);
		_btnmicrositeUrl.frame=CGRectMake(460, 125, 152, 45);
		image_leftThumb.frame=CGRectMake(460,125,152,45);
		imageThumb.frame=CGRectMake(46,41,275, 350);
		_imageAsynchronus.frame = CGRectMake(46,41,275, 350);
		imageMainbackground.frame=CGRectMake(20,20,733,632);
		textview.frame=CGRectMake(32, 403, 704, 160);
		
		btn_studyPlan.frame=CGRectMake(176, 591, 169, 45);
		btn_bibilography.frame=CGRectMake(353, 591, 121, 45);
		btn_tutiorial.frame=CGRectMake(483, 591, 101, 45);
		_labelCourseName.frame = CGRectMake(370, 41, 324, 55);
	}
	else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
	{
		Scrollview.frame=CGRectMake(0, 45, 1024, 655);
		Scrollview.contentSize=CGSizeMake(1024, 845);
		carousel_unregisteredCourses.frame=CGRectMake(169,664,695,162);
		imagecoverFlow.frame=CGRectMake(148,624,734,221);
		imageBackground.frame=CGRectMake(0,0,1024,768);
		_btnmicrositeUrl.frame=CGRectMake(596, 125, 152, 45);
		image_leftThumb.frame=CGRectMake(596,125,152,45);
		courses.frame=CGRectMake(171, 631, 403, 21);
		coursesLine.frame=CGRectMake(174, 657, 681, 2);
		
		_imageAsynchronus.frame = CGRectMake(174,41,275, 350);
		imageMainbackground.frame=CGRectMake(148,20,733,578);
		textview.frame=CGRectMake(160, 403, 709, 115);
		btn_studyPlan.frame=CGRectMake(304, 537, 169, 45);
		btn_bibilography.frame=CGRectMake(481, 537, 121, 45);
		btn_tutiorial.frame=CGRectMake(611, 537, 101, 45);
		_labelCourseName.frame = CGRectMake(500, 41, 324, 55);
	}
}

#pragma mark -
#pragma mark Action methods

-(IBAction) btn_studyPlanPressed:(id)sender
{
	btn_studyPlan.selected = YES;
	btn_bibilography.selected = NO;
	UIWindow *mainWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	mainWindow.backgroundColor = [UIColor whiteColor];
	pdfName=[NSString stringWithFormat:@"%@.pdf",[eEducationAppDelegate UniqueNameGeneratorFromUrl:[SelectedDictonary objectForKey:@"study_plan"]]];
	[pdfName retain];
	
	if([self checkExistOfFile:pdfName])
	{		
		[self displayPDFDocumentView];
	}
	else
	{
		HUD = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
		HUD.labelText = [eEducationAppDelegate getLocalvalue:@"Loading PDF..."];
		HUD.detailsLabelText = [eEducationAppDelegate getLocalvalue:@"Please wait"];
		[self downloadFile:[NSURL URLWithString:[[SelectedDictonary objectForKey:@"study_plan"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	}
	[mainWindow release];
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
	NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *pathString =[pathArray objectAtIndex:0];
	pathString=[pathString stringByAppendingPathComponent:@"PDFBOOKS"];
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
															message:[eEducationAppDelegate getLocalvalue:@"Pdf not downloded properly."]
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
		{
			objPlanTheStudies.Istype=@"PlanTheStudies";
		}
		else
		{
			objPlanTheStudies.Istype=@"bibilography";
		}
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
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
														message:errorMessage
													   delegate:nil
											  cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]
											  otherButtonTitles:nil];
	[HUD hide:YES];
	[alertView show];
	[alertView release];
}
     
-(IBAction) btn_tutiorialPressed:(id)sender
{
	YouTubePlayer *objYouTubePlayer = [[YouTubePlayer alloc] initWithNibName:@"YouTubePlayer" bundle:nil];
	objYouTubePlayer.strMovieURL =[[ArrayResponse objectAtIndex:0] objectForKey:@"tutorial"];
	objYouTubePlayer.strTitle = @"Tutorial Video";
	objYouTubePlayer.playedFromLocal=NO;
	[self.navigationController pushViewController:objYouTubePlayer animated:YES];
	[objYouTubePlayer release];
}

-(IBAction) btn_bibilographylPressed:(id)sender
{
	btn_studyPlan.selected = NO;
	btn_bibilography.selected = YES;
	UIWindow *mainWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];	
	mainWindow.backgroundColor = [UIColor whiteColor]; 
	pdfName=[NSString stringWithFormat:@"%@.pdf",[eEducationAppDelegate UniqueNameGeneratorFromUrl:[SelectedDictonary objectForKey:@"bibliography"]]];
	[pdfName retain];
	
	if([self checkExistOfFile:pdfName])
	{		
		[self displayPDFDocumentView];
	}
	else
	{
		HUD = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
		HUD.labelText = [eEducationAppDelegate getLocalvalue:@"Loading PDF..."];
		HUD.detailsLabelText = [eEducationAppDelegate getLocalvalue:@"Please wait"];
		[self downloadFile:[NSURL URLWithString:[[SelectedDictonary objectForKey:@"bibliography"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	}
	[mainWindow release];
}

-(IBAction) btn_LockPressed:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
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
	[async_iamge loadImageFromURL:[NSURL URLWithString:[[Dict objectForKey:@"coursesmall_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:@"no-image_s3-1.png"];
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
    transform.m34 = self.carousel_unregisteredCourses.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * carousel_unregisteredCourses.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    //wrap all carousels
    
    return NO;
}

-(IBAction)goToMicrositeUrl:(id)sender{
	MicroUrlWeb *_objMicroUrlWeb=[[MicroUrlWeb alloc] initWithNibName:@"MicroUrlWeb" bundle:nil];
	_objMicroUrlWeb.microUrlString=microSiteUrl;
	[self.navigationController pushViewController:_objMicroUrlWeb animated:YES];
	[_objMicroUrlWeb release];
}

-(void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{	
	[carousel_unregisteredCourses reloadData];
	if([[[ArrayResponse objectAtIndex:carousel.currentItemIndex] objectForKey:@"microsite_url"] length]){
		microSiteUrl=[[NSString alloc]initWithString:[[ArrayResponse objectAtIndex:carousel.currentItemIndex] objectForKey:@"microsite_url"]];
		image_leftThumb.hidden=NO;
		_btnmicrositeUrl.hidden=NO;
	}else{
		image_leftThumb.hidden=YES;
		_btnmicrositeUrl.hidden=YES;
	}

	SelectedDictonary=[ArrayResponse objectAtIndex:carousel.currentItemIndex];
	[[NSUserDefaults standardUserDefaults] setObject:[SelectedDictonary objectForKey:@"course_name"] forKey:@"course_name"];
	if(![[SelectedDictonary objectForKey:@"course_desc"] isKindOfClass:[NSNull class]])
		textview.text=[SelectedDictonary objectForKey:@"course_desc"];
	if([[SelectedDictonary objectForKey:@"coursebig_image"] length]>0)
		[_imageAsynchronus loadImageFromURL:[NSURL URLWithString:[[SelectedDictonary objectForKey:@"coursebig_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:nil];
	else
		[_imageAsynchronus loadImageFromURL:[NSURL URLWithString:[[SelectedDictonary objectForKey:@"coursebig_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:@"no-image_s3-1.png"];	
	
	if(!([[SelectedDictonary objectForKey:@"study_plan"] isKindOfClass:[NSNull class]]) && ([SelectedDictonary objectForKey:@"study_plan"]!=nil))
		([[SelectedDictonary objectForKey:@"study_plan"] isEqualToString:@""]) ? (btn_studyPlan.enabled=NO) : (btn_studyPlan.enabled=YES);
	else 
		btn_studyPlan.enabled=NO;
    
	if(!([[[ArrayResponse objectAtIndex:0] objectForKey:@"tutorial"] isKindOfClass:[NSNull class]]) && ([[ArrayResponse objectAtIndex:0] objectForKey:@"tutorial"]!=nil))
		([[[ArrayResponse objectAtIndex:0] objectForKey:@"tutorial"] isEqualToString:@""])? (btn_tutiorial.enabled=NO):(btn_tutiorial.enabled=YES);
	else 
		btn_tutiorial.enabled=NO;
	if(!([[SelectedDictonary objectForKey:@"bibliography"] isKindOfClass:[NSNull class]]) && ([SelectedDictonary objectForKey:@"bibliography"]!=nil))
		([[SelectedDictonary objectForKey:@"bibliography"] isEqualToString:@""])?(btn_bibilography.enabled=NO):(btn_bibilography.enabled=YES);
	else
		btn_bibilography.enabled=NO;
	_labelCourseName.text = [SelectedDictonary objectForKey:@"course_name"];
}


#pragma mark -
#pragma mark Button tap event

- (void)buttonTapped:(UIButton *)sender
{
   //Click On Course;

}

- (void)dealloc
{
	[imageBackground release];imageBackground=nil;
	[imagecoverFlow release];imagecoverFlow=nil;
	[courses release];courses=nil;
	[lbl_head release];lbl_head=nil;
	[imageTopbar release];imageTopbar=nil;
	[imageThumb release];imageThumb=nil;
	[imageMainbackground release];imageMainbackground=nil;
	[image_leftThumb release];image_leftThumb=nil;
	[textview release];textview=nil;
	[btn_studyPlan release];btn_studyPlan=nil;
	[btn_bibilography release];btn_bibilography=nil;
	[btn_tutiorial release];btn_tutiorial=nil;
	[ImageLogo release];ImageLogo=nil;
	[btn_Lock release];btn_Lock=nil;
	[Scrollview release];Scrollview=nil;
	[coursesLine release];coursesLine=nil;
	[_labelCourseName release];coursesLine=nil;	
	[ArrayResponse release];ArrayResponse=nil;
	[SelectedDictonary release];SelectedDictonary=nil;
	[microSiteUrl release];
	[carousel_unregisteredCourses release];carousel_unregisteredCourses=nil;
	[_imageAsynchronus release];
	_imageAsynchronus=nil;	
	[objParser release];
	objParser=nil;
	[super dealloc];
}

@end
