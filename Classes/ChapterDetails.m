    //
//  ChapterDetails.m
//  eEducation
//
//  Created by Hidden Brains on 11/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChapterDetails.h"
#import "ModulesList.h"
#import "PlanTheStudies.h"
#import "ModuleHomePage.h"
#import "ReflectionView.h"
#import"Message.h"
#import"Calender.h"
#import"Forum.h"
#import"Alert.h"
#import"VirtualLibrary.h"
#import "CGPDFDocument.h"
#define NUMBER_OF_MODULES ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 10: 12)
#define ITEM_SPACING 150
#define USE_BUTTONS YES
#define CONTENT_INSET 2.0f
@implementation ChapterDetails
@synthesize reflectionView;
@synthesize carousel_Chapters;
@synthesize appListData;
@synthesize connection;
@synthesize labelCourseName;
- (void)dealloc
{
	[imageBackground release];imageBackground=nil;
	[imagecoverFlow release];imagecoverFlow=nil;
	[lbl_documents release];lbl_documents=nil;
	[imageTopbar release];imageTopbar=nil;
	[imageMainbackground release];imageMainbackground=nil;
	[lbl_head release];lbl_head=nil;
	[btn_course release];btn_course=nil;
	[btn_Module release];btn_Module=nil;
	[btn_Chapter release];btn_Chapter=nil;
	[ImageLogo release];ImageLogo=nil;
	[btn_settings release];btn_settings=nil;
	[btn_home release];btn_home=nil;
	[Scrollview release];Scrollview=nil;
	[coursesLine release];coursesLine=nil;
	[bottomBar release];bottomBar=nil;
	[tab1 release];tab1=nil;
	[tab2 release];tab2=nil;
	[tab3 release];tab3=nil;
	[tab4 release];tab4=nil;
	[tab5 release];tab5=nil;
	[Web_view release];Web_view=nil;
	[labelCourseName release];labelCourseName=nil;
	[ArrayResponse release];ArrayResponse=nil;
	[objParser release];objParser=nil;
    [carousel_Chapters release];carousel_Chapters=nil;
	[_urlArray release];_urlArray=nil;
	[_videoData release];_videoData=nil;
	[objDownloadManager release];objDownloadManager=nil;
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	appDelegate=(eEducationAppDelegate *)[[UIApplication sharedApplication] delegate];
	objDownloadManager = [[downloadManager alloc] init];
	objDownloadManager.delegate = self;
	objParser = [[JSONParser alloc] init];
	objParser.delegate = self;
	HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	HUD.labelText=[eEducationAppDelegate getLocalvalue:@"Please wait"];
	[HUD show:YES];
	NSString *strURL = [WebService GetDocumentsListXml];
	NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:                                 
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"chapter_id"], @"chapter_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language",
								 nil];	
	[objParser sendRequestToParse:strURL params:requestData];
		[self setLocalizedText];	
    carousel_Chapters.type = iCarouselTypeCoverFlow;
}

-(void) viewWillAppear:(BOOL)animated
{
	icourselIndex=0;
	 [Web_view setScalesPageToFit:YES];
	[Web_view setScalesPageToFit:YES];
	self.navigationController.navigationBar.hidden=NO;
	[self.navigationItem setHidesBackButton:YES];
	[self.navigationController.navigationBar viewWithTag:BUTTON_HOME_TAG].hidden=NO;
	[(UILabel *)[self.navigationController.navigationBar viewWithTag:LABEL_TITLE_TAG] setText:@""];
	[self willAnimateRotationToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0.2];
    Scrollview.showsVerticalScrollIndicator=NO;
}

