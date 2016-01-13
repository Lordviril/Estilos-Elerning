    //
//  DownloadedDocument.m
//  eEducation
//
//  Created by Hidden Brains on 11/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DownloadedDocument.h"
#import"DownloadedCustomCell.h"
#import"AttemptToTest.h"
#import"PracticeList.h"
#import "ReaderDocument.h"
#import "PlanTheStudies.h"
#import "SearchViewController.h"
#import "EpubReaderViewController.h"
#import "TestDetail.h"
@implementation DownloadedDocument

 

#pragma mark -
#pragma mark LoadView Method

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	documentArray = [[NSMutableArray alloc] initWithArray:[DataBase readAllDocumentDetais]];
	lbl_title.text=[eEducationAppDelegate getLocalvalue:@"Working offline"];
	[tblView setBackgroundView:nil];
	[tblView setBackgroundView:[[[UIView alloc] init] autorelease]];
	
	[tblView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[tblView setSeparatorColor:[UIColor clearColor]];

	if([documentArray count]>0)
	{
		[tblView reloadData];
	}
	else 
	{
		[tblView reloadData];
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"You haven't download any documents"] delegate:self	 cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	btnDownloadedDocument.selected = YES;
	btnAttemptTest.selected = NO;
}

-(IBAction)gohomeScreen:(id)sender{
	[self.navigationController popToViewController:[[self.navigationController viewControllers]objectAtIndex:1] animated:YES];
}
-(void) viewWillAppear:(BOOL)animated
{ 
	[self setLocalizedvalues];
   self.navigationController.navigationBarHidden=YES;
   [self willAnimateRotationToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0];
}

-(void) viewWillDisappear:(BOOL)animated
{
	self.navigationController.navigationBarHidden=NO;
}

-(void) setLocalizedvalues
{
	[btnDownloadedDocument setTitle:[eEducationAppDelegate getLocalvalue:@"DOWNLOADED DOCUMENTS"] forState:UIControlStateNormal];
	[btnDownloadedDocument setTitle:[eEducationAppDelegate getLocalvalue:@"DOWNLOADED DOCUMENTS"] forState:UIControlStateHighlighted];
	[btnAttemptTest setTitle:[eEducationAppDelegate getLocalvalue:@"ATTEMPT FOR TEST"] forState:UIControlStateNormal];
	[btnAttemptTest setTitle:[eEducationAppDelegate getLocalvalue:@"ATTEMPT FOR TEST"] forState:UIControlStateHighlighted];
}

-(IBAction)btnDownloadedDocument_Clicked:(id)sender
{
	
	isAttemptToTest=FALSE;
	lbl_title.text=[eEducationAppDelegate getLocalvalue:@"Working offline"];
	btnDownloadedDocument.selected = YES;
	btnAttemptTest.selected = NO;
	if(documentArray)
	{
		[documentArray release];
		documentArray=nil;
	}
	documentArray = [[NSMutableArray alloc] initWithArray:[DataBase readAllDocumentDetais]];
	if([documentArray count]>0)
	{
		[tblView reloadData];
	}
	else 
	{
		[tblView reloadData];
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"You haven't download any documents"] delegate:self	 cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}
-(IBAction)btnAttemptTest_Clicked:(id)sender
{
	isAttemptToTest=TRUE;
	lbl_title.text=[eEducationAppDelegate getLocalvalue:@"Test"];
	btnDownloadedDocument.selected = NO;
	btnAttemptTest.selected = YES;
	if(testArray)
	{
		[testArray release];
		testArray=nil;
	}
	testArray = [[NSMutableArray alloc] initWithArray:[DataBase readalltestDetails]];
	if([testArray count]>0)
		[tblView reloadData];
	else {
		[tblView reloadData];
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"You haven't download any test"] delegate:self	 cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
}
-(IBAction)btnSearchLogo_Clicked:(id)sender
{
	SearchViewController *_objSearch = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
	if(isAttemptToTest)
	{
		_objSearch.isAttemptToTest = YES;
	}
	else {
		_objSearch.isAttemptToTest = NO;
	}
	_objSearch.delegate = self;
	[self.navigationController pushViewController:_objSearch animated:YES];
	[_objSearch release];
}


