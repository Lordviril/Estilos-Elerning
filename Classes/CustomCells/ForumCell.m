//
//  ForumCell.m
//  eEducation
//
//  Created by Hidden Brains on 23/11/13.
//
//

#import "ForumCell.h"

@interface ForumCell ()

@end

@implementation ForumCell

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//    }
//    return self;
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self=[[[NSBundle mainBundle] loadNibNamed:@"ForumCell" owner:self options:nil] lastObject];
    }
    return self;
}

@end
