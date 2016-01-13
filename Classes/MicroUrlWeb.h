//
//  MicroUrlWeb.h
//  eEducation
//
//  Created by HB iMac on 15/02/12.
//  Copyright 2012 HiddenBrains. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface MicroUrlWeb : UIViewController<UIWebViewDelegate> {
	NSString *_microUrlString;
	IBOutlet UIWebView *Web_view;
	IBOutlet UIButton *_btnBack;
	MBProgressHUD *HUD;
}
@property(nonatomic,retain)NSString *microUrlString;
-(IBAction)gotoBack:(id)sender;
@end
