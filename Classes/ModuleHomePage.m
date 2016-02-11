//
//  ModuleHomePage.m
//  eEducation
//
//  Created by Hidden Brains on 11/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ModuleHomePage.h"
#import <QuartzCore/QuartzCore.h>
#import "ICourseList.h"
#import "PlanTheStudies.h"
#import "ModulesList.h"
#import"Message.h"
#import"Calender.h"
#import"Forum.h"
#import"Alert.h"
#import"VirtualLibrary.h"
#import "LoginScreen.h"
#import "ChapterDetails.h"
#import"AttemptToTest.h"
#import "YouTubePlayer.h"
#import "PracticeList.h"
#import "TestDetail.h"
#import "GMGridViewLayoutStrategies.h"

#define PRACTICE_RTLABLE @"<font face=HelveticaNeue-Bold size=19 color='#ffffff'>%@: </font><font face='HelveticaNeue' size=16 color='#ffffff'>%@</font>"
#define RESULT_RTLABLE @"<font face=HelveticaNeue size=16 color='#ffffff'>%@: </font><font face='HelveticaNeue-Bold' size=16 color='#ffffff'>%@</font>"

#define NUMBER_OF_COURSES ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 10: 12)
#define ITEM_SPACING 150
#define USE_BUTTONS YES

#define RTChaptersTitle @"<font face=HelveticaNeue-Bold size=17 color='#ffffff'>%i </font><font face='HelveticaNeue-Bold' size=17 color='#0d323b'>%@</font>"
#define RTTitle @"<font face=HelveticaNeue-Bold size=17 color='#ffffff'>%i </font><font face='HelveticaNeue-Bold' size=17 color='#9f9f9f'>%@</font>"

@implementation ModuleHomePage
@synthesize connection = _connection;

- (void)dealloc
{
    [self releaseObjects];
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
    [self setUpGridView:self.gridChapters];
    [self setUpGridView:self.gridPractices];
    [self setUpGridView:self.gridTest];
    [self setUpGridView:self.gridVideos];
    [self setUpGridView:self.gridTeachers];
    [self setUpPaging];
    
	appDelegate=(eEducationAppDelegate *)[[UIApplication sharedApplication]delegate];
    [self.btnModulesDropDown setTitle:[[NSUserDefaults standardUserDefaults] valueForKey:@"module_name"]forState:UIControlStateNormal];
    
	objParser = [[JSONParser alloc] init];
	objParser.delegate = self;
    [self callModulesList];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:YES];
    [self.lblTopCourse setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"course_name"]];
    [self.lblTopDuration setText:[NSString stringWithFormat:RTLableText,[eEducationAppDelegate getLocalvalue:@"Begins "],[eEducationAppDelegate convertString:[[NSUserDefaults standardUserDefaults] valueForKey:@"edition_start"] fromFormate:@"yyyy-MM-dd" toFormate:@"dd MMMM yyyy"],[eEducationAppDelegate getLocalvalue:@"- Ends "],[eEducationAppDelegate convertString:[[NSUserDefaults standardUserDefaults] valueForKey:@"edition_end"] fromFormate:@"yyyy-MM-dd" toFormate:@"dd MMMM yyyy"]]];

    self.lblProfileBlueName.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_name"];
    self.lblProfileGrayName.text = [eEducationAppDelegate getLocalvalue:@"WELCOME"];
    [self.imgProfile loadImageFromURL:[NSURL URLWithString:[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_profile_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:@"no-image-200x200.png"];
    
    [self.imgLogo loadImageFromURL:[eEducationAppDelegate getTopCourseUrl] imageName:@"top-bar-logo.png"];
    [self.imgLogoStatic loadImageFromURL:[eEducationAppDelegate getTopStaticUrl] imageName:@"logo_top_static.png"];
    
	[self setLocalizedText];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self dealloc];
}

- (void)viewWillDisappear:(BOOL)animated{
}

#pragma mark - Webservices call
-(void)callModulesList{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	HUD.labelText=[eEducationAppDelegate getLocalvalue:@"Please wait"];
	objParser = [[JSONParser alloc] init];
	objParser.delegate = self;
	NSString *strURL =[WebService getCoursedetailsURL];
	NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"course_id"] ,@"course_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language",
								 nil];    
	[objParser sendRequestToParse:strURL params:requestData];
    strURL = nil;
}

-(void)callChaptersWS{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	HUD.labelText=[eEducationAppDelegate getLocalvalue:@"Please wait"];
    
	NSString *strURL = [WebService getChapterListURL];
	NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"module_id"], @"module_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language",
								 nil];
	[objParser sendRequestToParse:strURL params:requestData];
    strURL = nil;
}

-(void)callTeachersWS{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	HUD.labelText=[eEducationAppDelegate getLocalvalue:@"Please wait"];
    
	NSString *strURL = [WebService getTeachersURL];
	NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"module_id"], @"module_id",
								 nil];
	[objParser sendRequestToParse:strURL params:requestData];
    strURL = nil;
}
-(void)callVideosWS{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText=[eEducationAppDelegate getLocalvalue:@"Please wait"];
    
    NSString *strURL = [WebService GetChapterVideoListXml];
    NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"module_id"], @"module_id",
                                 [[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language",
								 nil];
    [objParser sendRequestToParse:strURL params:requestData];
    strURL = nil;
}
-(void)callPracticesWS{
    NSString *strStatus =[self.btnPractStatus titleForState:0];
    if ([strStatus isEqualToString:@"EVALUADAS"]) {
        strStatus = @"EVALUATED";
    }
    if ([strStatus isEqualToString:@"DISPONIBLES"]) {
        strStatus = @"AVAILABLE";
    }
    if ([strStatus isEqualToString:@"REALIZADAS"]) {
        strStatus = @"DONE";
    }

    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[HUD setLabelText:[eEducationAppDelegate getLocalvalue:@"Please wait"]];
	[HUD show:YES];
    
	NSString *strURL =[WebService getPracticelistURL];
	NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] ,@"user_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"module_id"], @"module_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"course_id"],@"course_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"editonid"],@"edition_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language",
                                 strStatus,@"evolution_status",
								 nil];
	[objParser sendRequestToParse:strURL params:requestData];
    strURL = nil;
}

-(void)callTestWS{
    NSString *strStatus =[self.btnTestStatus titleForState:0];
    if ([strStatus isEqualToString:@"EVALUADOS"]) {
        strStatus = @"EVALUATED";
    }
    if ([strStatus isEqualToString:@"DISPONIBLES"]) {
        strStatus = @"AVAILABLE";
    }
    if ([strStatus isEqualToString:@"REALIZADOS"]) {
        strStatus = @"DONE";
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[HUD setLabelText:[eEducationAppDelegate getLocalvalue:@"Please wait"]];
	[HUD show:YES];
	NSString *strURL =[WebService getexamlistURL];
	NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] ,@"user_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"module_id"], @"module_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"course_id"],@"course_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"editonid"],@"edition_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language",
                                 strStatus,@"test_status",
								 nil];
	[objParser sendRequestToParse:strURL params:requestData];
    strURL = nil;
}

-(void)callStartExamWS{
    isReqForExam = YES;
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[HUD setLabelText:[eEducationAppDelegate getLocalvalue:@"Please wait"]];
	[HUD show:YES];

    NSString *strURL =[WebService getdownloadexamURL];
	NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] ,@"user_id",
								 [self.dictSelctedTest valueForKey:@"test_id"], @"test_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language", nil];
	[objParser sendRequestToParse:strURL params:requestData];
    strURL=nil;
}

-(void)callResultsWS{
    isReqForResult = YES;
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[HUD setLabelText:[eEducationAppDelegate getLocalvalue:@"Please wait"]];
	[HUD show:YES];
    
    NSMutableArray *arrPast = [self.dictSelctedTest valueForKey:@"getpastexamlist"];
    if ([arrPast isKindOfClass:[NSMutableArray class]] && arrPast.count>0 && [[arrPast objectAtIndex:(arrPast.count-1)] isKindOfClass:[NSMutableDictionary class]]) {
        self.dictPastExamDetails = [[NSMutableDictionary alloc] initWithDictionary:[arrPast objectAtIndex:(arrPast.count-1)]];
    }
    
    NSString *strURL =[WebService getpasttestdetailURL];
    NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:
								 [self.dictSelctedTest objectForKey:@"test_id"], @"test_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"], @"user_id",
                                 [self.dictPastExamDetails valueForKey:@"studentreport_id"], @"student_report_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language",
								 nil];
	[objParser sendRequestToParse:strURL params:requestData];
    strURL=nil;
}

-(void)callPostAnswersWS
{
	HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[HUD setLabelText:[eEducationAppDelegate getLocalvalue:@"Please wait"]];
	[HUD show:YES];
	objParser = [[JSONParser alloc] init];
	objParser.delegate = self;
	questionDetail *objquestionDetail=[[[questionDetail alloc] init] autorelease];
	objquestionDetail.delegate=self;
	objquestionDetail.test_id=[[self.dictSelctedTest valueForKey:@"test_id"] integerValue];
	objquestionDetail.arrayQuestions=ExamQuesArray;
	objquestionDetail.dictTestDetail=self.dictSelctedTest;
	NSString *remainingattempt = [NSString stringWithFormat:@"%d", ([[self.dictSelctedTest valueForKey:@"totattempt"] intValue] - [[self.dictSelctedTest valueForKey:@"attemptedcnt"] intValue]) - 1];
	objquestionDetail.remainingattempt = remainingattempt;
	[objquestionDetail SubmitAnswer];
}

#pragma mark - Setup gridView And Paging
/**
 *  Sets UI for all paging indecators
 */
