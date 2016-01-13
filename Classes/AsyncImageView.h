//
//  AsyncImageView.h
//  YellowJacket
//
//  Created by Wayne Cochran on 7/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


//
// Code heavily lifted from here:
// http://www.markj.net/iphone-asynchronous-table-image/
//

#import <UIKit/UIKit.h>
#import "GBPathImageView.h"

@interface AsyncImageView : UIView {
    NSURLConnection *connection;
    NSMutableData *data;
    NSString *urlString; // key for image cache dictionary
	UILabel *plsWait;
	UIActivityIndicatorView *indicator;
    UIImage *originalImage;
}

@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *pathColor;
@property float pathWidth;

- (void)loadImageFromURL:(NSURL*)url imageName:(NSString*)defaultImageName;
- (UIImage *)scaleAndRotateImage:(UIImage *)imgPic;
-(void)loadImage:(UIImage *)objImage;
@end
