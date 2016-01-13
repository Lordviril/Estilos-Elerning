//
//  Message.m
//  eEducation
//
//  Created by Hidden Brains on 11/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Message.h"
#import "eEducationConstants.h"
#import"CustomCellMessageList.h"
#import"CustomCellMessageDetail.h"
#import"Settings.h"
#import"LoginScreen.h"
#import "ICourseList.h"
#import <QuartzCore/CoreAnimation.h>

@implementation Message

#pragma mark - ViewLife cycle
- (void)viewDidLoad 
{
    [super viewDidLoad];
    [self.tblViewSent registerNib:[UINib nibWithNibName:@"CustomCellMessageList" bundle:nil] forCellReuseIdentifier:@"CustomCellMessageList"];
    [self.tblViewInbox registerNib:[UINib nibWithNibName:@"CustomCellMessageList" bundle:nil] forCellReuseIdentifier:@"CustomCellMessageList"];
    [self.tblConversation registerNib:[UINib nibWithNibName:@"CustomCellMessageDetail" bundle:nil] forCellReuseIdentifier:@"CustomCellMessageDetail"];

	appDelegate=(eEducationAppDelegate*)[[UIApplication sharedApplication]delegate];
    
	msgDetailArray=[[NSMutableArray alloc] init];
	objParser = [[JSONParser alloc] init];
	objParser.delegate = self;
    newMsgOrReply = @"";
    self.tblViewSent.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setUpLocalText];

    [self.lblTopCourse setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"course_name"]];
    [self.lblTopDuration setText:[NSString stringWithFormat:RTLableText,[eEducationAppDelegate getLocalvalue:@"Begins "],[eEducationAppDelegate convertString:[[NSUserDefaults standardUserDefaults] valueForKey:@"edition_start"] fromFormate:@"yyyy-MM-dd" toFormate:@"dd MMMM yyyy"],[eEducationAppDelegate getLocalvalue:@"- Ends "],[eEducationAppDelegate convertString:[[NSUserDefaults standardUserDefaults] valueForKey:@"edition_end"] fromFormate:@"yyyy-MM-dd" toFormate:@"dd MMMM yyyy"]]];
    
    [self.lblTitle setText:[[eEducationAppDelegate getLocalvalue:@"MESSAGES"] uppercaseString]];
    self.lblProfileBlueName.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_name"];
    self.lblProfileGrayName.text = [eEducationAppDelegate getLocalvalue:@"WELCOME"];
    [self.imgProfile loadImageFromURL:[NSURL URLWithString:[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_profile_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:@"no-image-200x200.png"];
    [self.imgLogo loadImageFromURL:[eEducationAppDelegate getTopCourseUrl] imageName:@"top-bar-logo.png"];
    [self.imgLogoStatic loadImageFromURL:[eEducationAppDelegate getTopStaticUrl] imageName:@"logo_top_static.png"];
    
    if ([newMsgOrReply isEqualToString:@"New"]) {
        self.imgStrip.highlighted = YES;
        self.tblViewInbox.hidden = YES;
        self.tblViewSent.hidden = NO;
    } else {
        self.imgStrip.highlighted = NO;
        self.tblViewInbox.hidden = NO;
        self.tblViewSent.hidden = YES;
    }
    [self callWebService];
}

#pragma mark - Other Methods
-(void)messagePosted:(NSString*)msg{
    newMsgOrReply = msg;
}

/**
 *  Load text as per selected language
 */
-(void)setUpLocalText{
    [self.btnHome setTitle:[eEducationAppDelegate getLocalvalue:@"HOME"] forState:UIControlStateNormal];
    [self.btnModule setTitle:[[eEducationAppDelegate getLocalvalue:@"Module"] uppercaseString] forState:UIControlStateNormal];
    [self.lblTitle setText:[[eEducationAppDelegate getLocalvalue:@"MESSAGES"] uppercaseString]];    
    [self.btnInbox setTitle:[eEducationAppDelegate getLocalvalue:@"INBOX"] forState:UIControlStateNormal];
    [self.btnSent setTitle:[eEducationAppDelegate getLocalvalue:@"SENT"] forState:UIControlStateNormal];
    [self.btnCompose setTitle:[eEducationAppDelegate getLocalvalue:@"NEW MESSAGE"] forState:UIControlStateNormal];
    [self.btnPrev setTitle:[eEducationAppDelegate getLocalvalue:@"BACK"] forState:UIControlStateNormal];
    [self.btnReply setTitle:[eEducationAppDelegate getLocalvalue:@"REPLY"] forState:UIControlStateNormal];
}

#pragma mark - Webservice methods
- (void) callWebService
{
    HUD = [[MBProgressHUD alloc] initWithView:self.tabBarController.view];
    self.tabBarController.view.userInteractionEnabled = NO;
	[self.view addSubview:HUD];
    HUD.labelText = [eEducationAppDelegate getLocalvalue:@"Please wait"];
    [HUD show:YES];
    
    NSString *strURL=@"";
	if(!self.imgStrip.highlighted){
        self.btnInbox.titleLabel.textColor = [UIColor whiteColor];
        self.btnSent.titleLabel.textColor = [UIColor blackColor];
		strURL = [WebService getMessageInboxList];
        objParser.wsName = @"Inbox";
    }
    else{
        self.btnInbox.titleLabel.textColor = [UIColor blackColor];
        self.btnSent.titleLabel.textColor = [UIColor whiteColor];
		strURL = [WebService getMessageSentboxList];
        objParser.wsName = @"Sentbox";
    }
	NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],@"user_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"course_id"] ,@"course_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"editonid"],@"edition_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language",
								 nil];
	[objParser sendRequestToParse:strURL params:requestData];
}
-(void)callReadWs:(NSString*)mainInboxId{
    HUD = [[MBProgressHUD alloc] initWithView:self.tabBarController.view];
    self.tabBarController.view.userInteractionEnabled = NO;
	[self.view addSubview:HUD];
    HUD.labelText = [eEducationAppDelegate getLocalvalue:@"Please wait"];
    [HUD show:YES];
    
    NSString *strURL=[WebService getReadMessage];
    objParser.wsName = @"Read";
	NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],@"user_id",
								 mainInboxId ,@"main_inbox_id",
								 nil];
	[objParser sendRequestToParse:strURL params:requestData];
}

