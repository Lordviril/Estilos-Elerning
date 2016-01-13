
#import "EpubReaderViewController.h"

@implementation EpubReaderViewController
@synthesize _ePubContent;
@synthesize _rootPath;
@synthesize _strEpubFilePath;
@synthesize _titleName;
#pragma mark -
#pragma mark View LIFECYCLE
- (void)viewDidLoad
{	
    [super viewDidLoad];
    [self hideAndShowController:YES];
	[_webview setBackgroundColor:[UIColor clearColor]];
	[_webview setScalesPageToFit:YES];
	_webview.userInteractionEnabled = YES;
    _webview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	//First unzip the epub file to documents directory
	[self unzipAndSaveFile];
	_xmlHandler=[[XMLHandler alloc] init];
	_xmlHandler.delegate=self;
	[_xmlHandler parseXMLFileAt:[self getRootFilePath]];
	for (UIView *view in _webview.subviews) 
	{
        if ([view isKindOfClass:[UIScrollView class]]) 
		{
            scrollview = (UIScrollView *) view;
			scrollview.minimumZoomScale=1.0f;
		    scrollview.maximumZoomScale=5.0f;
        }
    }
	UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] 
                                           initWithTarget:self 
										   action:@selector(handleSwipeLeft:)];
	swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
	[self.view addGestureRecognizer:swipeLeft];
	[swipeLeft release];
	firstTap=YES;
	UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] 
                                            initWithTarget:self 
											action:@selector(handleSwipeRight:)];
	swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
	[self.view addGestureRecognizer:swipeRight];
	[swipeRight release];
    
    UITapGestureRecognizer *SingleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    SingleTapOne.numberOfTouchesRequired=1;
    SingleTapOne.numberOfTapsRequired = 1; 
    SingleTapOne.delegate = self;
    [_webview addGestureRecognizer:SingleTapOne];
//    UITapGestureRecognizer *doubleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
//    doubleTapOne.numberOfTouchesRequired=1;
//    doubleTapOne.numberOfTapsRequired = 2; 
//    doubleTapOne.delegate = self;
//    [self.view addGestureRecognizer:doubleTapOne];
    [SingleTapOne release];
   // [doubleTapTwo release];
	[btn_back setImage:[eEducationAppDelegate GetLocalImage:@"btn-back"] forState:0];
	[btn_back setImage:[eEducationAppDelegate GetLocalImage:@"btn-back_h"] forState:1];
}

-(void)handleSwipeLeft:(UISwipeGestureRecognizer*)sender{
	if ([self._ePubContent._spine count]-1>_pageNumber) {
		
		_pageNumber++;
		[self loadPage];
	}
	[self updateNextPreviousButtons];
}

-(void)handleSwipeRight:(UISwipeGestureRecognizer*)sender{
	if (_pageNumber>0) {		
		_pageNumber--;
		[self loadPage];
	}
	[self updateNextPreviousButtons];	
}

- (void)viewWillAppear:(BOOL)animated
{
	[self updateNextPreviousButtons];
	self.navigationController.navigationBarHidden=YES;
    lbl_head.text=_titleName;
	[self willAnimateRotationToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0.2];
}

-(void) viewWillDisappear:(BOOL)animated
{
	self.navigationController.navigationBarHidden=NO;  	
}


/*Function Name : unzipAndSaveFile
 *Return Type   : void
 *Parameters    : nil
 *Purpose       : To unzip the epub file to documents directory
 */

- (void)unzipAndSaveFile{
	
	ZipArchive* za = [[ZipArchive alloc] init];
	if( [za UnzipOpenFile:_strEpubFilePath])
	{
		
		NSString *strPath=[NSString stringWithFormat:@"%@/UnzippedEpub",[self applicationDocumentsDirectory]];
		
		//Delete all the previous files
		NSFileManager *filemanager=[[NSFileManager alloc] init];
		if ([filemanager fileExistsAtPath:strPath]) 
		{
			[filemanager release];
			[za release];
			return;
		}
		[filemanager release];
		filemanager=nil;
		//start unzip
		BOOL ret = [za UnzipFileTo:[NSString stringWithFormat:@"%@/",strPath] overWrite:YES];
		if( NO==ret )
		{
			// error handler here
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle
														  message:[eEducationAppDelegate getLocalvalue:@"An unknown error occured"]
														 delegate:self
												cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]
												otherButtonTitles:nil];
			[alert show];
			[alert release];
			alert=nil;
		}
		[za UnzipCloseFile];
	}					
	[za release];
}

/*Function Name : applicationDocumentsDirectory
 *Return Type   : NSString - Returns the path to documents directory
 *Parameters    : nil
 *Purpose       : To find the path to documents directory
 */

