//
//  CustomTabbarController.h
//  eEducation
//
//  Created by HB14 on 11/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomTabbarController;

@protocol CustomTabbarControllerDelegate;

@interface CustomTabbarController : UITabBarController<UITabBarControllerDelegate>
{
	id<CustomTabbarControllerDelegate>customDelegate;
	NSMutableArray *localTabImagesArray;
	NSMutableArray *localLandscapeArray;
	NSMutableArray *localPortraitArray;
	NSString *localTabbarImage;
	NSString *localBundlePath;
}
@property(nonatomic,retain) NSString *localBundlePath;
@property(nonatomic,assign) id<CustomTabbarControllerDelegate>customDelegate;
-(void) setTabbarImage:(NSString *)tabbarImage withTabItems:(NSArray *)tabImagesArray;
-(void) setHighligtedTabAtIndex:(NSInteger)tabIndex;
-(void) setTabbarImage:(NSString *)tabbarImage WithPortraitImages:(NSArray *)portraitArray andWithLandscapeImages:(NSArray *)landscapeArray;
-(void)refreshTabbarImages;

@end

@protocol CustomTabbarControllerDelegate <NSObject>
@optional
- (BOOL)customTabBarController:(CustomTabbarController *)customTabBarController shouldSelectViewController:(UIViewController *)viewController __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
- (void)customTabBarController:(CustomTabbarController *)customTabBarController didSelectViewController:(UIViewController *)viewController;
- (void)customTabBarController:(CustomTabbarController *)customTabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
- (void)customTabBarController:(CustomTabbarController *)customTabBarController willEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
- (void)customTabBarController:(CustomTabbarController *)customTabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed;
@end
