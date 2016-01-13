//
//  OtherStudents.m
//  eEducation
//
//  Created by Hidden Brains on 21/11/13.
//
//

#import "OtherStudents.h"
#import "ModuleHomePage.h"

@interface OtherStudents ()

@end

@implementation OtherStudents
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
    [self setUpGridView:self.gridStudets];
    objParser = [[JSONParser alloc] init];
	objParser.delegate = self;
	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
    HUD.labelText = [eEducationAppDelegate getLocalvalue:@"Please wait"];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.lblTopCourse setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"course_name"]];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"edition_start"] != nil && ![[[NSUserDefaults standardUserDefaults] valueForKey:@"edition_start"] isEqualToString:@""]) {
        [self.lblTopDuration setText:[NSString stringWithFormat:RTLableText,[eEducationAppDelegate getLocalvalue:@"Begins "],[eEducationAppDelegate convertString:[[NSUserDefaults standardUserDefaults] valueForKey:@"edition_start"] fromFormate:@"yyyy-MM-dd" toFormate:@"dd MMMM yyyy"],[eEducationAppDelegate getLocalvalue:@"- Ends "],[eEducationAppDelegate convertString:[[NSUserDefaults standardUserDefaults] valueForKey:@"edition_end"] fromFormate:@"yyyy-MM-dd" toFormate:@"dd MMMM yyyy"]]];
    }
    [self.imgLogo loadImageFromURL:[eEducationAppDelegate getTopCourseUrl] imageName:@"top-bar-logo.png"];
    [self.imgLogoStatic loadImageFromURL:[eEducationAppDelegate getTopStaticUrl] imageName:@"logo_top_static.png"];

	[self setLocalizedText];
    self.navigationController.navigationBarHidden = YES;
    
    [self.imgProfile loadImageFromURL:[NSURL URLWithString:[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_profile_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:@"no-image-200x200.png"];
    [self otherStudentWs];
}

#pragma mark - Call webservice
-(void)otherStudentWs{
    [HUD show:YES];
    NSString *strURL = [WebService getOtherStudentsURL];
    NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"course_id"],@"course_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] ,@"user_id",
								 [[NSUserDefaults standardUserDefaults] objectForKey:@"editonid"],@"edition_id",
                                 [[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language",
                                 nil];
    objParser.wsName = @"OtherStudents";
    [objParser sendRequestToParse:strURL params:requestData];
}

#pragma mark - Other methods
/**
 *  Load text as per selected language
 */
-(void)setLocalizedText
{
    self.lblProfileBlueName.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_name"];
    self.lblProfileGrayName.text = [eEducationAppDelegate getLocalvalue:@"WELCOME"];
    
    self.lblTitle.text = [[eEducationAppDelegate getLocalvalue:@"STUDENTS"] uppercaseString];//[_DicCourseDetails objectForKey:@"STUDENTS"];
    [self.btnHome setTitle:[eEducationAppDelegate getLocalvalue:@"HOME"] forState:UIControlStateNormal];
    [self.btnModule setTitle:[[eEducationAppDelegate getLocalvalue:@"Module"] uppercaseString] forState:UIControlStateNormal];
    
	[self.tab1 setImage:[eEducationAppDelegate GetLocalImage:@"biblioteca@2x"] forState:0];
	[self.tab1 setImage:[eEducationAppDelegate GetLocalImage:@"biblioteca_h@2x"] forState:UIControlStateHighlighted];
	
	[self.tab2 setImage:[eEducationAppDelegate GetLocalImage:@"foro@2x"] forState:0];
	[self.tab2 setImage:[eEducationAppDelegate GetLocalImage:@"foro_h@2x"] forState:UIControlStateHighlighted];
    
	[self.tab3 setImage:[eEducationAppDelegate GetLocalImage:@"avisos@2x"] forState:0];
	[self.tab3 setImage:[eEducationAppDelegate GetLocalImage:@"avisos_h@2x"] forState:UIControlStateHighlighted];
    
	[self.tab4 setImage:[eEducationAppDelegate GetLocalImage:@"calendario@2x"] forState:0];
	[self.tab4 setImage:[eEducationAppDelegate GetLocalImage:@"calendario_h@2x"] forState:UIControlStateHighlighted];
    
	[self.tab5 setImage:[eEducationAppDelegate GetLocalImage:@"mensajes@2x"] forState:0];
	[self.tab5 setImage:[eEducationAppDelegate GetLocalImage:@"mensajes_h@2x"] forState:UIControlStateHighlighted];
}

/**
 *  Calculate and returns the Lable height
 *
 *  @param myLable UILable object
 *
 *  @return Height of the lable
 */
-(float)getHeight :(UITextView*)myLable{
    CGSize labelSize = [myLable.text sizeWithFont:myLable.font
                                constrainedToSize:myLable.frame.size
                                    lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize.height;
}

#pragma mark - Setup gridView
/**
 *  SetUp UI for grid Controlls
 *
 *  @param gridView Object of GridView
 */
-(void)setUpGridView:(GMGridView*)gridView{
    gridView.minEdgeInsets = UIEdgeInsetsMake(5,0, 5, 0);
    gridView.style = GMGridViewStyleSwap;
    gridView.itemSpacing = 15;
    gridView.centerGrid = NO;
    gridView.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutVertical];
    gridView.pagingEnabled = NO;
    gridView.showsHorizontalScrollIndicator = NO;
    gridView.showsVerticalScrollIndicator = NO;
    gridView.clipsToBounds = YES;
    gridView.dataSource = self;
    gridView.delegate = self;
    gridView.actionDelegate = self;
    gridView.editing = NO;
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

-(IBAction)btnSettingsClicked:(id)sender{
    Settings *objSettings = [[Settings alloc] initWithNibName:@"Settings" bundle:nil];
    [[validations getAppDelegateInstance] removePresentVC];
	[[validations getAppDelegateInstance].navigationController pushViewController:objSettings animated:NO];
}

-(IBAction)btnLogoutClicked:(id)sender{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"You're about to logout, are you sure?"] delegate:self	 cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"NO"]  otherButtonTitles:[eEducationAppDelegate getLocalvalue:@"YES"],nil];
	[alert show];
	alert.tag=TAG_ALERT_LOGOUT;
}

