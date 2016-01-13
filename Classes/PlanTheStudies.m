    //
//  PlanTheStudies.m
//  eEducation
//
//  Created by Hidden Brains on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlanTheStudies.h"
#import "ReaderScrollView.h"
#import "Settings.h"
#import "ICourseList.h"
#import "ModulesList.h"
#import "eEducationAppDelegate.h"
#import "ModuleHomePage.h"
 
 @implementation PlanTheStudies
 @synthesize Istype,TitleOfPdfName;
@synthesize objContentView = _objContentView;
BOOL isWillActive=NO;
 #pragma mark Constants
 
 #define PAGING_VIEWS 3
 
 #define TOOLBAR_HEIGHT 44.0f
 
 #define PAGING_AREA_WIDTH 24.0f
 
#pragma mark -
#pragma mark Support methods
 
 - (void)updateScrollViewContentSize
 {
	 NSInteger count = [document.pageCount integerValue];
	 
	 if (count > PAGING_VIEWS) count = PAGING_VIEWS; // Limit
	 
	 CGFloat contentHeight = theScrollView.bounds.size.height;
	 
	 CGFloat contentWidth = (theScrollView.bounds.size.width * count);
	 
	 theScrollView.contentSize = CGSizeMake(contentWidth, contentHeight);
 }
 
-(IBAction) btn_chapter1Pressed:(id)sender{
	[self.navigationController popViewControllerAnimated:YES];
}
 - (void)showDocumentPage:(NSInteger)page
 {
  
	 if (page != currentPage) // Only if different
	 {
		 NSInteger minValue; NSInteger maxValue;
		 NSInteger maxPage = [document.pageCount integerValue];
		 NSInteger minPage = 1;
		 if ((page < minPage) || (page > maxPage))
			 return;
		 
		 if (maxPage <= PAGING_VIEWS) // Few pages
		 {
			 minValue = minPage;
			 maxValue = maxPage;
		 }
		 else // Handle more pages
		 {
			 minValue = (page - 1);
			 maxValue = (page + 1);
			 
			 if ( minValue < minPage )
			 { 
				 minValue++; maxValue++;
			 }
			 else
			 if ( maxValue > maxPage )
			 {
				 minValue--; maxValue--;
			 }
		}
		 
		 CGRect viewRect = CGRectZero; viewRect.size = theScrollView.bounds.size;
		 
		 NSMutableDictionary *unusedViews = [[contentViews mutableCopy] autorelease];
		 
		 for (NSInteger number = minValue; number <= maxValue; number++)
		 {
			 NSNumber *key = [NSNumber numberWithInteger:number]; // # key
			 
			 ReaderContentView *contentView = [contentViews objectForKey:key];
			 contentView.delegate=self;
			 if (contentView == nil) // Create brand new content view
			 {
				 fileURL = document.fileURL; NSString *phrase = document.password; // Document properties
				 
				 contentView = [[ReaderContentView alloc] initWithFrame:viewRect fileURL:fileURL page:number password:phrase _videoInfo:[document _dictVideoInfo:number]];
				 
				 [theScrollView addSubview:contentView]; [contentViews setObject:contentView forKey:key];
				 
				 contentView.delegate = self; [contentView release];
			  }
			  else // Reposition the existing content view
			  {
				 contentView.frame = viewRect; [contentView zoomReset];
				 
				 [unusedViews removeObjectForKey:key];
			  }
			 viewRect.origin.x += viewRect.size.width;
		 }
		 
		 [unusedViews enumerateKeysAndObjectsUsingBlock: // Remove unused views
		 ^(id key, id object, BOOL *stop)
		 {
			 [contentViews removeObjectForKey:key];
			 
			 ReaderContentView *contentView = object;
			 contentView.delegate=self;
			 [contentView removeFromSuperview];
		 }
		 ];
		 
		 CGFloat viewWidthX1 = viewRect.size.width;
		 CGFloat viewWidthX2 = (viewWidthX1 * 2.0f);
		 
		 CGPoint contentOffset = CGPointZero;
		 
		 if (maxPage >= PAGING_VIEWS)
		 {
			 if (page == maxPage)
				 contentOffset.x = viewWidthX2;
		 else
			 if (page != minPage)
				 contentOffset.x = viewWidthX1;
		 }
		 else
			 if (page == (PAGING_VIEWS - 1))
				 contentOffset.x = viewWidthX1;
		 
		 if (CGPointEqualToPoint(theScrollView.contentOffset, contentOffset) == false)
		 {
			 theScrollView.contentOffset = contentOffset; // Update content offset
		 }
		 
		 if ([document.pageNumber integerValue] != page) // Only if different
		 {
			 document.pageNumber = [NSNumber numberWithInteger:page]; // Update it
		 }
		 [self updateBottomTitle]; // Update display
		 currentPage = page; // Track current page number
	 }
 }
 
 - (void)showDocument:(id)object
 {
	 [self updateScrollViewContentSize]; // Set content size
	 [self showDocumentPage:[document.pageNumber integerValue]]; // Show
	 document.lastOpen = [NSDate date]; // Update last opened date
	 isVisible = YES; // iOS present modal WTF bodge
 }
 
 #pragma mark UIViewController methods
 
 - (id)initWithReaderDocument:(ReaderDocument *)object
{
  id reader = nil; // ReaderViewController object
  if ((object != nil) && ([object isKindOfClass:[ReaderDocument class]]))
   {
	  if ((self = [super initWithNibName:@"PlanTheStudies" bundle:nil])) // Designated initializer
		{
		  document = [object retain]; // Retain the supplied ReaderDocument object for our use
		  reader = self; // Return an initialized ReaderViewController object
		}
	}
  return reader;
 }
 

