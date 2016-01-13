//
//  PracticeDetail.m
//  eEducation
//
//  Created by Hidden Brains on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PracticeDetail.h"
#import"Settings.h"
#import "ReaderDocument.h"
#import "PlanTheStudies.h"
#import "ModulesList.h"
#import "ModuleHomePage.h"
#import "ICourseList.h"
#import <QuartzCore/QuartzCore.h>
#import "eEducationAppDelegate.h"

@implementation PracticeDetail
@synthesize isUploaded;
@synthesize appListData;
@synthesize connection;
@synthesize buttonModule = _buttonModule;
@synthesize dicPracticeList = _dicPracticeList;
@synthesize buttonViewUploadPriceList = _buttonViewUploadPriceList;

- (void)viewDidLoad 
{
    [super viewDidLoad];
	appDelegate=(eEducationAppDelegate *)[[UIApplication sharedApplication] delegate];
	if ([[_dicPracticeList objectForKey:@"Practice_doc_url"] length] > 0)
	{
		_buttonViewUploadPriceList.enabled = TRUE;
		btnPrecticeDocument.enabled = TRUE;
	}
	else 
	{
		btnPrecticeDocument.enabled = FALSE;
		_buttonViewUploadPriceList.enabled = FALSE;
	}
    
	[_buttonViewUploadPriceList setImage:[eEducationAppDelegate GetLocalImage:@"btn_viewuploaded"] forState:UIControlStateNormal];
	[_buttonViewUploadPriceList setImage:[eEducationAppDelegate GetLocalImage:@"btn_viewuploaded_h"] forState:UIControlStateHighlighted];
	[btnPrecticeDocument setImage:[eEducationAppDelegate GetLocalImage:@"btn_Practice-Document"] forState:UIControlStateNormal];
	[btnPrecticeDocument setImage:[eEducationAppDelegate GetLocalImage:@"btn_Practice-Document_h"] forState:UIControlStateHighlighted];
	[btnUpload setImage:[eEducationAppDelegate GetLocalImage:@"btn_upload"] forState:UIControlStateNormal];
	[btnUpload setImage:[eEducationAppDelegate GetLocalImage:@"btn_upload_h"] forState:UIControlStateHighlighted];
}

-(float)heightOfView:(NSString*)_description text_width:(float)_textWidth
{
	float _height=0.0;
	CGSize  textSize = {_textWidth, 10000.0 };
	CGSize size = [_description sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:textSize lineBreakMode:UILineBreakModeCharacterWrap];
	_height = size.height;
	return _height;
}

-(IBAction)buttonModuleClick:(id)sender{
	NSArray *viewContrlls=[[appDelegate navigationController] viewControllers];
	for( int i=0;i<[ viewContrlls count];i++)
	{
		id obj=[viewContrlls objectAtIndex:i];
		if([obj isKindOfClass:[ModuleHomePage class]])
		{
			[[appDelegate navigationController] popToViewController:obj animated:YES];
			return;
		}
	}
}