-(void)getDataFromwebService:(NSInteger)selectedSegment{
	NSString *strURL=@"";
	if(selectedSegment==0)
		strURL = [WebService getMessageInboxList];
	if(selectedSegment==1)
		strURL = [WebService getMessageSentboxList];
	NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:                                 
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],@"user_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"course_id"] ,@"course_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"editonid"],@"edition_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language",
								 nil];	
	[objParser sendRequestToParse:strURL params:requestData];
}

#pragma mark - Slide animation methods
-(void)openSlideView{
    self.viewSlider.frame = CGRectMake (self.view.frame.size.width, 116, self.viewSlider.frame.size.width, self.viewSlider.frame.size.height);
    [self.view addSubview:self.viewSlider];
    
    [UIView animateWithDuration :0.5 delay:0 options:UIViewAnimationCurveLinear
                     animations	:^{
                         self.viewMainContainer.alpha = 0.0;
                         self.viewSlider.frame = CGRectMake (18, 116, self.viewSlider.frame.size.width, self.viewSlider.frame.size.height);
                     }
                     completion	:^(BOOL finished) {
                         if (finished)
                         {
                             self.viewMainContainer.hidden = YES;
                         }
                     }
     ];
}

-(void)closeSlideView{
    self.viewMainContainer.hidden = NO;
    self.viewSlider.frame = CGRectMake (18, 116, self.viewSlider.frame.size.width, self.viewSlider.frame.size.height);
    
    [UIView animateWithDuration :0.5 delay:0 options:UIViewAnimationCurveLinear
                     animations	:^{
                         self.viewMainContainer.alpha = 1.0;
                         self.viewSlider.frame = CGRectMake (self.view.frame.size.width, 116, self.viewSlider.frame.size.width, self.viewSlider.frame.size.height);
                     }
                     completion	:^(BOOL finished) {
                         if (finished)
                         {
                             [self.view addSubview:self.viewMainContainer];
                             [self.viewSlider removeFromSuperview];
                         }
                     }
     ];
}

/**
 *  Returns proper date formate
 *
 *  @param date    Date received from the ws
 *  @param imgTime 
 *
 *  @return Formated date
 */
-(NSString*)getProperDateFormate:(NSString*)date :(UIImageView*)imgTime{
    NSInteger day = [[eEducationAppDelegate convertString:date fromFormate:@"yyyy-MM-dd HH:mm:ss" toFormate:@"dd"] integerValue];
    NSInteger month = [[eEducationAppDelegate convertString:date fromFormate:@"yyyy-MM-dd HH:mm:ss" toFormate:@"MM"] integerValue];
    NSInteger year = [[eEducationAppDelegate convertString:date fromFormate:@"yyyy-MM-dd HH:mm:ss" toFormate:@"YYYY"] integerValue];
    
    KLDate *kld = [[KLDate alloc] initWithYear:year month:month day:day];
    if ([kld isToday]) {
        imgTime.highlighted=NO;
        return [eEducationAppDelegate convertString:date fromFormate:@"yyyy-MM-dd HH:mm:ss" toFormate:@"hh:mm a"];
    } else {
        imgTime.highlighted=YES;
        return [eEducationAppDelegate convertString:date fromFormate:@"yyyy-MM-dd HH:mm:ss" toFormate:@"MMM dd"];
    }
}