- (void)viewDidLoad
{
#ifdef DEBUGX
	NSLog(@"%s %@", __FUNCTION__, NSStringFromCGRect(self.view.bounds));
#endif
	[super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceRotated:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
	[btn_courses setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"course_name"] forState:UIControlStateNormal];
	[btn_courses1 setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"course_name"] forState:UIControlStateNormal];
	[btn_Module1 setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"module_name"] forState:UIControlStateNormal];
	[BackBtn setImage:[eEducationAppDelegate GetLocalImage:@"btn_back_white@2x"] forState:0];
	[BackBtn setImage:[eEducationAppDelegate GetLocalImage:@"btn_back_white@2x"] forState:1];
	if([Istype isEqualToString:@"PlanTheStudies"])
	{
		btn_settings.hidden=YES;
		btn_chapter1.hidden=YES;
		btn_Module1.hidden=YES;
		btn_courses1.hidden=YES;
		lbl_head.text=[[eEducationAppDelegate getLocalvalue:@"View StudyPlans"] uppercaseString];
		//[btn_PlanDeStudies setImage:[UIImage imageNamed:@"bnt_carriculumn.png"] forState:0];
		[btn_PlanDeStudies setTitle:[eEducationAppDelegate getLocalvalue:@"CURRICULAM"] forState:UIControlStateNormal];
	}
	else if([Istype isEqualToString:@"bibilography"])
	{
		btn_settings.hidden=YES;
		btn_chapter1.hidden=YES;
		btn_Module1.hidden=YES;
		btn_courses1.hidden=YES;
		
		lbl_head.text=[[eEducationAppDelegate getLocalvalue:@"Bibliography"] uppercaseString];
		[btn_PlanDeStudies setTitle:[eEducationAppDelegate getLocalvalue:@"Bibliography"] forState:UIControlStateNormal];
	}
	else if([Istype isEqualToString:@"CHAPTERS"])
	{
		btn_settings.hidden=YES;
		btn_chapter1.hidden=YES;
		btn_Module1.hidden=YES;
		btn_courses1.hidden=YES;
		btn_ZoomPlus.frame=CGRectMake(699, 7, 30, 30);
		btn_Zoomminus.frame=CGRectMake(667, 7, 30, 30);
		btn_settings.frame=CGRectMake(731, 7, 30, 30);
		lbl_head.text=[[[NSUserDefaults standardUserDefaults] objectForKey:@"DocumentName"] uppercaseString];// [eEducationAppDelegate getLocalvalue:@" "];
		[btn_chapter1 setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"chapter_name"] forState:UIControlStateNormal];

		
	}else if([Istype isEqualToString:@"Practice"])
	{
		btn_courses.hidden=YES;
		btn_PlanDeStudies.hidden=YES;
		btn_ZoomPlus.frame=CGRectMake(669, 7, 30, 30);
		btn_Zoomminus.frame=CGRectMake(667, 7, 30, 30);
		btn_settings.frame=CGRectMake(731, 7, 30, 30);
		
		lbl_head.text=[[[NSUserDefaults standardUserDefaults] objectForKey:@"DocumentName"] uppercaseString];
		btn_Module1.hidden=NO;
	//	btn_PlanDeStudies
		[btn_chapter1 setTitle:[[NSUserDefaults standardUserDefaults]objectForKey:@"practice_name"] forState:0];
		
	}
	else if([Istype isEqualToString:@"ViewPDFreader"])
	{
		btn_courses.hidden=YES;
		btn_PlanDeStudies.hidden=YES;
		btn_settings.hidden=YES;
		btn_chapter1.hidden=YES;
		btn_Module1.hidden=YES;
		btn_courses1.hidden=YES;
		imgSegment.hidden=YES;
		lbl_head.text=[TitleOfPdfName uppercaseString];
		imglogo.hidden=YES;
		BackBtn.hidden=NO;
		imgBottom.hidden=NO;
		btn_pre.hidden=NO;
		btn_next.hidden=NO;
		lblTitle.hidden=NO;
	}
    [self HideAndShowController:YES];
	[self updateBottomTitle];
	assert(document != nil);
	assert(self.splitViewController == nil); // Not supported (sorry)
	self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
	UITapGestureRecognizer *singleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
	singleTapOne.numberOfTouchesRequired = 1; singleTapOne.numberOfTapsRequired = 1; singleTapOne.delegate = self;
	
	contentViews = [NSMutableDictionary new]; lastHideTime = [NSDate new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.btnBack setTitle:[eEducationAppDelegate getLocalvalue:@"BackAtrás"] forState:UIControlStateNormal];
	self.navigationController.navigationBarHidden=YES;
	self.navigationItem.hidesBackButton=YES;
    isFirstTime=YES;
	[super viewWillAppear:animated];
    [self willAnimateRotationToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0.2];
}

