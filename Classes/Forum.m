    //
//  Forum.m
//  eEducation
//
//  Created by hb12 on 07/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Forum.h"
#import"ForumCustomCell.h"
#import"ForumDetail.h"
#import"Settings.h"
#import"LoginScreen.h"
#import "ICourseList.h"
#import "WebService.h"
@implementation Forum
@synthesize documentArray;

#pragma mark - ViewLife Cycle
- (void)viewDidLoad 
{
    [super viewDidLoad];
	appDelegate=(eEducationAppDelegate*)[[UIApplication sharedApplication]delegate];
    
	[self.tblView setBackgroundView:nil];
	[self.tblView setBackgroundView:[[UIView alloc] init]];
	[self.tblView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[self.tblView setSeparatorColor:[UIColor clearColor]];
	_dateFormater=[[NSDateFormatter alloc] init];
    [_dateFormater setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
	
	objParser = [[JSONParser alloc] init];
	objParser.delegate = self;
	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
    HUD.labelText = [eEducationAppDelegate getLocalvalue:@"Please wait"];
    
    if (IsGreaterThan_iOS6) {
        [self.tblView registerNib:[UINib nibWithNibName:@"ForumCellHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"ForumCellHeader"];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [self setUpLocalText];
    [self.lblTopCourse setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"course_name"]];
    [self.lblTopDuration setText:[NSString stringWithFormat:RTLableText,[eEducationAppDelegate getLocalvalue:@"Begins "],[eEducationAppDelegate convertString:[[NSUserDefaults standardUserDefaults] valueForKey:@"edition_start"] fromFormate:@"yyyy-MM-dd" toFormate:@"dd MMMM yyyy"],[eEducationAppDelegate getLocalvalue:@"- Ends "],[eEducationAppDelegate convertString:[[NSUserDefaults standardUserDefaults] valueForKey:@"edition_end"] fromFormate:@"yyyy-MM-dd" toFormate:@"dd MMMM yyyy"]]];

    [self.lblTitle setText:[[eEducationAppDelegate getLocalvalue:@"Forum"] uppercaseString]];
    self.lblProfileBlueName.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_name"];
    self.lblProfileGrayName.text = [eEducationAppDelegate getLocalvalue:@"WELCOME"];
    [self.imgProfile loadImageFromURL:[NSURL URLWithString:[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_profile_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:@"no-image-200x200.png"];
    [self.imgLogo loadImageFromURL:[eEducationAppDelegate getTopCourseUrl] imageName:@"top-bar-logo.png"];
    [self.imgLogoStatic loadImageFromURL:[eEducationAppDelegate getTopStaticUrl] imageName:@"logo_top_static.png"];

    [self forumListinWs];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - Other methods
-(void)setUpLocalText{
    [self.btnHome setTitle:[eEducationAppDelegate getLocalvalue:@"HOME"] forState:UIControlStateNormal];
    [self.btnCreateNewForum setTitle:[eEducationAppDelegate getLocalvalue:@"NEW MESSAGE"] forState:UIControlStateNormal];
    [self.btnCancel setTitle:[eEducationAppDelegate getLocalvalue:@"Cancel"] forState:UIControlStateNormal];
    [self.btnOkay setTitle:[eEducationAppDelegate getLocalvalue:@"OK"] forState:UIControlStateNormal];
    [self.btnModule setTitle:[[eEducationAppDelegate getLocalvalue:@"Module"] uppercaseString] forState:UIControlStateNormal];
}

-(void)showView{
    isPopUpOpened=YES;
    [self.tblView setUserInteractionEnabled:NO];
    [self.tabBarController.tabBar setUserInteractionEnabled:NO];
    self.txtTitle.placeholder = [eEducationAppDelegate getLocalvalue:@"TITLE"];
    [self.txtComment setPlaceholder:[eEducationAppDelegate getLocalvalue:@"COMMENT"]];

    if (isNewForum) {
        self.txtTitle.text = @"";
        self.txtComment.text = @"";
        self.txtTitle.userInteractionEnabled = YES;
    } else {
        self.txtComment.text = @"";
        self.txtTitle.userInteractionEnabled = NO;
    }
    
    self.viewCommentBox.frame = CGRectMake(30, 122, 706, 419);
    [self.view addSubview:self.viewCommentBox];
    
    self.viewCommentBox.alpha =0.0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone
                           forView:self.viewCommentBox
                             cache:YES];
    self.viewCommentBox.alpha =1.0;
    [UIView commitAnimations];
}

-(void)removeView{
    isPopUpOpened = NO;
    [self.tblView setUserInteractionEnabled:YES];
    [self.tabBarController.tabBar setUserInteractionEnabled:YES];

    self.viewCommentBox.alpha =1.0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone
                           forView:self.viewCommentBox
                             cache:YES];
    self.viewCommentBox.alpha =0.0;
    [UIView commitAnimations];
    [self.viewCommentBox removeFromSuperview];
}

-(double)ConvertStingdateToDouble:(NSString *)str_date
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	double doubleInDate = (double)[[dateFormatter dateFromString:str_date] timeIntervalSince1970];
	return doubleInDate;
}

-(void)createPopover{
	UIViewController* popoverContent = [[UIViewController alloc] init];	
	UIView* popoverView = [[UIView alloc] init];
	UIImageView *imageBackGround=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
	imageBackGround.image=[UIImage imageNamed:@"box_s10B.png"];
	[popoverView addSubview: imageBackGround];

	pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,500,44)];
	pickerToolbar.barStyle = UIBarStyleBlack;
	NSMutableArray *barItems = [[NSMutableArray alloc] init];
	UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:[eEducationAppDelegate getLocalvalue:@"Cancel"] style:UIBarButtonSystemItemCancel target:self action:@selector(cancel_clicked:)];
	[barItems addObject:cancelBtn];

	UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[barItems addObject:flexSpace];

	UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:[eEducationAppDelegate getLocalvalue:@"Done"] style:UIBarButtonItemStyleDone target:self action:@selector(done_clicked:)];
	[barItems addObject:doneBtn];
	[pickerToolbar setItems:barItems animated:YES];
	[popoverView addSubview:pickerToolbar];
	
	UILabel *lablDate = [[UILabel alloc] initWithFrame:CGRectMake(380, 47 ,250,30)];
	lablDate.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
	lablDate.backgroundColor=[UIColor clearColor];
	NSDateFormatter *dateFormater=[[NSDateFormatter alloc] init];
    [dateFormater setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
	[dateFormater setDateFormat:@"dd MMM yyyy"];
	lablDate.text= [dateFormater stringFromDate:[NSDate date]];
	[popoverView addSubview:lablDate];
	
	textViewComment = [[UITextView alloc]initWithFrame:CGRectMake(15, 80 ,470,170)];
	textViewComment.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
	textViewComment.backgroundColor=[UIColor clearColor];
	CALayer *layer=[textViewComment layer];
	layer.cornerRadius=10;
	layer.borderWidth=2;
	labPlaceholder=[[UILabel alloc] initWithFrame:CGRectMake(8,2,470,30)];
    labPlaceholder.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    labPlaceholder.text=[eEducationAppDelegate getLocalvalue:@"Enter topic name.."];
    labPlaceholder.backgroundColor=[UIColor clearColor];
    labPlaceholder.textColor=[UIColor lightGrayColor];
	textViewComment.delegate=self;
    [textViewComment addSubview:labPlaceholder];
    [textViewComment resignFirstResponder];
	
	
	[popoverView addSubview:textViewComment];
	popoverContent.view = popoverView;
	popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
	[popoverController setPopoverContentSize:CGSizeMake(500,300) animated:NO];
	[popoverController presentPopoverFromRect:self.btnCreateNewForum.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)cancel_clicked:(id)sender
{
	[popoverController dismissPopoverAnimated:YES];
}

-(void)done_clicked:(id)sender{
		
	if([textViewComment.text length]>0)
    {
	  [HUD show:YES];
	  [self postcommentinJson];
	 [popoverController dismissPopoverAnimated:YES];
	}else
	{
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"Please enter topic name."] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
		alert.tag=333;
		[alert show];
	}
}

#pragma mark - Call webservice
-(void)forumListinWs{
    [HUD show:YES];
    NSString *strURL = [WebService getForumList];
    NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [[NSUserDefaults standardUserDefaults] objectForKey:@"course_id"],@"course_id",
                                 [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] ,@"user_id",
                                 [[NSUserDefaults standardUserDefaults] objectForKey:@"editonid"],@"edition_id",
                                 [[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language",
                                 nil];
    objParser.wsName = @"ForumListing";
    [objParser sendRequestToParse:strURL params:requestData];
}

-(void)postcommentinJson
{
	NSString *strURL=[WebService addNewtopic];
	isPostData=TRUE;
	NSDictionary *postDict=[[NSDictionary alloc] initWithObjectsAndKeys:
							[[NSUserDefaults standardUserDefaults] objectForKey:@"course_id"],@"course_id",
							[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] ,@"user_id",
							[[NSUserDefaults standardUserDefaults] objectForKey:@"editonid"],@"edition_id",
							[NSString stringWithFormat:@"%@",self.txtTitle.text],@"topic_name",
							[[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language",
                            [NSString stringWithFormat:@"%@",self.txtComment.text],@"comment",
							nil];
    objParser.wsName = @"CreateForum";
	[objParser sendRequestToParse:strURL params:postDict];
}

-(void)commenInForumWs{
	NSString *strURL=[WebService postFormData];
	NSDictionary *postDict=[[NSDictionary alloc] initWithObjectsAndKeys:
							[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],@"user_id",
							[[NSUserDefaults standardUserDefaults] objectForKey:@"course_id"],@"course_id",
							[NSString stringWithFormat:@"%@",selectedForumId],@"topic_id",
							[NSString stringWithFormat:@"%@",self.txtComment.text],@"comment",
							[[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language",
							nil];
    objParser.wsName = @"ForumComment";
	[objParser sendRequestToParse:strURL params:postDict];
}

#pragma mark - TextField Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
	return TRUE;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {	return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textField {
	return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
	if([textView.text length]>0){
		labPlaceholder.hidden=YES;
	}else {
		labPlaceholder.hidden=NO;
	}
}

#pragma mark - Action methods
-(IBAction)btnCreateNewForumClicked:(id)sender{
    isNewForum = YES;
    [self showView];
}
-(IBAction)btnReplyClicked:(id)sender{
    isNewForum = NO;
    self.txtTitle.text = selectedForumTitle;
    [self showView];
}

-(IBAction)btnCancelClicked:(id)sender{
    [self removeView];
}

-(IBAction)btnOkayClicked:(id)sender{
    
    if([self.txtTitle.text length] == 0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"Enter forum title."] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
		alert.tag=TAG_ALERT_TITLEWRONG;
		[alert show];
	} else if(![validations isValidData:self.txtTitle.text])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"Please enter valid forum title."] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
		alert.tag=TAG_ALERT_TITLEWRONG;
		[alert show];
	} else if(![validations isValidData:self.txtComment.text])
	{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"Please enter valid comment."] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
		alert.tag=TAG_ALERT_COMMENTWRONG;
		[alert show];
	} else {
        [self removeView];
        [HUD show:YES];
        isNewForum?[self postcommentinJson]:[self commenInForumWs];
    }
}

#pragma mark -
#pragma mark Topbar Action methods
-(IBAction)btnBackClicked:(id)sender{
    if (!isPopUpOpened) {
        @try {
            [[validations getAppDelegateInstance].navigationController popToViewController:[[validations getAppDelegateInstance].navigationController.viewControllers objectAtIndex:2] animated:NO];
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
    }
}

-(IBAction)proImgClicked:(id)sender{
    [self btnSettingsClicked:nil];
}

-(IBAction)btnStudentsClicked:(id)sender{
    if (!isPopUpOpened) {
        OtherStudents *objOtherStudents = [[OtherStudents alloc] initWithNibName:@"OtherStudents" bundle:nil];
        [[validations getAppDelegateInstance] removePresentVC];
        [[validations getAppDelegateInstance].navigationController pushViewController:objOtherStudents animated:NO];
    }
}

-(IBAction)btnSettingsClicked:(id)sender{
    if (!isPopUpOpened) {
        Settings *objSettings = [[Settings alloc] initWithNibName:@"Settings" bundle:nil];
        [[validations getAppDelegateInstance] removePresentVC];
        [[validations getAppDelegateInstance].navigationController pushViewController:objSettings animated:NO];
    }
}

-(IBAction)btnLogoutClicked:(id)sender{
    if (!isPopUpOpened) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"You're about to logout, are you sure?"] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"NO"]  otherButtonTitles:[eEducationAppDelegate getLocalvalue:@"YES"],nil];
        [alert show];
        alert.tag=TAG_ALERT_LOGOUT;
    }
}
-(IBAction)btnModuleClicked:(id)sender{
    if (!isPopUpOpened) {
        ModuleHomePage *objModuleListHomePage=[[ModuleHomePage alloc] initWithNibName:@"ModuleHomePage" bundle:nil];
        [[validations getAppDelegateInstance] removePresentVC];
        [[validations getAppDelegateInstance].navigationController pushViewController:objModuleListHomePage animated:NO];
    }
}

