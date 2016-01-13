    //
//  ForumDetail.m
//  eEducation
//
//  Created by hb12 on 07/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ForumDetail.h"
#import"ForumDetailCustomCell.h"
#import"Settings.h"
#import "WebService.h"
#import <QuartzCore/QuartzCore.h>
#import "Forum.h"
@implementation ForumDetail
@synthesize _stringTopicId;
@synthesize string_ForumName;
- (void)viewDidLoad 
{
    [super viewDidLoad];
	appDelegate=(eEducationAppDelegate*)[[UIApplication sharedApplication]delegate];
	[tblView setBackgroundView:nil];
	[tblView setBackgroundView:[[[UIView alloc] init] autorelease]];
	[tblView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[tblView setSeparatorColor:[UIColor clearColor]];

	objParser = [[JSONParser alloc] init];
	objParser.delegate = self;
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
    HUD.labelText = [eEducationAppDelegate getLocalvalue:@"Please wait"];
	_dateFormater=[[NSDateFormatter alloc] init];
    [_dateFormater setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
	[self callWebService];
}

-(void)callWebService{
	[HUD show:YES];
	NSString *strURL = [WebService getForumDetail];
	NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:                                 
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"], @"user_id",
								 _stringTopicId, @"topic_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language",
								 nil];	
	[objParser sendRequestToParse:strURL params:requestData];
}

-(void) viewWillAppear:(BOOL)animated
{
	[tblView reloadData];
	[buttonResponder setImage:[eEducationAppDelegate GetLocalImage:@"btn_responder1"] forState:UIControlStateNormal];
	[buttonResponder setImage:[eEducationAppDelegate GetLocalImage:@"btn_Responder1_h"] forState:UIControlStateHighlighted];
	[btnCourse setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"course_name"] forState:UIControlStateNormal];
	[btnForum setTitle:[eEducationAppDelegate getLocalvalue:@"Forum"] forState:UIControlStateNormal];
	//[btnThread setTitle:string_ForumName forState:UIControlStateNormal];
	CALayer *layer=[titleImgView layer];
	[layer setBorderColor:[[UIColor blackColor]CGColor]];
	[layer setBorderWidth:2];
	[layer setCornerRadius:15];
	lblTitle.text=string_ForumName;
	self.navigationController.navigationBar.hidden=NO;
	[self.navigationItem setHidesBackButton:YES];
	[self.navigationController.navigationBar viewWithTag:BUTTON_HOME_TAG].hidden=NO;
	[(UILabel *)[self.navigationController.navigationBar viewWithTag:LABEL_TITLE_TAG] setText:[eEducationAppDelegate getLocalvalue:@"Forum"]];
	[self willAnimateRotationToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0];	
}

- (void)parserDidFinishLoadingReturnData:(NSString *)responseString
{
	SBJSON *json = [[SBJSON new]autorelease];	
	if(isPostData){
		
	 NSMutableArray *responseArray=[[NSMutableArray alloc]initWithArray:[json objectWithString:responseString error:nil]];
		if([responseArray count]){
			if([[[responseArray objectAtIndex:0] objectForKey:@"success"] isEqualToString:@"1"]){
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"Comment add succesfully"] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
				alert.tag=105;
				[alert show];
				[alert release]; 
			}else{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:[[responseArray objectAtIndex:0] objectForKey:@"message"] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
				alert.tag=106;
				[alert show];
				[alert release];
			}
		}
		[responseArray release];
	}else{
		documentArray = [[NSMutableArray alloc]initWithArray:[json objectWithString:responseString error:nil]];
		if([documentArray count]){
			if([[[documentArray objectAtIndex:0] objectForKey:@"success"] isEqualToString:@"0"]){
				documentArray=nil;
			}
			else{
				NSSortDescriptor *aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dtPostedDate" ascending:YES];
				[documentArray sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
				[aSortDescriptor release];
				[tblView reloadData];
			}
		}
	}
	[HUD hide:YES];
}

- (void)parserDidFailWithRestoreError:(NSError*)error
{
	[HUD hide:YES];
	//documentArray=nil;
	isPostData=FALSE;
	NSString *strMsg = [eEducationAppDelegate getLocalvalue:@"The server cannot be reached. It could be down or busy. Please try again later."];
	UIAlertView *AlertView =  [[UIAlertView alloc]  initWithTitle:alertTitle message:strMsg delegate:nil 	cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil, nil];
	AlertView.tag=TAG_FailError;
	[AlertView show];
	[AlertView release];
}

#pragma mark -
#pragma mark Action Method