- (NSString *)applicationDocumentsDirectory
{
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	basePath=[basePath stringByAppendingPathComponent:self._rootPath];
    return basePath;
}

/*Function Name : getRootFilePath
 *Return Type   : NSString - Returns the path to container.xml
 *Parameters    : nil
 *Purpose       : To find the path to container.xml.This file contains the file name which holds the epub informations
 */

- (NSString*)getRootFilePath
{
	
	//check whether root file path exists
	NSFileManager *filemanager=[[NSFileManager alloc] init];
	NSString *strFilePath=[NSString stringWithFormat:@"%@/UnzippedEpub/META-INF/container.xml",[self applicationDocumentsDirectory]];
	if ([filemanager fileExistsAtPath:strFilePath]) {
		
		//valid ePub
		
		[filemanager release];
		filemanager=nil;
		
		return strFilePath;
	}
	else 
	{
		
		//Invalid ePub file
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle
													  message:[eEducationAppDelegate getLocalvalue:@"Root File not Valid"]
													 delegate:self
											cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]
											otherButtonTitles:nil];
		[alert show];
		[alert release];
		alert=nil;
		
	}
	[filemanager release];
	filemanager=nil;
	return @"";
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	[self.navigationController popViewControllerAnimated:YES];
}
#pragma mark XMLHandler Delegate Methods

- (void)foundRootPath:(NSString*)rootPath
{
	
	//Found the path of *.opf file
	
	//get the full path of opf file
	NSString *strOpfFilePath=[NSString stringWithFormat:@"%@/UnzippedEpub/%@",[self applicationDocumentsDirectory],rootPath];
	NSFileManager *filemanager=[[NSFileManager alloc] init];
	
	self._rootPath=[strOpfFilePath stringByReplacingOccurrencesOfString:[strOpfFilePath lastPathComponent] withString:@""];
	
	if ([filemanager fileExistsAtPath:strOpfFilePath]) 
	{
		
		//Now start parse this file
		[_xmlHandler parseXMLFileAt:strOpfFilePath];
	}
	else
	{
		
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle
													  message:[eEducationAppDelegate getLocalvalue:@"OPF File not found"]
													 delegate:self
											cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]
											otherButtonTitles:nil];
		[alert show];
		[alert release];
		alert=nil;
	}
	[filemanager release];
	filemanager=nil;
	
}


- (void)finishedParsing:(EpubContent*)ePubContents
{
	
	_pagesPath=[NSString stringWithFormat:@"%@/%@",self._rootPath,[ePubContents._manifest valueForKey:[ePubContents._spine objectAtIndex:0]]];
	self._ePubContent=ePubContents;
	_pageNumber=0;
	[self loadPage];
}
#pragma mark -
#pragma mark Button Actions

- (IBAction)onPreviousOrNext:(id)sender
{
	UIButton *btnClicked=(UIButton*)sender;
	if (btnClicked.tag==99) {
		
		if (_pageNumber>0) {
			
			_pageNumber--;
			[self loadPage];
		}
		
	}
	else {
		
		if ([self._ePubContent._spine count]-1>_pageNumber) {
			
			_pageNumber++;
			[self loadPage];
		}
	}
	[self updateNextPreviousButtons];
}


- (IBAction)onBack:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)Btn_zoomInPressed:(id)sender
{	
	if((scrollview.contentSize.width > 768))
		[scrollview setZoomScale:scrollview.zoomScale-0.1 animated:YES];
	else
	{
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"You are reached minimum zoom level."] delegate:nil cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
		[alert show];
		[alert release];
		
	}
}
-(IBAction)Btn_zoomOutPressed:(id)sender
{
	if((scrollview.contentSize.width< 2688.000000))
		[scrollview setZoomScale:scrollview.zoomScale+0.1 animated:YES];
	else
	{
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"You are reached maximum zoom level."] delegate:nil cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
		[alert show];
		[alert release];
		
	}
}

- (void)loadPage
{
	//[_webview setContentMode:UIViewContentModeCenter];
	//[scrollview setContentSize:CGSizeZero];
	_pagesPath=[NSString stringWithFormat:@"%@/%@",self._rootPath,[self._ePubContent._manifest valueForKey:[self._ePubContent._spine objectAtIndex:_pageNumber]]];
	[_webview loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:_pagesPath]]];
	//set page number
	_pageNumberLbl.text=[NSString stringWithFormat:@"%d / %d",_pageNumber+1,[self._ePubContent._spine count]];
}

-(void)updateNextPreviousButtons
{
	btn_Left.enabled = (_pageNumber>0);
	btn_right.enabled = ([self._ePubContent._spine count]-1>_pageNumber);
}

