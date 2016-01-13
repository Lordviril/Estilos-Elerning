//
//  SearchViewController.h
//  eEducation
//
//  Created by HB 13 on 21/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol addsearchArrayDelegate<NSObject>

-(void)getSearchAtrray:(NSArray *)ary_search docselected:(BOOL)yesOrNo;

@end


@interface SearchViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource> {
	
	IBOutlet UIView *searchView;
	IBOutlet UIImageView *imgsearchView;
	IBOutlet UIButton *btnDownloadedDocument;
	IBOutlet UIButton *btnAttemptTest;
	IBOutlet UIButton *btnSearch,*btnCancel;
	
	IBOutlet UILabel *lbl_searchDocumentType,*lbl_searchCourse,*lbl_searchChapter,*lbl_searchDocument,*lbl_searchTypeOFDocument;
	UIActionSheet *actionSheet;
	UIToolbar *pickerToolbar;
	UIPopoverController *popoverController;
	UIPickerView *Picker;
	NSString *str_previousValue;
	IBOutlet UILabel *lbl_title;
	IBOutlet UIButton *btn_DocType;
	
	UITextField *_textFieldCourse;
	UITextField *_textFieldModule;
	UITextField *_textFieldDocument;
	UILabel *_labelColon;
	NSMutableArray *_arraySearchResult;
	
	BOOL isAttemptToTest;
	id <addsearchArrayDelegate>delegate;

}
@property(nonatomic, retain) IBOutlet UITextField *textFieldCourse;
@property(nonatomic, retain) IBOutlet UITextField *textFieldModule;
@property(nonatomic, retain) IBOutlet UITextField *textFieldDocument;
@property(nonatomic, retain) IBOutlet UILabel *labelColon;
@property(nonatomic, retain) UIButton *btnDownloadedDocument;
@property(nonatomic, retain) UIButton *btnAttemptTest;
@property(nonatomic, retain) NSMutableArray *arraySearchResult;
@property(nonatomic, readwrite) BOOL isAttemptToTest;

@property(nonatomic, retain) id <addsearchArrayDelegate>delegate;

-(IBAction)btnDocumentTypeClicked:(id)sender;
-(IBAction)btnDownloadedDocument_Clicked:(id)sender;
-(IBAction)btnAttemptTest_Clicked:(id)sender;
-(IBAction)btnHome_Clicked:(id)sender;
-(IBAction)CacncelClick:(id)sender;
-(IBAction)SubmitClick:(id)sender;
-(void) setLocalizedvalues;
@end