-(void) setLocalizedText
{
	[btn_course setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"course_name"] forState:UIControlStateNormal];
	[btn_Module setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"module_name"] forState:UIControlStateNormal];
	[btn_Chapter setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"chapter_name"] forState:UIControlStateNormal];
	lbl_documents.text=[eEducationAppDelegate getLocalvalue:@"DOCUMENTS"];
	[tab1 setImage:[eEducationAppDelegate GetLocalImage:@"VirtualLibrary"] forState:0];
	[tab1 setImage:[eEducationAppDelegate GetLocalImage:@"VirtualLibrary_h"] forState:UIControlStateHighlighted];
	
	[tab2 setImage:[eEducationAppDelegate GetLocalImage:@"Forums"] forState:0];
	[tab2 setImage:[eEducationAppDelegate GetLocalImage:@"Forums_h"] forState:UIControlStateHighlighted];
	
	[tab3 setImage:[eEducationAppDelegate GetLocalImage:@"Alerts"] forState:0];
	[tab3 setImage:[eEducationAppDelegate GetLocalImage:@"Alerts_h"] forState:UIControlStateHighlighted];
	
	[tab4 setImage:[eEducationAppDelegate GetLocalImage:@"Calendar"] forState:0];
	[tab4 setImage:[eEducationAppDelegate GetLocalImage:@"Calendar_h"] forState:UIControlStateHighlighted];
	
	[tab5 setImage:[eEducationAppDelegate GetLocalImage:@"Messages"] forState:0];
	[tab5 setImage:[eEducationAppDelegate GetLocalImage:@"Messages_h"] forState:UIControlStateHighlighted];
	
}
-(void) viewWillDisappear:(BOOL)animated
{    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.carousel_Chapters = nil;	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

-(IBAction) TabarIndexSelected:(id)sender
{
//	UIButton *btn=sender;
//	int i=btn.tag/11;
//    appDelegate=(eEducationAppDelegate *)[[UIApplication sharedApplication] delegate];
//    [appDelegate setUpTabbarWithSelection:i];	
}
#pragma mark -
#pragma mark Action methods
-(IBAction) btn_coursePressed:(id)sender
{
	NSArray *viewContrlls=[[self navigationController] viewControllers];
    for( int i=0;i<[ viewContrlls count];i++){
        id obj=[viewContrlls objectAtIndex:i];
        if([obj isKindOfClass:[ModulesList class]] ){
			[[self navigationController] popToViewController:obj animated:YES];
            return;
        }
    }
}
-(IBAction) btn_ModulePressed:(id)sender
{
}
-(IBAction) btn_ChapterPressed:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark JSONParser delegate methodReflectionView.m: @implementation ReflectionView

- (void)parserDidFinishLoadingReturnData:(NSString *)responseString
{  
	
	SBJSON *json = [[SBJSON new] autorelease];	
	ArrayResponse = [[NSMutableArray alloc] initWithArray:[json objectWithString:responseString error:nil]];
	if([ArrayResponse count]==0||![[[ArrayResponse objectAtIndex:0] objectForKey:@"success"] isEqualToString:@"1"])
	{
		[ActIndicatorview stopAnimating];
		[HUD hide:YES];
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"No Documents are available for this Chapter."] delegate:self	 cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]  otherButtonTitles:nil];
		alert.tag=222;
		[alert show];
		[alert release];
	}
	else
	{   isDisapper=1;
		[carousel_Chapters reloadData];
		[carousel_Chapters scrollToItemAtIndex:0 animated:NO];
		[self refreshView];
	}
}

- (void)parserDidFailWithRestoreError:(NSError*)error
{
	[HUD hide:YES];
	NSString *strMsg = [eEducationAppDelegate getLocalvalue:@"The server cannot be reached. It could be down or busy. Please try again later."];
	UIAlertView *AlertView =  [[UIAlertView alloc]  initWithTitle:alertTitle message:strMsg delegate:nil 	cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil, nil];
	AlertView.tag=TAG_FailError;
	[AlertView show];
	[AlertView release];
}


-(void)ShowPdf:(NSString*)_pdfPath{
	NSURL *url =[NSURL URLWithString:[_pdfPath stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionAllowLossy]];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[Web_view loadRequest:requestObj];
	isPdfDownload=FALSE;
	
}

#pragma mark -
#pragma mark Web_view delegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView{
	
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
	[HUD hide:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//	NSLog(@"error");
}

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//	return nil;
//}

