//
//  CustomTextField.m
//  OnlineHunter
//
//  Created by hiddenbrains on 12/19/12.
//  Copyright (c) 2012 Hidden Brains. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField
@synthesize horizontalPadding, verticalPadding;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    if (self)
    {
        
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)drawPlaceholderInRect:(CGRect)rect
{
    [[UIColor colorWithWhite:0.427 alpha:1.000] setFill];
    [[self placeholder] drawInRect:CGRectMake(rect.origin.x, rect.origin.y+1, rect.size.width, rect.size.height) withFont:self.font];
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    horizontalPadding = 10;
    if (self.tag = 780) { // Search textfield tag
        // Need to reduce width to accomidate cancel buton
        return CGRectMake(bounds.origin.x+horizontalPadding, bounds.origin.y-1, bounds.size.width-35, bounds.size.height);
    }
    return CGRectMake(bounds.origin.x+horizontalPadding, bounds.origin.y-1, bounds.size.width, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    horizontalPadding = 10;
//    [[UIColor darkGrayColor] setFill];
    if (self.tag = 780) { // Search textfield tag
        // Need to reduce width to accomidate cancel buton
        return CGRectMake(bounds.origin.x+horizontalPadding, bounds.origin.y-1, bounds.size.width-35, bounds.size.height);
    }
    return CGRectMake(bounds.origin.x+horizontalPadding, bounds.origin.y-1, bounds.size.width, bounds.size.height);
}

@end
