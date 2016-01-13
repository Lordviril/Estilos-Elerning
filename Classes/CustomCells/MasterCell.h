//
//  MasterCell.h
//  eEducation
//
//  Created by Hidden Brains on 30/11/13.
//
//

#import <UIKit/UIKit.h>

@interface MasterCell : GMGridViewCell

@property (nonatomic,retain) IBOutlet AsyncImageView *imgProfile;
@property (nonatomic,retain) IBOutlet UILabel *lblName;
@property (nonatomic,retain) IBOutlet UITextView *txtDesc;

@end