-(IBAction)btnModuleClicked:(id)sender{
    ModuleHomePage *objModuleListHomePage=[[ModuleHomePage alloc] initWithNibName:@"ModuleHomePage" bundle:nil];
    [[validations getAppDelegateInstance] removePresentVC];
	[[validations getAppDelegateInstance].navigationController pushViewController:objModuleListHomePage animated:NO];
}

- (void)btnMailClicked:(UIButton*)sender
{
	if(![MFMailComposeViewController canSendMail])
	{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[eEducationAppDelegate getLocalvalue:@"E-mail not setup properly"] message:@"" delegate:nil cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
		[alert show];
		return;
	}
	else {
		MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
		mailController.mailComposeDelegate = self;
        [mailController setToRecipients:[NSArray arrayWithObject:[sender titleForState:0]]];
		[self presentModalViewController:mailController animated:YES];
	}
}

-(void)btnDescClicked:(UIButton*)sender{
    if ([[[self.arrStudents objectAtIndex:sender.tag] valueForKey:@"profile_description"] isKindOfClass:[NSNull class]]) {
        return;
    }
    StudentsCell *cell = (StudentsCell*)[self.gridStudets cellForItemAtIndex:sender.tag];
    UIViewController *tableViewController = [[UIViewController alloc] init];
    UITextView *txtDesc = [[UITextView alloc] initWithFrame:CGRectMake(0,0, 280, 500)];
    txtDesc.textAlignment = UITextAlignmentCenter;
    txtDesc.text = [[self.arrStudents objectAtIndex:sender.tag] valueForKey:@"profile_description"];
    txtDesc.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    txtDesc.userInteractionEnabled = NO;
    txtDesc.backgroundColor = [UIColor clearColor];
    txtDesc.textColor = [UIColor whiteColor];
    tableViewController.view.frame = CGRectMake(0,0, 280, [self getHeight:txtDesc] + 10);

    [tableViewController.view addSubview:txtDesc];
    
    TSPopoverController *popoverController = [[TSPopoverController alloc] initWithContentViewController:tableViewController];
    popoverController.cornerRadius = 5;
    popoverController.titleText = [[self.arrStudents objectAtIndex:sender.tag] valueForKey:@"student_full_name"];
    popoverController.popoverBaseColor = [UIColor colorWithRed:0.369 green:0.772 blue:0.904 alpha:0.900];
    popoverController.popoverGradient= NO;
    [popoverController showPopoverInView:cell.imgProfile];
}

