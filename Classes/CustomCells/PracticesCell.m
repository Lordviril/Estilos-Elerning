//
//  PracticesCell.m
//  eEducation
//
//  Created by Hidden Brains on 19/11/13.
//
//

#import "PracticesCell.h"

@interface PracticesCell ()

@end

@implementation PracticesCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self=[[[NSBundle mainBundle] loadNibNamed:@"PracticesCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)setHighlighted:(BOOL)aHighlighted
{
    [super setHighlighted:aHighlighted];
    self.imgBack.highlighted = aHighlighted;
}

@end
