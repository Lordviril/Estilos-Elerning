//
//  CustomCellForTestResultsListing.h
//  eEducation
//
//  Created by HB 13 on 28/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomCellForTestResultsListing : UITableViewCell {
	
	UILabel *_labelTestName;
	UILabel *_labelTestNameValue;
	UILabel *_labelStartDate;
	UILabel *_labelStartDateValue;
	UILabel *_labelEndDate;
	UILabel *_labelEndDateValue;
	UILabel *_labelStatus;
	UILabel *_labelStatusValue;
	UIImageView *_imageDisclouser;
	UILabel *lblcol1,*lblcol2,*lblcol3,*lblcol4;

}
@property (nonatomic, retain) UILabel *labelTestName; 
@property (nonatomic, retain) UILabel *labelTestNameValue; 
@property (nonatomic, retain) UILabel *labelStartDate; 
@property (nonatomic, retain) UILabel *labelStartDateValue; 
@property (nonatomic, retain) UILabel *labelEndDate; 
@property (nonatomic, retain) UILabel *labelEndDateValue; 
@property (nonatomic, retain) UILabel *labelStatus; 
@property (nonatomic, retain) UILabel *labelStatusValue; 
@property (nonatomic, retain) UIImageView *imageDisclouser;
@property (nonatomic,retain)UILabel *lblcol1,*lblcol2,*lblcol3,*lblcol4;
@end
