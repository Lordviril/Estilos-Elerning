//
//  PracticesCell.h
//  eEducation
//
//  Created by Hidden Brains on 19/11/13.
//
//

#import <UIKit/UIKit.h>
#import "GMGridView.h"

@interface PracticesCell : GMGridViewCell

@property(nonatomic,retain) IBOutlet UIImageView *imgBack,*imgCal;
@property(nonatomic,retain) IBOutlet UILabel *lblChapterTitle,*lblChapterDate;
@property(nonatomic,retain) IBOutlet UIButton *btnArrow;
@end
