//
//  CustomCellFortestDetails.h
//  eEducation
//
//  Created by HB 13 on 20/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomCellFortestDetails : UITableViewCell {

	UILabel *_labelTestName;
	UITextView *_textViewTestDes;
	UIImageView *_imagebackground;
	UIButton *_buttonStart;
	
}
@property (nonatomic, retain) UILabel *labelTestName;
@property (nonatomic, retain) UITextView *textViewTestDes;
@property (nonatomic, retain) UIImageView *imagebackground;
@property (nonatomic, retain) UIButton *buttonStart;
@end