-(IBAction)btnForum_Clicked:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnCourse_Clicked:(id)sender
{
//	[appDelegate.window addSubview:appDelegate.navigationController.view];   
//	[appDelegate.tabBarController.view removeFromSuperview];
}

#pragma mark -
#pragma mark tableView Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [documentArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if([[[documentArray objectAtIndex:section]objectForKey:@"comment"] isKindOfClass:[NSString class]]){
		return 1;
	}else
		return [[[documentArray objectAtIndex:section] objectForKey:@"comment"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	static NSString *CellIdentifier = @"ForumDetailCustomCell";
    ForumDetailCustomCell *cell = (ForumDetailCustomCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil)
//	{
//		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ForumDetailCustomCell" owner:self options:nil];
//		for (id currentObject in topLevelObjects)
//		{
//			if ([currentObject isKindOfClass:[UITableViewCell class]])
//			{
//				cell =  (ForumDetailCustomCell *) currentObject;
//				break;
//			}
//		}
//	}
//	cell=[self setMessageDetailCell:cell _indexPath:indexPath];
//	cell.lbl_Date.text=[eEducationAppDelegate getLocalvalue:@"Date"];
//	
//	if([[[documentArray objectAtIndex:indexPath.section]objectForKey:@"comment"] isKindOfClass:[NSString class]])
//	{
//		[_dateFormater setDateFormat:@"MMMM dd,yyyy hh:mm a"];
//		cell.lbl_StudentName.text=[[documentArray objectAtIndex:indexPath.section] objectForKey:@"Student_name"];
//		cell.txt_Description.text=[eEducationAppDelegate getLocalvalue:@"No comment avabilable for current topic."];
//		NSDate *date=[_dateFormater dateFromString:[[documentArray objectAtIndex:indexPath.section] objectForKey:@"date"]]; 
//		[_dateFormater setDateFormat:@"dd-MM-YYYY"];
//		cell.lbl_DateValue.text=[_dateFormater stringFromDate:date];
//	}
//	else  {
//		cell.lbl_StudentName.text=[[[[documentArray objectAtIndex:indexPath.section] objectForKey:@"comment"] objectAtIndex:indexPath.row] objectForKey:@"postedbyname"];
//		//NSData *data_latin1 = [[[[[documentArray objectAtIndex:indexPath.section] objectForKey:@"comment"] objectAtIndex:indexPath.row] objectForKey:@"tComment"] dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:YES];
////		NSString * description = [[NSString alloc] initWithData:data_latin1 encoding:NSASCIIStringEncoding];
//		cell.txt_Description.text=[[[[documentArray objectAtIndex:indexPath.section] objectForKey:@"comment"] objectAtIndex:indexPath.row] objectForKey:@"tComment"];
//		[_dateFormater setDateFormat:@"MMMM dd,yyyy hh:mm a"];
//		[_dateFormater setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
//		NSDate *date=[_dateFormater dateFromString:[[[[documentArray objectAtIndex:indexPath.section] objectForKey:@"comment"] objectAtIndex:indexPath.row] objectForKey:@"dtPostedDate"]]; 		
//		[_dateFormater setDateFormat:@"dd-MM-YYYY"];
//		cell.lbl_DateValue.text=[_dateFormater stringFromDate:date];
//	}
//	cell.backgroundColor=[UIColor clearColor];
	return cell;
}


-(ForumDetailCustomCell*)setMessageDetailCell:(ForumDetailCustomCell *)cell _indexPath:(NSIndexPath*)_indexPath{

	int	count=0;
	float hight = 95;
	if([[[documentArray objectAtIndex:_indexPath.section]objectForKey:@"comment"] isKindOfClass:[NSString class]])
	{
		
	}else{
	  	description=[[[[documentArray objectAtIndex:_indexPath.section] objectForKey:@"comment"] objectAtIndex:_indexPath.row] objectForKey:@"tComment"];
		NSArray *arr=[[[[[documentArray objectAtIndex:_indexPath.section] objectForKey:@"comment"] objectAtIndex:_indexPath.row] objectForKey:@"tComment"] componentsSeparatedByString:@"\n"];
		count   = [arr count]-1;
	}
	CGSize  textSize = {650, 10000.0 };
	CGSize size = [description sizeWithFont:[UIFont systemFontOfSize:14]
						  constrainedToSize:textSize 
							  lineBreakMode:UILineBreakModeWordWrap];
	//size.height += 60;
	hight = size.height;
	
	if([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown ){
		
//		cell.frame=CGRectMake(0, 0, 700,count+hight+80);
//		cell.backgroundiimg.frame=CGRectMake(0, 0, 700,count+hight+70);
//		cell.seperaterimg.frame=CGRectMake(1, 45, 698,1);
//		cell.lbl_Date.frame=CGRectMake(529, 16, 47, 23);
//		cell.lbl_DateValue.frame=CGRectMake(595, 17, 200, 23);
//		cell.txt_Description.frame=CGRectMake(12, 47,685,count+hight+10);		
//		cell.col1.frame=CGRectMake(583.5, 16, 5, 23);
	}
	else{
//		cell.frame=CGRectMake(0, 0, 950,count+hight+80);
//		cell.backgroundiimg.frame=CGRectMake(0, 0, 950,count+70+hight);
//		
//		cell.seperaterimg.frame=CGRectMake(1,45,948,1);
//		cell.lbl_Date.frame=CGRectMake(784, 16, 47, 23);
//		cell.col1.frame=CGRectMake(838.5, 16, 5, 23);
//		cell.lbl_DateValue.frame=CGRectMake(850, 17, 200, 23);
//		cell.txt_Description.frame=CGRectMake(12, 47,935, count+hight+10);	
	}
//	[self setLayer:cell.backgroundiimg];
	return cell;
	
}

- (void)setLayer:(UIImageView *)imageView{
	CALayer *layer=[imageView layer];
	[layer setCornerRadius:10];
	[layer setBorderColor:[[UIColor colorWithRed:54/255.0 green:56/255.0 blue:55/255.0 alpha:1] CGColor]];
	[layer setBorderWidth:2.2];
	[layer setMasksToBounds:YES];
}

-(void)alertShow{
	UIAlertView *alert=[[UIAlertView alloc]initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"No comment avabilable for current topic."] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
	alert.tag=101;
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	if(buttonIndex ==0){		
		if(alertView.tag==105)
		{
			isPostData=FALSE;
			[self callWebService];
		}
		else if(alertView.tag==101)
		{
			isalertShow=TRUE;
		}
		else if(alertView.tag==333)
		{
			[textViewComment becomeFirstResponder];
		}else if(alertView.tag==TAG_FailError){
			[appDelegate GoTOLoginScreen:NO];
		}
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     float hight = 95;
	int	count=0;
	if([[[documentArray objectAtIndex:indexPath.section]objectForKey:@"comment"] isKindOfClass:[NSString class]])
	{
		description= @"No comment avabilable for current topic.";
	}else{
	  	description=[[[[documentArray objectAtIndex:indexPath.section] objectForKey:@"comment"] objectAtIndex:indexPath.row] objectForKey:@"tComment"];
		NSArray *arr=[[[[[documentArray objectAtIndex:indexPath.section] objectForKey:@"comment"] objectAtIndex:indexPath.row] objectForKey:@"tComment"] componentsSeparatedByString:@"\n"];
		count   = [arr count]-1;
	}
	CGSize  textSize = {650.0, 10000.0};
	CGSize size = [description sizeWithFont:[UIFont systemFontOfSize:14]
						  constrainedToSize:textSize 
							  lineBreakMode:UILineBreakModeWordWrap];
	hight = size.height;
	return (count+72+hight);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark orientation Life Cycle

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[popoverController dismissPopoverAnimated:YES];
	
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		btnForum.frame=CGRectMake(388, 4, 149, 45);
		btnCourse.frame=CGRectMake(231, 4, 149, 45);
		btnThread.frame=CGRectMake(469, 4, 149, 45);
		tblView.frame=CGRectMake(-10, 118,820, 720);
		
	}
	else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight )
	{
		btnForum.frame=CGRectMake(515, 4, 149, 45);
		btnCourse.frame=CGRectMake(358, 4, 149, 45);
		btnThread.frame=CGRectMake(600, 4, 149, 45);
		tblView.frame=CGRectMake(-10, 115, 1035, 485);
		[tblView setContentInset:UIEdgeInsetsMake(-18, 0, 0, 0)];
		[tblView setScrollIndicatorInsets:UIEdgeInsetsMake(-18, 0, 0, 0)];
	}
	[tblView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return NO;
}

-(IBAction)btnResponder:(id)sender{
	[self createPopover];
}

-(void)createPopover{
	UIViewController* popoverContent = [[UIViewController alloc] init];	
	UIView* popoverView = [[UIView alloc] init];
	UIImageView *imageBackGround=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
	imageBackGround.image=[UIImage imageNamed:@"box_s10B.png"];
	[popoverView addSubview: imageBackGround];
	[imageBackGround release];
	pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,500,44)];
	pickerToolbar.barStyle = UIBarStyleBlack;
	NSMutableArray *barItems = [[NSMutableArray alloc] init];
	UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:[eEducationAppDelegate getLocalvalue:@"Cancel"] style:UIBarButtonSystemItemCancel target:self action:@selector(cancel_clicked:)];
	[barItems addObject:cancelBtn];
	[cancelBtn release];
	UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[barItems addObject:flexSpace];
	[flexSpace release];
	UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:[eEducationAppDelegate getLocalvalue:@"Done"] style:UIBarButtonItemStyleDone target:self action:@selector(done_clicked:)];
	[barItems addObject:doneBtn];
	[doneBtn release];
	[pickerToolbar setItems:barItems animated:YES];	
	[popoverView addSubview:pickerToolbar];
	[pickerToolbar release];
	[barItems release];
	
	UILabel *lablDate = [[UILabel alloc] initWithFrame:CGRectMake(380, 47 ,250,30)];
	lablDate.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
	lablDate.backgroundColor=[UIColor clearColor];
	NSDateFormatter *dateFormater=[[NSDateFormatter alloc] init];
    [dateFormater setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
	[dateFormater setDateFormat:@"dd MMM yyyy"];
	lablDate.text= [dateFormater stringFromDate:[NSDate date]];
	[popoverView addSubview:lablDate];
	[lablDate release];
	[dateFormater release];
	
	UILabel *lablUser = [[UILabel alloc] initWithFrame:CGRectMake(15, 47 ,150,30)];
	lablUser.backgroundColor=[UIColor clearColor];
	lablUser.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
	lablUser.text=[[documentArray objectAtIndex:0] objectForKey:@"Student_name"];
	[popoverView addSubview:lablUser];
	[lablUser release];
	
	textViewComment = [[UITextView alloc]initWithFrame:CGRectMake(15, 80 ,470,290)];
	textViewComment.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
	textViewComment.backgroundColor=[UIColor clearColor];
	CALayer *layer=[textViewComment layer];
	layer.cornerRadius=10;
	layer.borderWidth=2;
	labPlaceholder=[[UILabel alloc] initWithFrame:CGRectMake(8,2,470,30)];
    labPlaceholder.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    labPlaceholder.text=[eEducationAppDelegate getLocalvalue:@"Enter comment here"];
    labPlaceholder.backgroundColor=[UIColor clearColor];
    labPlaceholder.textColor=[UIColor lightGrayColor];
	textViewComment.delegate=self;
    [textViewComment addSubview:labPlaceholder];
    [textViewComment resignFirstResponder];
	
	
	[popoverView addSubview:textViewComment];
	popoverContent.view = popoverView;
	popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
	[popoverController setPopoverContentSize:CGSizeMake(500,400) animated:NO];
	[popoverController presentPopoverFromRect:buttonResponder.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	[popoverView release];
	[popoverContent release];
}

- (void)textViewDidChange:(UITextView *)textView{
	if([textView.text length]>0){
		labPlaceholder.hidden=YES;
	}else {
		labPlaceholder.hidden=NO;
	}
	
}

-(IBAction)cancel_clicked:(id)sender{
	[popoverController dismissPopoverAnimated:YES];
	[labPlaceholder release];
	[textViewComment release];
}

-(IBAction)done_clicked:(id)sender
{
	if([textViewComment.text length]>0)
	{
		[HUD show:YES];
		[self postcommentinJson];
		[popoverController dismissPopoverAnimated:YES];
	}
	else
	{
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"Please enter comment."] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
		alert.tag=333;
		[alert show];
		[alert release];
	}
}

