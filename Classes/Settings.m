    //
//  Settings.m
//  eEducation
//
//  Created by HB14 on 05/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"
#import "LoginScreen.h"
#import "ICourseList.h"
#import "DownloadedDocument.h"
#import <QuartzCore/QuartzCore.h>
#import "eEducationAppDelegate.h"
#import "eEducationConstants.h"

@implementation Settings

#pragma mark  -
#pragma mark View LifeCycle

- (void)viewDidLoad 
{
	[super viewDidLoad];
    didLangClick = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    self.tap.delegate = self;
    [scrlView addGestureRecognizer:self.tap];
    
	appDelegate=(eEducationAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    objParser = [[JSONParser alloc] init];
	objParser.delegate = self;
	NSString *strURL = [WebService GetSettingDataXml];
	NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"], @"user_id",
                                 [[NSUserDefaults standardUserDefaults] objectForKey:@"course_id"],@"course_id",
                                 [[NSUserDefaults standardUserDefaults] objectForKey:@"vLanguage"],@"language",
                                 nil];
	HUD = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
	HUD.labelText=[eEducationAppDelegate getLocalvalue:@"Please wait"];
    
	[objParser sendRequestToParse:strURL params:requestData];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.lblTopCourse setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"course_name"]];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"edition_start"] != nil && ![[[NSUserDefaults standardUserDefaults] valueForKey:@"edition_start"] isEqualToString:@""]) {
        [self.lblTopDuration setText:[NSString stringWithFormat:RTLableText,[eEducationAppDelegate getLocalvalue:@"Begins "],[eEducationAppDelegate convertString:[[NSUserDefaults standardUserDefaults] valueForKey:@"edition_start"] fromFormate:@"yyyy-MM-dd" toFormate:@"dd MMMM yyyy"],[eEducationAppDelegate getLocalvalue:@"- Ends "],[eEducationAppDelegate convertString:[[NSUserDefaults standardUserDefaults] valueForKey:@"edition_end"] fromFormate:@"yyyy-MM-dd" toFormate:@"dd MMMM yyyy"]]];
    }

    self.lblProfileBlueName.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_name"];
    self.lblProfileGrayName.text = [eEducationAppDelegate getLocalvalue:@"WELCOME"];
    [self.imgProfile loadImageFromURL:[NSURL URLWithString:[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_profile_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:@"no-image-200x200.png"];
    [self.imgBig loadImageFromURL:[NSURL URLWithString:[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_profile_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] imageName:@"no-image-200x200.png"];
    [self.imgLogo loadImageFromURL:[eEducationAppDelegate getTopCourseUrl] imageName:@"top-bar-logo.png"];
    [self.imgLogoStatic loadImageFromURL:[eEducationAppDelegate getTopStaticUrl] imageName:@"logo_top_static.png"];

	[self setLocalizedText];
	self.navigationController.navigationBar.hidden=YES;
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"course_id"] isEqualToString:@""]) {
        self.btnModule.hidden = YES;
        self.imgModuleArrow.hidden = YES;
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
}

#pragma mark - Gesture recognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]] || [touch.view isKindOfClass:[UITextField class]]) {
        return NO; // ignore the touch
    }
    [self.view endEditing:YES];
    return YES; // handle the touch
}

