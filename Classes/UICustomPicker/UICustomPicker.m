    //
//  UICustomPicker.m
//  pickerTest
//
//  Created by HB17 on 19/09/11.
//  Copyright 2011 HiddenBrains. All rights reserved.
//

#import "UICustomPicker.h"

#define Separator @"--------------------"

@implementation UICustomPicker
@synthesize delegate;

-(void)initWithCustomPicker:(CGRect)rect inView:(id)AddView ContentSize:(CGSize)ContentSize pickerSize:(CGRect)pickerRect barStyle:(UIBarStyle)barStyle Recevier:(id)Receiver componentArray:(NSMutableArray *)componentArray  toolBartitle:(NSString*)toolBartitle textColor:(UIColor*)textColor needToSort:(BOOL)needToSort withDictKey:(NSString *) dictKey 
{
    [self initWithCustomPicker:rect inView:AddView ContentSize:ContentSize pickerSize:pickerRect barStyle:barStyle Recevier:Receiver componentArray:componentArray toolBartitle:toolBartitle textColor:textColor needToSort:needToSort needMultiSelection:NO withDictKey:dictKey];
}

-(void)initWithCustomPicker:(CGRect)rect inView:(id)AddView ContentSize:(CGSize)ContentSize pickerSize:(CGRect)pickerRect barStyle:(UIBarStyle)barStyle Recevier:(id)Receiver componentArray:(NSMutableArray *)componentArray toolBartitle:(NSString*)toolBartitle textColor:(UIColor*)textColor needToSort:(BOOL)needToSort needMultiSelection:(BOOL)needMultiSelection withDictKey:(NSString *) dictKey 
{
    rowDictKey=dictKey;
    self.sender = Receiver;

    self.arPreMultiRecords = [NSMutableArray arrayWithArray:self.arMultiRecords];
    self.preSelectionString = self.selectionString;
    self.needMultiSelection = needMultiSelection;
    target=AddView;
    
    if (![componentArray count]) 
    {
        return;
    }
    
   
	senders=Receiver;
	pickerValue=@"";
	if ([senders isKindOfClass:[UILabel class]])
    {
		tempLable=(UILabel *)senders;
        preValue=[[NSString alloc] initWithFormat:@"%@",tempLable.text];
	}
	else if ([senders isKindOfClass:[UITextField class]])
    {
		tempText=(UITextField*)senders;
		preValue=[[NSString alloc] initWithFormat:@"%@",tempText.text];
	}
	else if ([senders isKindOfClass:[UIButton class]])
	{
		button_Temp = (UIButton *)senders;
		preValue=[button_Temp titleForState:0];
	}
    if (needToSort)
    {
        keyArray = [[NSMutableArray alloc] initWithArray:[componentArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    }
    else
    {
        keyArray = [[NSMutableArray alloc] initWithArray:[componentArray mutableCopy]];
    }
    
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
		UIView *popoverView = [[UIView alloc] init];
		CGRect ToolRect=CGRectMake(0, 0,pickerRect.size.width, 44);
		popoverView.backgroundColor = [UIColor blackColor];
		UIViewController* popoverContent = [[UIViewController alloc] init];	
		[popoverView addSubview:[self createToolBar:ToolRect BarStyle:barStyle toolBarTitle:toolBartitle textColor:textColor]];
		[popoverView addSubview:[self createPicker:CGRectMake(0, 44, pickerRect.size.width,pickerRect.size.height)]];
		popoverContent.view = popoverView;
	
		popoverView=nil;
		popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
		popoverController.delegate=self;
		
		popoverContent=nil;
		[popoverController setPopoverContentSize:ContentSize animated:NO];
//		[popoverController presentPopoverFromRect:rect inView:AddView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        UIButton *btn = AddView;
        [popoverController presentPopoverFromRect:btn.frame inView:btn.superview permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	}
    else
    {
		CGRect ToolRect;
		self.actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
		if ([AddView isKindOfClass:[UITabBarController class]])
        {
			UITabBarController *tabbarController=(UITabBarController*)AddView;
			[self.actionSheet showInView:tabbarController.tabBar];
			if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationPortraitUpsideDown)
            {
				[self.actionSheet setFrame:CGRectMake(rect.origin.x,IS_iPHONE_5?310:222, rect.size.width,260)];
				ToolRect=CGRectMake(rect.origin.x,0,320, 44);
			}
            else
            {
				[self.actionSheet setFrame:CGRectMake(rect.origin.x, 130, IS_iPHONE_5?568:480,350)];
				ToolRect=CGRectMake(rect.origin.x,0,IS_iPHONE_5?568:480, 32);
			}
 		}
        else
        {
            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationPortraitUpsideDown)
            {
                ToolRect=CGRectMake(rect.origin.x,0,320, 44);
                [self.actionSheet showInView:AddView];
                [self.actionSheet setFrame:CGRectMake(rect.origin.x, [AddView frame].size.height-256, 320,240)];
            }else
            {
                ToolRect=CGRectMake(rect.origin.x,0,480, 32);
                [self.actionSheet showInView:AddView];
                [self.actionSheet setFrame:CGRectMake(rect.origin.x, [AddView frame].size.height-190, [AddView frame].size.width,160)];
            }
		}
		self.actionSheet.backgroundColor=[UIColor clearColor];
        self.toolbar=[self createToolBar:ToolRect BarStyle:barStyle toolBarTitle:toolBartitle textColor:textColor];
		[self.actionSheet addSubview:self.toolbar];
        
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationPortraitUpsideDown)
        {
            [self.actionSheet addSubview:[self createPicker:CGRectMake(pickerRect.origin.x, 44, pickerRect.size.width,216)]];
        }else
        {
            [self.actionSheet addSubview:[self createPicker:CGRectMake(pickerRect.origin.x, 32,IS_iPHONE_5?568:480,160)]];
        }
    
	}
}

