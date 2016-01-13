//
//  AlertCustomCell.h
//  eEducation
//
//  Created by hb12 on 07/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AlertCustomCell : UITableViewCell 
{
	UILabel *lblAlert;
	UILabel *lblDate;	
	UIImageView *imgView;
}

@property(nonatomic,retain)IBOutlet UILabel *lblAlert;
@property(nonatomic,retain)IBOutlet UIButton *btnViewAlert;
@property(nonatomic,retain)IBOutlet UIImageView *imgView;
@property(nonatomic,retain)IBOutlet UILabel *lblDate;
-(IBAction)btnViewAlertClicked:(UIButton*)sender;
@end