- (void)viewDidAppear:(BOOL)animated
{
#ifdef DEBUGX
	NSLog(@"%s %@", __FUNCTION__, NSStringFromCGRect(self.view.bounds));
#endif
	
	[super viewDidAppear:animated];
	
	if (CGSizeEqualToSize(theScrollView.contentSize, CGSizeZero)) // First time
	{
		[self performSelector:@selector(showDocument:) withObject:nil afterDelay:0.0];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.backgroundColor = [UIColor clearColor];
	self.navigationController.navigationBarHidden=NO;

#ifdef DEBUGX
	NSLog(@"%s %@", __FUNCTION__, NSStringFromCGRect(self.view.bounds));
#endif
	
	[super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];

}

- (void)viewDidDisappear:(BOOL)animated
{
#ifdef DEBUGX
	NSLog(@"%s %@", __FUNCTION__, NSStringFromCGRect(self.view.bounds));
#endif
	[super viewDidDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];   
}

- (void)viewDidUnload
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
	
	
	[theScrollView release], theScrollView = nil; [contentViews release], contentViews = nil;
	
	[lastHideTime release], lastHideTime = nil; currentPage = 0;
	
	[super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}

#pragma mark -
#pragma mark Action Methods
-(IBAction) BackBtnPressed:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btn_prePressed:(id)sender
{
   [self decrementPageNumber];
	
}

-(IBAction)btn_nextPressed:(id)sender
{
	 [self incrementPageNumber];
}

-(IBAction)btn_settingsPressed:(id)sender
{
	Settings *objSettings=[[Settings alloc] initWithNibName:@"Settings" bundle:nil];
	[self.navigationController pushViewController:objSettings animated:NO];
	[objSettings release];
}

-(IBAction) btn_courses1Pressed:(id)sender
{
	NSArray *viewContrlls=[[self navigationController] viewControllers];
	for( int i=0;i<[ viewContrlls count];i++)
	{
		id obj=[viewContrlls objectAtIndex:i];
		if([obj isKindOfClass:[ModulesList class]] )
		{
			[[self navigationController] popToViewController:obj animated:YES];
			return;
		}
	}
	
}

-(IBAction) btn_Module1Pressed:(id)sender
{
	NSArray *viewContrlls=[[self navigationController] viewControllers];
	for( int i=0;i<[ viewContrlls count];i++)
	{
		id obj=[viewContrlls objectAtIndex:i];
		if([obj isKindOfClass:[ModuleHomePage class]])
		{
			[[self navigationController] popToViewController:obj animated:YES];
			return;
		}
	}
}

-(IBAction)btn_coursesPressed:(id) sender{

	[self.navigationController popViewControllerAnimated:YES];

}

-(IBAction)btn_ZoomPlusPressed:(id)sender
{
	NSInteger page = [document.pageNumber integerValue]; // Current page #
	
	NSNumber *key = [NSNumber numberWithInteger:page]; // Page number key
	
	ReaderContentView *targetView = [contentViews objectForKey:key];
    targetView.delegate = self;
	[targetView zoomIncrement];
		
	
}
-(IBAction)btn_ZoomminusPressed:(id)sender
{
	
	NSInteger page = [document.pageNumber integerValue]; // Current page #
	
	NSNumber *key = [NSNumber numberWithInteger:page]; // Page number key
	
	ReaderContentView *targetView = [contentViews objectForKey:key];
    targetView.delegate = self;
	[targetView zoomDecrement];	
	
}
-(IBAction)btn_PlanDeStudiesPressed:(id)sender
{
	[self.navigationController popViewControllerAnimated:TRUE];
}
#pragma mark -
#pragma mark orientation lifeCycle

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
	
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
	{
		imgBackground.frame=CGRectMake(0,0,1024,748);
		imgBottom .frame=CGRectMake(0, 699, 1024, 49);
		Imgtopbar.frame=CGRectMake(0,0,1024,44);
		lblTitle.frame=CGRectMake(0,699,1024,49);
		[btn_pre setFrame:CGRectMake(10,699, 64,49)];
		[btn_next setFrame:CGRectMake(980, 699,64,49)];
        if(!imgSegment.hidden)
		{
		
		theScrollView.frame=CGRectMake(3, -2, 1018, 752);
		}
		else
		{
			theScrollView.frame=CGRectMake(3, -2, 1018, 752);
		}
		btn_courses.frame=CGRectMake(328, 49, 179, 45);
		btn_PlanDeStudies.frame=CGRectMake(517, 49, 179, 45);
		
		lbl_head.frame=CGRectMake(0, 0, 1024, 44);

		if(!btn_Module1.hidden)
		{
		btn_chapter1.frame=CGRectMake(626, 48, 149, 45);
		btn_courses1.frame=CGRectMake(308, 48, 149, 45);
		btn_Module1.frame=CGRectMake(467, 48, 149, 45);
		}
		else 
		{
		btn_courses1.frame=CGRectMake(329, 48, 179, 45);
		btn_chapter1.frame=CGRectMake(516, 48, 179, 45);
		}
		if(!btn_settings.hidden)
		{
			btn_Zoomminus.frame=CGRectMake(918, 7, 30, 30);
			btn_ZoomPlus.frame=CGRectMake(951, 7, 30, 30);
			btn_settings.frame=CGRectMake(983, 7, 30, 30);	
		}
		else
		{
			btn_Zoomminus.frame=CGRectMake(948, 7, 30, 30);
			btn_ZoomPlus.frame=CGRectMake(981, 7, 30, 30);			
		}		
	}
	else if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown || interfaceOrientation == UIInterfaceOrientationPortrait)
	{			
		imgBackground.frame = CGRectMake(0, 0, 768, 1004);
		imgBottom.frame=CGRectMake(0, 955, 768, 49);
		Imgtopbar.frame=CGRectMake(0,0,768,44);
	    lblTitle.frame=CGRectMake(0,955,768,49);
		[btn_pre setFrame:CGRectMake(10, 955, 64, 49)];
		[btn_next setFrame:CGRectMake(682, 955, 64, 49)];
		btn_courses.frame=CGRectMake(200, 49, 179, 45);
		btn_PlanDeStudies.frame=CGRectMake(388, 49, 179, 45);
		btn_ZoomPlus.frame=CGRectMake(700, 11, 25, 25);
		btn_Zoomminus.frame=CGRectMake(670, 11, 25, 25);
		btn_settings.frame=CGRectMake(730, 11, 25, 25);
		lbl_head.frame=CGRectMake(0, 0,768, 44);
		if(!imgSegment.hidden)
		theScrollView.frame=CGRectMake(3, 0, 762, 1004);
		else
		theScrollView.frame=CGRectMake(3, 0, 762, 1004);
		if(!btn_Module1.hidden)
		{
			btn_chapter1.frame=CGRectMake(467, 48, 149, 45);
			btn_courses1.frame=CGRectMake(151, 48, 149, 45);
			btn_Module1.frame=CGRectMake(310, 48, 149, 45);		
		}
		else 
		{
			btn_chapter1.frame=CGRectMake(387, 48, 179, 45);
			btn_courses1.frame=CGRectMake(200, 48, 179, 45);
		}
		if(!btn_settings.hidden)
		{
            btn_ZoomPlus.frame=CGRectMake(699, 7, 30, 30);
            btn_Zoomminus.frame=CGRectMake(667, 7, 30, 30);
            btn_settings.frame=CGRectMake(731, 7, 30, 30);	
			
		}
		else
		{
			btn_Zoomminus.frame=CGRectMake(700, 7, 30, 30);
			btn_ZoomPlus.frame=CGRectMake(733, 7, 30, 30);
			
		}
		
		
	}
	
	if (isVisible == NO) return; // iOS present modal WTF bodge
	
	[self updateScrollViewContentSize]; // Update the content size
	
	NSMutableIndexSet *pageSet = [[NSMutableIndexSet new] autorelease];
	
	[contentViews enumerateKeysAndObjectsUsingBlock: // Enumerate content views
	 ^(id key, id object, BOOL *stop)
	 {
		 ReaderContentView *contentView = object;
		 contentView.delegate=self;
		 [pageSet addIndex:contentView.tag];
	 }
	 ];
	
	__block CGRect viewRect = CGRectZero; viewRect.size = theScrollView.bounds.size;
	
	__block CGPoint contentOffset = CGPointZero; NSInteger page = [document.pageNumber integerValue];
	
	[pageSet enumerateIndexesUsingBlock: // Enumerate page number set
	 ^(NSUInteger number, BOOL *stop)
	 {
		 NSNumber *key = [NSNumber numberWithInteger:number]; // # key
		 
		 ReaderContentView *contentView = [contentViews objectForKey:key];
		 contentView.delegate=self;
		 contentView.frame = viewRect; if (page == number) contentOffset = viewRect.origin;
		 
		 viewRect.origin.x += viewRect.size.width; // Next view frame position
	 }
	 ];
	if (CGPointEqualToPoint(theScrollView.contentOffset, contentOffset) == false)
	{
		theScrollView.contentOffset = contentOffset; // Update content offset
	}
	
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
#ifdef DEBUGX
	NSLog(@"%s %@ (%d to %d)", __FUNCTION__, NSStringFromCGRect(self.view.bounds), fromInterfaceOrientation, self.interfaceOrientation);