-(void)refreshView
{
	pdfName=[NSString stringWithFormat:@"%@.pdf",[eEducationAppDelegate UniqueNameGeneratorFromUrl:[[ArrayResponse objectAtIndex:0] objectForKey:@"doc_url"]]];
	[pdfName retain];
	[[NSUserDefaults standardUserDefaults] setObject:[[ArrayResponse objectAtIndex:0] objectForKey:@"document_name"] forKey:@"DocumentName"];	
	if([self checkExistOfFile:pdfName])
	{	
		if(![[[ArrayResponse objectAtIndex:0] objectForKey:@"chapter_video"] isKindOfClass:[NSString class]]){
			_urlArray=[[NSMutableArray alloc] init];
			for (int i=0;i<[[[ArrayResponse objectAtIndex:0] objectForKey:@"chapter_video"] count];i++){
				if([[[[[ArrayResponse objectAtIndex:0] objectForKey:@"chapter_video"]objectAtIndex:i]objectForKey:@"video_url"] length]>0){
					NSString *_videoName=[NSString stringWithFormat:@"%@.mp4",[eEducationAppDelegate UniqueNameGeneratorFromUrl:[[[[ArrayResponse objectAtIndex:0] objectForKey:@"chapter_video"]objectAtIndex:i]objectForKey:@"video_url"]]];
					if(![self checkExistOfFile:_videoName]){
						[_urlArray addObject:[[[[ArrayResponse objectAtIndex:0] objectForKey:@"chapter_video"]objectAtIndex:i]objectForKey:@"video_url"]];
					}
				}
			}
			if([_urlArray count]>0){
				[objDownloadManager initwithStringArray:_urlArray PdfName:pdfName];
			}else{
				[HUD show:YES];
				[self ShowPdf:[self GetPath:pdfName]];
			}
		}else{
			[HUD show:YES];
			[self ShowPdf:[self GetPath:pdfName]];
		}
	}
	else
	{
		[HUD show:YES];
		isPdfDownload=YES;
		if(_urlArray){
			[_urlArray release];
			_urlArray=nil;
		}
		_urlArray=[[NSMutableArray alloc] init];
		if(![[[ArrayResponse objectAtIndex:0] objectForKey:@"chapter_video"] isKindOfClass:[NSString class]]){
			NSArray *_videoInfoArray=[[NSArray alloc] initWithArray:[[ArrayResponse objectAtIndex:0] objectForKey:@"chapter_video"]];
			if([_videoInfoArray count]>0){
				for(int i=0;i<[_videoInfoArray count];i++){
					
					[_urlArray addObject:[[_videoInfoArray objectAtIndex:i] objectForKey:@"video_url"]];
				}
			}
			[_videoInfoArray release];
			if(_videoData){
				[_videoData release];
				_videoData=nil;
			}
			_videoData=[[NSData alloc]initWithData:[self getCurrentSavedVideoData:[[ArrayResponse objectAtIndex:0] objectForKey:@"chapter_video"]]];
		}
		[_urlArray addObject:[[ArrayResponse objectAtIndex:0] objectForKey:@"doc_url"]];
		
		[objDownloadManager initwithStringArray:_urlArray PdfName:pdfName];
	}
}

