    //
//  SearchViewController.m
//  eEducation
//
//  Created by HB 13 on 21/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"


@implementation SearchViewController
@synthesize textFieldCourse = _textFieldCourse;
@synthesize labelColon = _labelColon;
@synthesize textFieldModule = _textFieldModule;
@synthesize textFieldDocument = _textFieldDocument;
@synthesize arraySearchResult = _arraySearchResult;
@synthesize btnDownloadedDocument;
@synthesize btnAttemptTest;
@synthesize isAttemptToTest;
@synthesize delegate;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void) viewWillAppear:(BOOL)animated
{
	[self setLocalizedvalues];
	[self.view addSubview:searchView];
	self.navigationController.navigationBarHidden=YES;
	[self willAnimateRotationToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0];
}
-(void) setLocalizedvalues
{
	

	[btnSearch setImage:[eEducationAppDelegate GetLocalImage:@"btn_Search"] forState:0];
	[btnSearch setImage:[eEducationAppDelegate GetLocalImage:@"btn_Search_h"] forState:UIControlStateHighlighted];
	[btnCancel setImage:[eEducationAppDelegate GetLocalImage:@"btn_cancel1"] forState:0];
	[btnCancel setImage:[eEducationAppDelegate GetLocalImage:@"btn_cancel1_h"] forState:UIControlStateHighlighted];
	
	_textFieldCourse.placeholder=[eEducationAppDelegate getLocalvalue:@"Enter Course Name"];
	_textFieldModule.placeholder=[eEducationAppDelegate getLocalvalue:@"Enter Module Name"];
	lbl_searchCourse.text=[eEducationAppDelegate getLocalvalue:@"Course"];
	lbl_searchChapter.text=[eEducationAppDelegate getLocalvalue:@"Chapter"];
	lbl_searchDocument.text=[eEducationAppDelegate getLocalvalue:@"Document"];
	lbl_searchDocumentType.text=[eEducationAppDelegate getLocalvalue:@"Select Type"];
	lbl_searchTypeOFDocument.text=[eEducationAppDelegate getLocalvalue:@"Type of Document"];
	[btnDownloadedDocument setTitle:[eEducationAppDelegate getLocalvalue:@"DOWNLOADED DOCUMENTS"] forState:UIControlStateNormal];
	[btnDownloadedDocument setTitle:[eEducationAppDelegate getLocalvalue:@"DOWNLOADED DOCUMENTS"] forState:UIControlStateHighlighted];
	[btnAttemptTest setTitle:[eEducationAppDelegate getLocalvalue:@"ATTEMPT FOR TEST"] forState:UIControlStateNormal];
	[btnAttemptTest setTitle:[eEducationAppDelegate getLocalvalue:@"ATTEMPT FOR TEST"] forState:UIControlStateHighlighted];
	
	if(isAttemptToTest)
	{
		btnDownloadedDocument.selected = NO;
		btnAttemptTest.selected = YES;
		
		lbl_searchDocumentType.hidden = YES;
		lbl_searchTypeOFDocument.hidden = YES;
		btn_DocType.hidden = YES;
		_labelColon.hidden = YES;
		lbl_searchDocument.text = [eEducationAppDelegate getLocalvalue:@"Test"];
		_textFieldDocument.placeholder = [eEducationAppDelegate getLocalvalue:@"Enter Test Name"];
	}
	else 
	{
		btnDownloadedDocument.selected = YES;
		btnAttemptTest.selected = NO;
		
		lbl_searchDocumentType.hidden = NO;
		lbl_searchTypeOFDocument.hidden = NO;
		btn_DocType.hidden = NO;
		_labelColon.hidden = NO;
		lbl_searchDocument.text = [eEducationAppDelegate getLocalvalue:@"Document"];
		_textFieldDocument.placeholder = [eEducationAppDelegate getLocalvalue:@"Enter Document Name"];
	}
}
#pragma mark -
#pragma mark Action Method
-(IBAction)btnHome_Clicked:(id)sender
{
	if(isAttemptToTest)
	{
		if(_arraySearchResult)
		{
			[_arraySearchResult release];
			_arraySearchResult=nil;
		}
		_arraySearchResult = [[NSMutableArray alloc] initWithArray:[DataBase readalltestDetails]];
		[self.delegate getSearchAtrray:_arraySearchResult docselected:NO];
	}
	else 
	{
		if(_arraySearchResult)
		{
			[_arraySearchResult release];
			_arraySearchResult=nil;
		}
		_arraySearchResult = [[NSMutableArray alloc] initWithArray:[DataBase readAllDocumentDetais]];
		[self.delegate getSearchAtrray:_arraySearchResult docselected:YES];
	}

	[self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnDocumentTypeClicked:(id)sender
{
	str_previousValue=lbl_searchDocumentType.text;
	[str_previousValue retain];
	
	UIViewController* popoverContent = [[UIViewController alloc] init];	
	UIView* popoverView = [[UIView alloc] init];
	popoverView.backgroundColor = [UIColor blackColor];
	
	pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
	pickerToolbar.barStyle = UIBarStyleBlackOpaque;
	NSMutableArray *barItems = [[NSMutableArray alloc] init];
	
	UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:[eEducationAppDelegate getLocalvalue:@"cancel"] style:UIBarButtonSystemItemCancel target:self action:@selector(cancel_clicked:)];
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
	[barItems release];
	[pickerToolbar release];
	Picker=[[UIPickerView alloc] initWithFrame:CGRectMake(0,44,320, 340)];
	Picker.delegate=self;
	Picker.dataSource=self;
	Picker.showsSelectionIndicator=YES;
	[popoverView addSubview:Picker];
	if([lbl_searchDocumentType.text isEqualToString:@"PDF"] )
	{
		[Picker selectRow:0  inComponent:0 animated:YES];
	}
	else if([lbl_searchDocumentType.text isEqualToString:@"ePUB"])
	{
		[Picker selectRow:1  inComponent:0 animated:YES];
	}
	[Picker release];
	
	
	popoverContent.view = popoverView;
	popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
	[popoverController setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
	[popoverController presentPopoverFromRect:btn_DocType.frame inView:searchView  permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	[popoverView release];
	[popoverContent release];
	
	
}
-(IBAction)btnDownloadedDocument_Clicked:(id)sender
{
	btnDownloadedDocument.selected = YES;
	btnAttemptTest.selected = NO;
	lbl_searchDocumentType.hidden = NO;
	lbl_searchTypeOFDocument.hidden = NO;
	btn_DocType.hidden = NO;
	_labelColon.hidden = NO;
	lbl_searchDocument.text = [eEducationAppDelegate getLocalvalue:@"Document"];
	_textFieldDocument.placeholder = [eEducationAppDelegate getLocalvalue:@"Enter Document Name"];
}
-(IBAction)btnAttemptTest_Clicked:(id)sender
{
	btnDownloadedDocument.selected = NO;
	btnAttemptTest.selected = YES;
	lbl_searchDocumentType.hidden = YES;
	lbl_searchTypeOFDocument.hidden = YES;
	btn_DocType.hidden = YES;
	_labelColon.hidden = YES;
	
	lbl_searchDocument.text = [eEducationAppDelegate getLocalvalue:@"Test"];
	_textFieldDocument.placeholder = [eEducationAppDelegate getLocalvalue:@"Enter Test Name"];
	
}
-(IBAction)CacncelClick:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)SubmitClick:(id)sender
{
	
	if(btnDownloadedDocument.selected)
	{
		NSString *str_Query = @"";
		if([_textFieldCourse.text length]!=0&&([_textFieldDocument.text length]==0&&[_textFieldModule.text length]==0&&[lbl_searchDocumentType.text isEqualToString:[eEducationAppDelegate getLocalvalue:@"Select Type"]]))
			str_Query = [str_Query stringByAppendingFormat:@"SELECT  * from DocumentDetails WHERE vLang_Id = %i AND course_name like \'%@%%\'",[[[NSUserDefaults standardUserDefaults]objectForKey:@"vLang"]intValue],_textFieldCourse.text];
		else if([_textFieldDocument.text length]!=0&&([_textFieldCourse.text length]==0&&[_textFieldModule.text length]==0&&[lbl_searchDocumentType.text isEqualToString:[eEducationAppDelegate getLocalvalue:@"Select Type"]]))
			str_Query = [str_Query stringByAppendingFormat:@"SELECT  * from DocumentDetails WHERE vLang_Id = %i AND doc_name like \'%@%%\'",[[[NSUserDefaults standardUserDefaults]objectForKey:@"vLang"]intValue],_textFieldDocument.text];
		else if([_textFieldModule.text length]!=0&&([_textFieldCourse.text length]==0&&[_textFieldDocument.text length]==0&&[lbl_searchDocumentType.text isEqualToString:[eEducationAppDelegate getLocalvalue:@"Select Type"]]))
			str_Query = [str_Query stringByAppendingFormat:@"SELECT  * from DocumentDetails WHERE vLang_Id = %i AND module_name like \'%@%%\'",[[[NSUserDefaults standardUserDefaults]objectForKey:@"vLang"]intValue],_textFieldModule.text];
		else if(![lbl_searchDocumentType.text isEqualToString:[eEducationAppDelegate getLocalvalue:@"Select Type"]]&&([_textFieldDocument.text length]==0&&[_textFieldModule.text length]==0&&[_textFieldCourse.text length]==0))
			str_Query = [str_Query stringByAppendingFormat:@"SELECT  * from DocumentDetails WHERE vLang_Id = %i AND doc_type like \'%@%%\'",[[[NSUserDefaults standardUserDefaults]objectForKey:@"vLang"]intValue],lbl_searchDocumentType.text];
		else {
			str_Query = [str_Query stringByAppendingFormat:@"SELECT  * from DocumentDetails WHERE vLang_Id = %i AND",[[[NSUserDefaults standardUserDefaults]objectForKey:@"vLang"]intValue]];
			if([_textFieldCourse.text length]!=0)
				str_Query = ([str_Query hasSuffix:@"AND "])?[str_Query stringByAppendingFormat:@"course_name like \'%@%%\'",_textFieldCourse.text]:[str_Query stringByAppendingFormat:@"course_name like \'%@%%\'",_textFieldCourse.text];
			if([_textFieldModule.text length]!=0)
				str_Query = ([str_Query hasSuffix:@"AND "])?[str_Query stringByAppendingFormat:@"module_name like \'%@%%\'",_textFieldModule.text]:[str_Query stringByAppendingFormat:@" AND module_name like \'%@%%\'",_textFieldModule.text];
			if([_textFieldDocument.text length]!=0)
				str_Query = ([str_Query hasSuffix:@"AND "])?[str_Query stringByAppendingFormat:@"doc_name like \'%@%%\'",_textFieldDocument.text]:[str_Query stringByAppendingFormat:@" AND doc_name like \'%@%%\'",_textFieldDocument.text];
			if(![lbl_searchDocumentType.text isEqualToString:[eEducationAppDelegate getLocalvalue:@"Select Type"]])
				str_Query = ([str_Query hasSuffix:@"AND "])?[str_Query stringByAppendingFormat:@"doc_type like \'%@%%\'",lbl_searchDocumentType.text]:[str_Query stringByAppendingFormat:@" AND doc_type like \'%@%%\'",lbl_searchDocumentType.text];
		}
		if([str_Query hasSuffix:@"WHERE "])
			str_Query = [str_Query substringToIndex:[str_Query rangeOfString:@"WHERE"].location];
		
		if(_arraySearchResult)
		{
			[_arraySearchResult release];
			_arraySearchResult=nil;
		}
		_arraySearchResult = [[NSMutableArray alloc] initWithArray:[DataBase readDocumentSearchResults:str_Query]];
	}
	else if(btnAttemptTest.selected) 
	{
		if(_arraySearchResult)
		{
			[_arraySearchResult release];
			_arraySearchResult=nil;
		}
		NSString *str_Query = @"";
		if([_textFieldCourse.text length]!=0&&([_textFieldDocument.text length]==0&&[_textFieldModule.text length]==0))
			str_Query = [str_Query stringByAppendingFormat:@"SELECT  * from TestDetails WHERE course_name like \'%@%%\'",_textFieldCourse.text];
		else if([_textFieldDocument.text length]!=0&&([_textFieldCourse.text length]==0&&[_textFieldModule.text length]==0))
			str_Query = [str_Query stringByAppendingFormat:@"SELECT  * from TestDetails WHERE test_name like \'%@%%\'",_textFieldDocument.text];
		else if([_textFieldModule.text length]!=0&&([_textFieldCourse.text length]==0&&[_textFieldDocument.text length]==0))
			str_Query = [str_Query stringByAppendingFormat:@"SELECT  * from TestDetails WHERE module_name like \'%@%%\'",_textFieldModule.text];
		else {
			str_Query = [str_Query stringByAppendingFormat:@"SELECT  * from TestDetails WHERE "];
			if([_textFieldCourse.text length]!=0)
				str_Query = ([str_Query hasSuffix:@"WHERE "])?[str_Query stringByAppendingFormat:@"course_name like \'%@%%\'",_textFieldCourse.text]:[str_Query stringByAppendingFormat:@"course_name like \'%@%%\'",_textFieldCourse.text];
			if([_textFieldModule.text length]!=0)
				str_Query = ([str_Query hasSuffix:@"WHERE "])?[str_Query stringByAppendingFormat:@"module_name like \'%@%%\'",_textFieldModule.text]:[str_Query stringByAppendingFormat:@" AND module_name like \'%@%%\'",_textFieldModule.text];
			if([_textFieldDocument.text length]!=0)
				str_Query = ([str_Query hasSuffix:@"WHERE "])?[str_Query stringByAppendingFormat:@"test_name like \'%@%%\'",_textFieldDocument.text]:[str_Query stringByAppendingFormat:@" AND test_name like \'%@%%\'",_textFieldDocument.text];
		}
		if([str_Query hasSuffix:@"WHERE "])
		{
			str_Query = [str_Query substringToIndex:[str_Query rangeOfString:@"WHERE"].location];
		}		
		_arraySearchResult = [[NSMutableArray alloc] initWithArray:[DataBase readTestSearchResults:str_Query]];
	}

	[self.delegate getSearchAtrray:_arraySearchResult docselected:btnDownloadedDocument.selected];
	[self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark  UIPickerView delegate Methods
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return	1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return	2;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{ 
	switch (row) {
		case 0:
			 return @"PDF";
			break;
		case 1:
			return @"ePUB";
			break;
		default:
			break;
	}
	return @"";
} 
-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	switch (row) {
		case 0:
			lbl_searchDocumentType.text =  @"PDF";
			break;
		case 1:
			lbl_searchDocumentType.text =  @"ePUB";
			break;
		default:
			break;
	}
	
}
-(void)cancel_clicked:(id)sender
{
	lbl_searchDocumentType.text=str_previousValue;
	[popoverController dismissPopoverAnimated:YES];
}
-(void)done_clicked:(id)sender
{
	if([Picker selectedRowInComponent:0]==0)
	{
		lbl_searchDocumentType.text = @"PDF";
	}
	else if([Picker selectedRowInComponent:0]==1)
	{
		lbl_searchDocumentType.text = @"ePUB";
	}
	
	str_previousValue =  lbl_searchDocumentType.text;
	[popoverController dismissPopoverAnimated:YES];
}

#pragma mark -
#pragma mark orientation Life Cycle

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown )
	{
		searchView.frame=CGRectMake(0, 105, 768, 400);
		btnDownloadedDocument.frame=CGRectMake(111, 48, 269, 45);
		btnAttemptTest.frame=CGRectMake(388, 48, 269, 45);
	}
	else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight )
	{
		searchView.frame=CGRectMake(145, 105, 768, 400);
		btnDownloadedDocument.frame=CGRectMake(240, 48, 269, 45);
		btnAttemptTest.frame=CGRectMake(517, 48, 269, 45);
	}
	
	
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

#pragma mark -
#pragma mark UITextField delegate 
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[_textFieldCourse release];_textFieldCourse=nil;
	[_textFieldModule release];_textFieldModule=nil;
	[_textFieldDocument release];_textFieldDocument=nil;
	[_arraySearchResult release];_arraySearchResult=nil;
    [super dealloc];
}


@end
