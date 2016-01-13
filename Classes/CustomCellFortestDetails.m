//
//  CustomCellFortestDetails.m
//  eEducation
//
//  Created by HB 13 on 20/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomCellFortestDetails.h"


@implementation CustomCellFortestDetails
@synthesize labelTestName = _labelTestName;
@synthesize textViewTestDes = _textViewTestDes;
@synthesize imagebackground = _imagebackground;
@synthesize buttonStart = _buttonStart;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
		
		_imagebackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"box_s10A.png"]];
		_imagebackground.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:_imagebackground];
		
		_labelTestName = [[UILabel alloc] init];
		_labelTestName.backgroundColor = [UIColor clearColor];
		_labelTestName.textColor = [UIColor blackColor];
		_labelTestName.font = [UIFont fontWithName:@"Arial-BoldMT" size:18.0];
		[_imagebackground addSubview:_labelTestName];
		
		
		_textViewTestDes = [[UITextView alloc] init];
		_textViewTestDes.backgroundColor = [UIColor clearColor];
		_textViewTestDes.textColor = [UIColor blackColor];
		_textViewTestDes.editable = NO;
		_textViewTestDes.font = [UIFont fontWithName:@"ArialMT" size:15.0];
		//_textViewTestDes.font = [UIFont fontWithName:@"Arial Bold" size:15.0];
		[_imagebackground addSubview:_textViewTestDes];
		
		
		_buttonStart = [UIButton buttonWithType:UIButtonTypeCustom];
		_buttonStart.frame = CGRectMake(_textViewTestDes.frame.origin.x+_textViewTestDes.frame.size.width, 45, 20, 20);
		[_buttonStart setImage:[UIImage imageNamed:@"arrow.png"] forState:UIControlStateNormal];
		[_buttonStart setImage:[UIImage imageNamed:@"arrow.png"] forState:UIControlStateHighlighted];
		[self.contentView addSubview:_buttonStart];
 		
    }
    return self;
}

- (void)layoutSubviews {
	
	[super layoutSubviews];
	_imagebackground.frame = CGRectMake(-30, 0, self.frame.size.width-30, self.frame.size.height);
	_labelTestName.frame = CGRectMake(25, 20, self.frame.size.width-80, 21);
	_textViewTestDes.frame = CGRectMake(20, 42, self.frame.size.width-180, 90);
	_buttonStart.frame = CGRectMake(_textViewTestDes.frame.origin.x+_textViewTestDes.frame.size.width, 45, 109, 45);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
	[_labelTestName release]; _labelTestName=nil;
	[_textViewTestDes release]; _textViewTestDes = nil;
	[_imagebackground release]; _imagebackground = nil;
    [super dealloc];
}


@end
