//
//  MasterCell.m
//  eEducation
//
//  Created by Hidden Brains on 30/11/13.
//
//

#import "MasterCell.h"

@interface MasterCell ()

@end

@implementation MasterCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self=[[[NSBundle mainBundle] loadNibNamed:@"MasterCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)setHighlighted:(BOOL)aHighlighted
{
    [super setHighlighted:aHighlighted];
}


@end