-(IBAction)btnHome_Clicked:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}
-(void)getSearchAtrray:(NSArray *)ary_search docselected:(BOOL)yesOrNo
{
	if(yesOrNo)
	{
		btnDownloadedDocument.selected = YES;
		btnAttemptTest.selected = NO;
	}
	else {
		btnAttemptTest.selected = YES;
		btnDownloadedDocument.selected = NO;
	}

	if(btnDownloadedDocument.selected)
	{
		isAttemptToTest = NO;
		if(documentArray)
		{
			[documentArray release];
			documentArray=nil;
		}
		documentArray = [[NSMutableArray alloc] initWithArray:ary_search];
		if([documentArray count]>0)
		{
			[tblView reloadData];
		}
		else
		{
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"No document found with your search key"] delegate:self	 cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]  otherButtonTitles:nil];
			[alert show];
			alert.tag = 888;
			[alert release];
		}

	}
	else if(btnAttemptTest.selected) 
	{
		isAttemptToTest = YES;
		if(testArray)
		{
			[testArray release];
			testArray=nil;
		}
		testArray = [[NSMutableArray alloc] initWithArray:ary_search];
		if([testArray count]>0)
		{
			[tblView reloadData];
		}
		else
		{
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"No test found with your search key"] delegate:self	 cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]  otherButtonTitles:nil];
			[alert show];
			alert.tag = 888;
			[alert release];
			
		}

	}
	
}
#pragma mark -
#pragma mark tableView Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	if (isAttemptToTest) 
	{
		return [testArray count];
	}
	else
	{
		return [documentArray count];
	}

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	static NSString *CellIdentifier = @"mycell";
	DownloadedCustomCell *cell = (DownloadedCustomCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{	
		cell=[[[DownloadedCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		UIImageView*imgview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 734, 70)];
		imgview.image=[UIImage imageNamed:@"strip_f4.png" ];
		UIImageView*selimgview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 734, 70)];
		selimgview.image=[UIImage imageNamed:@"strip_f4_h.png" ];
		[cell setSelectedBackgroundView:selimgview];
		[selimgview release];
		cell.backgroundView = imgview;	
		[imgview release];
	}
	
	if (isAttemptToTest) 
	{
		
		cell.lblCourseName.text=[NSString stringWithFormat:@"%@ (%@)",[[testArray objectAtIndex:indexPath.section] objectForKey:@"course_name"],[[testArray objectAtIndex:indexPath.section] objectForKey:@"edition"]];
		cell.lblModuleName.text=[NSString stringWithFormat:@"%@",[[testArray objectAtIndex:indexPath.section] objectForKey:@"module_name"]];
		cell.lblDocName.text=[[testArray objectAtIndex:indexPath.section] objectForKey:@"test_name"];
		cell.lblType.text=@"";
		
	}
	else 
	{
		cell.lblCourseName.text=[[documentArray objectAtIndex:indexPath.section] objectForKey:@"course_name"];
		cell.lblModuleName.text=[[documentArray objectAtIndex:indexPath.section] objectForKey:@"module_name"];
		cell.lblDocName.text=[[documentArray objectAtIndex:indexPath.section] objectForKey:@"doc_name"];
		cell.lblType.text=[[documentArray objectAtIndex:indexPath.section] objectForKey:@"doc_type"];
	}
	//_indexPath=indexPath;
	cell.btnDelete.tag=indexPath.section;
	[cell.btnDelete setImage:[eEducationAppDelegate GetLocalImage:@"btn_delete"] forState:0];
	[cell.btnDelete addTarget:self action:@selector(deleteDownloadData:) forControlEvents:UIControlEventTouchUpInside];
	cell.backgroundColor=[UIColor clearColor];
	
