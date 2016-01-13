//
//  PrecticeListCustomCell.m
//  eEducation
//
//  Created by Hidden Brains on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PrecticeListCustomCell.h"

@implementation PrecticeListCustomCell
@synthesize lblPrecticeName,lblStatusValue,lblStatus,imgView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        lblPrecticeName=[[UILabel alloc]initWithFrame:CGRectMake(23, 12, 600, 21)];
		lblPrecticeName.backgroundColor=[UIColor clearColor];
		//lblPrecticeName.text=@"Prectice 1";
		lblPrecticeName.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
		[self.contentView addSubview:lblPrecticeName];
		
		lblStatus=[[UILabel alloc]initWithFrame:CGRectMake(23, 35, 70, 21)];
		lblStatus.backgroundColor=[UIColor clearColor];
		lblStatus.text=[eEducationAppDelegate getLocalvalue:@"Status :"];
		lblStatus.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0];
		[self.contentView addSubview:lblStatus];
		
		lblStatusValue=[[UILabel alloc]initWithFrame:CGRectMake(97, 35, 120, 21)];
		lblStatusValue.backgroundColor=[UIColor clearColor];
		//lblStatusValue.text=@"Not Uploaded";
		lblStatusValue.font=[UIFont fontWithName:@"ArialMT" size:15.0];
		[self.contentView addSubview:lblStatusValue];
		imgView=[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-130, 25, 20, 20)];
		imgView.image=[UIImage imageNamed:@"arrow.png"];
		[self.contentView addSubview:imgView];
    }
    return self;
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	lblPrecticeName.frame = CGRectMake(23, 12, self.frame.size.width-100, 21);
	imgView.frame=CGRectMake(self.frame.size.width-130, 25, 20, 20);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [super dealloc];
}


@end
