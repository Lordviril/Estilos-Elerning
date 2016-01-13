//
//  UICustomPicker.h
//  pickerTest
//
//  Created by HB17 on 19/09/11.
//  Copyright 2011 HiddenBrains. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eEducationAppDelegate.h"
@class UICustomPicker;

@protocol CustomPickerDelegate
@optional
-(void)CustomPickerValue:(id)retval;
-(void)adjustScrolling;
-(void)btnViewCustomClicked:(NSString*)doneValue;
-(void)pickerDoneClicked:(NSString*)doneValue withType:(NSString *)picker_type;
-(void)pickerCancelClicked:(NSString*)doneValue withType:(NSString *)picker_type;

-(void)picker:(UICustomPicker *)picker andDoneClicked:(NSString*)doneValue andIndex:(int)index;
-(void)picker:(UICustomPicker *)picker andCancelClicked:(NSString*)preValue;



@end

@interface UICustomPicker : UIViewController <UIPopoverControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate>
{
	UIPickerView *pickerView;
	UIPopoverController *popoverController;
	id senders;	
	NSString *preValue;
	UILabel *tempLable;
	UITextField *tempText;
	UIButton *button_Temp;
	NSString *pickerValue,*rowDictKey;
	NSDictionary *pickerDict;
	NSMutableArray *keyArray;
	int lWidth,lheight;
	id<CustomPickerDelegate>delegate;
    id target;     
 }
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIActionSheet *actionSheet;
@property (nonatomic,readwrite) BOOL needMultiSelection;
@property (nonatomic,strong) NSString *preSelectionString;
@property (nonatomic,strong) NSString *selectionString;
@property (nonatomic,strong) NSMutableArray *arMultiRecords;
@property (nonatomic,strong) NSMutableArray *arPreMultiRecords;

@property(nonatomic,strong)id<CustomPickerDelegate>delegate;
@property(nonatomic,strong) NSString *PickerName;
@property(nonatomic,strong) UIButton *btnViewCustom;
@property(nonatomic,assign) BOOL needToShowCustomIcon;
@property(nonatomic,strong) UIToolbar *toolbar;
@property(nonatomic,strong) id sender;
-(void)callSenders:(NSString*)pickerString;
-(NSMutableArray*)toolbarItem;
-(UIPickerView*)createPicker:(CGRect)rect;
-(UILabel*)createTitleLabel:(NSString*)labelTitle labelTextColor:(UIColor*)color width:(NSInteger)width;
-(void)initWithCustomPicker:(CGRect)rect inView:(id)AddView ContentSize:(CGSize)ContentSize pickerSize:(CGRect)pickerRect barStyle:(UIBarStyle)barStyle Recevier:(id)Receiver componentArray:(NSMutableArray *)componentArray  toolBartitle:(NSString*)toolBartitle textColor:(UIColor*)textColor needToSort:(BOOL)needToSort withDictKey:(NSString *) dictKey ;
-(void)initWithCustomPicker:(CGRect)rect inView:(id)AddView ContentSize:(CGSize)ContentSize pickerSize:(CGRect)pickerRect barStyle:(UIBarStyle)barStyle Recevier:(id)Receiver componentArray:(NSMutableArray *)componentArray  toolBartitle:(NSString*)toolBartitle textColor:(UIColor*)textColor needToSort:(BOOL)needToSort needMultiSelection:(BOOL)needMultiSelection withDictKey:(NSString *) dictKey ;

-(UIToolbar*)createToolBar:(CGRect)rect BarStyle:(UIBarStyle)BarStyle toolBarTitle:(NSString*)toolBarTitle textColor:(UIColor*)textColor;
@end