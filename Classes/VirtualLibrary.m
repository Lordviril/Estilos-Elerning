//
//  VirtualLibrary.m
//  eEducation
//
//  Created by HB14 on 09/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VirtualLibrary.h"
#import "CustomCellLibrary.h"
#import "VirtualVideos.h"
#import "Settings.h"
#import "EpubReaderViewController.h"
#import "ReaderDocument.h"
#import "PlanTheStudies.h"
#import "downloadManager.h"
#import "ModuleHomePage.h"

@implementation VirtualLibrary
@synthesize appListData;
@synthesize connection;

#pragma mark - ViewLife Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	appDelegate=(eEducationAppDelegate*)[[UIApplication sharedApplication] delegate];
	objDownloadManger=[[downloadManager alloc] init];
	MainDataArray=[[NSMutableArray alloc] init];

	objParser = [[JSONParser alloc] init];
	objParser.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:YES];

    self.btnPdf.selected = YES;
    self.btnVideos.selected = NO;
    
    [self.lblTopCourse setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"course_name"]];
    [self.lblTopDuration setText:[NSString stringWithFormat:RTLableText,[eEducationAppDelegate getLocalvalue:@"Begins "],[eEducationAppDelegate convertString:[[NSUserDefaults standardUserDefaults] valueForKey:@"edition_start"] fromFormate:@"yyyy-MM-dd" toFormate:@"dd MMMM yyyy"],[eEducationAppDelegate getLocalvalue:@"- Ends "],[eEducationAppDelegate convertString:[[NSUserDefaults standardUserDefaults] valueForKey:@"edition_end"] fromFormate:@"yyyy-MM-dd" toFormate:@"dd MMMM yyyy"]]];
    
    self.lblProfileBlueName.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_name"];
    self.lblProfileGrayName.text = [eEducationAppDelegate getLocalvalue:@"WELCOME"];
    [self.imgProfile loadImageFromURL:[NSURL URLWithString:[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_profile_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:@"no-image-200x200.png"];
    [self.imgLogo loadImageFromURL:[eEducationAppDelegate getTopCourseUrl] imageName:@"top-bar-logo.png"];
    [self.imgLogoStatic loadImageFromURL:[eEducationAppDelegate getTopStaticUrl] imageName:@"logo_top_static.png"];

    [self.btnPdf setTitle:[eEducationAppDelegate getLocalvalue:@"Abstracts In Pdf"] forState:UIControlStateNormal];
    [self.btnVideos setTitle:[eEducationAppDelegate getLocalvalue:@"Videos"] forState:UIControlStateNormal];
    [self.lblTitle setText:[[eEducationAppDelegate getLocalvalue:@"Library"] uppercaseString]];
    [self.lblBoxTitle setText:[[eEducationAppDelegate getLocalvalue:@"VIRTUAL LIBRARY"] uppercaseString]];
    [self.btnHome setTitle:[eEducationAppDelegate getLocalvalue:@"HOME"] forState:UIControlStateNormal];
    [self.btnModule setTitle:[[eEducationAppDelegate getLocalvalue:@"Module"] uppercaseString] forState:UIControlStateNormal];

    [self callPdfWs];
}

-(void)viewWillDisappear:(BOOL)animated
{
}

#pragma mark - Webservice methods
-(void)callPdfWs{
    HUD = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
	HUD.labelText=[eEducationAppDelegate getLocalvalue:@"Please wait"];
	NSString *strURL =[WebService  GetVituvalLibraryDataXml];
	NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"course_id"], @"course_id",
								 @"document", @"type",
								 @"pdf",@"doc_type",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language",
								 nil];
	[objParser sendRequestToParse:strURL params:requestData];
}
-(void)callVideosWs{
    HUD = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
	HUD.labelText=[eEducationAppDelegate getLocalvalue:@"Please wait"];
	NSString *strURL =[WebService  GetVituvalVideosDataXml];
	NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"course_id"], @"course_id",
								 @"video", @"type",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language",
								 nil];
	[objParser sendRequestToParse:strURL params:requestData];
}

