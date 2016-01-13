//
//  Customcell_AttemptTest.m
//  eEducation
//
//  Created by HB iMac on 20/12/11.
//  Copyright 2011 HiddenBrains. All rights reserved.
//

#import "Customcell_AttemptTest.h"


@implementation Customcell_AttemptTest
@synthesize lblTest,img_cell;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        lblTest=[[UILabel alloc]initWithFrame:CGRectMake(23, 24, 600, 21)];
		lblTest.backgroundColor=[UIColor clearColor];
		lblTest.font=[UIFont fontWithName:@"Arial-BoldMT" size:17];
		[self.contentView addSubview:lblTest];
		
		img_cell=[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-130, 25, 20, 20)];
		img_cell.image=[UIImage imageNamed:@"arrow.png"];
		[self.contentView addSubview:img_cell];
    }
    return self;
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	lblTest.frame = CGRectMake(23, 24, self.frame.size.width-100, 21);
    
	img_cell.frame=CGRectMake(self.frame.size.width-130, 25, 20, 20);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
	[img_cell release];
	[lblTest release];
    [super dealloc];
}


@end
