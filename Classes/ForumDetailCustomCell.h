//
//  ForumDetailCustomCell.h
//  eEducation
//
//  Created by hb12 on 07/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface ForumDetailCustomCell : UITableViewCell 
{
}
@property (nonatomic, retain) IBOutlet UIImageView *imgBackGround;
@property (nonatomic, retain) IBOutlet  UILabel *lbl_StudentName;
@property (nonatomic, retain) IBOutlet  UILabel *lbl_Date;
@property (nonatomic, retain) IBOutlet  UITextView *txt_Comment;
@property (nonatomic, retain) IBOutlet AsyncImageView *imgProfile;

@end