#pragma mark -
#pragma mark Topbar Action methods
-(IBAction)btnBackClicked:(id)sender{
    @try {
        [[validations getAppDelegateInstance].navigationController popToViewController:[[validations getAppDelegateInstance].navigationController.viewControllers objectAtIndex:2] animated:NO];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(IBAction)proImgClicked:(id)sender{
    [self btnSettingsClicked:nil];
}

-(IBAction)btnStudentsClicked:(id)sender{
    OtherStudents *objOtherStudents = [[OtherStudents alloc] initWithNibName:@"OtherStudents" bundle:nil];
    [[validations getAppDelegateInstance] removePresentVC];
	[[validations getAppDelegateInstance].navigationController pushViewController:objOtherStudents animated:NO];
	[objOtherStudents release];
}

-(IBAction)btnSettingsClicked:(id)sender{
    Settings *objSettings = [[Settings alloc] initWithNibName:@"Settings" bundle:nil];
    [[validations getAppDelegateInstance] removePresentVC];
	[[validations getAppDelegateInstance].navigationController pushViewController:objSettings animated:NO];
	[objSettings release];
}

-(IBAction)btnLogoutClicked:(id)sender{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"You're about to logout, are you sure?"] delegate:self	 cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"NO"]  otherButtonTitles:[eEducationAppDelegate getLocalvalue:@"YES"],nil];
	[alert show];
	alert.tag=TAG_ALERT_LOGOUT;
	[alert release];
}

-(IBAction)btnModuleClicked:(id)sender{
    ModuleHomePage *objModuleListHomePage=[[ModuleHomePage alloc] initWithNibName:@"ModuleHomePage" bundle:nil];
    [[validations getAppDelegateInstance] removePresentVC];
	[[validations getAppDelegateInstance].navigationController pushViewController:objModuleListHomePage animated:NO];
	[objModuleListHomePage release];
}

#pragma mark - Action methods
-(IBAction)btnVideos_clicked:(id)sender
{
    VirtualVideos *objVirtualVideos = [[VirtualVideos alloc] initWithNibName:@"VirtualVideos" bundle:nil];
	[self.navigationController pushViewController:objVirtualVideos animated:NO];
	[objVirtualVideos release];
}

-(IBAction)btnPDF_clicked:(UIButton *)sender{
}