#pragma mark - Json responce
- (void)parserDidFinishLoadingReturnData:(NSString *)responseString wsName:(NSString*)wsName
{
    NSLog(@"%@",responseString);
	SBJSON *json = [SBJSON new];
    if ([wsName isEqualToString:@"Inbox"]) {
        self.arrInbox = [[NSMutableArray alloc]initWithArray:[json objectWithString:responseString error:nil]];
        if([self.arrInbox count]){
            if([[[self.arrInbox objectAtIndex:0] objectForKey:@"success"] isEqualToString:@"0"]){
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"No messages are available for this course."] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
                alert.tag=104;
                [alert show];
            }
            else{
                if ([newMsgOrReply isEqualToString:@"Reply"]) {
                    self.arrSelectedThread = [[self.arrInbox objectAtIndex:selectedIndex] valueForKey:@"thread"];
                    [self.tblConversation reloadData];
                } else {
                    [self.tblViewInbox reloadData];
                }
            }
        }
    } else if ([wsName isEqualToString:@"Sentbox"]) {
        self.arrSent = [[NSMutableArray alloc]initWithArray:[json objectWithString:responseString error:nil]];
        if([self.arrSent count]){
            if([[[self.arrSent objectAtIndex:0] objectForKey:@"success"] isEqualToString:@"0"]){
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"No messages are available for this course."] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
                alert.tag=104;
                [alert show];
            }
            else{
                [self.tblViewSent reloadData];
            }
        }
    } else if([wsName isEqualToString:@"Read"]){
        if (self.arrSelectedThread != nil && self.arrSelectedThread.count > 0) {
            if ([[self.arrSelectedThread objectAtIndex:0] objectForKey:@"thread_from_username"] != nil && ![[[self.arrSelectedThread objectAtIndex:0] objectForKey:@"thread_from_username"] isKindOfClass:[NSNull class]]) {
                [self openSlideView];
                [self.tblConversation reloadData];
            }
        }
    }
    self.tabBarController.view.userInteractionEnabled = YES;
    [HUD hide:YES];
}

- (void)parserDidFailWithRestoreError:(NSError*)error :(NSString*)msg
{
	[HUD setHidden:YES];
    self.tabBarController.view.userInteractionEnabled = YES;
    if ([msg isEqualToString:@""]) {
        msg = [eEducationAppDelegate getLocalvalue:@"The server cannot be reached. It could be down or busy. Please try again later."];
    }
	UIAlertView *AlertView =  [[UIAlertView alloc]  initWithTitle:alertTitle message:msg delegate:nil 	cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil, nil];
	AlertView.tag=TAG_FailError;
	[AlertView show];
}

#pragma mark -
#pragma mark AlertView Delegate Method
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
    }
}
#pragma mark - Action methods
-(IBAction)btnInBoxClicked:(UIButton*)sender{
    self.btnInbox.titleLabel.textColor = [UIColor whiteColor];
    self.btnSent.titleLabel.textColor = [UIColor blackColor];
    self.imgStrip.highlighted = NO;
    self.tblViewSent.hidden = YES;
    self.tblViewInbox.hidden = NO;
    [self callWebService];
}

-(IBAction)btnSentClicked:(UIButton*)sender{
    self.btnInbox.titleLabel.textColor = [UIColor blackColor];
    self.btnSent.titleLabel.textColor = [UIColor whiteColor];
    self.imgStrip.highlighted = YES;
    self.tblViewSent.hidden = NO;
    self.tblViewInbox.hidden = YES;
    [self callWebService];
}

-(IBAction)btnComposeClicked:(id)sender{
    if ([[self.arrInbox objectAtIndex:0] objectForKey:@"teacher_id"] == nil || [[[self.arrInbox objectAtIndex:0] valueForKey:@"teacher_id"] length] == 0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"No teacher is assigned to you."] delegate:nil cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
        [alert show];
    } else {
        CreateMessageOrReply *objCreateMessageOrReply = [[CreateMessageOrReply alloc] initWithNibName:@"CreateMessageOrReply" bundle:nil];
        objCreateMessageOrReply.delegate = self;
        if (self.arrInbox != nil && self.arrInbox.count >0) {
            objCreateMessageOrReply.dictReceived = [self.arrInbox objectAtIndex:0];
        }
        objCreateMessageOrReply.isNewMessage = YES;
        [self.navigationController pushViewController:objCreateMessageOrReply animated:YES];
    }
}