#endif
	
}

- (void)deviceRotated:(NSNotification *)notification {
    if (!isWillActive) {
        [self willAnimateRotationToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0.2];
    }isWillActive=NO;
}


- (void)didReceiveMemoryWarning
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
	
	[super didReceiveMemoryWarning];
}

- (void)dealloc
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
	
	[theScrollView release], theScrollView = nil; [contentViews release], contentViews = nil;
	
	[lastHideTime release], lastHideTime = nil; [document release], document = nil;
	
	[super dealloc];
}

#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
	
	__block NSInteger page = 0;
	
	CGFloat contentOffsetX = scrollView.contentOffset.x;
	
	[contentViews enumerateKeysAndObjectsUsingBlock: // Enumerate content views
	 ^(id key, id object, BOOL *stop)
	 {
		 ReaderContentView *contentView = object;
		 contentView.delegate=self;
		 if (contentView.frame.origin.x == contentOffsetX)
		 {
			 page = contentView.tag; *stop = YES;
		 }
	 }
	 ];
	
	if (page != 0) [self showDocumentPage:page]; // Show the page
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
	
	[self showDocumentPage:theScrollView.tag]; // Show page
	
	theScrollView.tag = 0; // Clear page number tag
}

- (void)scrollViewTouchesBegan:(UIScrollView *)scrollView touches:(NSSet *)touches
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
		if (touches.count == 1) // Single touches only
		{
			UITouch *touch = [touches anyObject]; // Touch info
			
			CGPoint point = [touch locationInView:self.view]; // Location
			
			CGRect areaRect = CGRectInset(self.view.bounds, PAGING_AREA_WIDTH, TOOLBAR_HEIGHT);
			
			if (CGRectContainsPoint(areaRect, point) == false) return;
		}
		[lastHideTime release]; lastHideTime = [NSDate new];
	
}

