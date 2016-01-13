//
//  DownloadedCustomCell.h
//  eEducation
//
//  Created by Hidden Brains on 11/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DownloadedCustomCell : UITableViewCell {
	UILabel *lblCourseName;
	UILabel *lblDocName;
	UILabel *lblModuleName;
	UILabel *lblType;
	UIImageView *imgview;
	UIButton *_btnDelete;
}
@property(nonatomic,retain)UIButton *btnDelete;
@property(nonatomic,retain)UIImageView *imgview;
@property(nonatomic,retain)UILabel *lblCourseName;
@property(nonatomic,retain)UILabel *lblDocName;
@property(nonatomic,retain)UILabel *lblModuleName;
@property(nonatomic,retain)UILabel *lblType;
@end