#pragma mark - Other Methods
-(void)goBack{
    @try {
        [[validations getAppDelegateInstance].navigationController popToViewController:[[validations getAppDelegateInstance].navigationController.viewControllers objectAtIndex:1] animated:YES];
        [self releaseObjects];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(void)keyboardWillHide{
    [self scrollViewToCenterOfScreen:scrlView theView:txt_firstNameValue toShow:YES];
}

-(void)tap:(UITapGestureRecognizer*)tapRec{
    [self.view endEditing:YES];
}

-(void) ReloadSettingsData
{
	SettingsDict=[ArrayResponse objectAtIndex:0];
    btn_autoLogin.selected=([[[NSUserDefaults standardUserDefaults] objectForKey:@"IS_AUTO_LOGIN"] isEqualToString:@"YES"])?YES:NO;
	btn_Language.selected=([[[NSUserDefaults standardUserDefaults] objectForKey:@"IS_SPANISH_LANG"] isEqualToString:@"YES"])?NO:YES;
	txt_firstNameValue.text =[SettingsDict objectForKey:@"first_name"];
	txt_lastNameValue.text=[SettingsDict objectForKey:@"last_name"];
	txt_eMailValue.text=[SettingsDict objectForKey:@"email"];
	lbl_usernameValue.text=[SettingsDict objectForKey:@"username"];
	if (![[SettingsDict objectForKey:@"date_of_birth"] isEqual:[NSNull null]] && [SettingsDict objectForKey:@"date_of_birth"] != nil && ![[SettingsDict objectForKey:@"date_of_birth"] length]==0)
    {
		lbl_DOBValue.text =[SettingsDict objectForKey:@"date_of_birth"];
	}else{
		lbl_DOBValue.text =[eEducationAppDelegate getLocalvalue:@"Select date"];
	}
	txt_cityValue.text=[SettingsDict objectForKey:@"city"];
	txt_provinceValue.text=[SettingsDict objectForKey:@"province"];
	txt_countryValue.text=[SettingsDict objectForKey:@"country"];
	txt_telephoneValue.text=[SettingsDict objectForKey:@"telephone"];
}

-(void)setLocalizedText
{
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
    [self.btnHome setTitle:[eEducationAppDelegate getLocalvalue:@"HOME"] forState:UIControlStateNormal];
    [btn_Save setTitle:[eEducationAppDelegate getLocalvalue:@"SAVE"] forState:UIControlStateNormal];
    [self.btnProfileUpload setTitle:[eEducationAppDelegate getLocalvalue:@"CHANGE PHOTO"] forState:UIControlStateNormal];
    [self.btnModule setTitle:[[eEducationAppDelegate getLocalvalue:@"Module"] uppercaseString] forState:UIControlStateNormal];

    lbl_setAlerts.text=[eEducationAppDelegate getLocalvalue:@"Get Alerts"];
    lbl_setLang.text=[eEducationAppDelegate getLocalvalue:@"Language"];
	lbl_heading.text=[[eEducationAppDelegate getLocalvalue:@"Settings"] uppercaseString];
	lbl_generalSettings.text=[eEducationAppDelegate getLocalvalue:@"General Settings :"];
	lbl_autoLogin.text=[eEducationAppDelegate getLocalvalue:@"Auto Log-In"];
	lbl_profileSettings.text=[eEducationAppDelegate getLocalvalue:@"Profile Settings :"];
	lbl_firstName.text=[eEducationAppDelegate getLocalvalue:@"First Name"];
	lbl_lastName.text=[eEducationAppDelegate getLocalvalue:@"Last Name"];
	lbl_eMail.text=[eEducationAppDelegate getLocalvalue:@"Email"];
	lbl_username.text=[eEducationAppDelegate getLocalvalue:@"User Name"];
	lbl_DOB.text=[eEducationAppDelegate getLocalvalue:@"Date of Birth"];
	lbl_city.text=[eEducationAppDelegate getLocalvalue:@"City"];
	lbl_province.text=[eEducationAppDelegate getLocalvalue:@"Province"];
	lbl_country.text=[eEducationAppDelegate getLocalvalue:@"Country"];
	lbl_telephone.text=[eEducationAppDelegate getLocalvalue:@"Telephone"];
	lbl_passwordSettings.text=[eEducationAppDelegate getLocalvalue:@"Password Settings :"];
	lbl_currentPwd.text=[eEducationAppDelegate getLocalvalue:@"Current Password"];
	lbl_newPwd.text=[eEducationAppDelegate getLocalvalue:@"New Password"];
	lbl_reEnterPwd.text=[eEducationAppDelegate getLocalvalue:@"Re-enter Password"];
}

#pragma mark -
#pragma mark JSONParser delegate method
- (void)parserDidFinishLoadingReturnData:(NSString *)responseString
{
    [HUD setHidden:YES];
	SBJSON *json = [SBJSON new];
	if(!ArrayResponse)
	{
		ArrayResponse = (NSMutableArray*) [json objectWithString:responseString error:nil];
		[self ReloadSettingsData];
	}
	else 
	{
		ArrayResponse = (NSMutableArray*) [json objectWithString:responseString error:nil];
		UIAlertView *AlertView =  [[UIAlertView alloc]  initWithTitle:alertTitle
															  message:[eEducationAppDelegate getLocalvalue:@"Record updates successfully"]
															 delegate:self 
													cancelButtonTitle:nil
													otherButtonTitles:[eEducationAppDelegate getLocalvalue:@"OK"], nil];
		[AlertView show];
		AlertView.tag=33;
	}
}

- (void)parserDidFailWithRestoreError:(NSError*)error :(NSString*)msg
{
	[HUD setHidden:YES];
    if ([msg isEqualToString:@""]) {
        msg = [eEducationAppDelegate getLocalvalue:@"The server cannot be reached. It could be down or busy. Please try again later."];
    }
	UIAlertView *AlertView =  [[UIAlertView alloc]  initWithTitle:alertTitle message:msg delegate:self cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil, nil];
	AlertView.tag=TAG_FailError;
	[AlertView show];
}

#pragma mark -
#pragma mark  orientation LifeCycle
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
		
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown )
	{
		tab1.frame=CGRectMake(124, 955, 80, 49);
		tab2.frame=CGRectMake(234, 955, 80, 49);
		tab3.frame=CGRectMake(344, 955, 80, 49);
		tab4.frame=CGRectMake(454, 955, 80 ,49);
		tab5.frame=CGRectMake(564, 955, 80 ,49);
		scrlView.contentSize=CGSizeMake(scrlView.frame.size.width, 870);
	}
	else 
	{
		tab1.frame=CGRectMake(252, 699, 80, 49);
		tab2.frame=CGRectMake(362, 699, 80, 49);
		tab3.frame=CGRectMake(472, 699, 80, 49);
		tab4.frame=CGRectMake(582, 699, 80 ,49);
		tab5.frame=CGRectMake(692, 699, 80,49);
		scrlView.contentSize=CGSizeMake(scrlView.frame.size.width, 870);
	}
	if([popoverController isPopoverVisible])
	{
		[scrlView setContentOffset:CGPointMake(0, 250)];
		[popoverController presentPopoverFromRect:btn_DOB.frame inView:scrlView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	}
}

#pragma mark -
#pragma mark  Action methods 
-(IBAction) btChangePhotoPressed:(id)sender{
    actionSheet=[[UIActionSheet alloc] initWithTitle:[eEducationAppDelegate getLocalvalue:@""] delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:[eEducationAppDelegate getLocalvalue:@"Take a Photo"],[eEducationAppDelegate getLocalvalue:@"Choose Existing"],[eEducationAppDelegate getLocalvalue:@"Cancel"], nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [actionSheet showFromRect:[sender frame] inView:[sender superview] animated:YES];
}

-(IBAction) TabarIndexSelected:(id)sender
{
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"course_id"] isEqualToString:@""]) {
        UIButton *btn=sender;
        int i=btn.tag/11;
        appDelegate=(eEducationAppDelegate *)[[UIApplication sharedApplication] delegate];
        [[validations getAppDelegateInstance] removePresentVC];
        [appDelegate pushToTabbarWithSelection:i];
        [self releaseObjects];
    }
}

