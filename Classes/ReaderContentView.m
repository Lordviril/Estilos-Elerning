//
//	ReaderContentView.m
//	Reader v2.1.0
//
//	Created by Julius Oklamcak on 2011-07-01.
//	Copyright © 2011 Julius Oklamcak. All rights reserved.
//
//	This work is being made available under a Creative Commons Attribution license:
//		«http://creativecommons.org/licenses/by/3.0/»
//	You are free to use this work and any derivatives of this work in personal and/or
//	commercial products and projects as long as the above copyright is maintained and
//	the original author is attributed.
//

#import "ReaderContentView.h"
#import "ReaderContentPage.h"
#import "ReaderScrollView.h"

#import <QuartzCore/QuartzCore.h>

@implementation ReaderContentView

#pragma mark Constants

#define ZOOM_LEVELS 5
#define ZOOM_AMOUNT 0.1f
#define CONTENT_INSET 2.0f


#pragma mark Properties

@synthesize delegate;

#pragma mark ReaderContentView functions

static inline CGFloat ZoomScaleThatFits(CGSize target, CGSize source)
{
	CGFloat w_scale = (target.width / source.width);
	CGFloat h_scale = (target.height / source.height);

	return (w_scale < h_scale) ? w_scale : h_scale;
}

#pragma mark ReaderContentView instance methods

- (void)updateMinimumMaximumZoom
{
	CGRect targetRect = CGRectInset(theScrollView.bounds, CONTENT_INSET, CONTENT_INSET);

	CGFloat zoomScale = ZoomScaleThatFits(targetRect.size, theContentView.bounds.size);

	theScrollView.minimumZoomScale = zoomScale; // Set the minimum and maximum zoom scales

	theScrollView.maximumZoomScale = (zoomScale * ZOOM_LEVELS); // Number of zoom levels
}

- (id)initWithFrame:(CGRect)frame fileURL:(NSURL *)fileURL page:(NSUInteger)page password:(NSString *)phrase _videoInfo:(NSDictionary*)_videoInfo
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	
	if ((self = [super initWithFrame:frame]))
	{
		self.autoresizesSubviews = YES;
		self.userInteractionEnabled = YES;
		self.contentMode = UIViewContentModeRedraw;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.backgroundColor = [UIColor clearColor];
		UITapGestureRecognizer *TapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
		TapOne.numberOfTouchesRequired = 1; 
		TapOne.numberOfTapsRequired = 1; 
		TapOne.delegate = self;
		
//		UITapGestureRecognizer *TapTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//		TapTwo.numberOfTouchesRequired = 1; 
//		TapTwo.numberOfTapsRequired = 1; 
//		TapTwo.delegate = self;
		firstTap=YES;
		[self addGestureRecognizer:TapOne]; [TapOne release];
		//[self addGestureRecognizer:TapTwo]; [TapTwo release];
		
		theScrollView = [[ReaderScrollView alloc] initWithFrame:self.bounds];

		theScrollView.scrollsToTop = NO;
		theScrollView.delaysContentTouches = NO;
		theScrollView.showsVerticalScrollIndicator = NO;
		theScrollView.showsHorizontalScrollIndicator = NO;
		theScrollView.contentMode = UIViewContentModeRedraw;
		theScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		theScrollView.backgroundColor = [UIColor clearColor];
		theScrollView.userInteractionEnabled = YES;
		theScrollView.autoresizesSubviews = NO;
		theScrollView.bouncesZoom = YES;
		theScrollView.delegate = self;

		theContentView = [[ReaderContentPage alloc] initWithURL:fileURL page:page password:phrase];
        
		if (theContentView != nil) // Must have a valid and initialized content view
		{
			theContainerView = [[UIView alloc] initWithFrame:theContentView.bounds];

			theContainerView.autoresizesSubviews = NO;
			theContainerView.userInteractionEnabled = YES;
			theContainerView.contentMode = UIViewContentModeRedraw;
			theContainerView.autoresizingMask = UIViewAutoresizingNone;
			theContainerView.backgroundColor = [UIColor whiteColor];

			theScrollView.contentSize = theContentView.bounds.size; // Content size same as view size
			theScrollView.contentOffset = CGPointMake((0.0f - CONTENT_INSET), (0.0f - CONTENT_INSET));
			theScrollView.contentInset = UIEdgeInsetsMake(CONTENT_INSET, CONTENT_INSET, CONTENT_INSET, CONTENT_INSET);

			[theContainerView addSubview:theContentView];
			if(_videoInfo!=nil){
				NSInteger position=0;
				if ([[_videoInfo objectForKey:@"video_position"] isEqualToString:@"Top"]) {
					position=1;	
				}else if([[_videoInfo objectForKey:@"video_position"] isEqualToString:@"Middle"]){
					position =2;
				}else position =3;
			//	NSURL *url=[[NSURL alloc] initWithString:[_videoInfo objectForKey:@"video_url"]];
				NSString *urlString=[_videoInfo objectForKey:@"video_url"];
				switch (position) {
					case 1:
						_videoWebView = [[CustomWebView alloc] initWithFrame:CGRectMake(theContainerView.frame.origin.x+10,theContainerView.frame.origin.y+10, theContainerView.frame.size.width-20, 300) andUrl:urlString];
                        _videoWebView.backgroundColor = [UIColor clearColor];
                        //_videoWebView.u
						break;
					case 2:
						_videoWebView = [[CustomWebView alloc] initWithFrame:CGRectMake(theContainerView.frame.origin.x+10,theContainerView.frame.origin.y+260, theContainerView.frame.size.width-20, 300) andUrl:urlString];
						break;
					case 3:
						_videoWebView = [[CustomWebView alloc] initWithFrame:CGRectMake(theContainerView.frame.origin.x+10, theContainerView.frame.size.height-310, theContainerView.frame.size.width-20, 300) andUrl:urlString];
						break;
					default:
						break;
				}
				[theContainerView addSubview:_videoWebView];
			}
			
			// Add the content view to the container view
			[theScrollView addSubview:theContainerView]; // Add the container view to the scroll view			
			[self updateMinimumMaximumZoom]; // Update the minimum and maximum zoom scales
            theScrollView.zoomScale = theScrollView.minimumZoomScale; // Zoom to fit
            [theScrollView setContentSize:theContainerView.frame.size];
            theScrollView.maximumZoomScale = 5.0;
		}

					
		[self addSubview:theScrollView]; // Add the scroll view to the parent container view

		[theScrollView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];

		self.tag = page; // Tag the view with the page number
	}

	return self;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer 
       shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}
