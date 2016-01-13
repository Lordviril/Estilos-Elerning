//
//  CustomTabbarController.m
//  eEducation
//
//  Created by HB14 on 11/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomTabbarController.h"


@implementation CustomTabbarController
@synthesize customDelegate,localBundlePath;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	[super viewDidLoad];
	self.delegate=self;
	[self setHighligtedTabAtIndex:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)statusBarOrientationChange:(NSNotification *)notification
{
    UIInterfaceOrientation orient = [notification.userInfo[UIApplicationStatusBarOrientationUserInfoKey] integerValue];
    [self changeRespondToOrientation:orient];
}


#pragma mark -
#pragma mark CustomTabbar Refreshing Methods

-(void)refreshTabbarImages
{
	UIInterfaceOrientation toInterfaceOrientation=[UIApplication sharedApplication].statusBarOrientation;
	if(localTabImagesArray)
	{
		if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
		{
			[self setTabbarImage:localTabbarImage withTabItems:localTabImagesArray];
		}
		else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
		{
			if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
			{
				[self setTabbarImage:localTabbarImage withTabItems:localLandscapeArray];
			}
			else 
			{
				[self setTabbarImage:localTabbarImage withTabItems:localTabImagesArray];
			}
		}		
		
		[self setHighligtedTabAtIndex:self.selectedIndex];
	}
}

#pragma mark -
#pragma mark CustomTabbar iPhone+iPad Methods

-(void) setTabbarImage:(NSString *)tabbarImage WithPortraitImages:(NSArray *)portraitArray andWithLandscapeImages:(NSArray *)landscapeArray
{
	[self setTabbarImage:tabbarImage withTabItems:portraitArray];
	localLandscapeArray=[[NSMutableArray alloc] initWithArray:landscapeArray copyItems:YES];
}

#pragma mark -
#pragma mark CustomTabbar iPad Methods

