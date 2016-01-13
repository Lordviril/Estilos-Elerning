//
//  ChaptersCell.h
//  eEducation
//
//  Created by Hidden Brains on 18/11/13.
//
//

#import <UIKit/UIKit.h>
#import "GMGridView.h"

@interface ChaptersCell : GMGridViewCell

@property(nonatomic,retain) IBOutlet UIImageView *imgBack;
@property(nonatomic,retain) IBOutlet UILabel *lblChapterTitle,*lblChapterDate;
@property(nonatomic,retain) IBOutlet UITextView *txtChapterDesc;
@end
