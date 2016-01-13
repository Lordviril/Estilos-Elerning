//
//  CustomCellLibrary.h
//  eEducation
//
//  Created by HB14 on 09/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AsyncImageView;
@interface CustomCellLibrary : UITableViewCell 
{
}

@property(nonatomic,retain) IBOutlet UIButton *btn_book1;
@property(nonatomic,retain) IBOutlet UIButton *btn_book2;
@property(nonatomic,retain) IBOutlet UIButton *btn_book3;
@property (nonatomic,retain) IBOutlet AsyncImageView *Book1,*Book2,*Book3;

@end