-(void) viewWillAppear:(BOOL)animated
{
	[_buttonModule setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"module_name"] forState:UIControlStateNormal];
	[btnPrectice setTitle:[_dicPracticeList objectForKey:@"practice_name"] forState:UIControlStateNormal];
	[[NSUserDefaults standardUserDefaults] setObject:[_dicPracticeList objectForKey:@"practice_name"] forKey:@"practice_name"];
	[self setLocalizedText];
	NSDateFormatter *_dateFormater=[[NSDateFormatter alloc] init];
    [_dateFormater setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
	
	if([[_dicPracticeList objectForKey:@"status"] isEqualToString:@"Uploaded"])
	{
		[self.view addSubview:uploadView];
		uploadView.frame=CGRectMake(0, 58, 768, height+400);
		UploadImgView.frame=CGRectMake(20, 20, 734, height+100);
		CALayer *layer = [UploadImgView layer];
		[layer setBorderColor:[[UIColor blackColor]CGColor]];
		[layer setBorderWidth:2];
		[layer setCornerRadius:16];
		[layer setMasksToBounds:YES];
		if(![[_dicPracticeList objectForKey:@"practice_name"] isKindOfClass:[NSNull class]])
			lbl_nameDetails_uploadView.text=[_dicPracticeList objectForKey:@"practice_name"];
		if(![[_dicPracticeList objectForKey:@"start_date"] isKindOfClass:[NSNull class]]){
			[_dateFormater setDateFormat:@"MMMM dd,yyyy"];
			NSDate *_date=[_dateFormater dateFromString:[self getProperDate:[_dicPracticeList objectForKey:@"start_date"]]];
			[_dateFormater setDateFormat:@"dd-MM-yyyy"];
			lbl_startDateDetails_uploadView.text=[_dateFormater stringFromDate:_date];
		}
		if(![[_dicPracticeList objectForKey:@"end_date"] isKindOfClass:[NSNull class]]){
			[_dateFormater setDateFormat:@"MMMM dd,yyyy"];
			NSDate *_date=[_dateFormater dateFromString:[self getProperDate:[_dicPracticeList objectForKey:@"end_date"]]];
			[_dateFormater setDateFormat:@"dd-MM-yyyy"];
			lbl_EndDateDetails_uploadView.text = [_dateFormater stringFromDate:_date];
		}
		if(![[_dicPracticeList objectForKey:@"description"] isKindOfClass:[NSNull class]])
			txt_DescriptionDetails_uploadView.text=[_dicPracticeList objectForKey:@"description"];
		if(![[_dicPracticeList objectForKey:@"user_marks"] isKindOfClass:[NSNull class]])
			lbl_MarksDetails_uploadView.text = [_dicPracticeList objectForKey:@"user_marks"];
		if(![[_dicPracticeList objectForKey:@"uploaded_date"] isKindOfClass:[NSNull class]]){
			[_dateFormater setDateFormat:@"MMMM dd,yyyy"];
			NSDate *_date=[_dateFormater dateFromString:[self getProperDate:[_dicPracticeList objectForKey:@"uploaded_date"]]];
			[_dateFormater setDateFormat:@"dd-MM-yyyy"];
			lbl_DateDetails_uploadView.text = [_dateFormater stringFromDate:_date];
		}
	}
	else 
	{
		notUploadView.frame=CGRectMake(0, 58, 768, height+400);
		notUploadImgView.frame=CGRectMake(20, 20, 734, height+100);
		CALayer *layer = [notUploadImgView layer];
		[layer setBorderColor:[[UIColor blackColor]CGColor]];
		[layer setBorderWidth:2];
		[layer setCornerRadius:16];
		[layer setMasksToBounds:YES];
		txt_DescriptionDetails_notUploadView.frame=CGRectMake(185, 114, 556, height);
		btnPrecticeDocument.frame=CGRectMake(btnPrecticeDocument.frame.origin.x+40,notUploadImgView.frame.origin.y+height+135, 219, 45);   
		btnUpload.frame=CGRectMake(153,notUploadImgView.frame.origin.y+height+135, 219, 45); 
		[self.view addSubview:notUploadView];
		if(![[_dicPracticeList objectForKey:@"practice_name"] isKindOfClass:[NSNull class]])
			lbl_nameDetails_notUploadView.text=[_dicPracticeList objectForKey:@"practice_name"];
		if(![[_dicPracticeList objectForKey:@"start_date"] isKindOfClass:[NSNull class]]){
			[_dateFormater setDateFormat:@"MMMM dd,yyyy"];
			NSDate *_date=[_dateFormater dateFromString:[self getProperDate:[_dicPracticeList objectForKey:@"start_date"]]];
			[_dateFormater setDateFormat:@"dd-MM-yyyy"];
			lbl_startDateDetails_notUploadView.text=[_dateFormater stringFromDate:_date];
		}
		if(![[_dicPracticeList objectForKey:@"end_date"] isKindOfClass:[NSNull class]]){
			[_dateFormater setDateFormat:@"MMMM dd,yyyy"];
			NSDate *_date=[_dateFormater dateFromString:[self getProperDate:[_dicPracticeList objectForKey:@"end_date"]]];
			[_dateFormater setDateFormat:@"dd-MM-yyyy"];
			lbl_EndDateDetails_notUploadView.text=[_dateFormater stringFromDate:_date];
		}
		if(![[_dicPracticeList objectForKey:@"description"] isKindOfClass:[NSNull class]])
			txt_DescriptionDetails_notUploadView.text=[_dicPracticeList objectForKey:@"description"];
	}
	[_dateFormater release];
	self.navigationController.navigationBar.hidden=NO;
	[self.navigationItem setHidesBackButton:YES];
	[self.navigationController.navigationBar viewWithTag:BUTTON_HOME_TAG].hidden=NO;
	[(UILabel *)[self.navigationController.navigationBar viewWithTag:LABEL_TITLE_TAG] setText:[eEducationAppDelegate getLocalvalue:@" "]];
	[self willAnimateRotationToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0.2];
}

