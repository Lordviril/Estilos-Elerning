//
//  YouTubePlayer.h
//  VideoApp
//
//  Created by hb3 on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YouTubePlayer : UIViewController <MBProgressHUDDelegate,UIWebViewDelegate,UIAlertViewDelegate>
{
	IBOutlet UIWebView *youTubePlayer;
	NSString *strMovieURL;
	NSString *strTitle;
	MBProgressHUD *HUD;	
	BOOL playedFromLocal;
	BOOL isPlaying;
	IBOutlet UIButton *BtnBack;
	NSString *isFromTabbar;
}
@property (nonatomic,retain) NSString *isFromTabbar;    
@property(nonatomic, retain) NSString *strMovieURL;
@property(nonatomic, retain) NSString *strVimeoID;
@property(nonatomic, retain) NSString *strTitle;
@property(nonatomic, assign) BOOL playedFromLocal;
@property(nonatomic, retain) IBOutlet UIButton *btnBack;
@property(nonatomic, strong) NSString *youtube_id;

-(IBAction)btnBackClicked:(id)sender;

- (void)adjustYouTube;

@end
