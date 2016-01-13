//
//  CreateMessageOrReply.m
//  eEducation
//
//  Created by Hidden Brains on 28/11/13.
//
//

#import "CreateMessageOrReply.h"
#import "ModuleHomePage.h"

@interface CreateMessageOrReply ()

@end

@implementation CreateMessageOrReply

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    objParser = [[JSONParser alloc] init];
	objParser.delegate = self;
	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
    HUD.labelText = [eEducationAppDelegate getLocalvalue:@"Please wait"];
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    tapRec.delegate = self;
    [self.view addGestureRecognizer:tapRec];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUpLocalText];
    [self.lblTopCourse setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"course_name"]];
    [self.lblTopDuration setText:[NSString stringWithFormat:RTLableText,[eEducationAppDelegate getLocalvalue:@"Begins "],[eEducationAppDelegate convertString:[[NSUserDefaults standardUserDefaults] valueForKey:@"edition_start"] fromFormate:@"yyyy-MM-dd" toFormate:@"dd MMMM yyyy"],[eEducationAppDelegate getLocalvalue:@"- Ends "],[eEducationAppDelegate convertString:[[NSUserDefaults standardUserDefaults] valueForKey:@"edition_end"] fromFormate:@"yyyy-MM-dd" toFormate:@"dd MMMM yyyy"]]];
    
    self.lblProfileBlueName.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_name"];
    self.lblProfileGrayName.text = [eEducationAppDelegate getLocalvalue:@"WELCOME"];
    [self.imgProfile loadImageFromURL:[NSURL URLWithString:[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_profile_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:@"no-image-200x200.png"];
    [self.imgLogo loadImageFromURL:[eEducationAppDelegate getTopCourseUrl] imageName:@"top-bar-logo.png"];
    [self.imgLogoStatic loadImageFromURL:[eEducationAppDelegate getTopStaticUrl] imageName:@"logo_top_static.png"];
    
    self.txtTitle.placeholder = [[eEducationAppDelegate getLocalvalue:@"Subject"] uppercaseString];
    [self.txtComment setPlaceholder:[[eEducationAppDelegate getLocalvalue:@"Message"] uppercaseString]];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [df setDateFormat:@"hh:mm a"];
    self.lblTime.text = [df stringFromDate:[NSDate date]];
    
    if (self.isNewMessage) {
        self.txtTitle.text = @"";
        self.txtComment.text = @"";
        self.txtTitle.userInteractionEnabled = YES;
        self.lblTitleForRply.text = @"";
    } else {
        self.txtTitle.text = [self.dictReceived valueForKey:@"subject"];
        self.lblTitleForRply.text = [[self.dictReceived valueForKey:@"sender_name"] uppercaseString];
        self.txtComment.text = @"";
        self.txtTitle.userInteractionEnabled = NO;
    }
}

#pragma mark - TextField delegate method
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.txtComment becomeFirstResponder];
    return YES;
}

#pragma mark - Gesture recognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]] || [touch.view isKindOfClass:[UITextField class]]) {
        return NO; // ignore the touch
    }
    [self.view endEditing:YES];
    return YES; // handle the touch
}

#pragma mark - Other methods
-(void)tap{
    [self.view endEditing:YES];
}

/**
 *  Load text as per selected language
 */
-(void)setUpLocalText{
    [self.btnHome setTitle:[eEducationAppDelegate getLocalvalue:@"HOME"] forState:UIControlStateNormal];
    [self.btnCancel setTitle:[eEducationAppDelegate getLocalvalue:@"Cancel"] forState:UIControlStateNormal];
    [self.btnOkay setTitle:[eEducationAppDelegate getLocalvalue:@"OK"] forState:UIControlStateNormal];
    [self.lblTitle setText:[[eEducationAppDelegate getLocalvalue:@"MESSAGES"] uppercaseString]];
    [self.btnModule setTitle:[[eEducationAppDelegate getLocalvalue:@"Module"] uppercaseString] forState:UIControlStateNormal];
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

#pragma mark - Action methods
-(IBAction)btnCancelClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnOkayClicked:(id)sender{
    
    if([self.txtTitle.text length] == 0 || ![validations isValidData:self.txtTitle.text])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"Please enter valid subject."] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
		alert.tag=TAG_ALERT_TITLEWRONG;
		[alert show];
	} else if(![validations isValidData:self.txtComment.text])
	{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"Please enter valid message."] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
		alert.tag=TAG_ALERT_COMMENTWRONG;
		[alert show];
	} else {
        [HUD show:YES];
        self.isNewMessage? [self callNewMessageWS]:[self callReplyWS];
    }
}

#pragma mark - Call webservice methods
-(void)callNewMessageWS{
    NSString *strURL=[WebService getComposeMail];
    NSString *strToId = [self.dictReceived objectForKey:@"teacher_id"];

    NSDictionary *postDict=[[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],@"user_id",[[NSUserDefaults standardUserDefaults] objectForKey:@"course_id"],@"course_id",[[NSUserDefaults standardUserDefaults] objectForKey:@"editonid"],@"edition_id",strToId,@"to_user_id",self.txtTitle.text,@"subject",self.txtComment.text,@"message",[[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language",nil];
	[objParser sendRequestToParse:strURL params:postDict];
}

-(void)callReplyWS {
	NSString *strURL=[WebService getComposeMail];
    NSString *strToId = [self.dictReceived objectForKey:@"teacher_id"];
    
	NSDictionary *postDict=[[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],@"user_id",[[NSUserDefaults standardUserDefaults] objectForKey:@"course_id"],@"course_id",[[NSUserDefaults standardUserDefaults] objectForKey:@"editonid"],@"edition_id",strToId,@"to_user_id",self.txtTitle.text,@"subject",[NSString stringWithFormat:@"%@",self.txtComment.text],@"message",[self.dictReceived objectForKey:@"main_inbox_id"],@"main_inbox_id",[[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language",nil];
	[objParser sendRequestToParse:strURL params:postDict];
}

#pragma mark - AlertView Delegate methods
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
    } else if(alertView.tag == TAG_ALERT_NEEDTOREFRES){
        if ([self.delegate respondsToSelector:@selector(messagePosted:)]) {
            [self.delegate messagePosted:self.isNewMessage?@"New":@"Reply"];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Webservice delegate method
- (void)parserDidFinishLoadingReturnData:(NSString *)responseString
{
    [HUD hide:YES];
	SBJSON *json = [SBJSON new];
    NSMutableArray *responseArray=[[NSMutableArray alloc]initWithArray:[json objectWithString:responseString error:nil]];
    if([responseArray count]){
        if([[[responseArray objectAtIndex:0] objectForKey:@"success"] isEqualToString:@"1"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"Message Sent Successfully."] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
            alert.tag = TAG_ALERT_NEEDTOREFRES;
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:[[responseArray objectAtIndex:0] objectForKey:@"message"] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
            [alert show];
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
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