-(void)setLocalizedText
{
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
	
	[btnCourse setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"course_name"] forState:UIControlStateNormal];
	lbl_name_uploadView.text=[eEducationAppDelegate getLocalvalue:@"Name"];
	lbl_startDate_uploadView.text=[eEducationAppDelegate getLocalvalue:@"Start Date"];
	lbl_EndDate_uploadView.text=[eEducationAppDelegate getLocalvalue:@"End Date"];
	lbl_Description_uploadView.text=[eEducationAppDelegate getLocalvalue:@"Description"];
	lbl_marks_uploadView.text = [eEducationAppDelegate getLocalvalue:@"Marks"];
	lbl_Date_uploadView.text = [eEducationAppDelegate getLocalvalue:@"Date"];
	
	lbl_name_notUploadView.text=[eEducationAppDelegate getLocalvalue:@"Name"];
	lbl_startDate_notUploadView.text=[eEducationAppDelegate getLocalvalue:@"Start Date"];
	lbl_EndDate_notUploadView.text=[eEducationAppDelegate getLocalvalue:@"End Date"];
	lbl_Description_notUploadView.text=[eEducationAppDelegate getLocalvalue:@"Description"];
}

-(IBAction) TabarIndexSelected:(id)sender
{
	UIButton *btn=sender;
	int i=btn.tag/11;
    appDelegate=(eEducationAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate setUpTabbarWithSelection:i];	
}

-(NSString *)getProperDate:(NSString *)date_string
{
	date_string = [[date_string componentsSeparatedByString:@" "] objectAtIndex:0];
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
	[dateFormatter setDateFormat:@"YYYY-MM-dd"];
	NSDate *date = [dateFormatter dateFromString:date_string];
	[dateFormatter setDateFormat:@"MMMM dd, YYYY"];
	date_string = [dateFormatter stringFromDate:date];
	return date_string;
}

#pragma mark -
#pragma mark Action Method
-(IBAction)btnCourse_Clicked:(id)sender
{
	NSArray *viewContrlls=[[appDelegate navigationController] viewControllers];
	for( int i=0;i<[ viewContrlls count];i++)
	{
		id obj=[viewContrlls objectAtIndex:i];
		if([obj isKindOfClass:[ModulesList class]] )
		{
			[[appDelegate navigationController] popToViewController:obj animated:YES];
			return;
		}
	}
}

-(IBAction)btnModule_Clicked:(id)sender
{
	NSArray *viewContrlls=[[appDelegate navigationController] viewControllers];
	for( int i=0;i<[ viewContrlls count];i++)
	{
		id obj=[viewContrlls objectAtIndex:i];
		if([obj isKindOfClass:[ModuleHomePage class]] )
		{
			[[appDelegate navigationController] popToViewController:obj animated:YES];
			return;
		}
	}
}

