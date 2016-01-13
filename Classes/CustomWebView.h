//
//  CustomWebView.h
//  eEducation
//
//  Created by HB on 11/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface CustomWebView : UIWebView <UIWebViewDelegate>
{
	MBProgressHUD *HUD;
}

- (id)initWithFrame:(CGRect)frame andUrl:(NSString *)videoUrl;
- (void)adjustYouTube:(NSString *)videoUrl;

@end