- (void)dealloc
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	[theScrollView removeObserver:self forKeyPath:@"frame"];

	[theScrollView release], theScrollView = nil;

	[theContainerView release], theContainerView = nil;
	[_videoWebView stopLoading];
	[theContentView release], theContentView = nil;
	[_videoWebView release];_videoWebView=nil;
	[super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	if ((object == theScrollView) && [keyPath isEqualToString:@"frame"])
	{
		CGFloat oldMinimumZoomScale = theScrollView.minimumZoomScale;

		[self updateMinimumMaximumZoom]; // Update the zoom scale limits

		if (theScrollView.zoomScale == oldMinimumZoomScale) // Old minimum
		{
			theScrollView.zoomScale = theScrollView.minimumZoomScale;
		}
		else // Check against minimum zoom scale
		{
			if (theScrollView.zoomScale < theScrollView.minimumZoomScale)
			{
				theScrollView.zoomScale = theScrollView.minimumZoomScale;
			}
			else // Check against maximum zoom scale
			{
				if (theScrollView.zoomScale > theScrollView.maximumZoomScale)
				{
					theScrollView.zoomScale = theScrollView.maximumZoomScale;
				}
			}
		}
	}
}

- (void)layoutSubviews
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	CGRect viewFrame = theContainerView.frame;
	CGSize boundsSize = theScrollView.bounds.size;
	CGPoint contentOffset = theScrollView.contentOffset;

	if (viewFrame.size.width < boundsSize.width)
		viewFrame.origin.x = (((boundsSize.width - viewFrame.size.width) / 2.0f) + contentOffset.x);
	else
		viewFrame.origin.x = 0.0f;

	if (viewFrame.size.height < boundsSize.height)
		viewFrame.origin.y = (((boundsSize.height - viewFrame.size.height) / 2.0f) + contentOffset.y);
	else
		viewFrame.origin.y = 0.0f;

	theContainerView.frame = viewFrame;
}

- (id)singleTap:(UITapGestureRecognizer *)recognizer
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	return [theContentView singleTap:recognizer];
}

- (void)zoomIncrement
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	CGFloat zoomScale = theScrollView.zoomScale;

	if (zoomScale <= theScrollView.maximumZoomScale)
	{
		zoomScale += ZOOM_AMOUNT;

		if (zoomScale > theScrollView.maximumZoomScale)
		{
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"You are reached maximum zoom level."] delegate:nil cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
			[alert show];
			[alert release];
			
		}
	}

	if (zoomScale != theScrollView.zoomScale) // Do zoom
	{
		[theScrollView setZoomScale:zoomScale animated:YES];
	}
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    theContainerView.frame = [self centeredFrameForScrollView:scrollView andUIView:theContainerView];
}
- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView {
	CGSize boundsSize = scroll.bounds.size;
    CGRect frameToCenter = rView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }
    else {
        frameToCenter.origin.x = 0;
    }
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }
    else {
        frameToCenter.origin.y = 0;
    }
    return frameToCenter;
}



- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{    
    theScrollView.contentSize = CGSizeMake(theScrollView.contentSize.width, theScrollView.contentSize.height + (44 * scale));
}

- (void)zoomDecrement
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	CGFloat zoomScale = theScrollView.zoomScale;

	if (zoomScale >= theScrollView.minimumZoomScale)
	{
		zoomScale -= ZOOM_AMOUNT;

		if (zoomScale < theScrollView.minimumZoomScale)
		{
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"You are reached minimum zoom level."] delegate:nil cancelButtonTitle:[eEducationAppDelegate getLocalvalue:@"OK"] otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}

	if (zoomScale != theScrollView.zoomScale) // Do zoom
	{
		[theScrollView setZoomScale:zoomScale animated:YES];
	}
}

- (void)zoomReset
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	if (theScrollView.zoomScale > theScrollView.minimumZoomScale)
	{
		theScrollView.zoomScale = theScrollView.minimumZoomScale;
		
	}
}

#pragma mark UIScrollViewDelegate methods
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{

    if (firstTap) {
        [delegate touchHandler:1];
        firstTap=NO;
    }
    else{
        [delegate touchHandler:2];
        firstTap=YES;
    }
}



- (void)scrollViewTouchesBegan:(UIScrollView *)scrollView touches:(NSSet *)touches
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
	//[delegate scrollViewTouchesBegan:scrollView touches:touches];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return theContainerView;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return NO;
}
@end