-(void)postcommentinJson{
	NSString *strURL=[WebService postFormData];
	isPostData=TRUE;
	NSDictionary *postDict=[[NSDictionary alloc] initWithObjectsAndKeys:
							[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],@"user_id",
							[[NSUserDefaults standardUserDefaults] objectForKey:@"course_id"],@"course_id",
							[NSString stringWithFormat:@"%@",_stringTopicId],@"topic_id",
							[NSString stringWithFormat:@"%@",textViewComment.text],@"comment",
							[[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language",
							nil];
	[objParser sendRequestToParse:strURL params:postDict];
	[postDict release];
	[labPlaceholder release];
	[textViewComment release];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
	return TRUE;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {	
	return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textField {
	return YES;
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
	[tblView release];tblView=nil;
	[titleImgView release];titleImgView=nil;
	[lblTitle release];lblTitle=nil;
	[btnCourse release];btnCourse=nil;
	[btnForum release];btnForum=nil;
	[btnThread release];btnThread=nil;
	[_stringTopicId release];_stringTopicId=nil;
	[buttonResponder release];buttonResponder=nil;
	[HUD release];HUD=nil;
	[_dateFormater release];_dateFormater=nil;
	[documentArray release];documentArray=nil;
	[popoverController release];popoverController=nil;
	[HUD release];HUD=nil;
    [super dealloc];
}

@end