-(IBAction)btnPrevClicked:(id)sender{
	if(!self.imgStrip.highlighted){
         [self callWebService];   
    }
    [self closeSlideView];
}

-(IBAction)btnReplyClicked:(UIButton*)sender{
    CreateMessageOrReply *objCreateMessageOrReply = [[CreateMessageOrReply alloc] initWithNibName:@"CreateMessageOrReply" bundle:nil];
    objCreateMessageOrReply.delegate = self;
    objCreateMessageOrReply.isNewMessage = NO;
    if (!self.imgStrip.highlighted) {
        objCreateMessageOrReply.dictReceived = [self.arrInbox objectAtIndex:sender.tag];
    } else {
        objCreateMessageOrReply.dictReceived = [self.arrSent objectAtIndex:sender.tag];
    }
	[self.navigationController pushViewController:objCreateMessageOrReply animated:YES];
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
}

-(IBAction)btnSettingsClicked:(id)sender{
    Settings *objSettings = [[Settings alloc] initWithNibName:@"Settings" bundle:nil];
    [[validations getAppDelegateInstance] removePresentVC];
	[[validations getAppDelegateInstance].navigationController pushViewController:objSettings animated:NO];
}

-(IBAction)btnLogoutClicked:(id)sender{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"You're about to logout, are you sure?"] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"NO"]  otherButtonTitles:[eEducationAppDelegate getLocalvalue:@"YES"],nil];
	[alert show];
	alert.tag=TAG_ALERT_LOGOUT;
}

-(IBAction)btnModuleClicked:(id)sender{
    ModuleHomePage *objModuleListHomePage=[[ModuleHomePage alloc] initWithNibName:@"ModuleHomePage" bundle:nil];
    [[validations getAppDelegateInstance] removePresentVC];
	[[validations getAppDelegateInstance].navigationController pushViewController:objModuleListHomePage animated:NO];
}

#pragma mark -
#pragma mark tableView Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tblViewInbox) {
        return [self havingObjects:self.arrInbox];
    } else if (tableView == self.tblViewSent) {
        return [self havingObjects:self.arrSent];
    } else {
        return self.arrSelectedThread.count;
    }
}