#pragma mark -
#pragma mark tableView Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if (self.btnPdf.selected) {
        
    }
	NSInteger i=[MainDataArray count]/3;
	return ([MainDataArray count]%3==0)?i:i+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"CustomCellLibrary";
	CustomCellLibrary *cell=(CustomCellLibrary *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	cell=nil;
	if(cell==nil)
	{
		cell=(CustomCellLibrary*)[[[NSBundle mainBundle] loadNibNamed:@"CustomCellLibrary" owner:self options:nil] lastObject];
	}
    int count=[MainDataArray count];
    if(indexPath.row==count/3)
    {
        switch(count%3)
        {
            case 1:
            {
                cell.btn_book2.hidden=YES;
                cell.btn_book3.hidden=YES;
                cell.btn_book1.hidden=NO;
                cell.Book1.hidden=NO;
                cell.Book2.hidden=YES;
                cell.Book3.hidden=YES;
                [cell.Book1 loadImageFromURL:[NSURL URLWithString:[[[MainDataArray objectAtIndex:indexPath.row*3] objectForKey:@"doc_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:@"no-image-204x278.png"];
                [cell.btn_book1 addTarget:self action:@selector(BookPressed:) forControlEvents:UIControlEventTouchUpInside];
                break;
            }
            case 2:
            {
                cell.btn_book3.hidden=YES;
                cell.btn_book2.hidden=NO;
                cell.btn_book1.hidden=NO;
                cell.Book1.hidden=NO;
                cell.Book2.hidden=NO;
                cell.Book3.hidden=YES;
                [cell.Book2 loadImageFromURL:[NSURL URLWithString:[[[MainDataArray objectAtIndex:indexPath.row*3+1] objectForKey:@"doc_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:@"no-image-204x278.png"];
                [cell.Book1 loadImageFromURL:[NSURL URLWithString:[[[MainDataArray objectAtIndex:indexPath.row*3] objectForKey:@"doc_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:@"no-image-204x278.png"];
                [cell.btn_book1 addTarget:self action:@selector(BookPressed:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btn_book2 addTarget:self action:@selector(BookPressed:) forControlEvents:UIControlEventTouchUpInside];
                break;
            }
        }
    }
    else
    {
        cell.btn_book3.hidden=NO;
        cell.btn_book2.hidden=NO;
        cell.btn_book1.hidden=NO;
        cell.Book1.hidden=NO;
        cell.Book2.hidden=NO;
        cell.Book3.hidden=NO;
        [cell.Book3 loadImageFromURL:[NSURL URLWithString:[[[MainDataArray objectAtIndex:indexPath.row*3+2] objectForKey:@"doc_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:@"no-image-204x278.png"];
        [cell.Book2 loadImageFromURL:[NSURL URLWithString:[[[MainDataArray objectAtIndex:indexPath.row*3+1] objectForKey:@"doc_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:@"no-image-204x278.png"];
        [cell.Book1 loadImageFromURL:[NSURL URLWithString:[[[MainDataArray objectAtIndex:indexPath.row*3] objectForKey:@"doc_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:@"no-image-204x278.png"];
        
        [cell.btn_book1 addTarget:self action:@selector(BookPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn_book2 addTarget:self action:@selector(BookPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn_book3 addTarget:self action:@selector(BookPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
	[cell.btn_book1 addTarget:self action:@selector(BookPressed:) forControlEvents:UIControlEventTouchUpInside];
	[cell.btn_book2 addTarget:self action:@selector(BookPressed:) forControlEvents:UIControlEventTouchUpInside];
	[cell.btn_book3 addTarget:self action:@selector(BookPressed:) forControlEvents:UIControlEventTouchUpInside];
	cell.btn_book1.tag=indexPath.row*3;
	cell.btn_book2.tag=indexPath.row*3+1;
	cell.btn_book3.tag=indexPath.row*3+2;
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 232;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

#pragma mark - Other methods
-(BOOL)checkDataExistence:(NSMutableArray*)arr{
    if (arr.count == 0 || [[[arr objectAtIndex:0] objectForKey:@"success"] isEqualToString:@"0"])
    {
        return NO;
    }
    return YES;
}

-(void) BookPressed:(id)sender
{
	UIButton *btn=sender;
	SelectedDownloadEpub=btn.tag;
    if ([[MainDataArray objectAtIndex:btn.tag] objectForKey:@"doc_url"] == nil || [[[MainDataArray objectAtIndex:btn.tag] objectForKey:@"doc_url"] isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                            message:[eEducationAppDelegate getLocalvalue:@"Requested PDF is not found in server please try again."]
                                                           delegate:nil
                                                  cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    } else {
        UIWindow *mainWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        mainWindow.backgroundColor = [UIColor whiteColor];
        pdfName=[NSString stringWithFormat:@"%@.pdf",[eEducationAppDelegate UniqueNameGeneratorFromUrl:[[MainDataArray objectAtIndex:btn.tag] objectForKey:@"doc_url"]]];
        [pdfName retain];
        if([self checkExistOfFile:pdfName])
        {
            if(![[[MainDataArray objectAtIndex:btn.tag] objectForKey:@"pdf_videos"] isKindOfClass:[NSString class]]){
                _urlArray=[[NSMutableArray alloc] init];
                for (int i=0;i<[[[MainDataArray objectAtIndex:btn.tag] objectForKey:@"pdf_videos"] count];i++){
                    if([[[[[MainDataArray objectAtIndex:btn.tag] objectForKey:@"pdf_videos"]objectAtIndex:i]objectForKey:@"video_url"] length]>0){
                        NSString *_videoName=[NSString stringWithFormat:@"%@.mp4",[eEducationAppDelegate UniqueNameGeneratorFromUrl:[[[[MainDataArray objectAtIndex:btn.tag] objectForKey:@"pdf_videos"]objectAtIndex:i]objectForKey:@"video_url"]]];
                        if(![self checkExistOfFile:_videoName]){
                            [_urlArray addObject:[[[[MainDataArray objectAtIndex:btn.tag] objectForKey:@"pdf_videos"]objectAtIndex:i]objectForKey:@"video_url"]];
                        }
                    }
                }
                if([_urlArray count]>0){
                    HUD = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
                    HUD.detailsLabelText =[eEducationAppDelegate getLocalvalue: @"Loading PDF..."];
                    HUD.labelText=[eEducationAppDelegate getLocalvalue:@"Please wait"];
                    [objDownloadManger initwithStringArray:_urlArray PdfName:pdfName];
                    objDownloadManger.delegate=self;
                }else{
                    [self displayPDFDocumentView];
                }
            }else{
                [self displayPDFDocumentView];
            }
        }
        else
        {
            if(_urlArray){
                [_urlArray release];
                _urlArray=nil;
            }
            _urlArray=[[NSMutableArray alloc] init];
            if(![[[MainDataArray objectAtIndex:btn.tag] objectForKey:@"pdf_videos"] isKindOfClass:[NSString class]]){
                NSArray *_videoInfoArray=[[NSArray alloc] initWithArray:[[MainDataArray objectAtIndex:btn.tag] objectForKey:@"pdf_videos"]];
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
                _videoData=[[NSData alloc]initWithData:[self getCurrentSavedVideoData:[[MainDataArray objectAtIndex:btn.tag] objectForKey:@"pdf_videos"]]];
            }
            [_urlArray addObject:[[MainDataArray objectAtIndex:btn.tag] objectForKey:@"doc_url"]];
            
            HUD = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
            HUD.detailsLabelText =[eEducationAppDelegate getLocalvalue: @"Loading PDF..."];
            HUD.labelText=[eEducationAppDelegate getLocalvalue:@"Please wait"];
            [objDownloadManger initwithStringArray:_urlArray PdfName:pdfName];
            objDownloadManger.delegate=self;
        }
        [mainWindow release];
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
		if(![[[MainDataArray objectAtIndex:SelectedDownloadEpub] objectForKey:@"pdf_videos"] isKindOfClass:[NSString class]]){
			[[MainDataArray objectAtIndex:SelectedDownloadEpub] setObject:_videoData forKey:@"_videoData"];
		}
		if(![DataBase iscontainThisRecord:[[[MainDataArray objectAtIndex:SelectedDownloadEpub] objectForKey:@"doc_id"] intValue]])
		{
			[DataBase addDocumentDetailsToDB:[MainDataArray objectAtIndex:SelectedDownloadEpub] isVirtual:1];
			
		}else{
			[DataBase deleteOfflineData:[[[MainDataArray objectAtIndex:SelectedDownloadEpub] objectForKey:@"doc_id"]intValue] isAttemptTest:NO editionId:0];
			[DataBase addDocumentDetailsToDB:[MainDataArray objectAtIndex:SelectedDownloadEpub] isVirtual:1];
		}
		[self displayPDFDocumentView];
	}
	[HUD hide:YES];
}

-(void) DisplayTheEpubDocumentView:(NSString *)FilePath titleName:(NSString *)TitleName
{
	EpubReaderViewController *_epubReaderViewController=[[EpubReaderViewController alloc] initWithNibName:@"EpubReaderViewController" bundle:nil];
	_epubReaderViewController._strEpubFilePath=FilePath;
	_epubReaderViewController._titleName=TitleName;
	_epubReaderViewController._rootPath=TitleName;
	_epubReaderViewController.hidesBottomBarWhenPushed=YES;
	[self.navigationController pushViewController:_epubReaderViewController animated:YES];
	[_epubReaderViewController release];
	_epubReaderViewController=nil;
}

#pragma mark -
#pragma mark JSONParser delegate method
- (void)parserDidFinishLoadingReturnData:(NSString *)responseString
{
    [HUD hide:YES];
    SBJSON *json = [[SBJSON new] autorelease];
    MainDataArray = [[NSMutableArray alloc]initWithArray:[json objectWithString:responseString error:nil]];
    if([self checkDataExistence:MainDataArray])
    {
        self.btnPdf.selected?[self.tblViewBooks reloadData]:[self.tblViewVideos reloadData];
    } else {
        MainDataArray = [[NSMutableArray alloc] init];
        if (self.btnPdf.selected) {
            [self.tblViewBooks reloadData];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"No pdf books are available For this course."] delegate:nil cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
            [alert show];
            [alert release];
        } else {
            [self.tblViewVideos reloadData];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"No videos are available For this course."] delegate:nil cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
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

#pragma mark - AlertView Delegate methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if(alertView.tag==TAG_FailError)
	{
		if(buttonIndex==0)
		[appDelegate GoTOLoginScreen:YES];
	}
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag==99 && buttonIndex!=0)
	{
        eEducationAppDelegate *obj = (eEducationAppDelegate*)[UIApplication sharedApplication].delegate;
        [obj.navigationController popToViewController:[obj.navigationController.viewControllers objectAtIndex:1] animated:YES];
    } else if((alertView.tag == TAG_ALERT_LOGOUT && buttonIndex ==1) || alertView.tag == 33){
        @try {
            [[validations getAppDelegateInstance].navigationController popToViewController:[[validations getAppDelegateInstance].navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
    }
}

#pragma mark -
#pragma mark pdfName
-(void)downloadFile:(NSURL *)url
{
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:100.0];
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
	NSString *pathString=@"";
	if(0)
	{
		pathString=[pathArray objectAtIndex:0];
		pathString=[pathString stringByAppendingPathComponent:@"EPUBBOOKS"];
	}
	else 
	{
		pathString = [NSString stringWithFormat: @"/%@/PDFBOOKS/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], [[pdfName componentsSeparatedByString:@"."] objectAtIndex:0]];
		[[NSFileManager defaultManager] createDirectoryAtPath:pathString withIntermediateDirectories:NO attributes:NO error:nil];
	}
	
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
		[HUD hide:YES];
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
	NSMutableArray *_arrayTempVideoInfo=[[NSMutableArray alloc] init];
	NSString *filePath =[self GetPath:pdfName];
	if(![[[MainDataArray objectAtIndex:SelectedDownloadEpub] objectForKey:@"pdf_videos"] isKindOfClass:[NSString class]]){
		for (int i=0;i<[[[MainDataArray objectAtIndex:SelectedDownloadEpub] objectForKey:@"pdf_videos"] count];i++){
			if([[[[[MainDataArray objectAtIndex:SelectedDownloadEpub] objectForKey:@"pdf_videos"]objectAtIndex:i]objectForKey:@"video_url"] length]>0){
				NSMutableDictionary *dictTemp=[[NSMutableDictionary alloc] init];
				NSString *_videoName=[NSString stringWithFormat:@"%@.mp4",[eEducationAppDelegate UniqueNameGeneratorFromUrl:[[[[MainDataArray objectAtIndex:SelectedDownloadEpub] objectForKey:@"pdf_videos"]objectAtIndex:i]objectForKey:@"video_url"]]];
				NSString *fileVideoPath=[self GetPath:_videoName];
				[dictTemp setObject:fileVideoPath forKey:@"video_url"];
				[dictTemp setObject:[[[[MainDataArray objectAtIndex:SelectedDownloadEpub] objectForKey:@"pdf_videos"]objectAtIndex:i]objectForKey:@"video_page"] forKey:@"video_page"];
				[dictTemp setObject:[[[[MainDataArray objectAtIndex:SelectedDownloadEpub] objectForKey:@"pdf_videos"]objectAtIndex:i]objectForKey:@"video_position"] forKey:@"video_position"];
				[_arrayTempVideoInfo addObject:dictTemp];
				[dictTemp release];
			}
		} 
	}
	
	ReaderDocument *document = [[ReaderDocument alloc]initWithFilePath:filePath password:nil dictVideoInfo:_arrayTempVideoInfo];
	if (document != nil) // Must have a valid ReaderDocument object in order to proceed
	{
		PlanTheStudies *objPlanTheStudies=[[PlanTheStudies alloc] initWithReaderDocument:document];
		objPlanTheStudies.Istype=@"ViewPDFreader";
		objPlanTheStudies.hidesBottomBarWhenPushed=YES;
		objPlanTheStudies.TitleOfPdfName=[[MainDataArray objectAtIndex:SelectedDownloadEpub] objectForKey:@"doc_name"];
		[self.navigationController pushViewController:objPlanTheStudies animated:YES];
		[objPlanTheStudies release];
	}
	else 
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
															message:[eEducationAppDelegate getLocalvalue:@"requested PDF not loaded properly."]
														   delegate:nil
												  cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]
												  otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
	[_arrayTempVideoInfo release];
	[document release];
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
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:errorMessage delegate:nil
											  cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
	[HUD hide:YES];
	[alertView show];
	[alertView release];
}

#pragma mark -
#pragma mark orientation Life Cycle
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload 
{
    [super viewDidUnload];
}

- (void)dealloc 
{
	[objParser release];objParser=nil;
	[BooksDataArray release];BooksDataArray=nil;
	[EpubsDataArray release];EpubsDataArray=nil;
	[MainDataArray release];MainDataArray=nil;
	[_videoData release];
	[_urlArray release];
	[objDownloadManger release];objDownloadManger=nil;
	[super dealloc];	
}
@end