-(void)setUpPaging{
    [self.pcChapters removeFromSuperview];
    self.pcChapters= (UIPageControl *)[[SMPageControl alloc] initWithFrame:self.pcChapters.frame];
    [self.pcChapters addTarget:self action:@selector(btnPageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.scrlView addSubview:self.pcChapters];
    self.pcChapters.pageIndicatorTintColor = [UIColor colorWithRed:0.339 green:0.772 blue:0.914 alpha:0.800];
    self.pcChapters.currentPageIndicatorTintColor = [UIColor colorWithRed:0.000 green:0.658 blue:1.000 alpha:1.000];

    [self.pcPractices removeFromSuperview];
    self.pcPractices= (UIPageControl *)[[SMPageControl alloc] initWithFrame:self.pcPractices.frame];
    [self.pcPractices addTarget:self action:@selector(btnPageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.scrlView addSubview:self.pcPractices];
    self.pcPractices.pageIndicatorTintColor = [UIColor colorWithRed:0.339 green:0.772 blue:0.914 alpha:0.800];
    self.pcPractices.currentPageIndicatorTintColor = [UIColor colorWithRed:0.000 green:0.658 blue:1.000 alpha:1.000];

    [self.pcTest removeFromSuperview];
    self.pcTest= (UIPageControl *)[[SMPageControl alloc] initWithFrame:self.pcTest.frame];
    [self.pcTest addTarget:self action:@selector(btnPageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.scrlView addSubview:self.pcTest];
    self.pcTest.pageIndicatorTintColor = [UIColor colorWithRed:0.339 green:0.772 blue:0.914 alpha:0.800];
    self.pcTest.currentPageIndicatorTintColor = [UIColor colorWithRed:0.000 green:0.658 blue:1.000 alpha:1.000];

    [self.pcVideos removeFromSuperview];
    self.pcVideos= (UIPageControl *)[[SMPageControl alloc] initWithFrame:self.pcVideos.frame];
    [self.pcVideos addTarget:self action:@selector(btnPageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.scrlView addSubview:self.pcVideos];
    self.pcVideos.pageIndicatorTintColor = [UIColor colorWithRed:0.339 green:0.772 blue:0.914 alpha:0.800];
    self.pcVideos.currentPageIndicatorTintColor = [UIColor colorWithRed:0.000 green:0.658 blue:1.000 alpha:1.000];

    [self.pcTeacher removeFromSuperview];
    self.pcTeacher= (UIPageControl *)[[SMPageControl alloc] initWithFrame:self.pcTeacher.frame];
    [self.pcTeacher addTarget:self action:@selector(btnPageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.scrlView addSubview:self.pcTeacher];
    self.pcTeacher.pageIndicatorTintColor = [UIColor colorWithRed:0.507 green:0.519 blue:0.514 alpha:1.000];
    self.pcTeacher.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.919 alpha:1.000];
}

/**
 *  Set UI for all GridViews
 *
 *  @param gridView GridView object
 */
-(void)setUpGridView:(GMGridView*)gridView{
    gridView.minEdgeInsets = UIEdgeInsetsMake(5,0, 5, 0);
    gridView.style = GMGridViewStyleSwap;
    gridView.itemSpacing = 0;
    gridView.centerGrid = NO;
    gridView.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutHorizontalPagedLTR];
    gridView.pagingEnabled = YES;
    gridView.showsHorizontalScrollIndicator = NO;
    gridView.showsVerticalScrollIndicator = NO;
    gridView.clipsToBounds = YES;
    gridView.dataSource = self;
    gridView.delegate = self;
    gridView.actionDelegate = self;
    gridView.editing = NO;
    gridView.centerGrid = YES;
}

/**
 *  Update Timer while answering questions
 */
- (void)updateTimer
{
	NSDate *currentDate = [NSDate date];
	NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:startDt];
	NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
	[dateFormatter setDateFormat:@"HH:mm:ss"];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
	NSString *timeString=[dateFormatter stringFromDate:timerDate];
	self.lblTimer.text = timeString;
    
	[dateFormatter release];dateFormatter=nil;
    timerDate=nil;
    currentDate=nil;
    timeString=nil;
}

-(void)currenttime
{
	startDt = [[NSDate date]retain];
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

#pragma mark - SliderMethods
/**
 *  Opens slide with animation
 *
 *  @param viewToBeOpen Object of the UIView which to be opened
 */
-(void)openSlideView :(UIView*)viewToBeOpen{
    viewToBeOpen.frame = CGRectMake (self.view.frame.size.width, 92, viewToBeOpen.frame.size.width, viewToBeOpen.frame.size.height);
    [self.view addSubview:viewToBeOpen];
    
    [UIView animateWithDuration :0.5 delay:0 options:UIViewAnimationCurveLinear
                     animations	:^{
                         viewToBeOpen.frame = CGRectMake (0, 92, viewToBeOpen.frame.size.width, viewToBeOpen.frame.size.height);
                     }
                     completion	:^(BOOL finished) {
                         if (finished)
                         {
                             self.opendView = viewToBeOpen;
                         }
                     }
     ];
}

/**
 *  Closes slide with animation
 *
 *  @param viewToBeOpen Object of the UIView which to be closed
 */
-(void)closeSlideView : (UIView*)viewToBeClosed{
    viewToBeClosed.frame = CGRectMake (0, 92, viewToBeClosed.frame.size.width, viewToBeClosed.frame.size.height);
    
    [UIView animateWithDuration :0.5 delay:0 options:UIViewAnimationCurveLinear
                     animations	:^{
                         viewToBeClosed.frame = CGRectMake (self.view.frame.size.width, 92, viewToBeClosed.frame.size.width, viewToBeClosed.frame.size.height);
                     }
                     completion	:^(BOOL finished) {
                         if (finished)
                         {
                             if (viewToBeClosed == self.viewQue) {
                                 IsModulesListLoaded = YES;
                                 isPracticesLoaded = YES;
                                 IsCompletedChapterListing = YES;
                                 isTestsLoaded = YES;
                                 isTestsLoaded = NO;
                                 isVideosLoaded = YES;
                                 [self callTestWS];
                             }
                         }
                     }
     ];
}

/**
 *  Toggle the Ques slides while exam is going on with animation
 *
 *  @param view1 Object of the View to be opened
 *  @param view2 Object of the View to be closed
 */
-(void)toggelQuesSlideClicked:(UIView*)view1 :(UIView*)view2{
    [self.view addSubview:view1];
    view1.frame = CGRectMake (0, 92, view1.frame.size.width, view1.frame.size.height);
    view2.frame = CGRectMake (self.view.frame.size.width, 92, view2.frame.size.width, view2.frame.size.height);
    [self.view addSubview:view2];
    [UIView animateWithDuration :1 delay:0 options:UIViewAnimationCurveLinear
                     animations	:^{
                         view1.frame = CGRectMake (self.view.frame.size.width, 92, view1.frame.size.width, view1.frame.size.height);
                         view2.frame = CGRectMake (0, 92, view2.frame.size.width, view2.frame.size.height);
                     }
                     completion	:^(BOOL finished) {
                         if (finished)
                         {
                             [view1 removeFromSuperview];
                             self.opendView = view2;
                             if ([[self.btnTestStatus titleForState:0] isEqualToString:@"EVALUADAS"] || [[self.btnTestStatus titleForState:0] isEqualToString:@"EVALUATED"]) {
                             } else {
                                 if (questionNo == 0) {
                                     [self refreshView:questionNo];
                                 }
                             }
                         }
                     }
     ];
}

/**
 *  Toggle the Ques slides while checking the results on with animation
 *
 *  @param view1 Object of the View to be opened
 *  @param view2 Object of the View to be closed
 */
-(void)toggelSlideClicked:(UIView*)view1 :(UIView*)view2{
    
    view1.frame = CGRectMake (0, 92, view1.frame.size.width, view1.frame.size.height);
    view2.frame = CGRectMake (self.view.frame.size.width, 92, view2.frame.size.width, view2.frame.size.height);
    [self.view addSubview:view2];
    [UIView animateWithDuration :1 delay:0 options:UIViewAnimationCurveLinear
                     animations	:^{
                         view1.frame = CGRectMake (self.view.frame.size.width, 92, view1.frame.size.width, view1.frame.size.height);
                         view2.frame = CGRectMake (0, 92, view2.frame.size.width, view2.frame.size.height);
                     }
                     completion	:^(BOOL finished) {
                         if (finished)
                         {
                             [view1 removeFromSuperview];
                             self.opendView = view2;
                         }
                     }
     ];
}

#pragma mark - Slider loading methods
/**
 *  Refresh the view after clicking next or prev buttons
 *
 *  @param QuestionNumber index of the Question 
 */
-(void) refreshAnsView:(int)QuestionNumber
{
    [self.lblTestTitleAnsSlide setText:[self.dictPastExamDetails valueForKey:@"test_name"]];
    [self.lblTimeSpent setText:[NSString stringWithFormat:RESULT_RTLABLE,[eEducationAppDelegate getLocalvalue:@"Time Spent: "],[self.dictPastExamDetails valueForKey:@"taken_duration"]]];
    [self.lblRating setText:[NSString stringWithFormat:RESULT_RTLABLE,[eEducationAppDelegate getLocalvalue:@"Rating: "],[self.dictPastExamDetails valueForKey:@"user_score"]]];
    [self.lblMarks setText:[NSString stringWithFormat:RESULT_RTLABLE,[eEducationAppDelegate getLocalvalue:@"Marks: "],[self.dictPastExamDetails valueForKey:@"marks_achieved"]]];
    
	if(QuestionNumber<[ResultArray count])
	{
		NSMutableDictionary *dic_temp = [[NSMutableDictionary alloc] initWithDictionary:[ResultArray objectAtIndex:QuestionNumber]];
        [self.lblAnswerdQues setText:[NSString stringWithFormat:@"%i. %@",QuestionNumber+1,[dic_temp objectForKey:@"question"]]];
        self.lblAnswerdQues.frame = CGRectMake(50, 110, 480, [eEducationAppDelegate getLableHeight:self.lblAnswerdQues]);
		[self showOptionsForAns:[dic_temp objectForKey:@"answers"] :[dic_temp objectForKey:@"answersid"]];
        
		NSArray *user_answers = [[NSArray alloc] initWithArray:[[dic_temp objectForKey:@"user_answer"] componentsSeparatedByString:@","]];
		NSArray *actual_answers = [[NSArray alloc] initWithArray:[[dic_temp objectForKey:@"correct_answer"] componentsSeparatedByString:@","]];
        
        if (user_answers.count > 1 || actual_answers.count > 1) {
            int userGivenOptionsID = -1;
            for(int iCount = 0; iCount < [user_answers count]; iCount++)
            {
                NSString *strAns = [user_answers objectAtIndex:iCount];
                userGivenOptionsID = [[[strAns componentsSeparatedByString:@"||"] objectAtIndex:0] integerValue];
                if ([actual_answers containsObject:strAns]) {
                    if (iCount==0)
                        [self showActualAns:userGivenOptionsID :[dic_temp valueForKey:@"score"]];
                    else
                        [self showActualAns:userGivenOptionsID :@""];
                } else {
                    if (iCount==0)
                        [self showWrongAns:userGivenOptionsID :[dic_temp valueForKey:@"score"]];
                    else
                        [self showWrongAns:userGivenOptionsID :@""];
                }
                strAns=nil;
            }            
        } else {
            int userGivenOptionsID = -1;
            int actualOptionsID = -1;
            
            if([user_answers count]>0)
            {
                for(int iCount = 0; iCount < [user_answers count]; iCount++)
                {
                    NSString *strAns = [user_answers objectAtIndex:iCount];
                    userGivenOptionsID = [[[strAns componentsSeparatedByString:@"||"] objectAtIndex:0] integerValue];
                    strAns=nil;
                }
            }
            if([actual_answers count]>0)
            {
                for(int iCount = 0; iCount < [actual_answers count]; iCount++)
                {
                    NSString *strAns = [actual_answers objectAtIndex:iCount];
                    actualOptionsID = [[[strAns componentsSeparatedByString:@"||"] objectAtIndex:0] integerValue];
                    strAns=nil;
                }
            }
            
            if (actualOptionsID == userGivenOptionsID) { // Taking first object
                [self showActualAns:userGivenOptionsID :[dic_temp valueForKey:@"score"]];
            } else {
                [self showActualAns:actualOptionsID :@""];
                [self showWrongAns:userGivenOptionsID :[dic_temp valueForKey:@"score"]];
            }
        }
        
		self.lblAnswerdQues.text = [NSString stringWithFormat:@"%i. %@",QuestionNumber+1,[dic_temp objectForKey:@"question"]];
		NSString *_localString = [[[eEducationAppDelegate getLocalvalue:[[dic_temp objectForKey:@"question_type"] capitalizedString]]stringByAppendingString:@" "] stringByAppendingString:[eEducationAppDelegate getLocalvalue:@"Selection"]];
		if ([[[dic_temp objectForKey:@"question_type"] capitalizedString]isEqualToString:@"Single"])
		{
			NSString *strNew = [[[[dic_temp objectForKey:@"question_type"] capitalizedString]stringByAppendingString:@" "] stringByAppendingString:@"Selection"];
			_localString = [eEducationAppDelegate getLocalvalue:strNew];
            strNew = nil;
		}
        dic_temp=nil;
        _localString= nil;
        [actual_answers release];actual_answers=nil;
        [user_answers release];user_answers=nil;
    }
    self.btAnsnPrev.enabled = (questionNo > 0);
	self.btnAnsNext.enabled = (questionNo < ResultArray.count-1);
}

/**
 *  Loads all options for the question
 *
 *  @param dicText Dictionary of the options
 *  @param ansIds  Ids of the question seperated by comma
 */
-(void)showOptionsForAns:(NSString *)dicText :(NSString*)ansIds
{
//    float Y = [self getHeight:self.lblAnswerdQues];
    float Y = CGRectGetMaxY(self.lblAnswerdQues.frame);
//    self.lblAnswerdQues.frame = CGRectMake(50, 110, 507, Y);
	for (UIView *vwTemp in self.viewAnsViewInnerSlide.subviews)
	{
        if (vwTemp != self.lblTimeSpent && vwTemp != self.imgAnsInnerView && vwTemp != self.lblMarks && vwTemp != self.lblRating && vwTemp != self.lblAnswerdQues) {
            [vwTemp removeFromSuperview];
        }
	}
	NSArray *arCount = [dicText componentsSeparatedByString:@"@@"];
    NSArray *arCountId = [ansIds componentsSeparatedByString:@","];
	UILabel *lblOption;
    UIImageView *imgTick;
	float lblX = 110;
	float lblY = Y+30;
    float boxY = lblY;
	for (int i =0; i < [arCount count]; i++)
	{
        imgTick = [[UIImageView alloc] initWithFrame:CGRectMake(lblX-25, lblY, 20, 18)];
        imgTick.image = [UIImage imageNamed:@"icon_right_s5D@2x.png"];
        imgTick.highlightedImage = [UIImage imageNamed:@"icon_wrong_s5D@2x.png"];
        imgTick.tag = [[arCountId objectAtIndex:i] integerValue];
        imgTick.hidden = YES;
		[self.viewAnsViewInnerSlide addSubview:imgTick];

		lblOption = [[UILabel alloc] initWithFrame:CGRectMake(lblX, lblY, 370, 20)];
        lblOption.numberOfLines = 0;
        lblOption.lineBreakMode = NSLineBreakByWordWrapping;
		lblOption.text = [[dicText componentsSeparatedByString:@"@@"] objectAtIndex:i];
		lblOption.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        float h = [eEducationAppDelegate getLableHeight:lblOption];
        lblOption.frame = CGRectMake(lblX, lblY, 370, h);
        lblOption.textColor = [UIColor whiteColor];
        lblOption.tag =  [[arCountId objectAtIndex:i] integerValue];
		lblOption.backgroundColor = [UIColor clearColor];
		[self.viewAnsViewInnerSlide addSubview:lblOption];
        
        lblY = lblY + h + 10;
	}
    imgTick = [[UIImageView alloc] initWithFrame:CGRectMake(lblX-50, boxY-10, 450, lblY-boxY+10)];
//    imgTick.backgroundColor = [UIColor greenColor];
//    imgTick.contentMode = UIViewContentModeScaleToFill;
//    imgTick.image = [UIImage imageNamed:@"input-box_s5D@2x.png"];
    [self.viewAnsViewInnerSlide addSubview:imgTick];
    
    imgTick.layer.borderColor = [UIColor whiteColor].CGColor;
    imgTick.layer.borderWidth = 2;
    imgTick.layer.cornerRadius = 10;
    
    self.viewAnsViewInnerSlide.frame = CGRectMake(136, 108, 511, lblY+35);
    self.imgAnsInnerView.image = [UIImage imageNamed:@"box_s5C_bottom@2x.png"];
    self.btAnsnPrev.frame = CGRectMake(self.btAnsnPrev.frame.origin.x, lblY+160, self.btAnsnPrev.frame.size.width, self.btAnsnPrev.frame.size.height);
    self.btnAnsNext.frame = CGRectMake(self.btnAnsNext.frame.origin.x, lblY+160, self.btnAnsNext.frame.size.width, self.btnAnsNext.frame.size.height);
    arCount=nil;
    arCountId=nil;    
}

/**
 *  Loads actual ans and wrong answers with marks
 *
 *  @param ans   Actula Answer tag
 *  @param marks Marks for that Question
 */
-(void)showActualAns:(int)ans :(NSString*)marks
{
	for (UIImageView *btnTemp in self.viewAnsViewInnerSlide.subviews)
	{
		if ([btnTemp isKindOfClass:[UIImageView class]])
		{
            if (btnTemp.tag == ans) {
                btnTemp.hidden = NO;
                btnTemp.highlighted = NO;
            }
		}
        if ([btnTemp isKindOfClass:[UILabel class]] && ![marks isEqualToString:@""])
		{
            if (btnTemp.tag == ans) {
                UILabel *lbl = (UILabel*)btnTemp;
                lbl.text = [NSString stringWithFormat:@"> %@ (%@)",lbl.text,marks];
                lbl=nil;
            }
		}
        btnTemp=nil;
	}
}

/**
 *  Loads wrong answer with marks
 *
 *  @param ans   Wrong ans ID
 *  @param marks Marks for the question
 */
-(void)showWrongAns:(int)ans :(NSString*)marks
{
	for (UIImageView *btnTemp in self.viewAnsViewInnerSlide.subviews)
	{
		if ([btnTemp isKindOfClass:[UIImageView class]])
		{
            if (btnTemp.tag == ans) {
                btnTemp.hidden = NO;
                btnTemp.highlighted = YES;
            }
		}
        if ([btnTemp isKindOfClass:[UILabel class]] && ![marks isEqualToString:@""])
		{
            if (btnTemp.tag == ans) {
                UILabel *lbl = (UILabel*)btnTemp;
                lbl.text = [NSString stringWithFormat:@"> %@ (%@)",lbl.text,marks];
                lbl=nil;
            }
		}
        btnTemp=nil;
	}
}

/**
 *  Refresh view
 *
 *  @param QuestionNumber Index of the question number
 */
-(void) refreshView:(int)QuestionNumber
{
    self.lblTestNameQuesSlide.text = [self.dictSelctedTest valueForKey:@"test_name"];
	if(QuestionNumber<[ExamQuesArray count])
	{
		NSMutableDictionary *dic_temp = [[NSMutableDictionary alloc] initWithDictionary:[ExamQuesArray objectAtIndex:QuestionNumber]];
        self.lblQues.text = [NSString stringWithFormat:@"%i. %@",QuestionNumber+1,[dic_temp objectForKey:@"question"]];
        self.lblQues.frame = CGRectMake(29, 4, 507, [eEducationAppDelegate getLableHeight:self.lblQues]);
        
		[self noOfOptionsNew:[dic_temp objectForKey:@"options"]];
		NSArray *array_answers = [[NSArray alloc] initWithArray:[[[ExamQuesArray objectAtIndex:QuestionNumber] objectForKey:@"Answer"] componentsSeparatedByString:@"@@"]];
		if([array_answers count]>0)
		{
			for(int iCount = 0; iCount < [array_answers count]; iCount++)
			{
				NSString *strAns = [array_answers objectAtIndex:iCount];
				NSArray *arOptionsID = [[dic_temp objectForKey:@"optionsid"] componentsSeparatedByString:@","];
				NSString *strObj = [[strAns componentsSeparatedByString:@"||"] objectAtIndex:0];
				for (int i = 0; i <[arOptionsID count]; i++)
				{
					NSString *strTemp = [[NSString stringWithFormat:@"%@", [arOptionsID objectAtIndex:i]] stringByReplacingOccurrencesOfString:@"," withString:@""];
					if ([strTemp isEqualToString:strObj])
					{
						[self tickAnswer:i];
						break;
					}
				}
			}
		}
		[array_answers release];
		array_answers=nil;
		self.lblQues.text = [NSString stringWithFormat:@"%i. %@",QuestionNumber+1,[dic_temp objectForKey:@"question"]];
		NSString *_localString = [[[eEducationAppDelegate getLocalvalue:[[dic_temp objectForKey:@"question_type"] capitalizedString]]stringByAppendingString:@" "] stringByAppendingString:[eEducationAppDelegate getLocalvalue:@"Selection"]];
		if ([[[dic_temp objectForKey:@"question_type"] capitalizedString]isEqualToString:@"Single"])
		{
			NSString *strNew = [[[[dic_temp objectForKey:@"question_type"] capitalizedString]stringByAppendingString:@" "] stringByAppendingString:@"Selection"];
			_localString = [eEducationAppDelegate getLocalvalue:strNew];
            strNew=nil;
		}
        _localString=nil;
		[dic_temp release];
		dic_temp = nil;
	}
	[self updateNextAndPrevious];
}

/**
 *  Enable or Desable Next and Prev buttons
 */
-(void)updateNextAndPrevious
{
	self.btnQueBack.enabled = (questionNo > 0);
	self.btnNext.enabled = (questionNo < ExamQuesArray.count-1);
}

/**
 *  Shows Tick mark as it is correct answer
 *
 *  @param tick index of actula answer
 */
-(void)tickAnswer:(int)tick
{
	for (UIButton *btnTemp in self.viewQuesInnerView.subviews)
	{
		if ([btnTemp isKindOfClass:[UIButton class]] && btnTemp.tag == tick)
		{
			btnTemp.selected = TRUE;
			[btnTemp setImage:[UIImage imageNamed:@"radio_in@2x.png"] forState:UIControlStateNormal];            
			break;
		}
        btnTemp=nil;
	}
}

/**
 *  Load options
 *
 *  @param dicText Dictionary object
 */
-(void)noOfOptionsNew:(NSString *)dicText
{
    float Y = [self getHeight:self.lblQues];
    self.lblQues.frame = CGRectMake(29, 10, 507, Y);
	for (UIView *vwTemp in self.viewQuesInnerView.subviews)
	{
        if (vwTemp != self.lblQues && vwTemp != self.imgQuesInnerView) {
            [vwTemp removeFromSuperview];
        }
	}
	NSArray *arCount = [dicText componentsSeparatedByString:@"@@"];
	UIButton *btnOption;
	UILabel *lblOption;
	float lblX = 60;
	float lblY = CGRectGetMaxY(self.lblQues.frame)+25;
	float latestHeight = 0;
	
	for (int i =0; i < [arCount count]; i++)
	{
		lblOption = [[UILabel alloc] initWithFrame:CGRectMake(lblX, lblY, 465, 20)];
        lblOption.numberOfLines = 0;
        lblOption.lineBreakMode = NSLineBreakByWordWrapping;
		lblOption.text = [[dicText componentsSeparatedByString:@"@@"] objectAtIndex:i];
		lblOption.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
        float height = [eEducationAppDelegate getLableHeight:lblOption];
        lblOption.frame = CGRectMake(lblX, lblY, 465, height);
        lblOption.textColor = [UIColor whiteColor];
        lblOption.tag =  [[arCount objectAtIndex:i] integerValue];
		lblOption.backgroundColor = [UIColor clearColor];
		[self.viewQuesInnerView addSubview:lblOption];
        
        btnOption = [UIButton buttonWithType:UIButtonTypeCustom];
        btnOption.frame = CGRectMake(lblX-45, lblY, 465, 22);
        [btnOption.imageView setContentMode:UIViewContentModeScaleAspectFit];
		[btnOption setImage:[UIImage imageNamed:@"radio@2x.png"] forState:UIControlStateNormal];
        [btnOption setImage:[UIImage imageNamed:@"radio@2x.png"] forState:UIControlStateHighlighted];
		[btnOption setImage:[UIImage imageNamed:@"radio_in@2x.png"] forState:UIControlStateSelected];
		[btnOption setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        btnOption.adjustsImageWhenHighlighted = NO;
		[btnOption setTag:i];
		[btnOption addTarget:self action:@selector(btnOptions_Clicked:) forControlEvents:UIControlEventTouchUpInside];
		[self.viewQuesInnerView addSubview:btnOption];

        lblY = lblY + height + 10;
	}
    latestHeight = lblY - 25;
    self.viewQuesInnerView.frame = CGRectMake(134, 108, 512, latestHeight+35);
    self.imgQuesInnerView.image = [UIImage imageNamed:@"box_s5C_bottom@2x.png"];
    self.btnQueBack.frame = CGRectMake(self.btnQueBack.frame.origin.x, latestHeight+180, self.btnQueBack.frame.size.width, self.btnQueBack.frame.size.height);
    self.btnReply.frame = CGRectMake(self.btnReply.frame.origin.x, latestHeight+180, self.btnReply.frame.size.width, self.btnReply.frame.size.height);
    self.btnNext.frame = CGRectMake(self.btnNext.frame.origin.x, latestHeight+180, self.btnNext.frame.size.width, self.btnNext.frame.size.height);
    arCount=nil;
    btnOption=nil;
    lblOption=nil;
}

-(void)noOfOptions:(NSString *)dicText
{
    float Y = [self getHeight:self.lblQues];
    self.lblQues.frame = CGRectMake(29, 10, 507, Y);
	for (UIView *vwTemp in self.viewQuesInnerView.subviews)
	{
        if (vwTemp != self.lblQues && vwTemp != self.imgQuesInnerView) {
            [vwTemp removeFromSuperview];
        }
	}
	NSArray *arCount = [dicText componentsSeparatedByString:@"@@"];
	UIButton *btnOption;
	UILabel *lblOption;
	float btnX = 25;
	float btnY = Y+35;
	float lblX = 60;
	float lblY = Y+35;
	float latestHeight = 0;
	
	BOOL newLine = FALSE;
	int rowCounter = 0;
	int curCounter = 0;
	float prevY = 0;
	for (int i =0; i < [arCount count]; i++)
	{
		if (curCounter % 2 == 0)
		{
			rowCounter++;
			newLine = TRUE;
		}
		else
		{
			newLine = FALSE;
		}
		
		lblOption = [[UILabel alloc] init];
		lblOption.text = [[dicText componentsSeparatedByString:@"@@"] objectAtIndex:i];
		lblOption.font = [UIFont fontWithName:@"Arial" size:14.0];
		lblOption.backgroundColor = [UIColor clearColor];
		[self.viewQuesInnerView addSubview:lblOption];
        
        btnOption = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnOption.imageView setContentMode:UIViewContentModeScaleAspectFit];
		[btnOption setImage:[UIImage imageNamed:@"radio@2x.png"] forState:UIControlStateNormal];
        [btnOption setImage:[UIImage imageNamed:@"radio@2x.png"] forState:UIControlStateHighlighted];
		[btnOption setImage:[UIImage imageNamed:@"radio_in@2x.png"] forState:UIControlStateSelected];
		[btnOption setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        btnOption.adjustsImageWhenHighlighted = NO;
		[btnOption setTag:i];
		[btnOption addTarget:self action:@selector(btnOptions_Clicked:) forControlEvents:UIControlEventTouchUpInside];
		[self.viewQuesInnerView addSubview:btnOption];

		[lblOption release];
		if (i == 0)
		{	//A
            btnOption.frame = CGRectMake(btnX, btnY, 22+250, 22);
            lblOption.frame = CGRectMake(lblX, lblY, 270, 25);
			latestHeight = latestHeight + lblY;
		}
		else
		{
			if (i % 2 == 0)
			{
				float newY = 0;
				if (newLine)
				{
					newY = btnY + (((i - rowCounter) + 1 )* 50);
					prevY = newY;
				}
				else
				{
					newY = prevY;
				}
                btnOption.frame = CGRectMake(btnX, newY, 22+250, 22);
                lblOption.frame = CGRectMake(lblX, newY, 270, 25);
				latestHeight = newY;
			}
			else
			{
				if (i == 1)
				{	//B
                    btnOption.frame = CGRectMake(btnX + 307, btnY, 22+250, 22);
                    lblOption.frame = CGRectMake(lblX + 310, lblY, 270, 25);
				}
				else
				{	// D
					float newY = 0;
					if (newLine)
					{
						newY = btnY + ((i - rowCounter)* 50);
						prevY = newY;
					}
					else
					{
						if (prevY != 0)
						{
							newY = prevY;
						}
						else
						{
							newY = btnY + ((i - 2)* 50);
							prevY = newY;
						}
					}
                    btnOption.frame = CGRectMake(btnX + 307, newY, 22+250, 22);
                    lblOption.frame = CGRectMake(lblX + 310, newY, 270, 25);
					latestHeight = newY;
				}
			}
		}
		curCounter++;
	}
    self.viewQuesInnerView.frame = CGRectMake(134, 108, 512, latestHeight+35);
    self.imgQuesInnerView.image = [UIImage imageNamed:@"box_s5C_bottom@2x.png"];
    self.btnQueBack.frame = CGRectMake(self.btnQueBack.frame.origin.x, latestHeight+180, self.btnQueBack.frame.size.width, self.btnQueBack.frame.size.height);
    self.btnReply.frame = CGRectMake(self.btnReply.frame.origin.x, latestHeight+180, self.btnReply.frame.size.width, self.btnReply.frame.size.height);
    self.btnNext.frame = CGRectMake(self.btnNext.frame.origin.x, latestHeight+180, self.btnNext.frame.size.width, self.btnNext.frame.size.height);
    arCount=nil;
    btnOption=nil;
    lblOption=nil;
}

/**
 *  Fires on click of Paper submit button
 *
 *  @param sender button   
 */
-(IBAction)btnSubmitClicked:(id)sender{
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[eEducationAppDelegate getLocalvalue:@"Confirmation"] message:[eEducationAppDelegate getLocalvalue:@"Are you sure you want to submit the test? If submitted, the review shall be considered completed and delivered, and an attempt will be deducted."] delegate:self
                                        cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]  otherButtonTitles:[eEducationAppDelegate getLocalvalue:@"Cancel"],nil];
    alert.tag = TAG_ALERT_SUBMIT_PAPER_CONFIRMATION;
    [alert show];
    [alert release];
}


/**
 *  Fires on click of Next option
 *
 *  @param sender btnNext 
 */
-(IBAction)btnNext_Clicked:(id)sender
{
	[self getAnswersListForCurrentQuestions:questionNo];
	questionNo=questionNo+1;
	questionNo = (questionNo>[ExamQuesArray count])?[ExamQuesArray count]:questionNo;
    [self toggelQuesSlideClicked:self.practPdfSlide :self.viewQue];
    [self refreshView:questionNo];
}

/**
 *  Fires on click of Back Button
 *
 *  @param sender Buttton
 */
-(IBAction)btnBack_Clicked:(id)sender
{
	[self getAnswersListForCurrentQuestions:questionNo];
	questionNo=questionNo-1;
	questionNo = (questionNo<0)?0:questionNo;
    [self toggelQuesSlideClicked:self.practPdfSlide :self.viewQue];
	[self refreshView:questionNo];
}

/**
 *  Fires on click of Option
 *
 *  @param sender Button
 */
-(void)btnOptions_Clicked:(id)sender
{
	UIButton *btnCurrent = (UIButton*) sender;
	if([[[ExamQuesArray objectAtIndex:questionNo] objectForKey:@"question_type"] isEqualToString:@"single"])
	{
		for (UIView *vwTemp in self.viewQuesInnerView.subviews)
		{
			if ([vwTemp isKindOfClass:[UIButton class]])
			{
				UIButton *btnTemp = (UIButton*) vwTemp;
                [btnTemp.imageView setContentMode:UIViewContentModeScaleAspectFit];
                [btnTemp setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
				if ([btnTemp isEqual:btnCurrent])
				{
					if (btnTemp.selected)
					{
						[btnTemp setImage:[UIImage imageNamed:@"radio@2x.png"] forState:UIControlStateNormal];
						btnTemp.selected = FALSE;
					}
					else
					{
						[btnTemp setImage:[UIImage imageNamed:@"radio_in@2x.png"] forState:UIControlStateNormal];
						btnTemp.selected = TRUE;
					}
				}
				else
				{
					[btnTemp setImage:[UIImage imageNamed:@"radio@2x.png"] forState:UIControlStateNormal];
					btnTemp.selected=FALSE;
				}
			}
		}
	}
	else
	{
		for (UIView *vwTemp in self.viewQuesInnerView.subviews)
		{
			if ([vwTemp isKindOfClass:[UIButton class]])
			{
				UIButton *btnTemp = (UIButton*) vwTemp;
                [btnTemp.imageView setContentMode:UIViewContentModeScaleAspectFit];
                [btnTemp setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
				if ([btnTemp isEqual:btnCurrent])
				{
					if (btnTemp.selected)
					{
						[btnTemp setImage:[UIImage imageNamed:@"radio@2x.png"] forState:UIControlStateNormal];
						btnTemp.selected = NO;
						
					}
					else
					{
						[btnTemp setImage:[UIImage imageNamed:@"radio_in@2x.png"] forState:UIControlStateNormal];
						btnTemp.selected = YES;
					}
				}
			}
		}
	}
}

-(void)getAnswersListForCurrentQuestions:(int)questionNum
{
	NSMutableDictionary *dic_temp = [[NSMutableDictionary alloc] initWithDictionary:[ExamQuesArray objectAtIndex:questionNum]];
	NSString *str_answers = @"";
	NSString *strID = @"";
	int counter = 0;
	for (UIView *vwTemp in self.viewQuesInnerView.subviews)
	{
		if ([vwTemp isKindOfClass:[UIButton class]])
		{
			UIButton *btnTemp = (UIButton*) vwTemp;
			if (btnTemp.selected)
			{
				if (counter == 0)
				{
					strID = @"";
					str_answers = [str_answers length]?[str_answers stringByAppendingFormat:@",%@",[[[dic_temp objectForKey:@"options"] componentsSeparatedByString:@"@@"] objectAtIndex:btnTemp.tag]]:[str_answers stringByAppendingFormat:@"%@",[[[dic_temp objectForKey:@"options"] componentsSeparatedByString:@"@@"] objectAtIndex:btnTemp.tag]];
					strID = [strID length] ? [strID stringByAppendingFormat:@",%@",[[[dic_temp objectForKey:@"optionsid"] componentsSeparatedByString:@","] objectAtIndex:btnTemp.tag]]:[strID stringByAppendingFormat:@"%@",[[[dic_temp objectForKey:@"optionsid"] componentsSeparatedByString:@","] objectAtIndex:btnTemp.tag]];
					str_answers = [strID stringByAppendingFormat:@"||%@", str_answers];
				}
				else
				{
					strID = @"";
					strID = [str_answers length]?[strID stringByAppendingFormat:@"@@%@",[[[dic_temp objectForKey:@"optionsid"] componentsSeparatedByString:@","] objectAtIndex:btnTemp.tag]]:[strID stringByAppendingFormat:@"%@",[[[dic_temp objectForKey:@"optionsid"] componentsSeparatedByString:@","] objectAtIndex:btnTemp.tag]];
					str_answers = [str_answers stringByAppendingFormat:@"%@||",strID];
					str_answers = [str_answers length]?[str_answers stringByAppendingFormat:@"%@",[[[dic_temp objectForKey:@"options"] componentsSeparatedByString:@"@@"] objectAtIndex:btnTemp.tag]]:[str_answers stringByAppendingFormat:@"%@",[[[dic_temp objectForKey:@"options"] componentsSeparatedByString:@"@@"] objectAtIndex:btnTemp.tag]];
				}
				counter++;
			}
		}
	}
	[dic_temp setObject:str_answers forKey:@"Answer"];
	[ExamQuesArray replaceObjectAtIndex:questionNum withObject:dic_temp];
	[dic_temp release];dic_temp=nil;
}

-(void)loadAns:(int)index{
    [self.lblTestTitleAnsSlide setText:[self.dictSelctedTest valueForKey:@"test_name"]];
    [self.lblTimeSpent setText:[NSString stringWithFormat:RESULT_RTLABLE,[eEducationAppDelegate getLocalvalue:@"Time Spent: "],[self.dictSelctedTest valueForKey:@"taken_duration"]]];
    [self.lblRating setText:[NSString stringWithFormat:RESULT_RTLABLE,[eEducationAppDelegate getLocalvalue:@"Rating: "],[self.dictSelctedTest valueForKey:@"nota"]]];
    [self.lblMarks setText:[NSString stringWithFormat:RESULT_RTLABLE,[eEducationAppDelegate getLocalvalue:@"Marks: "],[self.dictSelctedTest valueForKey:@"total_marks"]]];
    [self.lblAnswerdQues setText:[[ResultArray objectAtIndex:index] valueForKey:@"question"]];
    
    self.btAnsnPrev.enabled = (questionNo > 0);
	self.btnAnsNext.enabled = (questionNo < ResultArray.count-1);
}

/**
 *  Fires on click of Prev button in answers slide
 *
 *  @param sender Button
 */
-(IBAction)btnAnsPrevClicked:(id)sender{
	questionNo=questionNo-1;
	questionNo = (questionNo>[ResultArray count])?[ResultArray count]:questionNo;
    [self toggelQuesSlideClicked:self.practPdfSlide :self.viewAnsSlide];
    [self refreshAnsView:questionNo];
}

/**
 *  Fires on click of Next button in answers slide
 *
 *  @param sender Button
 */
-(IBAction)btnAnsNextClicked:(id)sender{
	questionNo=questionNo+1;
	questionNo = (questionNo>[ResultArray count])?[ResultArray count]:questionNo;
    [self toggelQuesSlideClicked:self.practPdfSlide :self.viewAnsSlide];
    [self refreshAnsView:questionNo];
}

#pragma mark - Other Methods
-(float)getHeight :(UILabel*)myLable{
    CGSize labelSize = [myLable.text sizeWithFont:myLable.font
                                constrainedToSize:myLable.frame.size
                                    lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize.height;
}

-(void)downLoadAndShowPdf:(NSString*)docUrl{
	UIWindow *mainWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	mainWindow.backgroundColor = [UIColor whiteColor];
	pdfName=[NSString stringWithFormat:@"%@.pdf",[eEducationAppDelegate UniqueNameGeneratorFromUrl:docUrl]];
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
		[self downloadFile:[NSURL URLWithString:[docUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	}
	
	[mainWindow release];
}

-(BOOL)checkDataExistence:(NSMutableArray*)arr{
    if (arr.count == 0 || [[[arr objectAtIndex:0] objectForKey:@"success"] isEqualToString:@"0"])
    {
        return NO;
    }
    return YES;
}

-(void) setModulesButtonTitle{
}

/**
 *  Load text as per selected language
 */
-(void)setLocalizedText
{
    [self.btnBack setTitle:[eEducationAppDelegate getLocalvalue:@"HOME"] forState:UIControlStateNormal];
    [self.lblMasterOfModule setText:[[eEducationAppDelegate getLocalvalue:@"MASTERS OF MODULE"] uppercaseString]];
    
    [self.btnPractStatus setTitle:[eEducationAppDelegate getLocalvalue:@"AVAILABLE"] forState:UIControlStateNormal];
    [self.btnTestStatus setTitle:[eEducationAppDelegate getLocalvalue:@"AVAILABLE"] forState:UIControlStateNormal];
    [self.btnObjectives setTitle:[eEducationAppDelegate getLocalvalue:@"OBJECTIVES"] forState:UIControlStateNormal];
    [self.btnTableOfContets setTitle:[eEducationAppDelegate getLocalvalue:@"TABLE OF CONTENTS"] forState:UIControlStateNormal];
    [self.btnCheckList setTitle:[eEducationAppDelegate getLocalvalue:@"CHECKLIST"] forState:UIControlStateNormal];
    
    [self.btnPractDescription setTitle:[eEducationAppDelegate getLocalvalue:@"Description for practice"] forState:UIControlStateNormal];
    [self.btnPracticeDocument setTitle:[eEducationAppDelegate getLocalvalue:@"Practice document"] forState:UIControlStateNormal];
    [self.lblPractSlideDescription setText:[eEducationAppDelegate getLocalvalue:@"Description"]];
    
    [self.btnStartExam setTitle:[[eEducationAppDelegate getLocalvalue:@"start the test"] uppercaseString] forState:UIControlStateNormal];
    [self.btnQueBack setTitle:[eEducationAppDelegate getLocalvalue:@"PREVIOUS"] forState:UIControlStateNormal];
    [self.btnNext setTitle:[eEducationAppDelegate getLocalvalue:@"NEXT"] forState:UIControlStateNormal];
    [self.btnReply setTitle:[eEducationAppDelegate getLocalvalue:@"REPLY"] forState:UIControlStateNormal];
    
    [self.btAnsnPrev setTitle:[eEducationAppDelegate getLocalvalue:@"PREVIOUS"] forState:UIControlStateNormal];
    [self.btnAnsNext setTitle:[eEducationAppDelegate getLocalvalue:@"NEXT"] forState:UIControlStateNormal];
    
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

-(void)didDismissModalViewController
{
	[self viewWillAppear:YES];
}

#pragma mark -
#pragma mark JSONParser delegate method
- (void)parserDidFinishLoadingReturnData:(NSString *)responseString 
{
	[HUD hide:YES];
	SBJSON *json = [[SBJSON new] autorelease];
    if (isReqForResult) {
        isReqForResult=NO;
        ResultArray = [[NSMutableArray alloc] initWithArray:[json objectWithString:responseString error:nil]] ;
        if ([self checkDataExistence:ResultArray]) {
            self.lblTitle.text =[[eEducationAppDelegate getLocalvalue:@"TEST"] uppercaseString];
            questionNo=0;
            [self refreshAnsView:0];
            [self openSlideView:self.viewAnsSlide];
        } else {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"No question available for this test"] delegate:nil
                                                cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }else if (isReqForExam) {
        isReqForExam=NO;
        ExamQuesArray = [[NSMutableArray alloc] initWithArray:[json objectWithString:responseString error:nil]] ;
        if ([self checkDataExistence:ExamQuesArray]) {
            
            if([[[ExamQuesArray objectAtIndex:0] objectForKey:@"total_attempts"] intValue]>=[[[ExamQuesArray objectAtIndex:0] objectForKey:@"total_attempts_allowed"] intValue])
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"You are reached maximum attempt count."] delegate:nil cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]  otherButtonTitles:nil];
                [alert show];
                [alert release];
            } else {
                [self currenttime];
                [self toggelQuesSlideClicked:self.opendView :self.viewQue];
            }
        } else {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"No question available for this test"] delegate:self
                                                cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]  otherButtonTitles:nil];
            [alert show];
            alert.tag = TAG_NO_RECORD_FOUND;
            [alert release];
        }
    } else if (!IsModulesListLoaded) {
        IsModulesListLoaded=YES;
        self.arrModules = [[NSMutableArray alloc] initWithArray:[json objectWithString:responseString error:nil]] ;
         self.lblNoChapter.text = @"";
        if (self.arrModules.count ==0 || [[[self.arrModules objectAtIndex:0] valueForKey:@"success"] isEqualToString:@"0"]) {
            self.arrModules = [[NSMutableArray alloc] init];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                                message:[eEducationAppDelegate getLocalvalue:@"No module available for this course."]
                                                               delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]
                                                      otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        } else{
            self.dictSelectedModule = [[NSMutableDictionary alloc] initWithDictionary:[self.arrModules objectAtIndex:0]];
            [[NSUserDefaults standardUserDefaults] setObject:[[self.arrModules objectAtIndex:0] objectForKey:@"module_id"] forKey:@"module_id"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if(!([[self.dictSelectedModule objectForKey:@"objectives_file"] isKindOfClass:[NSNull class]]) && ([self.dictSelectedModule objectForKey:@"objectives_file"]!=nil))
                ([[self.dictSelectedModule objectForKey:@"objectives_file"] isEqualToString:@""]) ? (self.btnObjectives.selected=YES) : (self.btnObjectives.selected=NO);
            
            if(!([[self.dictSelectedModule objectForKey:@"content_file"] isKindOfClass:[NSNull class]]) && ([self.dictSelectedModule objectForKey:@"content_file"]!=nil))
                ([[self.dictSelectedModule objectForKey:@"content_file"] isEqualToString:@""]) ? (self.btnTableOfContets.selected=YES) : (self.btnTableOfContets.selected=NO);

            if(!([[self.dictSelectedModule objectForKey:@"checklist_file"] isKindOfClass:[NSNull class]]) && ([self.dictSelectedModule objectForKey:@"checklist_file"]!=nil))
                ([[self.dictSelectedModule objectForKey:@"checklist_file"] isEqualToString:@""]) ? (self.btnCheckList.selected=YES) : (self.btnCheckList.selected=NO);

            
            [self.btnModulesDropDown setTitle:[[self.arrModules objectAtIndex:0] valueForKey:@"module_name"] forState:UIControlStateNormal];
            self.lblTitle.text =[[[self.arrModules objectAtIndex:0] valueForKey:@"module_name"] uppercaseString];
            self.lblBlockTitle.text =[[[self.arrModules objectAtIndex:0] valueForKey:@"module_name"] uppercaseString];
            if (!isMastersLoaded) {
                [self callTeachersWS];
            }
        }
    } else if(!isMastersLoaded){
        isMastersLoaded=YES;
        TeachersArray = [[[NSMutableArray alloc] initWithArray:[json objectWithString:responseString error:nil]] retain] ;
        self.lblNoTeacher.text = @"";
        if (![self checkDataExistence:TeachersArray]) {
            TeachersArray = [[NSMutableArray alloc] init];
            self.lblNoTeacher.text = [eEducationAppDelegate getLocalvalue:@"NoTeach"];
        } else {
        }
        [self.gridTeachers reloadData];
        self.pcTeacher.numberOfPages = TeachersArray.count;
        
        if (!IsCompletedChapterListing) {
            [self callChaptersWS];
        }
    } else if(!IsCompletedChapterListing) {
	   IsCompletedChapterListing=YES;
	   ChapterListArray = [[[NSMutableArray alloc] initWithArray:[json objectWithString:responseString error:nil]] retain] ;
        self.lblNoChapter.text = @"";
        if (![self checkDataExistence:ChapterListArray]) {
            ChapterListArray = [[NSMutableArray alloc] init];
            self.lblNoChapter.text = [eEducationAppDelegate getLocalvalue:@"NoChap"];
        }
        [self.lblChapterCountTitle setText:[NSString stringWithFormat:RTChaptersTitle,ChapterListArray.count,[eEducationAppDelegate getLocalvalue:@"CHAPTERS"]]];
        self.pcChapters.numberOfPages = [validations getNumberOfPages:ChapterListArray];
        [self.gridChapters reloadData];

		if([ChapterListArray count]==0||![[[ChapterListArray objectAtIndex:0] objectForKey:@"success"] isEqualToString:@"1"])
		{
		}
		else
		{
            [[NSUserDefaults standardUserDefaults] setObject:[[ChapterListArray objectAtIndex:0]  objectForKey:@"chapter_id"] forKey:@"chapter_id"];
            [[NSUserDefaults standardUserDefaults] setObject:[[ChapterListArray objectAtIndex:0]  objectForKey:@"chapter_name"] forKey:@"chapter_name"];
            [[NSUserDefaults standardUserDefaults] synchronize];
		}
        if (!isPracticesLoaded) {
            [self callPracticesWS];
        }
	} else if(!isPracticesLoaded){
        isPracticesLoaded = YES;
		PracticesArray= [[NSMutableArray alloc] initWithArray:[json objectWithString:responseString error:nil]];
        self.lblNoPract.text = @"";
        if (![self checkDataExistence:PracticesArray]) {
            PracticesArray = [[NSMutableArray alloc] init];
            self.lblNoPract.text = [eEducationAppDelegate getLocalvalue:@"NoPrac"];
        }
        [self.lblPractCountTitle setText:[NSString stringWithFormat:RTTitle,PracticesArray.count,[eEducationAppDelegate getLocalvalue:@"Practices"]]];
        self.pcPractices.numberOfPages = [validations getNumberOfPages:PracticesArray];
        [self.gridPractices reloadData];
        
        if (!isTestsLoaded) {
            [self callTestWS];
        }

    } else if(!isTestsLoaded){
        isTestsLoaded = YES;
		TestArray= [[NSMutableArray alloc] initWithArray:[json objectWithString:responseString error:nil]];
        self.lblNoTest.text = @"";
        if (TestArray.count == 0 || [[[TestArray objectAtIndex:0] valueForKey:@"success"] isEqualToString:@"0"]) {
            TestArray = [[NSMutableArray alloc] init];
            self.lblNoTest.text = [eEducationAppDelegate getLocalvalue:@"NoTest"];
        }
        [self.lblTestCountTitle setText:[NSString stringWithFormat:RTTitle,TestArray.count,[eEducationAppDelegate getLocalvalue:@"Tests"]]];
        self.pcTest.numberOfPages = [validations getNumberOfPages:TestArray];
        [self.gridTest reloadData];
        
        if (!isVideosLoaded) {
            [self callVideosWS];
        }
    }
	else
	{
        self.lblNoVideo.text = @"";
		VideoListArray= [[NSMutableArray alloc] initWithArray:[json objectWithString:responseString error:nil]] ;
        if ([self checkDataExistence:VideoListArray])
		{
            self.pcVideos.numberOfPages = VideoListArray.count;
            [self.gridVideos reloadData];
		} else {
            self.lblNoVideo.text = [eEducationAppDelegate getLocalvalue:@"NoVideo"];
            VideoListArray= [[NSMutableArray alloc] init];
            [self.gridVideos reloadData];
        }
        [self.lblVIdeosCountTitle setText:[NSString stringWithFormat:RTTitle,VideoListArray.count,[eEducationAppDelegate getLocalvalue:@"Videos"]]];
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

/**
 *  Fires after sucessfully submition of the paper
 *
 *  @param sucess Flag 1/0
 */
-(void)DidSubmitSucesfully:(NSString*)sucess
{
	[HUD hide:YES];
	if([sucess isEqualToString:@"1"])
	{
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"Your test uploaded successfully"] delegate:self	 cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]  otherButtonTitles:nil];
		[alert show];
		alert.tag = TAG_ALERT_CLOSE_SLIDE;
		[alert release];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[eEducationAppDelegate getLocalvalue:@"Failed to upload test"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:[eEducationAppDelegate getLocalvalue:@"OK"],nil];
		[alert show];
		alert.tag=TAG_ALERT_CLOSE_SLIDE;
		[alert release];
	}
}

