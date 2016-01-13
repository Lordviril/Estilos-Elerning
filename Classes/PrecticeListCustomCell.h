//
//  PrecticeListCustomCell.h
//  eEducation
//
//  Created by Hidden Brains on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PrecticeListCustomCell : UITableViewCell {
	UILabel *lblPrecticeName;
	UILabel *lblStatusValue;
	UILabel *lblStatus;
	UIImageView *imgView;
}
@property(nonatomic,retain)UIImageView *imgView;
@property(nonatomic,retain)UILabel *lblPrecticeName;
@property(nonatomic,retain)UILabel *lblStatusValue;
@property(nonatomic,retain)UILabel *lblStatus;
@end