-(void) setTabbarImage:(NSString *)tabbarImage withTabItems:(NSArray *)tabImagesArray\
{
	
	if([self.viewControllers count] != [tabImagesArray count])
	{
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle 
													  message:[eEducationAppDelegate getLocalvalue:@"Tabbar Viewcontrollers and Tabbar Images Should be equal. Tabbar images will not Set."]
													 delegate:nil 
											cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"]
											otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	//self.delegate=self;
	
	for(id object in self.tabBar.subviews)
	{
		if([object isKindOfClass:[UIImageView class]])
		{
			[object removeFromSuperview];
		}
	}

	if(!localTabImagesArray)
		localTabImagesArray=[[NSMutableArray alloc] initWithArray:tabImagesArray copyItems:YES];
	localTabbarImage=tabbarImage;
	
	UIImageView *TabbarImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:tabbarImage]];
	
	float startX;
	float portraitWidth,landscapeWidth;
	float tabWidth,gapForEachTab;
	
	
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		portraitWidth=768;
		landscapeWidth=1024;
		//tabWidth=80;
		if([UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationLandscapeRight || [UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationLandscapeLeft )
		{
			gapForEachTab=([self.viewControllers count]<=8)?30:0;
			tabWidth=landscapeWidth/(([self.viewControllers count]<=8)?12.8:[self.viewControllers count]);
			TabbarImageView.frame=CGRectMake(0, 0, 1024, 50);
			startX=landscapeWidth-(([tabImagesArray count]*tabWidth)+(([tabImagesArray count]-1)*gapForEachTab));
			startX/=2;
		}else {
			gapForEachTab=([self.viewControllers count]<8)?30:0;
			tabWidth=portraitWidth /(([self.viewControllers count]<8)?9.6:[self.viewControllers count]);
			TabbarImageView.frame=CGRectMake(0, 0, 768, 50);
			startX=portraitWidth-(([tabImagesArray count]*tabWidth)+(([tabImagesArray count]-1)*gapForEachTab));
			startX/=2;
		}
	}
	else
	{
		portraitWidth=320;
		landscapeWidth=480;
		gapForEachTab=0;
		
		if([UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationLandscapeRight || [UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationLandscapeLeft )
		{
			tabWidth=landscapeWidth/[self.viewControllers count];
			TabbarImageView.frame=CGRectMake(0, 0, 480, 50);
			startX=landscapeWidth-(([tabImagesArray count]*tabWidth)+(([tabImagesArray count]-1)*gapForEachTab));
			startX/=2;
		}else {
			tabWidth=portraitWidth/[self.viewControllers count];
			TabbarImageView.frame=CGRectMake(0, 0, 320, 50);
			startX=portraitWidth-(([tabImagesArray count]*tabWidth)+(([tabImagesArray count]-1)*gapForEachTab));
			startX/=2;
		}
	}
	
	TabbarImageView.tag=111;
	[TabbarImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin];
	[self.tabBar addSubview:TabbarImageView];
	for(int i=0;i<[tabImagesArray count];i++)
	{
		NSString *imagePath=nil;
		UIImageView *tabItemImage=[[UIImageView alloc]initWithFrame:CGRectMake(startX+i*(tabWidth+gapForEachTab),0.0,tabWidth,49.0)];

		// For default image
			NSString *imageName=[tabImagesArray objectAtIndex:i];
			imagePath=[[NSBundle bundleWithPath:localBundlePath] pathForResource:imageName ofType:nil];

			if(imagePath==nil)
				imagePath=[[NSBundle mainBundle] pathForResource:imageName ofType:nil];
		
			tabItemImage.image=[UIImage imageWithContentsOfFile:imagePath];	
		
		// For highlighted image
			imagePath=nil;

			NSString *imageName_h=[tabImagesArray objectAtIndex:i];
			imageName_h=[imageName_h stringByReplacingOccurrencesOfString:@".png" withString:@"_h.png"];
			imagePath=[[NSBundle bundleWithPath:localBundlePath] pathForResource:imageName_h ofType:nil];
			
			if(imagePath==nil)
				imagePath=[[NSBundle mainBundle] pathForResource:imageName_h ofType:nil];
	
			tabItemImage.tag=i;
			tabItemImage.highlightedImage=[UIImage imageWithContentsOfFile:imagePath];
			[TabbarImageView addSubview:tabItemImage];
			[tabItemImage release];
		}
	
	[TabbarImageView release];
}

-(void) setHighligtedTabAtIndex:(NSInteger)tabIndex
{
	int findObject=0;
	for(id object in [self.tabBar viewWithTag:111].subviews)
	{
		[object setHighlighted:NO];
		if(++findObject==tabIndex+1)
			[object setHighlighted:YES];
	}
}

#pragma mark -
#pragma mark CustomTabbar Delegate Methods

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	//[viewController.navigationController popToRootViewControllerAnimated:YES];
	if(localTabImagesArray)
	{
		[self setHighligtedTabAtIndex:self.selectedIndex];
	}
	
	if([self.customDelegate respondsToSelector:@selector(customTabBarController:didSelectViewController:)])
	{
		[self.customDelegate customTabBarController:self didSelectViewController:viewController];
	}
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
	if([self.customDelegate respondsToSelector:@selector(customTabBarController:shouldSelectViewController:)])
	{
		return [self.customDelegate customTabBarController:self shouldSelectViewController:viewController];
	}
	return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers
{
	if([self.customDelegate respondsToSelector:@selector(customTabBarController:willBeginCustomizingViewControllers:)])
	{
		[self.customDelegate customTabBarController:self willBeginCustomizingViewControllers:viewControllers];
	}
}

- (void)tabBarController:(UITabBarController *)tabBarController willEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed 
{
	if([self.customDelegate respondsToSelector:@selector(customTabBarController:willEndCustomizingViewControllers:changed:)])
	{
		[self.customDelegate customTabBarController:self willEndCustomizingViewControllers:viewControllers changed:changed];
	}
}

- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
	if([self.customDelegate respondsToSelector:@selector(customTabBarController:didEndCustomizingViewControllers:changed:)])
	{
		[self.customDelegate customTabBarController:self didEndCustomizingViewControllers:viewControllers changed:changed];
	}
}

#pragma mark -
#pragma mark CustomTabbar Orientation Methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}


-(void)changeRespondToOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	if(localTabImagesArray)
	{
		if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
		{
            [self setTabbarImage:localTabbarImage withTabItems:localTabImagesArray];
		}
		else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
		{
			if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad && localLandscapeArray)
			{
				[self setTabbarImage:localTabbarImage withTabItems:localLandscapeArray];
			}
			else
			{
				[self setTabbarImage:localTabbarImage withTabItems:localTabImagesArray];
			}
		}
		[self setHighligtedTabAtIndex:self.selectedIndex];
	}
}

//-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{	
//	if(localTabImagesArray)
//	{
//		if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
//		{
//				[self setTabbarImage:localTabbarImage withTabItems:localTabImagesArray];
//		}
//		else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
//		{
//			if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad && localLandscapeArray)
//			{
//				[self setTabbarImage:localTabbarImage withTabItems:localLandscapeArray];
//			}
//			else 
//			{
//				[self setTabbarImage:localTabbarImage withTabItems:localTabImagesArray];
//			}
//		}		
//		[self setHighligtedTabAtIndex:self.selectedIndex];
//	}
//	
//	if(self.selectedViewController!=nil && [self.selectedViewController respondsToSelector:@selector(willAnimateRotationToInterfaceOrientation:duration:)])
//	{
//		[self.selectedViewController willAnimateRotationToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0.2];
//	}
//	
//	if(self.navigationController!=nil && [self.navigationController respondsToSelector:@selector(willAnimateRotationToInterfaceOrientation:duration:)])
//	{
//		[self.navigationController willAnimateRotationToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0.2];
//	}
//}

#pragma mark -
#pragma mark Memory Management Methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	[localTabbarImage release];
	[localTabImagesArray release];
	[localLandscapeArray release];
	[localPortraitArray release];
	[localBundlePath release];
}


- (void)dealloc {
    [super dealloc];
}


@end