-(void)btnViewCustomClicked:(id)sender
{
    if ([(NSObject *)self.delegate respondsToSelector:@selector(btnViewCustomClicked:)])
    {
        [delegate btnViewCustomClicked:nil];
        [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    }
}

-(UIPickerView*)createPicker:(CGRect)rect
{
	pickerView=[[UIPickerView alloc] initWithFrame:rect];
	pickerView.delegate  = self;
	pickerView.dataSource = self;
	int x=0;
	pickerView.showsSelectionIndicator = YES;
	if ([preValue length] > 0)
	{
        if ([[keyArray objectAtIndex:0] isKindOfClass:[NSString class]])
        {
            if ([keyArray  containsObject:preValue])
                x=[keyArray  indexOfObject:preValue];
            [pickerView selectRow:x inComponent:0 animated:YES];
        }
        else if([[keyArray objectAtIndex:0] isKindOfClass:[NSDictionary class]]){
            if ([rowDictKey isEqualToString:@"level_info"]) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"level_info = %@",preValue];
                NSMutableArray *predarr = [NSMutableArray arrayWithArray:[keyArray filteredArrayUsingPredicate:predicate]];
                if (predarr!=nil && predarr.count!=0) {
                    if ([keyArray  containsObject:[predarr objectAtIndex:0]])
                        x=[keyArray  indexOfObject:[predarr objectAtIndex:0]];
                }
            }
            else if ([rowDictKey isEqualToString:@"Merchant"]) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",preValue];
                NSMutableArray *predarr = [NSMutableArray arrayWithArray:[keyArray filteredArrayUsingPredicate:predicate]];
                if (predarr!=nil && predarr.count!=0) {
                    if ([keyArray  containsObject:[predarr objectAtIndex:0]])
                        x=[keyArray  indexOfObject:[predarr objectAtIndex:0]];
                }
            }
            else if ([rowDictKey isEqualToString:@"country"]) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"country = %@",preValue];
                NSMutableArray *predarr = [NSMutableArray arrayWithArray:[keyArray filteredArrayUsingPredicate:predicate]];
                if (predarr!=nil && predarr.count!=0) {
                    if ([keyArray  containsObject:[predarr objectAtIndex:0]])
                        x=[keyArray  indexOfObject:[predarr objectAtIndex:0]];
                }