#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)recognizer shouldReceiveTouch:(UITouch *)touch
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
	
	if ([touch.view isMemberOfClass:[UIScrollView class]]) return YES;
	
	return NO;
}

#pragma mark UIGestureRecognizer action methods
-(void) updateBottomTitle
{
	
	NSInteger page = [document.pageNumber integerValue];
	NSInteger maxPage = [document.pageCount integerValue];
	lblTitle.text=[NSString stringWithFormat:@"%d/%d",page,maxPage];
	if(page==1 && maxPage==1){            //condition for when we have only one page then next button is disable(from hb tester)
		btn_pre.enabled=NO;
		btn_next.enabled=NO;
	}
	else if(page==1)
	{
		btn_pre.enabled=NO;
		btn_next.enabled=YES;
	}
	else if(page==maxPage)
	{
		btn_pre.enabled=YES;
		btn_next.enabled=NO;

	}
	else
	{
		btn_pre.enabled=YES;
		btn_next.enabled=YES;
	}

}
- (void)decrementPageNumber
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
	
	if (theScrollView.tag == 0) // Scroll view did end
	{
		NSInteger page = [document.pageNumber integerValue];
		NSInteger maxPage = [document.pageCount integerValue];
	    
		 NSInteger minPage = 1; // Minimum
		
		if ((maxPage > minPage) && (page != minPage))
		{
			CGPoint contentOffset = theScrollView.contentOffset;
			
			contentOffset.x -= theScrollView.bounds.size.width; // -= 1
			
			[theScrollView setContentOffset:contentOffset animated:YES];
			
			theScrollView.tag = (page - 1); // Decrement page number
			lblTitle.text=[NSString stringWithFormat:@"%d/%d",page-1,maxPage];
			if(page-1==1)
			{
				btn_pre.enabled=YES;
				btn_next.enabled=NO;
				
			}else {
				btn_pre.enabled=YES;
				btn_next.enabled=YES;
				
			}
			
			

		}
	}
}

