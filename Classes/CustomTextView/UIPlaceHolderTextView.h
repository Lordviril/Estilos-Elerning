//
//  UIPlaceHolderTextView.h
//  Scanner
//
//  Created by Chirag Ahmedabadi on 19/06/13.
//
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