//                else if([preValue isEqualToString:@"Select Country"]){
//                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"country = 'United States'"];
//                    NSMutableArray *predarr = [NSMutableArray arrayWithArray:[keyArray filteredArrayUsingPredicate:predicate]];
//                    if (predarr!=nil && predarr.count!=0) {
//                        if ([keyArray  containsObject:[predarr objectAtIndex:0]])
//                            x=[keyArray  indexOfObject:[predarr objectAtIndex:0]];
//                    }
//                }
            }
            else if([rowDictKey isEqualToString:@"state"]){
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"state = %@",preValue];
                NSMutableArray *predarr = [NSMutableArray arrayWithArray:[keyArray filteredArrayUsingPredicate:predicate]];
                if (predarr!=nil && predarr.count!=0) {
                    if ([keyArray  containsObject:[predarr objectAtIndex:0]])
                        x=[keyArray  indexOfObject:[predarr objectAtIndex:0]];
                }
            }
            else{
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"city = %@",preValue];
                NSMutableArray *predarr = [NSMutableArray arrayWithArray:[keyArray filteredArrayUsingPredicate:predicate]];
                if (predarr!=nil && predarr.count!=0) {
                    if ([keyArray  containsObject:[predarr objectAtIndex:0]])
                        x=[keyArray  indexOfObject:[predarr objectAtIndex:0]];
                }
            }
            
            [pickerView selectRow:x inComponent:0 animated:YES];
        }
	}
	return pickerView;
}          

-(UIToolbar*)createToolBar:(CGRect)rect BarStyle:(UIBarStyle)BarStyle toolBarTitle:(NSString*)toolBarTitle textColor:(UIColor*)textColor
{
	UIToolbar *Toolbar = [[UIToolbar alloc] initWithFrame:rect];
	Toolbar.barStyle = BarStyle;
    Toolbar.tintColor = [UIColor colorWithRed:0.000 green:0.597 blue:0.800 alpha:1.000];
	Toolbar.opaque=YES;
	Toolbar.translucent=NO;
	[Toolbar setItems:[self toolbarItem] animated:YES];	
	if ([toolBarTitle length]!=0)
    {
		[Toolbar addSubview:[self createTitleLabel:toolBarTitle labelTextColor:textColor width:(rect.size.width - 150)]];
	}
	return Toolbar ;
}

#pragma mark - UIPickerView delegate methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{	
	if ([keyArray count] > 0)
	{
		if ([[keyArray objectAtIndex:0] isKindOfClass:[NSString class]])
		{
			return [keyArray count];
		}
        else{
            return [keyArray count];
        }
	}
	return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if ([keyArray count] > 0)
	{
		if ([[keyArray objectAtIndex:0] isKindOfClass:[NSString class]])
		{
			return [keyArray objectAtIndex:row];
		}
        else{
            if ([rowDictKey isEqualToString:@"Merchant"]) {
                return [[keyArray  objectAtIndex:row] valueForKey:@"name"];
            }
            else if ([rowDictKey isEqualToString:@"Location"]) {
                return [[keyArray  objectAtIndex:row] valueForKey:@"addresss"];
            }
            else
                return [[keyArray  objectAtIndex:row] valueForKey:rowDictKey];
        }
	}
	return @"";
}