-(IBAction) TabarIndexSelected:(id)sender
{
	UIButton *btn=sender;
	int i=btn.tag/11;
    [[validations getAppDelegateInstance] removePresentVC];
    eEducationAppDelegate *appDelegate=(eEducationAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate pushToTabbarWithSelection:i];
}

#pragma mark - Mail composer delegate method
- (void)mailComposeController:(MFMailComposeViewController*)mailController didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	NSString *msg;
	switch (result)
	{
		case MFMailComposeResultCancelled: msg =[eEducationAppDelegate getLocalvalue:@"Sending mail is canceled."];
			break;
		case MFMailComposeResultSaved: msg = [eEducationAppDelegate getLocalvalue:@"Mail saved in drafts."];
			break;
		case MFMailComposeResultSent:msg = [eEducationAppDelegate getLocalvalue:@"Message sent successfully."];
			break;
		case MFMailComposeResultFailed: msg =[eEducationAppDelegate getLocalvalue:@"Mail sending failed."];
			break;
		default: msg = [eEducationAppDelegate getLocalvalue:@"Mail sent successfully."];
			break;
	}
	if([WebService checkForNetworkStatus])
	{
		UIAlertView *mailResuletAlert = [[UIAlertView alloc]initWithFrame:CGRectMake(10, 170, 300, 120)];
		mailResuletAlert.title=msg;
		[mailResuletAlert addButtonWithTitle:[eEducationAppDelegate getLocalvalue:@"OK"]];
		[mailResuletAlert show];
		[self dismissModalViewControllerAnimated:YES];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[eEducationAppDelegate getLocalvalue:@"No internet connection. Please try later!"] message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:[eEducationAppDelegate getLocalvalue:@"OK"],nil];
		[alert show];
		[self dismissModalViewControllerAnimated:YES];
	}
}

#pragma mark - UIAlertViewDelegate methods
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

#pragma mark - GM Grid view Delegates
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}
- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return self.arrStudents.count;
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(218, 229);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    StudentsCell *cell = (StudentsCell *)[gridView dequeueReusableCell];
    if (!cell)
    {
        cell = [[StudentsCell alloc] init];
    }
    cell.lblName.text = [[self.arrStudents objectAtIndex:index] valueForKey:@"student_full_name"];
    [cell.btnEmail setTitle:[[self.arrStudents objectAtIndex:index] valueForKey:@"student_email_id"] forState:UIControlStateNormal];
    [cell.imgProfile loadImageFromURL:[NSURL URLWithString:[[[self.arrStudents objectAtIndex:index] valueForKey:@"student_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:@"no-image-200x200.png"];
    cell.btnDesc.tag = index;
    cell.btnEmail.tag = index;
    [cell.btnEmail.titleLabel setTextAlignment:UITextAlignmentCenter];
    [cell.btnDesc addTarget:self action:@selector(btnDescClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnEmail addTarget:self action:@selector(btnMailClicked:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
}

#pragma mark - Jshon methods
- (void)parserDidFinishLoadingReturnData:(NSString *)responseString wsName:(NSString*)wsName
{
	SBJSON *json = [SBJSON new];
	if([wsName isEqualToString:@"OtherStudents"]){
		NSMutableArray *responseArray=[[NSMutableArray alloc] initWithArray:[json objectWithString:responseString error:nil]];
		if([responseArray count]>0){
			if([[[responseArray objectAtIndex:0] objectForKey:@"success"] isEqualToString:@"1"]){
                self.arrStudents = [[NSMutableArray alloc] initWithArray:responseArray];
                [self.gridStudets reloadData];
			}else{
				UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"No student found."] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
				alert.tag=TAG_ALERT_NEEDTOREFRES;
				[alert show];
			}
		} else{
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"Server error,Please try again later."] delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
			[alert show];
		}
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
}

#pragma mark - Received memory warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