-(IBAction)btnViewPractice_Clicked:(id)sender
{
  	UIWindow *mainWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];	
	mainWindow.backgroundColor = [UIColor whiteColor]; 
	pdfName=[NSString stringWithFormat:@"%@.pdf",[_dicPracticeList objectForKey:@"practice_id"]];
	[pdfName retain];
	
	if([self checkExistOfFile:pdfName])
	{		
		[self displayPDFDocumentView];
	}
	else
	{
		HUD = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
		HUD.detailsLabelText = [eEducationAppDelegate getLocalvalue:@"Loading PDF..."];
		HUD.labelText=[eEducationAppDelegate getLocalvalue:@"Please wait"];
		
		[self downloadFile:[NSURL URLWithString:[[_dicPracticeList objectForKey:@"uploaded_doc_url"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	}
	[mainWindow release];	
}

-(IBAction)btnPrectice:(id)sender
{
	[self.navigationController popViewControllerAnimated:TRUE];
}

-(IBAction)btnPractice_Clicked:(id)sender
{
	UIWindow *mainWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];	
	mainWindow.backgroundColor = [UIColor whiteColor]; 
	pdfName=[NSString stringWithFormat:@"%@.pdf",[_dicPracticeList objectForKey:@"practice_id"]];
	[pdfName retain];
	
	if([self checkExistOfFile:pdfName])
	{		
		[self displayPDFDocumentView];
	}
	else
	{
		HUD = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
		HUD.detailsLabelText = [eEducationAppDelegate getLocalvalue:@"Loading PDF..."];
		HUD.labelText=[eEducationAppDelegate getLocalvalue:@"Please wait"];
		
		[self downloadFile:[NSURL URLWithString:[[_dicPracticeList objectForKey:@"Practice_doc_url"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	}
	
	[mainWindow release];
}

#pragma mark -
#pragma mark orientation Life Cycle
-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown )
	{	
		if(![[_dicPracticeList objectForKey:@"description"] isKindOfClass:[NSNull class]])
			height=[self heightOfView:[_dicPracticeList objectForKey:@"description"] text_width:500.0];
		else{
			height=[self heightOfView:@" " text_width:500.0];
		}
		
		
		txt_DescriptionDetails_notUploadView.frame=CGRectMake(185, 114, 556, height+20);
		txt_DescriptionDetails_uploadView.frame=CGRectMake(169, 114, 575, height+20);
		lbl_Description_uploadView.frame=CGRectMake(39, 119, 124, 22);
		notUploadView.frame=CGRectMake(0, 58, 768,txt_DescriptionDetails_notUploadView.frame.origin.y+height+90);
		notUploadImgView.frame=CGRectMake(20, 20, 734, txt_DescriptionDetails_notUploadView.frame.origin.y+height+10);
		btnPrecticeDocument.frame=CGRectMake(277,notUploadImgView.frame.origin.y+notUploadImgView.frame.size.height+30, 219, 45);  
		//btnPrecticeDocument.frame=CGRectMake(396,notUploadImgView.frame.origin.y+notUploadImgView.frame.size.height+30, 219, 45); 
		btnUpload.frame=CGRectMake(153,notUploadImgView.frame.origin.y+notUploadImgView.frame.size.height+30, 219, 45); 
		//btnPrectice.frame=CGRectMake(401, 4, 149, 45);
		btnPrectice.frame=CGRectMake(457, 4, 149, 45);
		btnCourse.frame=CGRectMake(141, 4, 149, 45);
		_buttonModule.frame=CGRectMake(300, 4, 149, 45);
		//btnCourse.frame=CGRectMake(218, 4, 149, 45);
		//_buttonModule.frame=CGRectMake(, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);
		lbl_marks_uploadView.frame=CGRectMake(lbl_marks_uploadView.frame.origin.x,txt_DescriptionDetails_uploadView.frame.origin.y+height+30, 127, 21);
		lbl_Date_uploadView.frame=CGRectMake(lbl_Date_uploadView.frame.origin.x,txt_DescriptionDetails_uploadView.frame.origin.y+height+30, 127, 21);
		lbl_colon1.frame=CGRectMake(lbl_colon1.frame.origin.x,txt_DescriptionDetails_uploadView.frame.origin.y+height+30, 14, 21);
		lbl_colon2.frame=CGRectMake(lbl_colon2.frame.origin.x,txt_DescriptionDetails_uploadView.frame.origin.y+height+30, 14, 21);
		lbl_MarksDetails_uploadView.frame=CGRectMake(lbl_MarksDetails_uploadView.frame.origin.x,txt_DescriptionDetails_uploadView.frame.origin.y+height+30, 183, 21);
		lbl_DateDetails_uploadView.frame=CGRectMake(lbl_DateDetails_uploadView.frame.origin.x,txt_DescriptionDetails_uploadView.frame.origin.y+height+30, 157, 21);
		
		UploadImgView.frame=CGRectMake(20, 20, 734,lbl_DateDetails_uploadView.frame.origin.y+lbl_DateDetails_uploadView.frame.size.height+5);
		_buttonViewUploadPriceList.frame=CGRectMake(277,UploadImgView.frame.origin.y+height+200, 219, 45); 
		uploadView.frame=CGRectMake(0, 58, 768,lbl_DateDetails_uploadView.frame.origin.y+lbl_DateDetails_uploadView.frame.size.height+100);
		tab1.frame=CGRectMake(124, 911, 80, 49);
		tab2.frame=CGRectMake(234, 911, 80, 49);
		tab3.frame=CGRectMake(344, 911, 80, 49);
		tab4.frame=CGRectMake(454, 911, 80 ,49);
		tab5.frame=CGRectMake(564, 911, 80 ,49);
	}
	else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight )
	{
		if(![[_dicPracticeList objectForKey:@"description"] isKindOfClass:[NSNull class]])
			height=[self heightOfView:[_dicPracticeList objectForKey:@"description"] text_width:769];
		else{
			height=[self heightOfView:@" " text_width:769];
		}
		//btnPrectice.frame=CGRectMake(529, 4, 149, 45);
//		btnCourse.frame=CGRectMake(346, 4, 149, 45);
		uploadView.frame=CGRectMake(0, 58, 1024,300);
		
		txt_DescriptionDetails_uploadView.frame=CGRectMake(169, 114, 769, height+20);
		txt_DescriptionDetails_notUploadView.frame=CGRectMake(185, 114,txt_DescriptionDetails_notUploadView.frame.size.width , height+20);
		notUploadView.frame=CGRectMake(0, 58, 1024, txt_DescriptionDetails_notUploadView.frame.origin.y+height+90);
		notUploadImgView.frame=CGRectMake(20, 20, notUploadImgView.frame.size.width,txt_DescriptionDetails_notUploadView.frame.origin.y+height+10);
		btnPrecticeDocument.frame=CGRectMake(btnPrecticeDocument.frame.origin.x,notUploadImgView.frame.origin.y+notUploadImgView.frame.size.height+30, 219, 45); 
		btnUpload.frame=CGRectMake(btnUpload.frame.origin.x,notUploadImgView.frame.origin.y+notUploadImgView.frame.size.height+30, 219, 45);
		lbl_marks_uploadView.frame=CGRectMake(lbl_marks_uploadView.frame.origin.x,txt_DescriptionDetails_uploadView.frame.origin.y+height+30, 127, 21);
		lbl_Date_uploadView.frame=CGRectMake(lbl_Date_uploadView.frame.origin.x,txt_DescriptionDetails_uploadView.frame.origin.y+height+30, 127, 21);
		lbl_colon1.frame=CGRectMake(lbl_colon1.frame.origin.x,txt_DescriptionDetails_uploadView.frame.origin.y+height+30, 14, 21);
		lbl_colon2.frame=CGRectMake(lbl_colon2.frame.origin.x,txt_DescriptionDetails_uploadView.frame.origin.y+height+30, 14, 21);
		lbl_MarksDetails_uploadView.frame=CGRectMake(lbl_MarksDetails_uploadView.frame.origin.x,txt_DescriptionDetails_uploadView.frame.origin.y+height+30, 183, 21);
		lbl_DateDetails_uploadView.frame=CGRectMake(lbl_DateDetails_uploadView.frame.origin.x,txt_DescriptionDetails_uploadView.frame.origin.y+height+30, 157, 21);
		UploadImgView.frame=CGRectMake(20, 20, UploadImgView.frame.size.width,lbl_DateDetails_uploadView.frame.origin.y+lbl_DateDetails_uploadView.frame.size.height+5);
		_buttonViewUploadPriceList.frame=CGRectMake(_buttonViewUploadPriceList.frame.origin.x+34,UploadImgView.frame.origin.y+height+200, 219, 45); 
		uploadView.frame=CGRectMake(0, 58, uploadView.frame.size.width,lbl_DateDetails_uploadView.frame.origin.y+lbl_DateDetails_uploadView.frame.size.height+100);
		btnPrectice.frame=CGRectMake(626, 4, 149, 45);
		btnCourse.frame=CGRectMake(308, 4, 149, 45);
		_buttonModule.frame=CGRectMake(467, 4, 149, 45);
		tab1.frame=CGRectMake(252, 655, 80, 49);
		tab2.frame=CGRectMake(362, 655, 80, 49);
		tab3.frame=CGRectMake(472, 655, 80, 49);
		tab4.frame=CGRectMake(582, 655, 80 ,49);
		tab5.frame=CGRectMake(692, 655, 80,49);
	}	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark -
#pragma mark pdfName
-(void)downloadFile:(NSURL *)url
{
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
	connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
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
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"pdf not downloded properly"] delegate:nil
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
		//PlanTheStudies *objPlanTheStudies=[[PlanTheStudies alloc] initWithNibName:@"PlanTheStudies" bundle:nil];
		//		[objPlanTheStudies initWithReaderDocument:document];
		PlanTheStudies *objPlanTheStudies=[[PlanTheStudies alloc] initWithReaderDocument:document];
		objPlanTheStudies.Istype=@"Practice";
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
											  cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]
											  otherButtonTitles:nil];
	[HUD hide:YES];
    [alertView show];
    [alertView release];
}

#pragma mark -
#pragma mark Memory Management Method

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[uploadView release];uploadView=nil;
	[notUploadView release];notUploadView=nil;
	[btnPrecticeDocument release];btnPrecticeDocument=nil;
	[btnCourse release];btnCourse=nil;
	[btnModule release];btnModule=nil;
	[btnPrectice release];btnPrectice=nil;
	[btnSetting release];btnSetting=nil;
	[btnUpload release];btnUpload=nil;
	[notUploadImgView release];notUploadImgView=nil;
	[UploadImgView release];UploadImgView=nil;
	[_buttonModule release];_buttonModule=nil;
	[tab1 release];tab1=nil;
	[tab2 release];tab2=nil;
	[tab3 release];tab3=nil;
	[tab4 release];tab4=nil;
	[tab5 release];tab5=nil;
	[lbl_name_uploadView release];lbl_name_uploadView=nil;
	[lbl_startDate_uploadView release];lbl_startDate_uploadView=nil;
	[lbl_Description_uploadView release];lbl_Description_uploadView=nil;
	[lbl_EndDate_uploadView release];lbl_EndDate_uploadView=nil;
	[lbl_colon1 release];lbl_colon1=nil;
	[lbl_colon2 release];lbl_colon2=nil;
	[lbl_nameDetails_uploadView release];lbl_nameDetails_uploadView=nil;
	[lbl_startDateDetails_uploadView release];lbl_startDateDetails_uploadView=nil;
	[lbl_EndDateDetails_uploadView release];lbl_EndDateDetails_uploadView=nil;
	[lbl_MarksDetails_uploadView release];lbl_MarksDetails_uploadView=nil;
	[lbl_DateDetails_uploadView release];lbl_DateDetails_uploadView=nil;
	[lbl_marks_uploadView release];lbl_marks_uploadView=nil;
	[lbl_Date_uploadView release];lbl_Date_uploadView=nil;
	[txt_DescriptionDetails_uploadView release];txt_DescriptionDetails_uploadView=nil;
	[lbl_name_notUploadView release];lbl_name_notUploadView=nil;
	[lbl_startDate_notUploadView release];lbl_startDate_notUploadView=nil;
	[lbl_Description_notUploadView release];lbl_Description_notUploadView=nil;
	[lbl_EndDate_notUploadView release];lbl_EndDate_notUploadView=nil;
	[lbl_nameDetails_notUploadView release];lbl_nameDetails_notUploadView=nil;
	[lbl_startDateDetails_notUploadView release];lbl_startDateDetails_notUploadView=nil;
	[lbl_EndDateDetails_notUploadView release];lbl_EndDateDetails_notUploadView=nil;
	[txt_DescriptionDetails_notUploadView release];txt_DescriptionDetails_notUploadView=nil;
	[_dicPracticeList release];_dicPracticeList=nil;
	[_buttonViewUploadPriceList release];_buttonViewUploadPriceList = nil;
    [super dealloc];
}


@end
