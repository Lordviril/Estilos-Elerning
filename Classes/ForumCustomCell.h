//
//  ForumCustomCell.h
//  eEducation
//
//  Created by hb12 on 07/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ForumCustomCell : UITableViewCell
{
	UILabel *lblTopic;
	UILabel *lblTotalComment;
	UILabel *lblPostedBy;
	UILabel *lblPostedDate;
	UILabel *lblTopicValue;
	UILabel *lblTotalCommentValue;
	UILabel *lblPostedByValue;
	UILabel *lblPostedDateValue;
	UIImageView *imgview;
	UILabel *lblcol1,*lblcol2,*lblcol3,*lblcol4;
}
@property(nonatomic,retain)UILabel *lblTopic;
@property(nonatomic,retain)UILabel *lblTopicValue;
@property(nonatomic,retain)UILabel *lblTotalComment;
@property(nonatomic,retain)UILabel *lblPostedBy;
@property(nonatomic,retain)UILabel *lblPostedDate;
@property(nonatomic,retain)UIImageView *imgview;
@property(nonatomic,retain)UILabel *lblTotalCommentValue;
@property(nonatomic,retain)UILabel *lblPostedByValue;
@property(nonatomic,retain)UILabel *lblPostedDateValue;
@property (nonatomic,retain)UILabel *lblcol1,*lblcol2,*lblcol3,*lblcol4;

@end