-(void) pickerView:(UIPickerView *)pickerVies didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	NSString  *pickerLocalValue=@"";
    if ([pickerView numberOfComponents]>1)
    {
        for(int i=0;i<[pickerView numberOfComponents];i++)
        {
            if ([[keyArray objectAtIndex:0] isKindOfClass:[NSString class]])
            {
                pickerLocalValue=[pickerLocalValue stringByAppendingFormat:@"%@",[keyArray objectAtIndex:[pickerView selectedRowInComponent:0]]];
            }
            else{
                if ([rowDictKey isEqualToString:@"Merchant"]) {
                    pickerLocalValue=[pickerLocalValue stringByAppendingFormat:@"%@",[[keyArray objectAtIndex:[pickerView selectedRowInComponent:0]] valueForKey:@"name"]];
                }
                else if ([rowDictKey isEqualToString:@"Location"]) {
                    pickerLocalValue=[pickerLocalValue stringByAppendingFormat:@"%@",[[keyArray objectAtIndex:[pickerView selectedRowInComponent:0]] valueForKey:@"addresss"]];
                }
                else{
                pickerLocalValue=[pickerLocalValue stringByAppendingFormat:@"%@",[[keyArray objectAtIndex:[pickerView selectedRowInComponent:0]] valueForKey:rowDictKey]];
                }
            }
        }
    }
    else {
        if ([[keyArray objectAtIndex:0] isKindOfClass:[NSString class]]) {
            pickerLocalValue=[pickerLocalValue stringByAppendingFormat:@"%@",[keyArray objectAtIndex:[pickerView selectedRowInComponent:0]]];
        }
        else{
             if ([rowDictKey isEqualToString:@"Merchant"]) {
                 pickerLocalValue=[pickerLocalValue stringByAppendingFormat:@"%@",[[keyArray objectAtIndex:[pickerView selectedRowInComponent:0]] valueForKey:@"name"]];

             }
             else if ([rowDictKey isEqualToString:@"Location"]) {
                 pickerLocalValue=[pickerLocalValue stringByAppendingFormat:@"%@",[[keyArray objectAtIndex:[pickerView selectedRowInComponent:0]] valueForKey:@"addresss"]];
             }
             else{
            pickerLocalValue=[pickerLocalValue stringByAppendingFormat:@"%@",[[keyArray objectAtIndex:[pickerView selectedRowInComponent:0]] valueForKey:rowDictKey]];
             }
        }
    }
	pickerValue = pickerLocalValue;
	[self callSenders:pickerValue];
}

-(IBAction)done_clicked:(id)sender
{
    [self.arPreMultiRecords removeAllObjects];
    [self.arPreMultiRecords addObjectsFromArray:self.arMultiRecords];
    if ([pickerValue length] == 0)
    {
        if ([keyArray count] > 0)
        {
            if ([[keyArray objectAtIndex:0] isKindOfClass:[NSString class]])
            {
                pickerValue = [keyArray objectAtIndex:[pickerView selectedRowInComponent:0]];
            }
            else{
                if([rowDictKey isEqualToString:@"Merchant"])
                {
                    pickerValue=[[keyArray objectAtIndex:[pickerView selectedRowInComponent:0]] valueForKey:@"name"];

                }
                else if([rowDictKey isEqualToString:@"Location"]){
                    pickerValue=[[keyArray objectAtIndex:[pickerView selectedRowInComponent:0]] valueForKey:@"addresss"];
                }
                else{
                    pickerValue=[[keyArray objectAtIndex:[pickerView selectedRowInComponent:0]] valueForKey:rowDictKey];
                }
            }
        }  
    }
    
    if ([(NSObject *)self.delegate respondsToSelector:@selector(pickerDoneClicked: withType:)])
    {
        [delegate pickerDoneClicked:pickerValue withType:rowDictKey];
    }
    if ([(NSObject *)self.delegate respondsToSelector:@selector(picker:andDoneClicked:andIndex:)])
    {
        [popoverController dismissPopoverAnimated:YES];
        [self.delegate picker:self andDoneClicked:pickerValue andIndex:[pickerView selectedRowInComponent:0]];
    }
    if(!self.needMultiSelection)
    {
        [self callSenders:pickerValue];
    }
    if ([(NSObject *)self.delegate respondsToSelector:@selector(adjustScrolling)])
    {
        [delegate adjustScrolling];
    }
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
		[popoverController dismissPopoverAnimated:YES];
	}
    else
    {
		[self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
	}
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	[self callSenders:preValue];
}

-(UILabel*)createTitleLabel:(NSString*)labelTitle labelTextColor:(UIColor*)color width:(NSInteger)width
{
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ||
        [UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationPortraitUpsideDown)
    {
        lheight = 36;
        lWidth = 4;
    }
    else
    {
        lWidth = 2;
        lheight = 28;
    }
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(70,lWidth,width,lheight)];
	self.label.textColor = color;
	self.label.backgroundColor = [UIColor clearColor];
	self.label.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
	self.label.text = labelTitle;
    self.label.numberOfLines=0;
    if(!self.PickerName)
    {
        self.PickerName = labelTitle;
    }
	self.label.textAlignment = NSTextAlignmentCenter;
	return self.label ;
}