-(int)havingObjects:(NSMutableArray*)arr{
    if ([arr isKindOfClass:[NSMutableArray class]] && arr.count > 0 && [[[arr objectAtIndex:0] valueForKey:@"success"] isEqualToString:@"1"] && [[[arr objectAtIndex:0] allKeys] count]>2) {
        return arr.count;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
	return [eEducationAppDelegate getLocalvalue:@"Delete"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tblViewInbox) {
        
        static NSString *identifier = @"CustomCellMessageList";
        CustomCellMessageList *cell = (CustomCellMessageList*) [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.imgBlueDot.hidden=NO;
        [cell.lblFrom setText:[NSString stringWithFormat:MessagesListRTLableText,[eEducationAppDelegate getLocalvalue:@"From: "],[[self.arrInbox objectAtIndex:indexPath.row] valueForKey:@"sender_name"]]];
        [cell.lblSubject setText:[NSString stringWithFormat:MessagesListRTLableText,[eEducationAppDelegate getLocalvalue:@"Subject: "],[[self.arrInbox objectAtIndex:indexPath.row] valueForKey:@"subject"]]];
        cell.lblDateTime.text = [self getProperDateFormate:[[self.arrInbox objectAtIndex:indexPath.row] valueForKey:@"added_date"]:cell.imgDateTimeIcon];
        if ([[[self.arrInbox objectAtIndex:indexPath.row] valueForKey:@"read"] isEqualToString:@"No"]) {
            cell.imgBlueDot.image = [UIImage imageNamed:@"circle_s12_blue@2x.png"];
        } else {
            cell.imgBlueDot.image = [UIImage imageNamed:@"circle_s12_gray@2x.png"];
        }
        return cell;
        
    } else if(tableView == self.tblViewSent){
        
        static NSString *identifier = @"CustomCellMessageList";
        CustomCellMessageList *cell = (CustomCellMessageList*) [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.imgBlueDot.hidden=YES;

        [cell.lblFrom setText:[NSString stringWithFormat:MessagesListRTLableText,[eEducationAppDelegate getLocalvalue:@"To: "],[[self.arrSent objectAtIndex:indexPath.row] valueForKey:@"to_username"]]];
        [cell.lblSubject setText:[NSString stringWithFormat:MessagesListRTLableText,[eEducationAppDelegate getLocalvalue:@"Subject: "],[[self.arrSent objectAtIndex:indexPath.row] valueForKey:@"subject"]]];
        cell.lblDateTime.text = [self getProperDateFormate:[[self.arrSent objectAtIndex:indexPath.row] valueForKey:@"date"]:cell.imgDateTimeIcon];
        return cell;
    }
    else
    {
        static NSString *identifier = @"CustomCellMessageDetail";
        CustomCellMessageDetail *cell = (CustomCellMessageDetail*) [tableView dequeueReusableCellWithIdentifier:identifier];
        [cell.imgProfilePic loadImageFromURL:[NSURL URLWithString:[[[self.arrSelectedThread objectAtIndex:indexPath.row] valueForKey:@"sender_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:@"no-image-200x200.png"];
        cell.lbl_FromValue.text = [[self.arrSelectedThread objectAtIndex:indexPath.row] valueForKey:@"thread_from_username"];
        cell.txt_Message.text = [[self.arrSelectedThread objectAtIndex:indexPath.row] valueForKey:@"thread_message"];
        
        NSString *strDate1 = [NSString stringWithFormat:@"%@: %@",[eEducationAppDelegate getLocalvalue:@"Date"],[eEducationAppDelegate convertString:[[self.arrSelectedThread objectAtIndex:0] objectForKey:@"thread_date"] fromFormate:@"MMMM dd, yyyy" toFormate:@"dd/MM/yyyy"]];
        cell.lbl_DateValue.text = strDate1;
        
        if ([eEducationAppDelegate checkLoggedInUser:[[self.arrSelectedThread objectAtIndex:indexPath.row] valueForKey:@"thread_from_username"]]) {
            cell.backgroundiimg.image = [UIImage imageNamed:@"chat_s13@2x.png"];
            cell.backgroundiimg.frame = CGRectMake(-20, 0, 641, 142);
            cell.viewBack.frame = CGRectMake(25, 0, 641, 142);
        } else {
            cell.backgroundiimg.image = [UIImage imageNamed:@"chat_s13-1@2x.png"];
            cell.backgroundiimg.frame = CGRectMake(0, 0, 641, 142);
            cell.viewBack.frame = CGRectMake(75, 0, 641, 142);
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tblConversation) {
        return 160;
    }
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.btnReply.tag = indexPath.row;
    if (tableView == self.tblConversation) return;
    if (!self.imgStrip.highlighted)
    {
        self.arrSelectedThread = [[NSMutableArray alloc] initWithArray:[[self.arrInbox objectAtIndex:indexPath.row] objectForKey:@"thread"]];
        self.lblSublect.text = [[self.arrInbox objectAtIndex:indexPath.row] valueForKey:@"subject"];
        self.btnReply.hidden = NO;
        selectedIndex = indexPath.row;
        if ([[[self.arrInbox objectAtIndex:indexPath.row] valueForKey:@"read"] isEqualToString:@"No"]) {
            [self callReadWs:[[self.arrInbox objectAtIndex:indexPath.row] valueForKey:@"main_inbox_id"]];
        } else {
            if (self.arrSelectedThread != nil && self.arrSelectedThread.count > 0) {
                if ([[self.arrSelectedThread objectAtIndex:0] objectForKey:@"thread_from_username"] != nil && ![[[self.arrSelectedThread objectAtIndex:0] objectForKey:@"thread_from_username"] isKindOfClass:[NSNull class]]) {
                    [self openSlideView];
                    [self.tblConversation reloadData];
                }
            }
        }
    }
    else
    {
        self.arrSelectedThread = [[NSMutableArray alloc] initWithArray:[[self.arrSent objectAtIndex:indexPath.row] objectForKey:@"thread"]];
        self.lblSublect.text = [[self.arrSent objectAtIndex:indexPath.row] valueForKey:@"subject"];
        self.btnReply.hidden = YES;
        
        if (self.arrSelectedThread != nil && self.arrSelectedThread.count > 0) {
            if ([[self.arrSelectedThread objectAtIndex:0] objectForKey:@"thread_from_username"] != nil && ![[[self.arrSelectedThread objectAtIndex:0] objectForKey:@"thread_from_username"] isKindOfClass:[NSNull class]]) {
                [self openSlideView];
                [self.tblConversation reloadData];
            }
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - orientation Life Cycle
-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    return;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return NO;
}

#pragma mark - TextField Delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];	
	return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	return TRUE;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textField
{
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
}

@end