//
//  ForumCellHeader.h
//  eEducation
//
//  Created by Hidden Brains on 22/11/13.
//
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface ForumCellHeader : UITableViewHeaderFooterView

@property (nonatomic,retain) IBOutlet AsyncImageView *imgView;
@property (nonatomic,retain) IBOutlet UILabel *lblTopic,*lblFirstComment,*lblName;
@property (nonatomic,retain) IBOutlet UIButton *btnComments;

@end