return cell;
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (isAttemptToTest) 
	{
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isNetworkAvailble"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		TestDetail *objTestDetail=[[TestDetail alloc] initWithNibName:@"TestDetail" bundle:nil];
		objTestDetail.test_id = [[[testArray objectAtIndex:indexPath.section] objectForKey:@"test_id"] intValue];
		objTestDetail.edition_id = [[[testArray objectAtIndex:indexPath.section] objectForKey:@"editonid"] intValue];
		[self.navigationController pushViewController:objTestDetail animated:YES];
		[objTestDetail release];
	}
	else
	{
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isNetworkAvailble"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		if([[[documentArray objectAtIndex:indexPath.section] objectForKey:@"doc_type"] isEqualToString:@"PDF"])
			[self displayPDFDocumentView:indexPath.section];
		else 
		{
				
			[self DisplayTheEpubDocumentView:[self GetPath:[NSString stringWithFormat:@"%@.epub",[eEducationAppDelegate UniqueNameGeneratorFromUrl:[[documentArray objectAtIndex:indexPath.section] objectForKey:@"doc_url"]]] withType:@"EPUB"] titleName:[[documentArray objectAtIndex:indexPath.section] objectForKey:@"doc_name"] ];
		}
	}
}


-(IBAction)deleteDownloadData:(id)sender{
	UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:[eEducationAppDelegate getLocalvalue:@"Are you sure to delete data?"] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"YES"] otherButtonTitles:[eEducationAppDelegate getLocalvalue:@"NO"],nil];
	alert.tag=2221;
	[alert show];
	[alert release];
	UIButton *_tempBtn=sender;
	_indexPath=_tempBtn.tag ;
	if (isAttemptToTest) 
	{
		_delData_Id=[[[testArray objectAtIndex:_indexPath] objectForKey:@"test_id"] intValue];
	}else{
		_delData_Id=[[[documentArray objectAtIndex:_indexPath] objectForKey:@"doc_id"] intValue];
	}
}


-(NSMutableArray*)getVideoData:(NSData*)_tmpVideoData
{ 
	NSData *videoData=[[[NSData alloc] initWithData:_tmpVideoData] autorelease];
	NSMutableArray *video_infoArray= [[NSMutableArray alloc]initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:videoData]];
	return [video_infoArray autorelease];
}

-(void)displayPDFDocumentView:(int)index
{	
	pdfName=[NSString stringWithFormat:@"%@.pdf",[eEducationAppDelegate UniqueNameGeneratorFromUrl:[[documentArray objectAtIndex:index] objectForKey:@"doc_url"]]];
	NSString *filePath =[self GetPath:[NSString stringWithFormat:@"%@.pdf",[eEducationAppDelegate UniqueNameGeneratorFromUrl:[[documentArray objectAtIndex:index] objectForKey:@"doc_url"] ]] withType:(NSString *)[[documentArray objectAtIndex:index] objectForKey:@"doc_type"]];
	
	NSMutableArray *_arrayTempVideoInfo=[[NSMutableArray alloc] init];
	NSMutableArray *tempVideoArray = [self getVideoData:[[documentArray objectAtIndex:index]objectForKey:@"_videoData"]];
	for(int i=0;i<[tempVideoArray count];i++){
		NSMutableDictionary *dictTemp=[[NSMutableDictionary alloc] init];
		NSString *_videoName=[NSString stringWithFormat:@"%@.mp4",[eEducationAppDelegate UniqueNameGeneratorFromUrl:[[tempVideoArray objectAtIndex:i]objectForKey:@"video_url"]]];
		NSString *fileVideoPath=[self GetPath:_videoName withType:@"PDF"];
		[dictTemp setObject:fileVideoPath forKey:@"video_url"];
		[dictTemp setObject:[[tempVideoArray objectAtIndex:i]objectForKey:@"video_page"] forKey:@"video_page"];
		[dictTemp setObject:[[tempVideoArray objectAtIndex:i]objectForKey:@"video_position"] forKey:@"video_position"];
		[_arrayTempVideoInfo addObject:dictTemp];
		[dictTemp release];
	}
	
	ReaderDocument *document = [[ReaderDocument alloc]initWithFilePath:filePath password:nil dictVideoInfo:_arrayTempVideoInfo];
	if (document != nil) // Must have a valid ReaderDocument object in order to proceed
	{
		PlanTheStudies *objPlanTheStudies=[[PlanTheStudies alloc] initWithReaderDocument:document];
		objPlanTheStudies.Istype=@"ViewPDFreader";
		objPlanTheStudies.hidesBottomBarWhenPushed=YES;
		objPlanTheStudies.TitleOfPdfName=[[documentArray objectAtIndex:index] objectForKey:@"doc_name"];
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
-(NSString *) GetPath:(NSString *)Path withType:(NSString *)Type
{
	NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *pathString =[pathArray objectAtIndex:0];
	if([Type isEqualToString:@"PDF"]){
		pathString = [NSString stringWithFormat: @"/%@/PDFBOOKS/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], [[pdfName componentsSeparatedByString:@"."] objectAtIndex:0]];
		[[NSFileManager defaultManager] createDirectoryAtPath:pathString withIntermediateDirectories:NO attributes:NO error:nil];
	}
	else
	pathString=[pathString stringByAppendingPathComponent:@"EPUBBOOKS"];	
	if(![[NSFileManager defaultManager] fileExistsAtPath:pathString])
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:pathString withIntermediateDirectories:YES attributes:nil error:nil]; 
	}
	
	NSString *str=[pathString stringByAppendingPathComponent:Path];	
	return str;
}

-(NSString *) GetPath:(NSString *)Path
{
	NSString *pathString=@"";
	
	pathString = [NSString stringWithFormat: @"/%@/PDFBOOKS/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], [[Path componentsSeparatedByString:@"."] objectAtIndex:0]];
	[[NSFileManager defaultManager] createDirectoryAtPath:pathString withIntermediateDirectories:NO attributes:NO error:nil];
	
	if(![[NSFileManager defaultManager] fileExistsAtPath:pathString])
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:pathString withIntermediateDirectories:YES attributes:nil error:nil]; 
	}
	return pathString;
}


