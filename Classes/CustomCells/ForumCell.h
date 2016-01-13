//
//  ForumCell.h
//  eEducation
//
//  Created by Hidden Brains on 23/11/13.
//
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface ForumCell : UIView

@property (nonatomic,retain) IBOutlet AsyncImageView *imgView;
@property (nonatomic,retain) IBOutlet UILabel *lblTopic,*lblName,*lblDate;
@property (nonatomic,retain) IBOutlet UIButton *btnComments,*btnForCellTap;
@property (nonatomic,retain) IBOutlet UITextView *txtFirstComment;

@end
