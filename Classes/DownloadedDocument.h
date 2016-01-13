//
//  DownloadedDocument.h
//  eEducation
//
//  Created by Hidden Brains on 11/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"

@class DownloadedCustomCell;
@interface DownloadedDocument : UIViewController<addsearchArrayDelegate>
{
	IBOutlet UIImageView *image_BackGround;
	IBOutlet UITableView *tblView;
	
	BOOL isAttemptToTest;
	IBOutlet UIButton *btnDownloadedDocument;
	IBOutlet UIButton *btnAttemptTest;
	IBOutlet UIButton *btnSearch;
	IBOutlet UIButton *btnHome;
	IBOutlet UILabel *lbl_title;
	NSMutableArray *documentArray;
	NSMutableArray *testArray;
	NSString *pdfName;
	NSInteger _delData_Id;
	NSInteger _indexPath;
}
-(IBAction)gohomeScreen:(id)sender;
-(IBAction)btnDownloadedDocument_Clicked:(id)sender;
-(IBAction)btnAttemptTest_Clicked:(id)sender;
-(IBAction)btnSearchLogo_Clicked:(id)sender;
-(IBAction)btnHome_Clicked:(id)sender;
-(IBAction)deleteDownloadData:(id)sender;
-(NSString *) GetPath:(NSString *)Path;
-(void) setLocalizedvalues;
-(NSString *) GetPath:(NSString *)Path withType:(NSString *)Type;
-(void)displayPDFDocumentView:(int)index;
-(void) DisplayTheEpubDocumentView:(NSString *)FilePath titleName:(NSString *)TitleName ;
@end