-(IBAction)btnStudentsClicked:(id)sender{
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"course_id"] isEqualToString:@""]) {
        OtherStudents *objOtherStudents = [[OtherStudents alloc] initWithNibName:@"OtherStudents" bundle:nil];
        [[validations getAppDelegateInstance] removePresentVC];
        [[validations getAppDelegateInstance].navigationController pushViewController:objOtherStudents animated:NO];
        [self releaseObjects];
    }
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
    [self releaseObjects];
}

-(IBAction) btn_HomePressed:(id)sender
{
    @try {
        [[validations getAppDelegateInstance].navigationController popToViewController:[[validations getAppDelegateInstance].navigationController.viewControllers objectAtIndex:2] animated:NO];
        [self releaseObjects];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(void)tabOnOff_clicked:(UIButton *)sender
{
	sender.selected=!sender.selected;
    if (sender == btn_Language) {
        didLangClick = YES;
    }
}

#pragma mark -
#pragma mark  UIAlertViewDelegate methods 
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	if(alertView.tag==TAG_FailError)
	{
		if(buttonIndex==0)
		{
			[self btn_HomePressed:nil];
		}
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag==99 && buttonIndex!=0)
	{
        eEducationAppDelegate *obj = (eEducationAppDelegate*)[UIApplication sharedApplication].delegate;
        [obj.navigationController popToViewController:[obj.navigationController.viewControllers objectAtIndex:1] animated:NO];
        [self releaseObjects];
    } else if((alertView.tag == TAG_ALERT_LOGOUT && buttonIndex ==1)){
        [self goBack];
    } else if(alertView.tag == 33){
        [self goBack];
    }
}

#pragma mark -
#pragma mark  DatePicker methods
-(IBAction) btn_SavePressed:(id)sender
{
	[self MakeValidation];
}

-(void)btnDOB_clicked:(id)sender
{
    [self.view endEditing:YES];
	str_previousValue=lbl_DOBValue.text;
	UIViewController* popoverContent = [[UIViewController alloc] init];
	UIView* popoverView = [[UIView alloc] init];
	pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
	pickerToolbar.barStyle = UIBarStyleBlackOpaque;
	NSMutableArray *barItems = [[NSMutableArray alloc] init];
	UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:[eEducationAppDelegate getLocalvalue:@"Cancel"] style:UIBarButtonSystemItemCancel target:self action:@selector(cancel_clicked:)];
	[barItems addObject:cancelBtn];
	UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[barItems addObject:flexSpace];
	UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:[eEducationAppDelegate getLocalvalue:@"Done"] style:UIBarButtonItemStyleDone target:self action:@selector(done_clicked:)];
	[barItems addObject:doneBtn];
	[pickerToolbar setItems:barItems animated:YES];
	[popoverView addSubview:pickerToolbar];
	datePicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0,44,320, 340)];
    [datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
	datePicker.datePickerMode = UIDatePickerModeDate;
	datePicker.maximumDate=[NSDate date];
	[datePicker addTarget:self action:@selector(Result) forControlEvents:UIControlEventValueChanged];
	[popoverView addSubview:datePicker];
	popoverContent.view = popoverView;
	popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
	popoverController.delegate=self;
	[popoverController setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
	[popoverController presentPopoverFromRect:btn_DOB.frame inView:scrlView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)Result
{
	NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
	[format setDateFormat:@"dd-MM-yyyy"];
	lbl_DOBValue.text=[format stringFromDate:[datePicker date]];
}

-(void)cancel_clicked:(id)sender
{
	[scrlView setContentOffset:CGPointMake(0, 0)];
	lbl_DOBValue.text=str_previousValue;
	[popoverController dismissPopoverAnimated:YES];
}

-(void)done_clicked:(id)sender
{
	[scrlView setContentOffset:CGPointMake(0, 0)];
	NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
	[format setDateFormat:@"dd-MM-yyyy"];
	lbl_DOBValue.text=[format stringFromDate:[datePicker date]];
	str_previousValue =  lbl_DOBValue.text;
	[popoverController dismissPopoverAnimated:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)_popoverController
{
	[self cancel_clicked:self];
}

#pragma mark -
#pragma mark  Validation methods 
-(void)MakeValidation
{
	NSString *MsgStr = @"";
	int ErrFlag = 2;	
	NSMutableDictionary *EditSettingData=[[NSMutableDictionary alloc] init];
	if( ! [ validations isValidData:txt_firstNameValue.text ] )
	{
        [txt_firstNameValue becomeFirstResponder];
		ErrFlag = 1;
		MsgStr = [eEducationAppDelegate getLocalvalue:@"Please enter firstname."];
	}
	else if(![validations isValidData:txt_lastNameValue.text])
	{
		ErrFlag = 1;
        [txt_lastNameValue becomeFirstResponder];
		MsgStr = [eEducationAppDelegate getLocalvalue:@"Please enter lastname."];
	}
	else if(![validations isValidData:txt_eMailValue.text])
	{
		ErrFlag = 1;
        [txt_eMailValue becomeFirstResponder];
		MsgStr = [eEducationAppDelegate getLocalvalue:@"Please enter email address."];
	}
	else if(![validations validateEmail:txt_eMailValue.text error:&MsgStr])
	{
		ErrFlag = 1;
        [txt_eMailValue becomeFirstResponder];
		MsgStr = [eEducationAppDelegate getLocalvalue:@"Please enter valid email address."];
	}
	else if([lbl_DOBValue.text isEqualToString:[eEducationAppDelegate getLocalvalue:@"Select date"]])
	{
		ErrFlag = 1;
		MsgStr = [eEducationAppDelegate getLocalvalue:@"Please select date of birth."];
	}
	else if(![validations isValidData:txt_cityValue.text ])
	{
		ErrFlag = 1;
        [txt_cityValue becomeFirstResponder];
		MsgStr = [eEducationAppDelegate getLocalvalue:@"Please enter city."];
	}
	else if(![validations isValidData:txt_provinceValue.text])
	{
		ErrFlag = 1;
        [txt_provinceValue becomeFirstResponder];
		MsgStr = [eEducationAppDelegate getLocalvalue:@"Please enter province."];
	}
	else if(![validations isValidData:txt_countryValue.text])
	{
		ErrFlag = 1;
        [txt_countryValue becomeFirstResponder];
		MsgStr = [eEducationAppDelegate getLocalvalue:@"Please enter country."];
	}
	else if(![validations isValidData:txt_telephoneValue.text])
	{
		ErrFlag = 1;
        [txt_telephoneValue becomeFirstResponder];
		MsgStr = [eEducationAppDelegate getLocalvalue:@"Please enter telephone."];
	}
	else if([validations isValidData:txt_currentPwdValue.text] && ![validations comparePasswords:txt_currentPwdValue.text confirmPassword:[SettingsDict objectForKey:@"password"]])
	{
		ErrFlag = 1;
        [txt_currentPwdValue becomeFirstResponder];
		MsgStr = [eEducationAppDelegate getLocalvalue:@"Please enter valid current password."];
	}
	else if([validations isValidData:txt_currentPwdValue.text] && ![validations isValidData:txt_newPwdValue.text])
	{
		ErrFlag = 1;
        [txt_newPwdValue becomeFirstResponder];
		MsgStr =[eEducationAppDelegate getLocalvalue: @"Please enter new password."];
	}
    else if([validations isValidData:txt_currentPwdValue.text] && ![validations isValidData:txt_reEnterPwdValue.text])
	{
		ErrFlag = 1;
        [txt_reEnterPwdValue becomeFirstResponder];
		MsgStr =[eEducationAppDelegate getLocalvalue: @"Please re-enter password."];
	}
	else if(![validations comparePasswords:txt_reEnterPwdValue.text confirmPassword:txt_newPwdValue.text])
	{
		ErrFlag = 1;
		MsgStr =[eEducationAppDelegate getLocalvalue:@"Both new password and confirm password should be equal."];
	}
	
	if(ErrFlag == 1)
	{
		UIAlertView *AlertView =[[UIAlertView alloc]  initWithTitle:alertTitle 
													  message:MsgStr
													  delegate:nil 
													  cancelButtonTitle:nil
												      otherButtonTitles:[eEducationAppDelegate getLocalvalue:@"OK"], nil];
		[AlertView show];
	}
	else 
	{
		[EditSettingData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] forKey:@"user_id"];
		[[NSUserDefaults standardUserDefaults] setObject:btn_autoLogin.selected?@"YES":@"NO" forKey:@"IS_AUTO_LOGIN"];
		[[NSUserDefaults standardUserDefaults] setObject:btn_Language.selected?@"NO":@"YES" forKey:@"IS_SPANISH_LANG"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[EditSettingData setObject:txt_firstNameValue.text forKey:@"first_name"];
		[EditSettingData setObject:txt_lastNameValue.text forKey:@"last_name"];
		[EditSettingData setObject:txt_eMailValue.text forKey:@"email"];
		[EditSettingData setObject:lbl_usernameValue.text forKey:@"username"];
		[EditSettingData setObject:lbl_DOBValue.text forKey:@"date_of_birth"];
		[EditSettingData setObject:txt_cityValue.text forKey:@"city"];
		[EditSettingData setObject:txt_provinceValue.text forKey:@"province"];
		[EditSettingData setObject:txt_countryValue.text forKey:@"country"];
		[EditSettingData setObject:txt_telephoneValue.text forKey:@"telephone"];
		[EditSettingData setObject:txt_currentPwdValue.text forKey:@"old_pass"];
		[EditSettingData setObject:txt_newPwdValue.text forKey:@"new_pass"];
		[EditSettingData setObject:txt_reEnterPwdValue.text forKey:@"confirm_pass"];
        if (self.dataPic != nil) {
            [EditSettingData setObject:self.dataPic forKey:@"userImage"];
        }


         NSString *strURL = [WebService GetSettingEditDataXml];
		HUD = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
		HUD.labelText=[eEducationAppDelegate getLocalvalue:@"Please wait"];
        if (self.dataPic != nil) {
            [objParser sendRequestToPostImage:strURL params:EditSettingData :self.dataPic];
        } else {
            [objParser sendRequestToParse:strURL params:EditSettingData];
        }
        [eEducationAppDelegate GetLangKey:(btn_Language.selected)?@"en":@"sp"];
	}
	if([[[NSUserDefaults standardUserDefaults] objectForKey:@"IS_SPANISH_LANG"] isEqualToString:@"YES"]) {
		[[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"vLang"];
		[[NSUserDefaults standardUserDefaults] setObject:@"Spanish" forKey:@"vLanguage"];
	} else {
		[[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"vLang"];
		[[NSUserDefaults standardUserDefaults] setObject:@"English" forKey:@"vLanguage"];
	}
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
#pragma mark  UITextFieldDelegate methods 
- (void)textFieldDidBeginEditing:(UITextField *)textField
{ 
    isReturned = FALSE;
    currentTxtField = textField;
    [self scrollViewToCenterOfScreen:scrlView theView:textField toShow:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{ 
    [textField resignFirstResponder];
    isReturned = TRUE;
    if (textField == txt_firstNameValue) {
        [txt_lastNameValue becomeFirstResponder];
    } else if (textField == txt_lastNameValue) {
        [txt_eMailValue becomeFirstResponder];
    } else if (textField == txt_eMailValue) {
        [txt_cityValue becomeFirstResponder];
    } else if (textField == txt_cityValue) {
        [txt_provinceValue becomeFirstResponder];
    } else if (textField == txt_provinceValue) {
        [txt_countryValue becomeFirstResponder];
    } else if (textField == txt_countryValue) {
        [txt_telephoneValue becomeFirstResponder];
    } else if (textField == txt_currentPwdValue) {
        [txt_newPwdValue becomeFirstResponder];
    } else if (textField == txt_newPwdValue) {
        [txt_reEnterPwdValue becomeFirstResponder];
    } 
    return NO;
} 

- (UIScrollView*) scrollViewToCenterOfScreen:(UIScrollView*)_scrlView theView:(UIView *)theView toShow:(BOOL)toShow
{
    float reqSize1=320,reqSize2=300;
    CGFloat viewMaxY = CGRectGetMaxY(theView.frame) + theView.superview.frame.origin.y + 75;
   	CGFloat availableHeight;
    BOOL isPortrait = UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
    CGSize viewSize = CGSizeMake(isPortrait?reqSize1:([UIScreen mainScreen].applicationFrame.size.height), isPortrait?([UIScreen mainScreen].applicationFrame.size.height):reqSize2);
	if (toShow)
	{
        float keyHeight = KEYBOARD_HEIGHT;
        if ([theView isKindOfClass : [UITextField class]] && [theView tag]==1234) {
            keyHeight  = keyHeight +44;
        }
        if ([theView isKindOfClass : [UITextField class]] && [theView tag]==222) {
            keyHeight  = keyHeight +60;
        }
        if ([theView isKindOfClass : [UITextField class]] && [theView tag]==789) {
            keyHeight  = keyHeight +20;
        }
		availableHeight = viewSize.height - keyHeight - (CGRectGetMinY(_scrlView.frame));
	}
	else
	{
		availableHeight = viewSize.height + KEYBOARD_HEIGHT + (CGRectGetMinY(_scrlView.frame));
	}
	CGFloat y = viewMaxY - availableHeight;
	if (y < 0)
	{
        y = 0;
	}
    if (toShow)
        [_scrlView setContentOffset:CGPointMake(_scrlView.contentOffset.x, y) animated:YES];
    else
    {
        CGFloat posY = ((_scrlView.contentOffset.y+_scrlView.frame.size.height)>_scrlView.contentSize.height)?(_scrlView.contentSize.height-_scrlView.frame.size.height):(_scrlView.contentOffset.y);
        
        [_scrlView setContentOffset:CGPointMake(_scrlView.contentOffset.x,(posY<0)?0:posY) animated:YES];
        
    }
    return _scrlView;
}

- (void)actionSheet:(UIActionSheet *)actionSheets clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex ==0){
        [self attachImage:@"Camera"];
    }else if(buttonIndex ==1){
        [self attachImage:@"Gallery"];
    }else if(buttonIndex ==2){
        [popoverImages dismissPopoverAnimated:YES];
    }
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)attachImage:(NSString*)fromType{
    if([fromType isEqualToString:@"Camera"]){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *objImagePickerController = [[UIImagePickerController alloc] init];
            objImagePickerController.delegate = self;
            [objImagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self presentModalViewController:objImagePickerController animated:YES];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[eEducationAppDelegate getLocalvalue:@"Current device doesn't have camera."] message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:[eEducationAppDelegate getLocalvalue:@"OK"],nil];
            [alert show];
        }
    }else {
        UIImagePickerController *objImagePickerController = [[UIImagePickerController alloc] init];
        objImagePickerController.delegate = self;
        [objImagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [objImagePickerController setMediaTypes:[NSArray arrayWithObject:@"public.image"]];
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            popoverImages = [[UIPopoverController alloc]initWithContentViewController:[self imagePickerControllerSetting:UIImagePickerControllerSourceTypePhotoLibrary mode:UIImagePickerControllerCameraCaptureModePhoto mediaType:[NSArray arrayWithObject:[NSString stringWithFormat:@"public.image"]]]];
            popoverImages.delegate =self;
            [popoverImages presentPopoverFromRect:[self.btnProfileUpload frame] inView:[self.btnProfileUpload superview] permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }else
            [self presentModalViewController:objImagePickerController animated:YES];
    }
}

- (UIImagePickerController*)imagePickerControllerSetting:(UIImagePickerControllerSourceType)sourceType mode:(UIImagePickerControllerCameraCaptureMode)mode mediaType:(NSArray*)mediaType{
    UIImagePickerController *objImagePickerController = [[UIImagePickerController alloc] init];
    UIToolbar *pickerToolbarForImage = [[UIToolbar alloc] initWithFrame:CGRectMake(0,-5,320,40)];
    pickerToolbarForImage.barStyle = UIBarStyleBlackTranslucent;
    pickerToolbarForImage.tintColor = [UIColor colorWithRed:0.009 green:0.064 blue:0.139 alpha:1.000];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:[eEducationAppDelegate getLocalvalue:@"Cancel"] style:UIBarButtonItemStyleBordered target:self action:@selector(imagePickerCancel_clicked:)];
    [barItems addObject:cancelBtn];
    [pickerToolbarForImage setItems:barItems animated:YES];
    [objImagePickerController.view addSubview:pickerToolbar];
    [objImagePickerController setDelegate:self];
    [objImagePickerController setSourceType:sourceType];
    [objImagePickerController setMediaTypes:mediaType];
    if(![objImagePickerController sourceType] == UIImagePickerControllerSourceTypePhotoLibrary){
        [objImagePickerController setCameraCaptureMode:mode];
    }
    return objImagePickerController;
}

#pragma mark - ImagePickerDelegate Methods
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [popoverImages dismissPopoverAnimated:YES];
    UIImage *img = [eEducationAppDelegate imageByScalingAndCroppingForSize:CGSizeMake(self.imgBig.frame.size.width*2, self.imgBig.frame.size.height*2) andImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    self.dataPic = UIImageJPEGRepresentation(img, 1);
    [self.imgBig loadImage:img];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark  Memory management methods 
- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)releaseObjects {
    self.tap=nil;
	scrlView=nil;
	lbl_heading=nil;
	lbl_generalSettings=nil;
	lbl_autoLogin=nil;
	lbl_setAlerts=nil;
	btn_autoLogin=nil;
	btn_setAlerts=nil;
	btn_Language=nil;
	lbl_profileSettings=nil;
	lbl_firstName=nil;
	lbl_lastName=nil;
	lbl_eMail=nil;
	lbl_username=nil;
	lbl_DOB=nil;
	lbl_city=nil;
	lbl_province=nil;
	lbl_country=nil;
	lbl_telephone=nil;
	txt_firstNameValue=nil;
	txt_lastNameValue=nil;
	txt_eMailValue=nil;
	lbl_usernameValue=nil;
	lbl_DOBValue=nil;
	txt_cityValue=nil;
	txt_provinceValue=nil;
	txt_countryValue=nil;
	txt_telephoneValue=nil;
	btn_DOB=nil;
	lbl_passwordSettings=nil;
	lbl_currentPwd=nil;
	lbl_newPwd=nil;
	lbl_reEnterPwd=nil;
	txt_currentPwdValue=nil;
	txt_newPwdValue=nil;
	txt_reEnterPwdValue=nil;
	tab1=nil;
	tab2=nil;
	tab3=nil;
	tab4=nil;
	tab5=nil;
	btn_Save=nil;
	currentTxtField=nil;
	actionSheet=nil;
	str_previousValue=nil;
	objParser=nil;
	ArrayResponse=nil;
	SettingsDict=nil;
	HUD=nil;
    
    self.imgProfile=nil;
    self.imgBig=nil;
    self.imgLogo=nil;
    self.imgLogoStatic=nil;
    self.lblProfileGrayName=nil;
    self.lblProfileBlueName=nil;
    self.lblTopCourse=nil;
    self.lblTopDuration=nil;
    self.btnHome=nil;
    self.btnModule=nil;
    self.btnOtherStudents=nil;
    self.btnProfileUpload=nil;
    self.imgModuleArrow=nil;
    self.tap=nil;
    self.objPicker=nil;
    self.dataPic=nil;
}

@end
