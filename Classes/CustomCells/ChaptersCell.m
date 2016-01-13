//
//  ChaptersCell.m
//  eEducation
//
//  Created by Hidden Brains on 18/11/13.
//
//

#import "ChaptersCell.h"

@interface ChaptersCell ()

@end

@implementation ChaptersCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self=[[[NSBundle mainBundle] loadNibNamed:@"ChaptersCell" owner:self options:nil] lastObject];
    }
    return self;
}


- (void)setHighlighted:(BOOL)aHighlighted
{
    [super setHighlighted:aHighlighted];
    self.imgBack.highlighted = aHighlighted;
}

@end
