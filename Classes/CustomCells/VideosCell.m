//
//  VideosCell.m
//  eEducation
//
//  Created by Hidden Brains on 19/11/13.
//
//

#import "VideosCell.h"

@interface VideosCell ()

@end

@implementation VideosCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self=[[[NSBundle mainBundle] loadNibNamed:@"VideosCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)setHighlighted:(BOOL)aHighlighted
{
    [super setHighlighted:aHighlighted];
    self.imgBack.highlighted = aHighlighted;
}

@end
