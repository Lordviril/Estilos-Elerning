//
//  CustomCellMessageList.h
//  eEducation
//
//  Created by Hidden Brains on 11/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@interface CustomCellMessageList : UITableViewCell 
{
    
}

@property(nonatomic,retain) IBOutlet UILabel *lblDateTime;
@property(nonatomic,retain) IBOutlet UIImageView *imgBlueMark,*imgBlueDot,*imgDateTimeIcon;
@property(nonatomic,retain) IBOutlet RTLabel *lblFrom,*lblSubject;

@end