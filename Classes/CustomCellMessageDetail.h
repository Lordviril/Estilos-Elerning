//
//  CustomCellMessageDetail.h
//  eEducation
//
//  Created by Hidden Brains on 11/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface CustomCellMessageDetail : UITableViewCell 
{
}
@property (nonatomic, retain) IBOutlet UILabel *lbl_FromValue;
@property (nonatomic, retain) IBOutlet UILabel *lbl_DateValue;
@property (nonatomic, retain) IBOutlet UITextView *txt_Message;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundiimg;
@property (nonatomic, retain) IBOutlet AsyncImageView *imgProfilePic;
@property (nonatomic, retain) IBOutlet UIView *viewBack;

@end
