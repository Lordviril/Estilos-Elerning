//
//  VideosCell.h
//  eEducation
//
//  Created by Hidden Brains on 19/11/13.
//
//

#import <UIKit/UIKit.h>
#import "GMGridView.h"
#import "AsyncImageView.h"

@interface VideosCell : GMGridViewCell

@property(nonatomic,retain) IBOutlet UIImageView *imgBack;
@property(nonatomic,retain) IBOutlet UILabel *lblVideoTitle;
@property(nonatomic,retain) IBOutlet UITextView *txtVideoDesc;
@property(nonatomic,retain) IBOutlet AsyncImageView *asyVideoImg;

@end