-(void)callSenders:(NSString*)pickerString
{
    if ([senders isKindOfClass:[UILabel class]])
    {
		tempLable=(UILabel *)senders;
		tempLable.text=pickerString;
		//senders=(UILabel*)senders;
	}
	else if ([senders isKindOfClass:[UITextField class]]){
		tempText=(UITextField *)senders;
		tempText.text=pickerString;
		//senders=(UITextField*)senders;
	}
	else if ([senders isKindOfClass:[UIButton class]])
	{
		button_Temp = (UIButton *)senders;
		[button_Temp setTitle:pickerString forState:UIControlStateNormal];
        [button_Temp setTitle:pickerString forState:UIControlStateHighlighted];
		//senders = (UIButton *)senders;
	}
    if ([(NSObject *)self.delegate respondsToSelector:@selector(CustomPickerValue:)])
    {
        [delegate CustomPickerValue:senders];
    }

}
-(IBAction)cancel_clicked:(id)sender
{
    self.selectionString = self.preSelectionString;
    [self.arMultiRecords removeAllObjects];
    [self.arMultiRecords addObjectsFromArray:self.arPreMultiRecords];
	[self callSenders:preValue];
    if ([(NSObject *)self.delegate respondsToSelector:@selector(adjustScrolling)])
    {
        [delegate adjustScrolling];
    }
    if ([(NSObject *)self.delegate respondsToSelector:@selector(pickerCancelClicked: withType:)])
    {
        [popoverController dismissPopoverAnimated:YES];
        [self.delegate pickerCancelClicked:preValue withType:rowDictKey];
    }
    if ([(NSObject *)self.delegate respondsToSelector:@selector(picker:andCancelClicked:)])
    {
        [self.delegate picker:self andCancelClicked:preValue];
    }

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
		[popoverController dismissPopoverAnimated:YES];
	}
    else
    {
		[self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
	}
}

-(NSMutableArray*)toolbarItem
{
	NSMutableArray *barItems = [[NSMutableArray alloc] init];
	UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:[eEducationAppDelegate getLocalvalue:@"Cancel"] style:UIBarButtonItemStyleBordered target:self action:@selector(cancel_clicked:)];
//    [cancelBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                       [UIColor whiteColor], UITextAttributeTextColor,
//                                       [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
//                                       [UIFont fontWithName:@"Arial-BoldMT" size:14], UITextAttributeFont, nil] forState:UIControlStateNormal];
//    [cancelBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                       [UIColor whiteColor], UITextAttributeTextColor,
//                                       [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
//                                       [UIFont fontWithName:@"Arial-BoldMT" size:14], UITextAttributeFont, nil] forState:UIControlStateHighlighted];
	[barItems addObject:cancelBtn];
    
	UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[barItems addObject:flexSpace];    
	UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:[eEducationAppDelegate getLocalvalue:@"Done"] style:UIBarButtonItemStyleBordered target:self action:@selector(done_clicked:)];
    
//    [doneBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                       [UIColor colorWithRed:105/255.0 green:103/255.0 blue:103/255.0 alpha:1.0], UITextAttributeTextColor,
//                                       [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0], UITextAttributeTextShadowColor,
//                                       [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
//                                       [UIFont fontWithName:@"Arial-BoldMT" size:14], UITextAttributeFont, nil] forState:UIControlStateNormal];
//    
//    [doneBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                     [UIColor colorWithRed:105/255.0 green:103/255.0 blue:103/255.0 alpha:1.0], UITextAttributeTextColor,
//                                     [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0], UITextAttributeTextShadowColor,
//                                     [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
//                                     [UIFont fontWithName:@"Arial-BoldMT" size:14], UITextAttributeFont, nil] forState:UIControlStateHighlighted];

	[barItems addObject:doneBtn];

	return barItems ;
}

@end