#pragma mark -
#pragma mark WebView Delegate Methods
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSString* js = 
    @"var meta = document.createElement('meta'); " \
	"meta.setAttribute( 'name', 'viewport' ); " \
	"meta.setAttribute( 'content', 'width = device-width, initial-scale = 1.0,maximum-scale=3.5; user-scalable = no' ); " \
	"document.getElementsByTagName('head')[0].appendChild(meta)";
	
    [_webview stringByEvaluatingJavaScriptFromString: js];
}
#pragma mark -
#pragma mark  orientation LIFECYCLE

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	
	
	if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
	{
		btn_Left.frame=CGRectMake(5, 699, 50,49);
		btn_right.frame=CGRectMake(950, 699, 50,49);
		_pageNumberLbl.frame=CGRectMake(0, 699, 1024,49);
		img_background.frame=CGRectMake(0, 699, 1024, 49);
	}
	else 
	{
		btn_Left.frame=CGRectMake(5, 960, 57,49);
		btn_right.frame=CGRectMake(715, 960, 50,49);
		_pageNumberLbl.frame=CGRectMake(0, 960, 768,49);
		img_background.frame=CGRectMake(0, 960, 768, 49);
		
	}
	
}
-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}


#pragma mark -
#pragma mark Memory handlers

- (void)didReceiveMemoryWarning 
{
	
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
	
}
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{

    if (firstTap) {
        [self hideAndShowController:NO];
        firstTap=NO;
    }
    else{
        [self hideAndShowController:YES];
        firstTap=YES;
    }
}
//- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
//{
//	
//	switch (recognizer.numberOfTapsRequired) // Touches count
//	{
//		case 1: // One finger double tap: zoom ++
//		{
//			[self hideAndShowController:NO];
//		}
//			break;
//		case 2: // Two finger double tap: zoom --
//		{
//            [self hideAndShowController:YES];
//            NSLog(@"Double tap");
//			//[self zoomDecrement]; break;
//		}
//            break;
//	}
//	
//}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return YES;
}
- (void)hideAndShowController:(BOOL)Value
{
    if (Value) {
        [self fadeOut:_pageNumberLbl withDuration:1 andWait:0];
        [self fadeOut:btn_Left withDuration:1 andWait:0];
        [self fadeOut:btn_right withDuration:1 andWait:0];
        [self fadeOut:topImage withDuration:1 andWait:0];
        [self fadeOut:lbl_head withDuration:1 andWait:0];
        [self fadeOut:btn_zoomIn withDuration:1 andWait:0];
        [self fadeOut:btn_zoomOut withDuration:1 andWait:0];
        [self fadeOut:bottomImage withDuration:1 andWait:0];
        [self fadeOut:btn_back withDuration:1 andWait:0];

    }
    else{
        [self fadeIn:_pageNumberLbl withDuration:1 andWait:0];
        [self fadeIn:btn_Left withDuration:1 andWait:0];
        [self fadeIn:btn_right withDuration:1 andWait:0];
        [self fadeIn:topImage withDuration:1 andWait:0];
        [self fadeIn:lbl_head withDuration:1 andWait:0];
        [self fadeIn:btn_zoomIn withDuration:1 andWait:0];
        [self fadeIn:btn_zoomOut withDuration:1 andWait:0];
        [self fadeIn:bottomImage withDuration:1 andWait:0];
        [self fadeIn:btn_back withDuration:1 andWait:0];
         
    }
}
-(void)fadeOut:(UIView*)viewToDissolve withDuration:(NSTimeInterval)duration   andWait:(NSTimeInterval)wait
{
    [UIView beginAnimations: @"Fade Out" context:nil];
    
    // wait for time before begin
    [UIView setAnimationDelay:wait];
    
    // druation of animation
    [UIView setAnimationDuration:duration];
    viewToDissolve.alpha = 0.0;
    [UIView commitAnimations];
}

-(void)fadeIn:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration         andWait:(NSTimeInterval)wait
{
    [UIView beginAnimations: @"Fade In" context:nil];
    
    // wait for time before begin
    [UIView setAnimationDelay:wait];
    
    // druation of animation
    [UIView setAnimationDuration:duration];
    viewToFadeIn.alpha = 1;
    [UIView commitAnimations];
    
}
- (void)dealloc 
{
	[btn_Left release];
	btn_Left=nil;
	[btn_right release];
	btn_right=nil;
	[_webview release];
	_webview=nil;
	//[scrollview release];
	scrollview=nil;
	
	
	[_ePubContent release];
	_ePubContent=nil;
	
	_pagesPath=nil;
	_rootPath=nil;
	
	[_strEpubFilePath release];
	_strEpubFilePath=nil;
	
	[_backGroundImage release];
	_backGroundImage=nil;
	
    [super dealloc];
}

@end
