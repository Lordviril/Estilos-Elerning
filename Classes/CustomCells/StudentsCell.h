//
//  StudentsCell.h
//  eEducation
//
//  Created by Hidden Brains on 21/11/13.
//
//

#import <UIKit/UIKit.h>
#import "GMGridViewCell.h"

@interface StudentsCell : GMGridViewCell

@property (nonatomic,retain) IBOutlet AsyncImageView *imgProfile;
@property (nonatomic,retain) IBOutlet UILabel *lblName;
@property (nonatomic,retain) IBOutlet UIButton *btnDesc,*btnEmail;

@end