#pragma mark -
#pragma mark orientation Life Cycle

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		image_BackGround.frame=CGRectMake(0, 0, 768, 1004);
		btnDownloadedDocument.frame=CGRectMake(111, 48, 269, 45);
		btnAttemptTest.frame=CGRectMake(388, 48, 269, 45);
		btnSearch.frame=CGRectMake(727, 11, 24, 21);
		[tblView reloadData];
	}
	else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
	{
		image_BackGround.frame=CGRectMake(0, 0, 1024, 748);
		btnDownloadedDocument.frame=CGRectMake(240, 48, 269, 45);
		btnAttemptTest.frame=CGRectMake(517, 48, 269, 45);
		btnSearch.frame=CGRectMake(983, 11, 24, 21);
	    [tblView reloadData];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark -
#pragma mark UIAlertView delegate Method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag==888)
	{
		SearchViewController *_objSearch = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
		if(isAttemptToTest)
		{
			_objSearch.isAttemptToTest = YES;
		}
		else {
			_objSearch.isAttemptToTest = NO;
		}
		_objSearch.delegate = self;
		[self.navigationController pushViewController:_objSearch animated:YES];
		[_objSearch release];
	}else if(alertView.tag==2221){
		if(buttonIndex==0){
			if(isAttemptToTest){
				[DataBase deleteOfflineData:_delData_Id isAttemptTest:isAttemptToTest editionId:[[[testArray objectAtIndex:_indexPath] objectForKey:@"editonid"] intValue]];
				[testArray removeObjectAtIndex:_indexPath];
			}else{
				NSString *filePath=@"";
				NSFileManager *fileManager = [NSFileManager defaultManager];
				if([[[documentArray objectAtIndex:_indexPath] objectForKey:@"doc_type"] isEqualToString:@"PDF"]){
					filePath=[self GetPath:[NSString stringWithFormat:@"%@.pdf",[eEducationAppDelegate UniqueNameGeneratorFromUrl:[[documentArray objectAtIndex:_indexPath] objectForKey:@"doc_url"] ]]];					
				}
				else
				{
					
					filePath=[self GetPath:[NSString stringWithFormat:@"%@.epub",[eEducationAppDelegate UniqueNameGeneratorFromUrl:[[documentArray objectAtIndex:_indexPath] objectForKey:@"doc_url"]]] withType:@"EPUB"];
				}
				[fileManager removeItemAtPath:filePath error:NULL];
				[DataBase deleteOfflineData:_delData_Id isAttemptTest:isAttemptToTest editionId:0];
				[documentArray removeObjectAtIndex:_indexPath];				
			}


			[tblView reloadData];
		}
	}
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
	[documentArray release];
	[testArray release];
    [super dealloc];
}


@end