- (void)incrementPageNumber
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
	
	if (theScrollView.tag == 0) // Scroll view did end
	{
		NSInteger page = [document.pageNumber integerValue];
		NSInteger maxPage = [document.pageCount integerValue];
	   
		NSInteger minPage = 1; // Minimum
		
		if ((maxPage > minPage) && (page != maxPage))
		{
			CGPoint contentOffset = theScrollView.contentOffset;
			
			contentOffset.x += theScrollView.bounds.size.width; // += 1
			
			[theScrollView setContentOffset:contentOffset animated:YES];
			
			theScrollView.tag = (page + 1); // Increment page number
			lblTitle.text=[NSString stringWithFormat:@"%d/%d",page+1,maxPage];
            if(page+1==maxPage)
			{
				btn_pre.enabled=YES;
				btn_next.enabled=NO;				
			}else {
				btn_pre.enabled=YES;
				btn_next.enabled=YES;
			}			
		}
	}
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
	
	if (recognizer.state == UIGestureRecognizerStateRecognized)
	{
		CGRect viewRect = recognizer.view.bounds; // View bounds
		
		CGPoint point = [recognizer locationInView:recognizer.view];
		
		CGRect areaRect = CGRectInset(viewRect, PAGING_AREA_WIDTH, 0.0f);
		
		if (CGRectContainsPoint(areaRect, point)) // Single tap is inside the area
		{
			NSInteger page = [document.pageNumber integerValue]; // Current page #
			
			NSNumber *key = [NSNumber numberWithInteger:page]; // Page number key
			
			ReaderContentView *targetView = [contentViews objectForKey:key];
			targetView.delegate=self;
			id target = [targetView singleTap:recognizer]; // Process tap
			
			if (target != nil) // Handle the returned target object
			{
				if ([target isKindOfClass:[NSURL class]]) // Open a URL
				{
					[[UIApplication sharedApplication] openURL:target];
				}
				else // Not a URL, so check for other possible object type
				{
					if ([target isKindOfClass:[NSNumber class]]) // Goto page
					{
						NSInteger value = [target integerValue]; // Number
						
						[self showDocumentPage:value]; // Show the page
					}
				}
			}
			else // Nothing active tapped in the target content view
			{
			}
			
			return;
		}
		
	}
}

