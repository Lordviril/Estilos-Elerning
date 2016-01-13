//
//  CalenderCustomCell.h
//  eEducation
//
//  Created by Hidden Brains on 11/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CalenderCustomCell : UITableViewCell 
{
	UILabel *lblDate;
	UILabel *lblDescription;
}
@property(nonatomic,retain)UILabel *lblDate;
@property(nonatomic,retain)UILabel *lblDescription;
@end