#pragma mark -
#pragma mark alertview Delegate 

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{	
if(alertView.tag==222)
	{
		[self.navigationController popViewControllerAnimated:YES];
	}else if(alertView.tag==TAG_FailError){
		if(buttonIndex==0)
		[appDelegate GoTOLoginScreen:NO ];
	}	
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
	reflectionView=[[ReflectionView alloc] initWithFrame:CGRectMake(0,0, 108, 138)];
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame=CGRectMake(0,0, 108, 138);
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	button.titleLabel.font = [button.titleLabel.font fontWithSize:50];
	[button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
	button.tag = index;
	AsyncImageView *async_iamge = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height)];
	[async_iamge loadImageFromURL:[NSURL URLWithString:[[[Dict objectForKey:@"doc_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation]] imageName:@"no_pdf_s3-3.png"];
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

- (NSUInteger)numberOfVisibleitemsInCarousel:(iCarousel *)carousel
{
    //limit the number of items_Modules views loaded concurrently (for performance reasons)
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
    transform.m34 = self.carousel_Chapters.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * carousel_Chapters.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    //wrap all carousels
    return NO;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
	[carousel_Chapters reloadData];
	if([ArrayResponse count]>1)
	{
	
		[HUD show:YES];
		icourselIndex = carousel.currentItemIndex;
		pdfName=[NSString stringWithFormat:@"%@.pdf",[eEducationAppDelegate UniqueNameGeneratorFromUrl:[[ArrayResponse objectAtIndex:carousel.currentItemIndex] objectForKey:@"doc_url"]]];
		[pdfName retain];
		[[NSUserDefaults standardUserDefaults] setObject:[[ArrayResponse objectAtIndex:carousel.currentItemIndex] objectForKey:@"document_name"] forKey:@"DocumentName"];
		if([self checkExistOfFile:pdfName])
		{		
			if(![[[ArrayResponse objectAtIndex:icourselIndex] objectForKey:@"chapter_video"] isKindOfClass:[NSString class]]){
				_urlArray=[[NSMutableArray alloc] init];
				for (int i=0;i<[[[ArrayResponse objectAtIndex:icourselIndex] objectForKey:@"chapter_video"] count];i++){
					if([[[[[ArrayResponse objectAtIndex:icourselIndex] objectForKey:@"chapter_video"]objectAtIndex:i]objectForKey:@"video_url"] length]>0){
						NSString *_videoName=[NSString stringWithFormat:@"%@.mp4",[eEducationAppDelegate UniqueNameGeneratorFromUrl:[[[[ArrayResponse objectAtIndex:icourselIndex] objectForKey:@"chapter_video"]objectAtIndex:i]objectForKey:@"video_url"]]];
						//NSString *fileVideoPath=[self GetPath:_videoName];
						if(![self checkExistOfFile:_videoName]){
							[_urlArray addObject:[[[[ArrayResponse objectAtIndex:icourselIndex] objectForKey:@"chapter_video"]objectAtIndex:i]objectForKey:@"video_url"]];
						}
					}
				}
				if([_urlArray count]>0){
					[objDownloadManager initwithStringArray:_urlArray PdfName:pdfName];
				}else{
					[HUD show:YES];
					[self ShowPdf:[self GetPath:pdfName]];
				}
			}else{
				[HUD show:YES];
				[self ShowPdf:[self GetPath:pdfName]];
			}
		}
		else
		{
			[HUD show:YES];
			isPdfDownload=YES;
			if(_urlArray){
				[_urlArray release];
				_urlArray=nil;
			}
			_urlArray=[[NSMutableArray alloc] init];
			if(![[[ArrayResponse objectAtIndex:carousel.currentItemIndex] objectForKey:@"chapter_video"] isKindOfClass:[NSString class]]){
				NSArray *_videoInfoArray=[[NSArray alloc] initWithArray:[[ArrayResponse objectAtIndex:carousel.currentItemIndex] objectForKey:@"chapter_video"]];
				if([_videoInfoArray count]>0){
					for(int i=0;i<[_videoInfoArray count];i++){
						
						[_urlArray addObject:[[_videoInfoArray objectAtIndex:i] objectForKey:@"video_url"]];
					}
				}
				[_videoInfoArray release];
				if(_videoData){
					[_videoData release];
					_videoData=nil;
				}
				_videoData=[[NSData alloc]initWithData:[self getCurrentSavedVideoData:[[ArrayResponse objectAtIndex:carousel.currentItemIndex] objectForKey:@"chapter_video"]]];
			}
			[_urlArray addObject:[[ArrayResponse objectAtIndex:carousel.currentItemIndex] objectForKey:@"doc_url"]];
			[objDownloadManager initwithStringArray:_urlArray PdfName:pdfName];
		}
	}
}

-(NSData *)getCurrentSavedVideoData:(NSArray*)pathArray
{
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:pathArray];
	return data;
}

- (void) didDownload:(BOOL)isComplete
{
	if(isComplete)

	{
		NSMutableDictionary *_tempDict=[[NSMutableDictionary alloc] init];
		[_tempDict setObject:[[ArrayResponse objectAtIndex:icourselIndex] objectForKey:@"document_name"] forKey:@"doc_name"];
		[_tempDict setObject:[[ArrayResponse objectAtIndex:icourselIndex] objectForKey:@"doc_url"] forKey:@"doc_url"];
		[_tempDict setObject:[[ArrayResponse objectAtIndex:icourselIndex] objectForKey:@"document_id"] forKey:@"doc_id"];
		[_tempDict setObject:[[ArrayResponse objectAtIndex:icourselIndex]objectForKey:@"doc_type"] forKey:@"doc_type"];
		if(![[[ArrayResponse objectAtIndex:icourselIndex] objectForKey:@"chapter_video"] isKindOfClass:[NSString class]]){
			[[ArrayResponse objectAtIndex:icourselIndex] setObject:_videoData forKey:@"_videoData"];
			[_tempDict setObject:_videoData forKey:@"_videoData"];
		}
		[_tempDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"module_name"] forKey:@"moduleName"];
		if(![DataBase iscontainThisRecord:[[[ArrayResponse objectAtIndex:icourselIndex] objectForKey:@"document_id"] intValue]])
		{
			[DataBase addDocumentDetailsToDB:_tempDict isVirtual:0];
			
		}else{
			[DataBase deleteOfflineData:[[[ArrayResponse objectAtIndex:icourselIndex] objectForKey:@"document_id"] intValue] isAttemptTest:NO editionId:0];
			[DataBase addDocumentDetailsToDB:_tempDict isVirtual:0];
		}
		[_tempDict release];
		_tempDict=nil;
		[self ShowPdf:[self GetPath:pdfName]];
	}
	[HUD hide:YES];
}

	
#pragma mark -
#pragma mark orientation Life Cycle

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
 {
	 if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
	 {	
		 Scrollview.frame=CGRectMake(0, 56, 768, 841);
		 Scrollview.contentSize=CGSizeMake(768, 841);
		 tab1.frame=CGRectMake(124, 911, 80, 49);
		 tab2.frame=CGRectMake(234, 911, 80, 49);
		 tab3.frame=CGRectMake(344, 911, 80, 49);
		 tab4.frame=CGRectMake(454, 911, 80 ,49);
		 tab5.frame=CGRectMake(564, 911, 80 ,49);
		 btn_Chapter.frame=CGRectMake(472, 4, 157, 45);
		 btn_course.frame=CGRectMake(125, 4, 179, 45);
		 btn_Module.frame=CGRectMake(312, 4, 152, 45);
		 
		 
		 
		 imagecoverFlow.frame=CGRectMake(20,620,734,221);
		 imageBackground.frame=CGRectMake(0,0,768,1004);
		 carousel_Chapters.frame=CGRectMake(41,660,695,162);
		 lbl_documents.frame=CGRectMake(43, 628, 403, 21);
		 coursesLine.frame=CGRectMake(46, 653, 681, 2);
		 
		 imageMainbackground.frame=CGRectMake(20,20,733,1024);
		 Web_view.frame=CGRectMake(28,24,719,564);
		}
	 else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
	 {
		 Scrollview.frame=CGRectMake(0, 56, 1024, 598);
		 Scrollview.contentSize=CGSizeMake(1024, 845);
		 tab1.frame=CGRectMake(252, 655, 80, 49);
		 tab2.frame=CGRectMake(362, 655, 80, 49);
		 tab3.frame=CGRectMake(472, 655, 80, 49);
		 tab4.frame=CGRectMake(582, 655, 80 ,49);
		 tab5.frame=CGRectMake(692, 655, 80,49);
		 btn_Chapter.frame=CGRectMake(606, 4, 157, 45);
		 btn_course.frame=CGRectMake(259, 4, 179, 45);
		 btn_Module.frame=CGRectMake(446, 4, 152, 45);
		 
		 
		 imagecoverFlow.frame=CGRectMake(148,570,734,221);
		 imageBackground.frame=CGRectMake(0,0,1024,768);
		 carousel_Chapters.frame=CGRectMake(169,605,695,157);
		 lbl_documents.frame=CGRectMake(173, 580, 175, 21);
		 coursesLine.frame=CGRectMake(174, 604, 681, 2);
		 imageMainbackground.frame=CGRectMake(148,20,733,1024);
		 Web_view.frame=CGRectMake(155,27,719,511);
	 }
	 Web_view.layer.masksToBounds=YES;
	 Web_view.layer.cornerRadius=10.0;
	 [Web_view setOpaque:NO];
	 [Web_view.layer setBorderColor:[[UIColor darkGrayColor]CGColor]];
	 [Web_view.layer setBorderWidth:2];
	 [Web_view setBackgroundColor:[UIColor clearColor]];

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
															message:@"pdf not downloded properly."
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
		[alertView show];
		[alertView release];		
	}
	else 
	{
		[appListData writeToFile:path atomically:YES];
	    [appListData release];
		appListData=nil;
		(isPdfDownload)?[self ShowPdf:path]:[self displayPDFDocumentView];		
		
	}
}
-(void)displayPDFDocumentView
{
	NSMutableArray *_arrayTempVideoInfo=[[NSMutableArray alloc] init];
	NSString *filePath =[self GetPath:pdfName];
	if(![[[ArrayResponse objectAtIndex:icourselIndex] objectForKey:@"chapter_video"] isKindOfClass:[NSString class]]){
		for (int i=0;i<[[[ArrayResponse objectAtIndex:icourselIndex] objectForKey:@"chapter_video"] count];i++){
			if([[[[[ArrayResponse objectAtIndex:icourselIndex] objectForKey:@"chapter_video"]objectAtIndex:i]objectForKey:@"video_url"] length]>0){
				NSMutableDictionary *dictTemp=[[NSMutableDictionary alloc] init];
				NSString *_videoName=[NSString stringWithFormat:@"%@.mp4",[eEducationAppDelegate UniqueNameGeneratorFromUrl:[[[[ArrayResponse objectAtIndex:icourselIndex] objectForKey:@"chapter_video"]objectAtIndex:i]objectForKey:@"video_url"]]];
				NSString *fileVideoPath=[self GetPath:_videoName];
				[dictTemp setObject:fileVideoPath forKey:@"video_url"];
				[dictTemp setObject:[[[[ArrayResponse objectAtIndex:icourselIndex] objectForKey:@"chapter_video"]objectAtIndex:i]objectForKey:@"video_page"] forKey:@"video_page"];
				[dictTemp setObject:[[[[ArrayResponse objectAtIndex:icourselIndex] objectForKey:@"chapter_video"]objectAtIndex:i]objectForKey:@"video_position"] forKey:@"video_position"];
				[_arrayTempVideoInfo addObject:dictTemp];
				[dictTemp release];
			}
		} 
	}
	
	ReaderDocument *document = [[ReaderDocument alloc]initWithFilePath:filePath password:nil dictVideoInfo:_arrayTempVideoInfo];
	if (document != nil) 
	{
		PlanTheStudies *objPlanTheStudies=[[PlanTheStudies alloc] initWithReaderDocument:document];
		objPlanTheStudies.Istype=@"CHAPTERS";
		objPlanTheStudies.TitleOfPdfName=pdfName;
		[self.navigationController pushViewController:objPlanTheStudies animated:YES];
		[objPlanTheStudies release];
	}
	else 
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
															message:[eEducationAppDelegate getLocalvalue:@"Requested PDF is not found in server please try again."]
														   delegate:nil
												  cancelButtonTitle:@"OK"
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
#pragma mark Button tap event


- (void)buttonTapped:(UIButton *)sender
{
	
	UIWindow *mainWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];	
	mainWindow.backgroundColor = [UIColor whiteColor]; 
	pdfName=[NSString stringWithFormat:@"%@.pdf",[eEducationAppDelegate UniqueNameGeneratorFromUrl:[[ArrayResponse objectAtIndex:sender.tag] objectForKey:@"doc_url"]]];
	[pdfName retain];
	[[NSUserDefaults standardUserDefaults] setObject:[[ArrayResponse objectAtIndex:sender.tag] objectForKey:@"document_name"] forKey:@"DocumentName"];
	if([self checkExistOfFile:pdfName])
	{		
		[self displayPDFDocumentView];
	}
	else
	{
		HUD = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
		HUD.detailsLabelText = [eEducationAppDelegate getLocalvalue:@"Please wait"];
		HUD.labelText=[eEducationAppDelegate getLocalvalue:@"Loading PDF..."];
		[self downloadFile:[NSURL URLWithString:[[[ArrayResponse objectAtIndex:sender.tag] objectForKey:@"doc_url"]stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation ]]];
    }
	[mainWindow release];
}

@end