#pragma mark -
#pragma mark tableView Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [self.documentArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if (section == didSection) {
        return self.arrSelectedForumComments.count+1; //self.documentArray.count
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (indexPath.row == self.arrSelectedForumComments.count) { 
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [self.btnReply setTitle:[eEducationAppDelegate getLocalvalue:@"LEAVE COMMENT"] forState:UIControlStateNormal];
        [cell addSubview:self.replyCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
	static NSString *CellIdentifier = @"ForumDetailCustomCell";
	ForumDetailCustomCell *cell = (ForumDetailCustomCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
        cell = (ForumDetailCustomCell*)[[[NSBundle mainBundle] loadNibNamed:@"ForumDetailCustomCell" owner:self options:nil] lastObject];
        cell.backgroundColor = [UIColor whiteColor];
	}
	if (indexPath.row == 0) {
        [cell.imgBackGround setImage:[UIImage imageNamed:@"strip_top_s7A@2x-1.png"]];
    } else if (indexPath.row == self.arrSelectedForumComments.count) { // self.documentArray.count
        [cell.imgBackGround setImage:[UIImage imageNamed:@"strip_bot_s7A@2x-1.png"]];
    } else {
        [cell.imgBackGround setImage:[UIImage imageNamed:@"strip_ctr_s7A@2x-1.png"]];
    }
    NSString *str = [NSString stringWithFormat:@"%@ %@",[eEducationAppDelegate getLocalvalue:@"Date:"],[eEducationAppDelegate convertString:[eEducationAppDelegate getValurForKey:[self.arrSelectedForumComments objectAtIndex:indexPath.row] :@"dtPostedDate"] fromFormate:@"MMMM dd, yyyy hh:mm a" toFormate:@"dd / MM / yyyy"]];
	cell.lbl_Date.text = str;
	cell.lbl_StudentName.text=[eEducationAppDelegate getValurForKey:[self.arrSelectedForumComments objectAtIndex:indexPath.row] :@"postedbyname"];
    cell.txt_Comment.text = [eEducationAppDelegate getValurForKey:[self.arrSelectedForumComments objectAtIndex:indexPath.row] :@"tComment"];
    [cell.imgProfile loadImageFromURL:[NSURL URLWithString:[[eEducationAppDelegate getValurForKey:[self.arrSelectedForumComments objectAtIndex:indexPath.row] :@"profile_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:@"no-image-200x200.png"];
    
	return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (false) {//Cambiado "IsGreaterThan_iOS6" por "false"
        ForumCellHeader *header=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ForumCellHeader"];
        header.backgroundColor = [UIColor redColor];
        
        header.lblTopic.text = [[self.documentArray objectAtIndex:section] objectForKey:@"topic_name"];
        header.lblName.text = [[self.documentArray objectAtIndex:section] objectForKey:@"post_by"];
        [header.imgView loadImage:[UIImage imageNamed:@"no-image_s3-1.png"]];
        header.btnComments.tag = section;
        [header.btnComments addTarget:self action:@selector(addCell:) forControlEvents:UIControlEventTouchUpInside];
        return header;
    } else{
        ForumCell *header = [[ForumCell alloc] initWithFrame:CGRectMake(20, 0, 768, 240)];
        
        header.lblTopic.text = [[self.documentArray objectAtIndex:section] objectForKey:@"topic_name"];
        header.lblName.text =[eEducationAppDelegate getValurForKey:[self.documentArray objectAtIndex:section] :@"postedbyname"];
        
        header.txtFirstComment.text =[eEducationAppDelegate getValurForKey:[self.documentArray objectAtIndex:section] :@"last_comment"];
        
        [header.btnComments setTitle:[NSString stringWithFormat:@"%@ %@",[eEducationAppDelegate getValurForKey:[self.documentArray objectAtIndex:section] :@"total_comments"],[eEducationAppDelegate getLocalvalue:@"COMMENTS"]] forState:UIControlStateNormal];
        
        NSString *str = [NSString stringWithFormat:@"%@ %@",[eEducationAppDelegate getLocalvalue:@"Date:"],[eEducationAppDelegate convertString:[[self.documentArray objectAtIndex:section] objectForKey:@"post_date"] fromFormate:@"yyyy-MM-dd HH:mm:ss" toFormate:@"dd / MM / yyyy"]];
        header.lblDate.text = str;
        NSString *strImg = [eEducationAppDelegate getValurForKey:[self.documentArray objectAtIndex:section] :@"profile_image"];
        if ([strImg length] == 0)
        {
        }
        [header.imgView loadImageFromURL:[NSURL URLWithString:[strImg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:@"no-image-200x200.png"];
        header.btnComments.tag = section;
        header.btnForCellTap.tag = section+10001;
        [header.btnComments addTarget:self action:@selector(addCell:) forControlEvents:UIControlEventTouchUpInside];
        [header.btnForCellTap addTarget:self action:@selector(addCell:) forControlEvents:UIControlEventTouchUpInside];
        
        if (section == didSection) {
            header.btnForCellTap.userInteractionEnabled = YES;
            header.btnComments.hidden = YES;
        } else {
            header.btnForCellTap.userInteractionEnabled = NO;
            header.btnComments.hidden = NO;
        }
        return header;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 240;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == didSection) {
        if (indexPath.row == self.arrSelectedForumComments.count) {
            return 55;
        }
        return 168;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - TableView helper methods
- (void)addCell:(UIButton *)bt{
    if (CGRectEqualToRect(bt.frame, CGRectMake(165,173,177,39))) {
        endSection = bt.tag;
        bt.hidden = YES;
        selectedForumId = [[self.documentArray objectAtIndex:bt.tag] valueForKey:@"topic_id"];
        selectedForumTitle = [[self.documentArray objectAtIndex:bt.tag] valueForKey:@"topic_name"];
        self.arrSelectedForumComments = [[self.documentArray objectAtIndex:bt.tag] valueForKey:@"comment"];
    }
    if (didSection==self.self.documentArray.count+1) {
        ifOpen = NO;
        didSection = endSection;
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
    else{
        if (didSection==endSection) {
            [self didSelectCellRowFirstDo:NO nextDo:NO];
        }
        else{
            [self didSelectCellRowFirstDo:NO nextDo:YES];
        }
    }
}

-(void)deleteCells{
    
    [self addCell:nil];
}

- (void)firstOneClicked{
    didSection = 0;
    endSection = 0;
    [self didSelectCellRowFirstDo:YES nextDo:NO];
}
- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert{
    ifOpen = firstDoInsert;
    if (!ifOpen) {
        didSection = self.documentArray.count+1;
    } else{
    }
    
    if (nextDoInsert) {
        didSection = endSection;
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
    [self.tblView reloadData];

    if (didSection != 0 && ifOpen) {
        [self.tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:didSection] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

#pragma mark -
#pragma mark orientation Life Cycle
-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return NO;
}

#pragma mark - AlertView Delegate methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	if(buttonIndex==0){
		if(alertView.tag==112)
		{
            [self forumListinWs];
		}
		else if(alertView.tag==TAG_ALERT_NEEDTOREFRES){
            postedCommentOrForum = YES;
			isPostData=FALSE;
            [self forumListinWs];
		}
		else if(alertView.tag==333)
		{
			[textViewComment becomeFirstResponder];
            
		} else if(alertView.tag==TAG_FailError){
			[appDelegate GoTOLoginScreen:YES];
		}
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == TAG_ALERT_LOGOUT && buttonIndex == 1){
        @try {
            [[validations getAppDelegateInstance].navigationController popToViewController:[[validations getAppDelegateInstance].navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
    } else if(alertView.tag == TAG_ALERT_TITLEWRONG){
        [self.txtTitle becomeFirstResponder];
    } else if(alertView.tag == TAG_ALERT_COMMENTWRONG){
        [self.txtComment becomeFirstResponder];
    } 
}

#pragma mark - Jshon methods
- (void)parserDidFinishLoadingReturnData:(NSString *)responseString wsName:(NSString*)wsName
{
	SBJSON *json = [SBJSON new];
	if([wsName isEqualToString:@"CreateForum"]){
		NSMutableArray *responseArray=[[NSMutableArray alloc] initWithArray:[json objectWithString:responseString error:nil]];
		if([responseArray count]>0){
			if([[[responseArray objectAtIndex:0] objectForKey:@"success"] isEqualToString:@"1"]){
				UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"Forum Topic Posted Successfully"] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
				alert.tag=112;
				[alert show];
			}else{
				UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[[responseArray objectAtIndex:0] objectForKey:@"message"] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
				alert.tag=TAG_ALERT_NEEDTOREFRES;
				[alert show];
			}
		} else{
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"Server error,Please try again later."] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
			[alert show];
		}
	} else if([wsName isEqualToString:@"ForumComment"]){
		NSMutableArray *responseArray=[[NSMutableArray alloc] initWithArray:[json objectWithString:responseString error:nil]];
		if([responseArray count]>0){
			if([[[responseArray objectAtIndex:0] objectForKey:@"success"] isEqualToString:@"1"]){
				UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"Comment Posted Successfully."] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
				alert.tag=112;
				[alert show];
			}else{
				UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[[responseArray objectAtIndex:0] objectForKey:@"message"] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
				alert.tag=TAG_ALERT_NEEDTOREFRES;
				[alert show];
			}
		} else{
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"Server error,Please try again later."] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
            alert.tag=TAG_ALERT_NEEDTOREFRES; //need to remove
			[alert show];
		}
	} else {
		self.documentArray = [[NSMutableArray alloc]initWithArray:[json objectWithString:responseString error:nil]];
		if([self.documentArray count]){
			if([[[self.documentArray objectAtIndex:0] objectForKey:@"success"] isEqualToString:@"0"]){
				UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"No Forums are available For this course."] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
				alert.tag=104;
				[alert show];
				self.documentArray=nil;
			}
			else{
                self.lblNumberOfForums.text = [NSString stringWithFormat:@"%i %@",self.documentArray.count,[eEducationAppDelegate getLocalvalue:@"TOPICS"]];
                if (postedCommentOrForum) {
                    didSection = 0; // Recent comment will come top.This is to open that cell by default
                    self.arrSelectedForumComments = [[self.documentArray objectAtIndex:0] valueForKey:@"comment"];
                    ifOpen = YES;
                    [self.tblView reloadData];
                    [self.tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewRowAnimationTop animated:NO];
                } else {
                    didSection = self.documentArray.count+1;
                    [self.tblView reloadData];
                }
			}
		}
		else {
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"No Forums are available For this course."] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
			alert.tag=103;
			[alert show];
		}
	}
	[HUD hide:YES];
}
//192.168.33.145
- (void)parserDidFailWithRestoreError:(NSError*)error :(NSString*)msg
{
	[HUD setHidden:YES];
    if ([msg isEqualToString:@""]) {
        msg = [eEducationAppDelegate getLocalvalue:@"The server cannot be reached. It could be down or busy. Please try again later."];
    }
	UIAlertView *AlertView =  [[UIAlertView alloc]  initWithTitle:alertTitle message:msg delegate:nil 	cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil, nil];
	AlertView.tag=TAG_FailError;
	[AlertView show];
}


#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc 
{	
}
@end
