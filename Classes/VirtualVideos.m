    //
//  VirtualVideos.m
//  eEducation
//
//  Created by HB14 on 09/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VirtualVideos.h"
#import "Settings.h"
#import "ReflectionView.h"
#import "YouTubePlayer.h"
#import <QuartzCore/QuartzCore.h>
#import "ModuleHomePage.h"

#define NUMBER_OF_COURSES ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 10: 12)
#define ITEM_SPACING 150
#define USE_BUTTONS YES

@interface VirtualVideos () <UIActionSheetDelegate>

@property (nonatomic, retain) NSMutableArray *items;

@end

@implementation VirtualVideos
@synthesize reflectionView;
@synthesize carousel_VirtualVideos;
@synthesize items;
@synthesize imageAsynchronus = _imageAsynchronus;
@synthesize timerForFlash = _timerForFlash;

- (void)dealloc
{
	[lbl_Videos release];lbl_Videos=nil;
	[lbl_VideoName release];lbl_VideoName=nil;
	[lbl_VideoNameValue release];lbl_VideoNameValue=nil;
	[txt_desc release]; txt_desc = nil;
	[txt_Description release];txt_Description=nil;
	[_imageAsynchronus release];_imageAsynchronus=nil;
	[carousel_VirtualVideos release];carousel_VirtualVideos=nil;
	[videoArray release];videoArray=nil;
	[objParser release];objParser=nil;
	if([self.timerForFlash isValid])
	{
		[self.timerForFlash invalidate];
		[_timerForFlash release];
		_timerForFlash = nil;
	}
	[_imageViewIndicator release];_imageViewIndicator = nil;
	[items release];
	[super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	objParser = [[JSONParser alloc] init];
	objParser.delegate = self;
  	HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	HUD.labelText=[eEducationAppDelegate getLocalvalue:@"Please wait"];
	_imageAsynchronus = [[AsyncImageView alloc] initWithFrame:CGRectMake(224,235,260,180)];
	[self.view addSubview:_imageAsynchronus];
	CALayer *viewLayer = [_imageAsynchronus layer];
	[viewLayer setBorderWidth:2.0f];
	[viewLayer setBorderColor:[[UIColor blackColor]CGColor]];
	[viewLayer setMasksToBounds:TRUE];
	[viewLayer setCornerRadius:5.0];
	self.btn_Play=[UIButton buttonWithType:UIButtonTypeCustom];
	self.btn_Play.frame=CGRectMake(326, 300, 57, 57);
	[self.btn_Play setImage:[UIImage imageNamed:@"btn_play@2x.png"] forState:0];
	[self.btn_Play addTarget:self action:@selector(btn_PlayPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.btn_Play];
	txt_desc.font = [UIFont systemFontOfSize:13.0];
	txt_Description.font=[UIFont systemFontOfSize:13.0];
	
	self.navigationItem.hidesBackButton=YES;
	appDelegate=(eEducationAppDelegate*)[[UIApplication sharedApplication] delegate];
	carousel_VirtualVideos.type = iCarouselTypeCoverFlow;
	CALayer *viewLayer1 = [self.imageViewIndicator layer];
	[viewLayer1 setBorderWidth:2.0f];
	[viewLayer1 setBorderColor:[[UIColor clearColor] CGColor]];
	[viewLayer1 setMasksToBounds:TRUE];
	[viewLayer1 setCornerRadius:3.0];
	[self Hideall];
}

-(void)viewWillAppear:(BOOL)animated
{
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

	[self  setLocalizedText];
    [self callVideosWs];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - Webservice methods
-(void)callVideosWs{
	NSString *strURL =[WebService  GetVituvalVideosDataXml];
	NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"course_id"], @"course_id",
								 @"video", @"type",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language",
								 nil];
	[objParser sendRequestToParse:strURL params:requestData];
}

#pragma mark - Other methods
/**
 *  Load text as per selected language
 */
-(void)setLocalizedText
{
    [self.btnHome setTitle:[eEducationAppDelegate getLocalvalue:@"HOME"] forState:UIControlStateNormal];
    [self.btnModule setTitle:[[eEducationAppDelegate getLocalvalue:@"Module"] uppercaseString] forState:UIControlStateNormal];
	lbl_Videos.text=[eEducationAppDelegate getLocalvalue:@"VIDEOS"];
	lbl_VideoName.text=[NSString stringWithFormat:@"%@:",[eEducationAppDelegate getLocalvalue:@"Video"]];
	lbl_videoDescription.text=[NSString stringWithFormat:@"%@:",[eEducationAppDelegate getLocalvalue:@"Description"]];
	lbl_speckerDescription.text=[NSString stringWithFormat:@"%@:",[eEducationAppDelegate getLocalvalue:@"Speaker"]];
}

-(void)refreshview
{
	NSMutableDictionary *Dict=[videoArray objectAtIndex:0];
	lbl_VideoNameValue.text=[Dict objectForKey:@"video_name"];
	
	if(![[Dict objectForKey:@"speaker_desc"] isKindOfClass:[NSNull class]] && ![[Dict objectForKey:@"speaker_desc"]isEqualToString:@"(null)"])
	{
		txt_desc.text=[Dict objectForKey:@"speaker_desc"];
	}
	txt_Description.text=[Dict objectForKey:@"video_desc"];
	if(txt_Description.contentSize.height>70)
	{
		[txt_Description setScrollEnabled:YES];
		self.imageViewIndicator.hidden = NO;
	}
	else
	{
		[txt_Description setScrollEnabled:NO];
		self.imageViewIndicator.hidden = YES;
	}
    [_imageAsynchronus loadImage:[UIImage imageNamed:@"no-image-522x356.png"]];
	NSURL *_URL=[[NSURL alloc] initWithString:[[Dict objectForKey:@"large_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[_imageAsynchronus loadImageFromURL:_URL imageName:@"no-image-522x356.png"];
	[_URL release];
}

-(void) Hideall
{
	_imageAsynchronus.hidden=YES;
	self.btn_Play.hidden=YES;
	lbl_VideoNameValue.hidden=YES;
	txt_desc.hidden = YES;
	txt_Description.hidden=YES;
	lbl_VideoName.hidden=YES;
	lbl_speckerDescription.hidden=YES;
	txt_desc.hidden=YES;
	lbl_videoDescription.hidden=YES;
	lbl_col3.hidden=YES;
	txt_Description.hidden=YES;
	lbl_col2.hidden=YES;
}

-(void) UnhideAll
{
	_imageAsynchronus.hidden=NO;
	self.btn_Play.hidden=NO;
	lbl_VideoNameValue.hidden=NO;
	txt_desc.hidden = NO;
	txt_Description.hidden=NO;
	lbl_VideoName.hidden=NO;
	lbl_speckerDescription.hidden=NO;
	txt_desc.hidden=NO;
	lbl_videoDescription.hidden=NO;
	lbl_col3.hidden=NO;
	txt_Description.hidden=NO;
	lbl_col2.hidden=NO;
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
}
-(IBAction)btnPDF_clicked:(UIButton *)sender{
	[self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -
#pragma mark JSONParser delegate method
- (void)parserDidFinishLoadingReturnData:(NSString *)responseString
{
	SBJSON *json = [[SBJSON new] autorelease];	
	videoArray = [[NSMutableArray alloc]initWithArray:[json objectWithString:responseString error:nil]];
    //NSLog(@"%@",responseString);
	if([videoArray count])
	{
		if([[[videoArray objectAtIndex:0] objectForKey:@"success"] isEqualToString:@"0"])
		{
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"No videos are available For this course."] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
			alert.tag = 1111;
			[alert show];
			[alert release];
		}
		else
		{
			[self UnhideAll];
			[carousel_VirtualVideos reloadData];
			[carousel_VirtualVideos scrollToItemAtIndex:0 animated:NO];
			[self refreshview];
		}
	}
	else {
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"No videos are available For this course."] delegate:nil cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	[HUD hide:YES];
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
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	if(alertView.tag==TAG_FailError){
		if(buttonIndex==0)
			[appDelegate GoTOLoginScreen:YES];
	}
	if(alertView.tag == 1111){
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if((alertView.tag == TAG_ALERT_LOGOUT && buttonIndex ==1) || alertView.tag == 33){
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
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    if([[[videoArray objectAtIndex:0] valueForKey:@"success"] isEqualToString:@"1"]){
        return [videoArray count];
    } else {
        return 0;
    }
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
	NSMutableDictionary *Dict=[videoArray objectAtIndex:index];
	
	reflectionView=[[ReflectionView alloc] initWithFrame:CGRectMake(0,0, 108,138)];
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame=CGRectMake(0, 0, reflectionView.frame.size.width, reflectionView.frame.size.height);
	[button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
	button.tag = index;
	AsyncImageView *async_iamge = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height)];
	[async_iamge loadImageFromURL:[NSURL URLWithString:[[Dict objectForKey:@"video_image"]stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation]] imageName:@"no-image-224x316.png"];
	CALayer *viewLayer = [async_iamge layer];
	[viewLayer setBorderWidth:2.0f];
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
    return ITEM_SPACING;
}

- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
{
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    //do 3d transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = self.carousel_VirtualVideos.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * carousel_VirtualVideos.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return NO;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    if ([videoArray count] == 0) return;
	[carousel_VirtualVideos reloadData];
	NSMutableDictionary *Dict=[videoArray objectAtIndex:carousel.currentItemIndex];
	lbl_VideoNameValue.text=[Dict objectForKey:@"video_name"];
	if(![[Dict objectForKey:@"speaker_desc"] isKindOfClass:[NSNull class]] && ![[Dict objectForKey:@"speaker_desc"]isEqualToString:@"(null)"])
	{
		txt_desc.text=[Dict objectForKey:@"speaker_desc"];
	}
	if(![[Dict objectForKey:@"video_desc"] isKindOfClass:[NSNull class]])
	{
		txt_Description.text=[Dict objectForKey:@"video_desc"];
	}
	self.imageViewIndicator.frame = CGRectMake(txt_Description.frame.origin.x+txt_Description.frame.size.width-7, txt_Description.frame.origin.y+3, 6, 35);
	if(txt_Description.contentSize.height>70)
	{
		[txt_Description setScrollEnabled:YES];
		self.imageViewIndicator.hidden = NO;
	}
	else 
	{
		[txt_Description setScrollEnabled:NO];
		self.imageViewIndicator.hidden = YES;
	}
    if (![[Dict objectForKey:@"video_desc"] isKindOfClass:[NSNull class]] && [[[videoArray objectAtIndex:0] valueForKey:@"success"] isEqualToString:@"1"]) {
        NSURL *_URL=[[NSURL alloc] initWithString:[([Dict objectForKey:@"large_image"])?[Dict objectForKey:@"large_image"]:@"" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [_imageAsynchronus loadImageFromURL:_URL imageName:@"no-image-522x356.png"];
        [_URL release];
    }
}

#pragma mark -
#pragma mark Button tap event

- (void)buttonTapped:(UIButton *)sender
{
}

#pragma mark -
#pragma mark orientation Life Cycle
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return NO;
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		self.btnVideos.frame=CGRectMake(387, 72, 362, 105);
		lbl_Videos.frame=CGRectMake(22, 26, 166, 22);
		lbl_VideoName.frame=CGRectMake(360, 214, 80, 22);
		lbl_VideoNameValue.frame=CGRectMake(460,214,253,22);
		lbl_speckerDescription.frame=CGRectMake(360,243,80, 22);
		txt_desc.frame = CGRectMake(452,238,250,60);
		if(txt_desc.contentSize.height < txt_desc.frame.size.height){
			lbl_videoDescription.frame=CGRectMake(360, txt_desc.frame.origin.y+txt_desc.contentSize.height+5,80, 22);
			lbl_col3.frame=CGRectMake(445,txt_desc.frame.origin.y+txt_desc.contentSize.height+5,12,22);
			txt_Description.frame = CGRectMake(452,txt_desc.frame.origin.y+txt_desc.contentSize.height,250, 60);
		}
		else{ 
			lbl_videoDescription.frame=CGRectMake(360,308,80, 22);
			lbl_col3.frame=CGRectMake(445,308,12,22);
			txt_Description.frame = CGRectMake(452, 304, 250, 60);
		}
		carousel_VirtualVideos.frame=CGRectMake(22, 519, 689, 173);
		self.btn_Play.frame=CGRectMake(152, 263, 57, 57);
		_imageAsynchronus.frame=CGRectMake(45,193, 272,196);
		lbl_col2.frame=CGRectMake(445, 243, 12, 22);
		self.imageViewIndicator.frame = CGRectMake(txt_Description.frame.origin.x+txt_Description.frame.size.width-7, txt_Description.frame.origin.y+3, 6, 35);
	}
	else 
	{
		lbl_Videos.frame=CGRectMake(166.5, 26, 166, 22);
		lbl_VideoName.frame=CGRectMake(504.5, 214, 80, 22);
		lbl_VideoNameValue.frame=CGRectMake(601.5, 214, 253, 22);
		lbl_speckerDescription.frame=CGRectMake(504.5, 243,80, 22);
		txt_desc.frame = CGRectMake(595.5, 238, 250, 60);
		if(txt_desc.contentSize.height<txt_desc.frame.size.height){
			lbl_videoDescription.frame=CGRectMake(504.5, txt_desc.frame.origin.y+txt_desc.contentSize.height+5,80, 22);
			lbl_col3.frame=CGRectMake(586.5,txt_desc.frame.origin.y+txt_desc.contentSize.height+5,12,22);
			txt_Description.frame = CGRectMake(595.5, txt_desc.frame.origin.y+txt_desc.contentSize.height, 250, 60);
		}
		else {
			lbl_videoDescription.frame=CGRectMake(504.5,308,80, 22);
			lbl_col3.frame=CGRectMake(586.5,308,12,22);
			txt_Description.frame = CGRectMake(595.5, 304, 250, 60);
		}
		carousel_VirtualVideos.frame=CGRectMake(166.5, 519, 689, 173);
		lbl_col2.frame=CGRectMake(586.5, 243, 12, 22);
		self.imageViewIndicator.frame = CGRectMake(txt_Description.frame.origin.x+txt_Description.frame.size.width-7, txt_Description.frame.origin.y+3, 6, 35);
	}
}

-(IBAction) btn_PlayPressed:(id)sender
{//NSLog(@"%@",[videoArray description]);
   // if ([[videoArray objectAtIndex:carousel_VirtualVideos.currentItemIndex] objectForKey:@"video_url"] == nil || [[[videoArray objectAtIndex:carousel_VirtualVideos.currentItemIndex] valueForKey:@"video_url"] length]==0) {
    if ([[videoArray objectAtIndex:carousel_VirtualVideos.currentItemIndex] objectForKey:@"vimeo"] == nil || [[[videoArray objectAtIndex:carousel_VirtualVideos.currentItemIndex] valueForKey:@"vimeo"] length]==0) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"Requested video is not found in server please try again."] delegate:nil cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]  otherButtonTitles:nil];
        [alert show];
        [alert release];
    } else {
        YouTubePlayer *objYouTubePlayer = [[YouTubePlayer alloc] initWithNibName:@"YouTubePlayer" bundle:nil];
        objYouTubePlayer.strMovieURL =[[videoArray objectAtIndex:carousel_VirtualVideos.currentItemIndex] objectForKey:@"vimeo"];
        objYouTubePlayer.strTitle =[[videoArray objectAtIndex:carousel_VirtualVideos.currentItemIndex] objectForKey:@"video_name"];
        objYouTubePlayer.playedFromLocal=NO;
        objYouTubePlayer.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:objYouTubePlayer animated:YES];
        [objYouTubePlayer release];
    }
}

-(void)didDismissModalViewController
{
	[self viewWillAppear:YES];
}

-(IBAction)btnBooks_clicked:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
	self.imageViewIndicator.hidden = YES;
	
}// called on finger up as we are moving
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}

-(IBAction)btncourse_clicked:(id)sender
{
}

#pragma mark -
#pragma mark Memory Management
- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

@end
