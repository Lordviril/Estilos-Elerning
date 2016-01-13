//
//  StudentsCell.m
//  eEducation
//
//  Created by Hidden Brains on 21/11/13.
//
//

#import "StudentsCell.h"

@interface StudentsCell ()

@end

@implementation StudentsCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self=[[[NSBundle mainBundle] loadNibNamed:@"StudentsCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)setHighlighted:(BOOL)aHighlighted
{
    [super setHighlighted:aHighlighted];
}

@end