#pragma mark-HideAndShowController
- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
	
	switch (recognizer.numberOfTapsRequired) // Touches count
	{
		case 1: // One finger double tap: zoom ++
		{
			[self HideAndShowController:YES];
		}
			break;
		case 2: // Two finger double tap: zoom --
		{
             [self HideAndShowController:NO];
		}
            break;
	}
	
}
- (void)touchHandler:(int)TapCount
{
    if(TapCount==2)
    {
        [self HideAndShowController:YES];
    }else
    {
        [self HideAndShowController:NO];
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
- (void)HideAndShowController:(BOOL)value
{
    if (value) {
        [self fadeOut:Imgtopbar withDuration:1 andWait:0];
        [self fadeOut:imgBottom withDuration:1 andWait:0];
        [self fadeOut:imgSegment withDuration:1 andWait:0];
        [self fadeOut:imgBottom withDuration:1 andWait:0];
        [self fadeOut:lbl_head withDuration:1 andWait:0];
        [self fadeOut:btn_ZoomPlus withDuration:1 andWait:0];
        [self fadeOut:btn_Zoomminus withDuration:1 andWait:0];
        [self fadeOut:btn_courses withDuration:1 andWait:0];
        [self fadeOut:btn_PlanDeStudies withDuration:1 andWait:0];
        [self fadeOut:btn_pre withDuration:1 andWait:0];
        [self fadeOut:btn_Module1 withDuration:1 andWait:0];
        [self fadeOut:btn_chapter1 withDuration:1 andWait:0];
        [self fadeOut:btn_next withDuration:1 andWait:0];
        [self fadeOut:BackBtn withDuration:1 andWait:0];
        [self fadeOut:lblTitle withDuration:1 andWait:0];
        [self fadeOut:self.btnBack withDuration:1 andWait:0];
    }
    else{
        [self fadeIn:Imgtopbar withDuration:1 andWait:0];
        [self fadeIn:imgBottom withDuration:1 andWait:0];
        [self fadeIn:imgSegment withDuration:1 andWait:0];
        [self fadeIn:imgBottom withDuration:1 andWait:0];
        [self fadeIn:lbl_head withDuration:1 andWait:0];
        [self fadeIn:btn_ZoomPlus withDuration:1 andWait:0];
        [self fadeIn:btn_Zoomminus withDuration:1 andWait:0];
        [self fadeIn:btn_courses withDuration:1 andWait:0];
        [self fadeIn:btn_PlanDeStudies withDuration:1 andWait:0];
        [self fadeIn:btn_pre withDuration:1 andWait:0];
        [self fadeIn:btn_Module1 withDuration:1 andWait:0];
        [self fadeIn:btn_chapter1 withDuration:1 andWait:0];
        [self fadeIn:btn_next withDuration:1 andWait:0];
        [self fadeIn:BackBtn withDuration:1 andWait:0]; 
        [self fadeIn:lblTitle withDuration:1 andWait:0];    
        [self fadeIn:self.btnBack withDuration:1 andWait:0];
    }
    if([Istype isEqualToString:@"PlanTheStudies"])
	{
        if (value) {
            [self fadeOut:imglogo withDuration:1 andWait:0];
        }
        else{
            [self fadeIn:imglogo withDuration:1 andWait:0];
        }
		btn_settings.hidden=YES;
		btn_chapter1.hidden=YES;
		btn_Module1.hidden=YES;
		btn_courses1.hidden=YES;
	}
	else if([Istype isEqualToString:@"bibilography"])
	{
        if (value) {
            [self fadeOut:imglogo withDuration:1 andWait:0];
        }
        else{
            [self fadeIn:imglogo withDuration:1 andWait:0];
        }
		btn_settings.hidden=YES;
		btn_chapter1.hidden=YES;
		btn_Module1.hidden=YES;
		btn_courses1.hidden=YES;		
	}
	else if([Istype isEqualToString:@"CHAPTERS"])
	{
        if (value) {
            [self fadeOut:btn_courses1 withDuration:1 andWait:0];
            [self fadeOut:btn_settings withDuration:1 andWait:0];
            [self fadeOut:imglogo withDuration:1 andWait:0];
        }
        else{
            [self fadeIn:btn_courses1 withDuration:1 andWait:0];
            [self fadeIn:btn_settings withDuration:1 andWait:0];
            [self fadeIn:imglogo withDuration:1 andWait:0];
        }
		btn_courses.hidden=YES;
		btn_PlanDeStudies.hidden=YES;        
		
	}else if([Istype isEqualToString:@"Practice"])
	{
		btn_courses.hidden=YES;
		btn_PlanDeStudies.hidden=YES;
		btn_Module1.hidden=NO;		
	}
	else if([Istype isEqualToString:@"ViewPDFreader"])
	{
		btn_courses.hidden=YES;
		btn_PlanDeStudies.hidden=YES;
		btn_settings.hidden=YES;
		btn_chapter1.hidden=YES;
		btn_Module1.hidden=YES;
		btn_courses1.hidden=YES;
		imgSegment.hidden=YES;
        imglogo.hidden=YES;
	}

}

@end