-(void)DidSubmitFail:(NSString*)error
{
	[HUD hide:YES];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[eEducationAppDelegate getLocalvalue:@"The server cannot be reached. It could be down or busy. Please try again later."] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:[eEducationAppDelegate getLocalvalue:@"OK"],nil];
	[alert show];
	alert.tag=TAG_ALERT_CLOSE_SLIDE;
	[alert release];
}

#pragma mark -
#pragma mark alertview Delegate 
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == TAG_ALERT_LOGOUT && buttonIndex == 1){
        @try {
            [[validations getAppDelegateInstance].navigationController popToViewController:[[validations getAppDelegateInstance].navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
    } else  if(alertView.tag == TAG_ALERT_LOGOUT && buttonIndex == 1){
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    } else if(alertView.tag == TAG_ALERT_SUBMIT_PAPER_CONFIRMATION){
        if (buttonIndex == 0) {
            self.lblTitle.text =[self.lblBlockTitle.text uppercaseString];
            if(timer)
            {
                [timer invalidate];
                timer = nil;
            }
            [[NSUserDefaults standardUserDefaults] setObject:self.lblTimer.text forKey:@"TimeDuration"];
            self.lblTimer.hidden = YES;
            self.lblTimerStatic.hidden = YES;
            [self getAnswersListForCurrentQuestions:questionNo];
            [self callPostAnswersWS];
        }
    } else if(alertView.tag==222)
	{
		[self.navigationController popViewControllerAnimated:YES];
	}
	else if(alertView.tag==TAG_FailError)
	{
		if (buttonIndex == 0)
		{
			[appDelegate GoTOLoginScreen:NO];
		}
	} else if (alertView.tag == TAG_ALERT_CLOSE_SLIDE){
        [self closeSlideView:self.opendView];
    }
	else if (alertView.tag == 707)
	{
		[self.navigationController popViewControllerAnimated:TRUE];
	}
}

#pragma mark -
#pragma mark Topbar Action methods
-(IBAction)proImgClicked:(id)sender{
    [self btnSettingsClicked:nil];
}

-(IBAction)btnStudentsClicked:(id)sender{
    OtherStudents *objOtherStudents = [[OtherStudents alloc] initWithNibName:@"OtherStudents" bundle:nil];
    [self releaseObjects];
    [[validations getAppDelegateInstance] removePresentVC];
	[[validations getAppDelegateInstance].navigationController pushViewController:objOtherStudents animated:NO];
	[objOtherStudents release];
}

-(IBAction)btnSettingsClicked:(id)sender{
    Settings *objSettings = [[Settings alloc] initWithNibName:@"Settings" bundle:nil];
    [self releaseObjects];
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

-(IBAction)btnBackClicked:(id)sender{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:NO];
}

#pragma mark - Custom Picker Delegate Methods
-(void)picker:(UICustomPicker *)picker andDoneClicked:(NSString*)doneValue andIndex:(int)index
{
    if (picker == self.objPicker) {
        self.dictSelectedModule = [[NSMutableDictionary alloc] initWithDictionary:[self.arrModules objectAtIndex:index]];
        if ([self.dictSelectedModule objectForKey:@"objectives_file"] == nil || [[self.dictSelectedModule objectForKey:@"objectives_file"] length] == 0) {
            self.btnObjectives.selected = YES;
        }
        if ([self.dictSelectedModule objectForKey:@"checklist_file"] == nil || [[self.dictSelectedModule objectForKey:@"checklist_file"] length] == 0) {
            self.btnCheckList.selected = YES;
        }
        if ([self.dictSelectedModule objectForKey:@"content_file"] == nil || [[self.dictSelectedModule objectForKey:@"content_file"] length] == 0) {
            self.btnTableOfContets.selected = YES;
        }

        NSString *strSelectedModuleId = [[self.arrModules objectAtIndex:index] valueForKey:@"module_id"];
        [[NSUserDefaults standardUserDefaults] setValue:strSelectedModuleId forKey:@"module_id"];

        self.lblTitle.text =[[[self.arrModules objectAtIndex:index] valueForKey:@"module_name"] uppercaseString];
        self.lblBlockTitle.text =[[[self.arrModules objectAtIndex:index] valueForKey:@"module_name"] uppercaseString];

        isPracticesLoaded = NO;
        IsCompletedChapterListing = NO;
        isTestsLoaded = NO;
        isVideosLoaded = NO;
        isMastersLoaded = NO;
        [self callTeachersWS];
    } else if(picker == self.objPractStautsPicker){
        IsModulesListLoaded = YES;
        isPracticesLoaded = NO;
        IsCompletedChapterListing = YES;
        isTestsLoaded = YES;
        isTestsLoaded = YES;
        isVideosLoaded = YES;
        [self callPracticesWS];
    } else {
        IsModulesListLoaded = YES;
        isPracticesLoaded = YES;
        IsCompletedChapterListing = YES;
        isTestsLoaded = YES;
        isTestsLoaded = NO;
        isVideosLoaded = YES;
        [self callTestWS];
    }
}
-(void)picker:(UICustomPicker *)picker andCancelClicked:(NSString*)preValue
{
}

#pragma mark -
#pragma mark Action methods
-(IBAction) btnStartExamClickedClicked:(id)sender{
    self.lblTimer.hidden = NO;
    self.lblTimerStatic.hidden = NO;
    [self callStartExamWS];
}

-(IBAction)btnPractCloseClicked:(id)sender{
    self.lblTitle.text =[self.lblBlockTitle.text uppercaseString];
    [self closeSlideView:self.opendView];
}

-(IBAction)btnPractDiscriptionClicked:(id)sender{
    
    if ([self.dictSelectedPractice objectForKey:@"Practice_doc_url"] == nil || [[self.dictSelectedPractice objectForKey:@"Practice_doc_url"] length]==0) {
        [self pdfNotFoundAlert];
    } else {
        HUD = [MBProgressHUD showHUDAddedTo:[validations getAppDelegateInstance].window animated:YES];
        HUD.labelText=[eEducationAppDelegate getLocalvalue:@"Please wait"];
        isPractPdf = YES;
        NSURL *targetURL = [NSURL URLWithString:[[self.dictSelectedPractice objectForKey:@"Practice_doc_url"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
        NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
        [self.webViewPdf loadRequest:request];
        isPractPdf = NO;
        [self toggelSlideClicked:self.viewPracticeSlide :self.practPdfSlide];
    }
}

-(IBAction)btnPractDocumentClicked:(id)sender{
    if ([self.dictSelectedPractice objectForKey:@"uploaded_doc_url"] == nil || [[self.dictSelectedPractice objectForKey:@"uploaded_doc_url"] length]==0) {
        [self pdfNotFoundAlert];
    } else {
        HUD = [MBProgressHUD showHUDAddedTo:[validations getAppDelegateInstance].window animated:YES];
        HUD.labelText=[eEducationAppDelegate getLocalvalue:@"Please wait"];
        NSURL *targetURL = [NSURL URLWithString:[self.dictSelectedPractice valueForKey:@"uploaded_doc_url"]];
        NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
        [self.webViewPdf loadRequest:request];
        
        isPractPdf = NO;
        [self toggelSlideClicked:self.viewPracticeSlide :self.practPdfSlide];

    }
}

-(IBAction)btnPractStatusClicked:(id)sender{
    self.objPractStautsPicker =[[UICustomPicker alloc] init];
    self.objPractStautsPicker.delegate = self;
    [self.objPractStautsPicker initWithCustomPicker:CGRectMake(0, 160, 320,240) inView:self.btnPractStatus  ContentSize:CGSizeMake(320, 216) pickerSize:CGRectMake(0, 20, 320, 216) barStyle:UIBarStyleBlack Recevier:(UIButton*)sender componentArray:[NSArray arrayWithObjects:[eEducationAppDelegate getLocalvalue:@"AVAILABLE"],[eEducationAppDelegate getLocalvalue:@"pDONE"],[eEducationAppDelegate getLocalvalue:@"pEVALUATED"], nil] toolBartitle:[eEducationAppDelegate getLocalvalue:nil] textColor:[UIColor whiteColor] needToSort:FALSE withDictKey:@""];
}

-(IBAction)btnTestStatusClicked:(id)sender{
    self.objTestStatusPicker =[[UICustomPicker alloc] init];
    self.objTestStatusPicker.delegate = self;
    [self.objTestStatusPicker initWithCustomPicker:CGRectMake(0, 160, 320,240) inView:self.btnTestStatus  ContentSize:CGSizeMake(320, 216) pickerSize:CGRectMake(0, 20, 320, 216) barStyle:UIBarStyleBlack Recevier:(UIButton*)sender componentArray:[NSArray arrayWithObjects:[eEducationAppDelegate getLocalvalue:@"AVAILABLE"],[eEducationAppDelegate getLocalvalue:@"tDONE"],[eEducationAppDelegate getLocalvalue:@"tEVALUATED"], nil] toolBartitle:[eEducationAppDelegate getLocalvalue:nil] textColor:[UIColor whiteColor] needToSort:FALSE withDictKey:@""];
}

-(IBAction) btnModulesDropDownClicked:(id)sender{
    if (!self.objPicker) {
        self.objPicker =[[UICustomPicker alloc] init];
        self.objPicker.delegate = self;
    }
    printf("%s", [self.arrModules valueForKey:@"module_name"]);
    [self.objPicker initWithCustomPicker:CGRectMake(0, 160, 320,240) inView:self.btnModulesDropDown  ContentSize:CGSizeMake(320, 216) pickerSize:CGRectMake(0, 20, 320, 216) barStyle:UIBarStyleBlack Recevier:(UIButton*)sender componentArray:[NSArray arrayWithArray:[self.arrModules valueForKey:@"module_name"]] toolBartitle:[eEducationAppDelegate getLocalvalue:nil] textColor:[UIColor whiteColor] needToSort:FALSE withDictKey:@"module_name"];
}

-(IBAction)btnObjectivesClicked:(id)sender{
    if ([self.dictSelectedModule objectForKey:@"objectives_file"] != nil && [[self.dictSelectedModule objectForKey:@"objectives_file"] length] != 0) {
        [self downLoadAndShowPdf:[self.dictSelectedModule valueForKey:@"objectives_file"]];
    }
}

-(IBAction)btnTableOfContentsClicked:(id)sender{
    if ([self.dictSelectedModule objectForKey:@"content_file"] != nil && [[self.dictSelectedModule objectForKey:@"content_file"] length] != 0) {
        [self downLoadAndShowPdf:[self.dictSelectedModule valueForKey:@"content_file"]];
    }
}

-(IBAction)btnCheckListClicked:(id)sender{
    if ([self.dictSelectedModule objectForKey:@"checklist_file"] != nil && [[self.dictSelectedModule objectForKey:@"checklist_file"] length] != 0) {
        [self downLoadAndShowPdf:[self.dictSelectedModule valueForKey:@"checklist_file"]];
    }
}

-(IBAction) TabarIndexSelected:(id)sender
{
	UIButton *btn=sender;
	int i=btn.tag/11;
    [self releaseObjects];
    [[validations getAppDelegateInstance] removePresentVC];
    appDelegate=(eEducationAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate pushToTabbarWithSelection:i];
}

-(void)pdfNotFoundAlert{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:[eEducationAppDelegate getLocalvalue:@"Requested PDF is not found in server please try again."]
                                                       delegate:nil
                                              cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

#pragma mark - PageController Action methods
-(void)btnPageControlValueChanged:(UIPageControl*) sender{
    if (sender == self.pcChapters) {
        [self.gridChapters setContentOffset:CGPointMake(sender.currentPage * CGRectGetWidth(self.gridChapters.frame), 0) animated:YES] ;
    } else if (sender == self.pcPractices) {
        [self.gridPractices setContentOffset:CGPointMake(sender.currentPage * CGRectGetWidth(self.gridPractices.frame), 0) animated:YES] ;
    } else if (sender == self.pcTest) {
        [self.gridTest setContentOffset:CGPointMake(sender.currentPage * CGRectGetWidth(self.gridTest.frame), 0) animated:YES] ;
    } else if (sender == self.pcVideos) {
        [self.gridVideos setContentOffset:CGPointMake(sender.currentPage * CGRectGetWidth(self.gridVideos.frame), 0) animated:YES] ;
    } else if (sender == self.pcTeacher) {
        [self.gridTeachers setContentOffset:CGPointMake(sender.currentPage * CGRectGetWidth(self.gridTeachers.frame), 0) animated:YES] ;
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
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}

#pragma mark -
#pragma mark Button tap event
- (void)button_chaptersTapped:(UIButton *)sender
{
	ChapterDetails *objChapterDetails=[[ChapterDetails alloc] initWithNibName:@"ChapterDetails" bundle:nil];
	[self.navigationController pushViewController:objChapterDetails animated:YES];
	[objChapterDetails release];
		
}
-(void) button_videosTapped:(UIButton *)sender
{
}

#pragma mark - GM Grid view Delegates
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.gridChapters) {
        CGFloat pageWidth = self.gridChapters.frame.size.width;
        float fractionalPage = self.gridChapters.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        self.pcChapters.currentPage = page ;
    } else if (scrollView == self.gridPractices) {
        CGFloat pageWidth = self.gridPractices.frame.size.width;
        float fractionalPage = self.gridPractices.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        self.pcPractices.currentPage = page ;
    } else if (scrollView == self.gridTest) {
        CGFloat pageWidth = self.gridTest.frame.size.width;
        float fractionalPage = self.gridTest.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        self.pcTest.currentPage = page ;
    } else if (scrollView == self.gridTeachers) {
        CGFloat pageWidth = self.gridTeachers.frame.size.width;
        float fractionalPage = self.gridTeachers.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        self.pcTeacher.currentPage = page ;
    } else{
        CGFloat pageWidth = self.gridVideos.frame.size.width;
        float fractionalPage = self.gridVideos.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        self.pcVideos.currentPage = page ;
    }
}
- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    if (gridView == self.gridChapters) {
        return ChapterListArray.count;
    } else if(gridView == self.gridPractices){
        return PracticesArray.count;
    } else if(gridView == self.gridTest){
        return TestArray.count;
    } else if(gridView == self.gridTeachers){
        return TeachersArray.count;
    }
    return VideoListArray.count;
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (gridView == self.gridChapters) {
        return CGSizeMake(489, 108);
    } else if(gridView == self.gridPractices || gridView == self.gridTest){
        return CGSizeMake(489, 71);
    } else  if (gridView == self.gridTeachers) {
        return CGSizeMake(218, 298);
    }
    return CGSizeMake(489, 141);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    if (gridView == self.gridChapters) {
        ChaptersCell *cell = (ChaptersCell *)[gridView dequeueReusableCell];
        if (!cell)
        {
            cell = [[ChaptersCell alloc] init];
        }
        cell.lblChapterTitle.text = [[ChapterListArray objectAtIndex:index] valueForKey:@"chapter_name"];
        //cell.lblChapterTitle.ContainerInset = UIEdgeInsetsMake(0, 20, 0, 20);
        //cell.lblChapterTitle.contentMode = UIEdgeInsetsMake(-4,-8,0,0);
        cell.txtChapterDesc.text = [[ChapterListArray objectAtIndex:index] valueForKey:@"chapter_desc"];
        return cell;
    } else if(gridView == self.gridTeachers){
        MasterCell *cell = (MasterCell *)[gridView dequeueReusableCell];
        if (!cell)
        {
            cell = [[MasterCell alloc] init];
        }
        cell.lblName.text = [[TeachersArray objectAtIndex:index] valueForKey:@"name"];
        cell.txtDesc.text = [[TeachersArray objectAtIndex:index] valueForKey:@"desc"];
        [cell.imgProfile loadImageFromURL:[NSURL URLWithString:[[[TeachersArray objectAtIndex:index] valueForKey:@"teacher_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:@"no-image-374x310.png"];
        return cell;
    } else if(gridView == self.gridPractices){
        PracticesCell *cell = (PracticesCell *)[gridView dequeueReusableCell];
        if (!cell)
        {
            cell = [[PracticesCell alloc] init];
        }
        NSString *strDate = [eEducationAppDelegate convertString:[[PracticesArray objectAtIndex:index] valueForKey:@"end_date"] fromFormate:@"yyyy-MM-dd" toFormate:@"dd/MM/yyyy"];

        cell.lblChapterTitle.text = [[PracticesArray objectAtIndex:index] valueForKey:@"practice_name"];
        cell.lblChapterDate.text =[NSString stringWithFormat:@"%@ %@",[eEducationAppDelegate getLocalvalue:@"Limit"],strDate] ;

        NSString *strStatus =[self.btnPractStatus titleForState:0];
        if ([strStatus isEqualToString:@"EVALUADAS"] || [strStatus isEqualToString:@"EVALUATED"] || [strStatus isEqualToString:@"EVALUADOS"]) {
            [cell.btnArrow setImage:[UIImage imageNamed:@"hand_icon.png"] forState:UIControlStateNormal];
        } else if ([strStatus isEqualToString:@"DISPONIBLES"] || [strStatus isEqualToString:@"AVAILABLE"]) {
            [cell.btnArrow setImage:[UIImage imageNamed:@"right_box_arrow_s4@2x.png"] forState:UIControlStateNormal];
        } else {
            [cell.btnArrow setImage:[UIImage imageNamed:@"btn_done@2x.png"] forState:UIControlStateNormal];
        }
        return cell;
    } else if(gridView == self.gridTest) {
        PracticesCell *cell = (PracticesCell *)[gridView dequeueReusableCell];
        if (!cell)
        {
            cell = [[PracticesCell alloc] init];
        }
        cell.lblChapterTitle.text = [[TestArray objectAtIndex:index] valueForKey:@"test_name"];

        NSString *strStatus =[self.btnTestStatus titleForState:0];
        if ([strStatus isEqualToString:@"EVALUADAS"] || [strStatus isEqualToString:@"EVALUATED"] || [strStatus isEqualToString:@"EVALUADOS"]) {
            [cell.btnArrow setImage:[UIImage imageNamed:@"hand_icon.png"] forState:UIControlStateNormal];
            cell.lblChapterTitle.frame = CGRectMake(36, 26, 429, 20);
            cell.lblChapterDate.hidden = YES;
            cell.imgCal.hidden = YES;
        } else if ([strStatus isEqualToString:@"DISPONIBLES"] || [strStatus isEqualToString:@"AVAILABLE"]) {
            [cell.btnArrow setImage:[UIImage imageNamed:@"right_box_arrow_s4@2x.png"] forState:UIControlStateNormal];
            cell.lblChapterDate.hidden = NO;
            cell.imgCal.hidden = NO;
            NSString *strDate = [eEducationAppDelegate convertString:[[TestArray objectAtIndex:index] valueForKey:@"enddate"] fromFormate:@"yyyy-MM-dd" toFormate:@"dd/MM/yyyy"];
            cell.lblChapterDate.text = [NSString stringWithFormat:@"%@ %@",[eEducationAppDelegate getLocalvalue:@"Limit"],strDate];
            cell.lblChapterTitle.frame = CGRectMake(36, 14, 429, 20);
        } else {
            [cell.btnArrow setImage:[UIImage imageNamed:@"btn_done@2x.png"] forState:UIControlStateNormal];
            cell.lblChapterTitle.frame = CGRectMake(36, 26, 429, 20);
            cell.lblChapterDate.hidden = YES;
            cell.imgCal.hidden = YES;
        }
        
        return cell;
    } else {
        VideosCell *cell = (VideosCell *)[gridView dequeueReusableCell];
        if (!cell)
        {
            cell = [[VideosCell alloc] init];
        }
        cell.lblVideoTitle.text = [[VideoListArray objectAtIndex:index] valueForKey:@"video_name"];
        cell.txtVideoDesc.text = [[VideoListArray objectAtIndex:index] valueForKey:@"video_desc"];
        [cell.asyVideoImg loadImageFromURL:[NSURL URLWithString:[[[VideoListArray objectAtIndex:index] valueForKey:@"video_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:@"logo_mindway.png"];
        return cell;
    }
}

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    if (gridView == self.gridChapters) {
        NSMutableArray *arr = [[[ChapterListArray objectAtIndex:position] valueForKey:@"chapter_document"] retain];
        if (arr != nil && arr.count !=0) {
            @try {
                pdfHavingVideos = YES;
                selectedChapter = position;
                [[NSUserDefaults standardUserDefaults] setObject:[[arr objectAtIndex:0] objectForKey:@"document_name"] forKey:@"DocumentName"]; // Taking first doc only
                NSString *strPdfUrl = [[arr objectAtIndex:0]valueForKey:@"doc_url"];
                if (strPdfUrl == nil || [strPdfUrl isEqualToString:@""]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                                        message:[eEducationAppDelegate getLocalvalue:@"Requested PDF is not found in server please try again."]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    [alertView release];
                } else {
                    [self downLoadAndShowPdf:strPdfUrl];
                }
            }
            @catch (NSException *exception) {
            }
            @finally {
            }
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                                message:[eEducationAppDelegate getLocalvalue:@"Requested PDF is not found in server please try again."]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
        [arr release];
    } else if (gridView == self.gridVideos) {
        //if ([[VideoListArray objectAtIndex:position] objectForKey:@"video_url"] == nil || [[[VideoListArray objectAtIndex:position] objectForKey:@"video_url"] length] == 0) {
        if ([[VideoListArray objectAtIndex:position] objectForKey:@"vimeo"] == nil || [[[VideoListArray objectAtIndex:position] objectForKey:@"vimeo"] length] == 0) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"Requested video is not found in server please try again."] delegate:nil cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]  otherButtonTitles:nil];
            [alert show];
            [alert release];
        } else {
            YouTubePlayer *objYouTubePlayer = [[YouTubePlayer alloc] initWithNibName:@"YouTubePlayer" bundle:nil];
//            objYouTubePlayer.strMovieURL =[[VideoListArray objectAtIndex:position] objectForKey:@"video_url"];
            objYouTubePlayer.strMovieURL =[[VideoListArray objectAtIndex:position] objectForKey:@"vimeo"];
            objYouTubePlayer.strTitle = [[VideoListArray objectAtIndex:position] objectForKey:@"video_name"];
            objYouTubePlayer.playedFromLocal=NO;
            [self.navigationController pushViewController:objYouTubePlayer animated:YES];
            [objYouTubePlayer release];
        }
    } else if(gridView == self.gridPractices){
        self.lblTitle.text =[[eEducationAppDelegate getLocalvalue:@"Practices"] uppercaseString];
        if ([[self.btnPractStatus titleForState:0] isEqualToString:@"EVALUADAS"] || [[self.btnPractStatus titleForState:0] isEqualToString:@"EVALUATED"] || [[self.btnPractStatus titleForState:0] isEqualToString:@"EVALUADOS"] || [[self.btnPractStatus titleForState:0] isEqualToString:@"DONE"] || [[self.btnPractStatus titleForState:0] isEqualToString:@"REALIZADAS"]) {
            self.btnPracticeDocument.hidden = NO;
        } else {
            self.btnPracticeDocument.hidden = YES;
        }
        self.dictSelectedPractice = [PracticesArray objectAtIndex:position];
        self.lblPractSlideTitle.text = [self.dictSelectedPractice valueForKey:@"practice_name"];
        self.txtPractSlideDescription.text = [self.dictSelectedPractice valueForKey:@"description"];
        self.lblPracatSlideDate.text = [NSString stringWithFormat:@"%@ %@",[eEducationAppDelegate getLocalvalue:@"Date"],[self.dictSelectedPractice valueForKey:@"end_date"]];
        [self.lblPractSlideStartDate setText:[NSString stringWithFormat:PRACTICE_RTLABLE,[eEducationAppDelegate getLocalvalue:@"Start Date"],[self.dictSelectedPractice valueForKey:@"start_date"]]];
        [self.lblPractSlideEndDate setText:[NSString stringWithFormat:PRACTICE_RTLABLE,[eEducationAppDelegate getLocalvalue:@"End Date"],[self.dictSelectedPractice valueForKey:@"end_date"]]];
        [self openSlideView:self.viewPracticeSlide];
        
    } else if(gridView == self.gridTest){
        if ([[self.btnTestStatus titleForState:0] isEqualToString:@"EVALUADAS"] || [[self.btnTestStatus titleForState:0] isEqualToString:@"EVALUATED"] || [[self.btnTestStatus titleForState:0] isEqualToString:@"EVALUADOS"]) {
            self.dictSelctedTest = [TestArray objectAtIndex:position];
            [self callResultsWS];
        } else {
            questionNo = 0;
            self.dictSelctedTest = [TestArray objectAtIndex:position];
            if([[self.dictSelctedTest objectForKey:@"attemptedcnt"] intValue]>=[[self.dictSelctedTest objectForKey:@"totattempt"] intValue])
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"You are reached maximum attempt count."] delegate:nil cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]  otherButtonTitles:nil];
                [alert show];
                [alert release];
            } else {
                self.lblTitle.text =[[eEducationAppDelegate getLocalvalue:@"TEST"] uppercaseString];
                self.lblTestTitle.text = [self.dictSelctedTest valueForKey:@"test_name"];
                self.txtTestDiscr.text = [self.dictSelctedTest valueForKey:@"test_details"];
                NSString *strDate = [eEducationAppDelegate convertString:[[TestArray objectAtIndex:position] valueForKey:@"enddate"] fromFormate:@"yyyy-MM-dd" toFormate:@"dd/MM/yyyy"];
                self.lblTestCompletionDate.text = [NSString stringWithFormat:@"%@ %@",[eEducationAppDelegate getLocalvalue:@"Completion date"],strDate];
                [self.lblTestBlueTitle setText:[eEducationAppDelegate getLocalvalue:@"Instructions"]];
                [self openSlideView:self.viewStartExamSlide];
            }
        }
    }
}

#pragma mark -
#pragma mark pdfName
-(void)downloadFile:(NSURL *)url
{
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
	self.connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	NSAssert(self.connection != nil, @"Failure to create URL connection.");
	self.connection = nil;
    theRequest=nil;
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
    pathString =nil;
	return str;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	appListData = [[NSMutableData data] retain];
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
    NSMutableArray *_arrayTempVideoInfo=[[NSMutableArray alloc] init];
    NSString *filePath =[self GetPath:pdfName];

    if (pdfHavingVideos) {
        pdfHavingVideos = NO;
        if(![[[ChapterListArray objectAtIndex:selectedChapter] objectForKey:@"chapter_document"] isKindOfClass:[NSString class]]){
            NSMutableArray *arr = [[ChapterListArray objectAtIndex:selectedChapter] objectForKey:@"chapter_document"];
            if (![[[arr objectAtIndex:0] valueForKey:@"chapter_video"] isKindOfClass:[NSString class]]) {
                NSMutableArray *arrVideos = [[arr objectAtIndex:0] valueForKey:@"chapter_video"];
                if (arrVideos.count > 0) {
                    for (int i=0; i<arrVideos.count; i++) {
                        NSMutableDictionary *dictTemp=[[NSMutableDictionary alloc] init];
                        NSString *_videoName=[NSString stringWithFormat:@"%@.mp4",[eEducationAppDelegate UniqueNameGeneratorFromUrl:[[arrVideos objectAtIndex:i]objectForKey:@"video_url"]]];
                        NSString *fileVideoPath=[self GetPath:_videoName];
                        [dictTemp setObject:fileVideoPath forKey:@"video_url"];
                        [dictTemp setObject:[[arrVideos objectAtIndex:i]objectForKey:@"video_page"] forKey:@"video_page"];
                        [dictTemp setObject:[[arrVideos objectAtIndex:i]objectForKey:@"video_position"] forKey:@"video_position"];
                        [_arrayTempVideoInfo addObject:dictTemp];
                        [dictTemp release];
                    }
                }
            }
        }
    }
    
    if (isPractPdf) {
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

#pragma mark - Webview delegate methods
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [HUD hide:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	[HUD hide:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:[eEducationAppDelegate getLocalvalue:@"Selected Pdf is not loaded properly."]
                                                       delegate:nil
                                              cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

-(void)releaseObjects{
	[tab1 release];tab1=nil;
	[tab2 release];tab2=nil;
	[tab3 release];tab3=nil;
	[tab4 release];tab4=nil;
	[tab5 release];tab5=nil;
    
	[ChapterListArray release];ChapterListArray=nil;
	[VideoListArray release];VideoListArray=nil;
    [TestArray release];TestArray=nil;
    [PracticesArray release];PracticesArray=nil;
    [self.gridChapters release];self.gridChapters=nil;
    [self.gridPractices release];self.gridPractices=nil;
    [self.gridTest release];self.gridTest=nil;
    [self.gridVideos release];self.gridVideos=nil;
    
    [self.btnModulesDropDown release];self.btnModulesDropDown=nil;
    [self.btnObjectives release];self.btnObjectives=nil;
    [self.btnTableOfContets release];self.btnTableOfContets=nil;
    [self.btnCheckList release];self.btnCheckList=nil;
    [self.btnTestStatus release];self.btnTestStatus=nil;
    [self.btnBack release];self.btnBack=nil;
    
    [self.lblTopDuration release];self.lblTopDuration=nil;
    [self.lblChapterCountTitle release];self.lblChapterCountTitle=nil;
    [self.lblPractCountTitle release];self.lblPractCountTitle=nil;
    [self.lblTestCountTitle release];self.lblTestCountTitle=nil;
    [self.lblVIdeosCountTitle release];self.lblVIdeosCountTitle=nil;
    
    [self.lblNoChapter release];self.lblNoChapter=nil;
    [self.lblBlockTitle release];self.lblBlockTitle=nil;
    [self.lblTopCourse release];self.lblTopCourse=nil;
    [self.lblNoPract release];self.lblNoPract=nil;
    [self.lblNoTest release];self.lblNoTest=nil;
    [self.lblNoVideo release];self.lblNoVideo=nil;
    
    [self.opendView release];self.opendView=nil;
    [self.lblPractSlideTitle release];self.lblPractSlideTitle=nil;
    [self.lblPracatSlideDate release];self.lblPracatSlideDate=nil;
    [self.lblPractSlideDescription release];self.lblPractSlideDescription=nil;
    [self.txtPractSlideDescription release];self.txtPractSlideDescription=nil;
    [self.lblPractSlideStartDate release];self.lblPractSlideStartDate=nil;
    [self.lblPractSlideEndDate release];self.lblPractSlideEndDate=nil;
    [self.btnPractDescription release];self.btnPractDescription=nil;
    [self.btnPracticeDocument release];self.btnPracticeDocument=nil;
    [self.webViewPdf release];self.webViewPdf=nil;
    
    [self.imgQuesInnerView release];self.imgQuesInnerView=nil;
    [self.imgAnsInnerView release];self.imgAnsInnerView=nil;
    [self.lblTestTitle release];self.lblTestTitle=nil;
    [self.lblTestCompletionDate release];self.lblTestCompletionDate=nil;
    [self.lblTestBlueTitle release];self.lblTestBlueTitle=nil;
    [self.txtTestDiscr release];self.txtTestDiscr=nil;
    [self.btnStartExam release];self.btnStartExam=nil;
    [self.btnNext release];self.btnNext=nil;
    [self.btnQueBack release];self.btnQueBack=nil;
    [self.btnReply release];self.btnReply=nil;
    
    [self.lblQues release];self.lblQues=nil;
    [self.lblTestNameQuesSlide release];self.lblTestNameQuesSlide=nil;
    [self.lblTestTitleQueSlide release];self.lblTestTitleQueSlide=nil;
    [self.lblTimeSpent release];self.lblTimeSpent=nil;
    [self.lblRating release];self.lblRating=nil;
    [self.lblMarks release];self.lblMarks=nil;
    [self.lblAnswerdQues release];self.lblAnswerdQues=nil;
    [self.lblTestTitleAnsSlide release];self.lblTestTitleAnsSlide=nil;
    [self.btAnsnPrev release];self.btAnsnPrev=nil;
    [self.btnAnsNext release];self.btnAnsNext=nil;
}

@end
