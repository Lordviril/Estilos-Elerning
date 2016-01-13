//
//  AsyncImageView.m
//

#import "AsyncImageView.h"
#import "ImageCacheObject.h"
#import "ImageCache.h"
#import <QuartzCore/QuartzCore.h>

#define LINE_BORDER_WIDTH 1.0
//
// Key's are URL strings.
// Value's are ImageCacheObject's
//
static ImageCache *imageCache = nil;

@implementation AsyncImageView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
		indicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		indicator.frame=CGRectMake(self.frame.size.width/2-15, self.frame.size.height/2-15, 30, 30);
		[indicator startAnimating];
		[indicator hidesWhenStopped];
		[self addSubview:indicator];
    }
    return self;
}
-(void)removeOldImage{
}

-(void)loadImage:(UIImage *)objImage
{
    if ([[self subviews] count] > 0)
    {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    UIImageView *imageView;
    if (self.tag == 12345)
        imageView = [[[GBPathImageView alloc] initWithImage:[self scaleAndRotateImage:objImage]  frame:(CGRect)self.frame] autorelease];
    else
        imageView = [[[GBPathImageView alloc] initWithImage:[self scaleAndRotateImage:objImage] frame:CGRectZero] autorelease];
    
    imageView.contentMode = self.contentMode;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self insertSubview:imageView atIndex:[self.subviews count]];
    //    [self addSubview:imageView];
    imageView.frame = self.bounds;
    imageView.clipsToBounds = YES;
    [imageView setBackgroundColor:[UIColor clearColor]];
    [imageView setNeedsLayout]; // is this necessary if superview gets setNeedsLayout?
    [self setNeedsLayout];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)dealloc {
    [connection cancel];
    [connection release];
    [data release];
    [super dealloc];
}
- (NSString *)quotedPrintableString:(NSString*)str{
    NSMutableString *encoded = [NSMutableString stringWithCapacity:3*[str length]];
    const char *characters = [str UTF8String];
    NSUInteger length = strlen(characters);
    for (NSUInteger i = 0; i < length; ++i) {
        char character = characters[i];
        int left = character & 0xF;
        int right = (character >> 4) & 0xF;
        [encoded appendFormat:@"=%X%X", right, left];
    }
    return encoded;
}

#define SPINNY_TAG 5555
#define plsWait_TAG 9999
-(void)loadImageFromURL:(NSURL*)url imageName:(NSString*)defaultImageName
{
    indicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame=CGRectMake(self.frame.size.width/2-15, self.frame.size.height/2-15, 30, 30);
    [indicator startAnimating];
    [indicator hidesWhenStopped];
    [self addSubview:indicator];
    
    if (connection != nil) {
        [connection cancel];
        [connection release];
        connection = nil;
    }
    if (data != nil) {
        [data release];
        data = nil;
    }
    
    if (imageCache == nil) // lazily create image cache
        imageCache = [[ImageCache alloc] initWithMaxSize:2*1024*1024];  // 2 MB Image cache
    
    [urlString release];
    urlString = [[url absoluteString] copy];
//    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    //    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIImage *cachedImage = [imageCache imageForKey:urlString];
    if (cachedImage != nil)
	{
        if ([[self subviews] count] > 0)
		{
            [[[self subviews] objectAtIndex:0] removeFromSuperview];
        }
		CGImageRef imgRef = cachedImage.CGImage;
		CGFloat width = CGImageGetWidth(imgRef);
		CGFloat height = CGImageGetHeight(imgRef);
        
        GBPathImageView *imageView;
        if (self.tag == 12345)
            imageView = [[[GBPathImageView alloc] initWithImage:cachedImage frame:(CGRect)self.frame] autorelease];
        else
            imageView = [[[GBPathImageView alloc] initWithImage:cachedImage frame:CGRectZero] autorelease];
        
		if( (width >= 108.0 && height > 90 ) ||(height >= 138 && width > 80)){
			imageView.contentMode = UIViewContentModeScaleAspectFit;
		}else{
			imageView.contentMode = self.contentMode;
		}
		self.backgroundColor=[UIColor clearColor];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        for (UIView *v in self.subviews) {
            if ([v isKindOfClass:[UIImageView class]]) {
                [v removeFromSuperview];
            }
        }
        //		[[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self addSubview:imageView];
        imageView.frame = self.bounds;
        [imageView setNeedsLayout]; // is this necessary if superview gets setNeedsLayout?
        [self setNeedsLayout];
        return;
	}
	// this shows a default place holder image if no cached image exists.
	else
	{
		// Use a default placeholder when no cached image is found
        GBPathImageView *imageView;
        if (self.tag == 12345)
            imageView = [[[GBPathImageView alloc] initWithImage:[self scaleAndRotateImage:[UIImage imageNamed:defaultImageName]]  frame:(CGRect)self.frame] autorelease];
        else
            imageView = [[[GBPathImageView alloc] initWithImage:[self scaleAndRotateImage:[UIImage imageNamed:defaultImageName]] frame:CGRectZero] autorelease];
        
		CALayer *l = [imageView layer];
		l.masksToBounds = YES;
		//l.cornerRadius = 10.0;
		l.borderWidth = 1.0;
		l.borderColor = [[UIColor clearColor] CGColor];
		imageView.contentMode = self.contentMode;
        //		imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        for (UIView *v in self.subviews) {
            if ([v isKindOfClass:[UIImageView class]] || [v isKindOfClass:[UIActivityIndicatorView class]]) {
                [v removeFromSuperview];
            }
        }
		[self addSubview:imageView];
		
		imageView.frame = self.bounds;
		[imageView setNeedsLayout];
		[self setNeedsLayout];
	}
	
    if ([urlString length] == 0)
    {
        [indicator removeFromSuperview];
    }
    else
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval:60.0];
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)incrementalData {
    if (data==nil) {
        data = [[[NSMutableData alloc] initWithCapacity:2048] retain];
    }
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
    [connection release];
    connection = nil;
	//NSString *str=[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    //	NSLog(@"%@",str);
    
    if ([[self subviews] count] > 0)
	{
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    if(data!=nil)
	{
		UIImage *image = [UIImage imageWithData:data];
		CGImageRef imgRef = image.CGImage;
		CGFloat width = CGImageGetWidth(imgRef);
		CGFloat height = CGImageGetHeight(imgRef);
        
        GBPathImageView *imageView;
        if (self.tag == 12345)
            imageView = [[[GBPathImageView alloc] initWithImage:[self scaleAndRotateImage:image]  frame:(CGRect)self.frame] autorelease];
        else
            imageView = [[[GBPathImageView alloc] initWithImage:[self scaleAndRotateImage:image] frame:CGRectZero] autorelease];
        
		if( (width >= 108.0 && height > 90 ) ||(height >= 138 && width > 80)){
			imageView.contentMode = UIViewContentModeScaleAspectFit;
		}else{
			imageView.contentMode = self.contentMode;
		}
		[imageCache insertImage:image withSize:[data length] forKey:urlString];
		//UIImageView *imageView = [[[UIImageView alloc] initWithImage:[image stretchableImageWithLeftCapWidth:275.0f topCapHeight:309.0f]] autorelease];
		
		imageView.backgroundColor=[UIColor clearColor];
        for (UIView *v in self.subviews) {
            if ([v isKindOfClass:[UIImageView class]]) {
                [v removeFromSuperview];
            }
        }
        //		[[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
		[self addSubview:imageView];
		imageView.frame = self.bounds;
		[imageView setNeedsLayout]; // is this necessary if superview gets setNeedsLayout?
		[self setNeedsLayout];
	}
	else
	{
		UIImage *image = [UIImage imageNamed:@"no-image-200x200.png"];
		[imageCache insertImage:image withSize:[data length] forKey:urlString];
        
        GBPathImageView *imageView;
        if (self.tag == 12345)
            imageView = [[[GBPathImageView alloc] initWithImage:[self scaleAndRotateImage:image]  frame:(CGRect)self.frame] autorelease];
        else
            imageView = [[[GBPathImageView alloc] initWithImage:[self scaleAndRotateImage:image] frame:CGRectZero] autorelease];
        
		imageView.contentMode = self.contentMode;
		imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        for (UIView *v in self.subviews) {
            if ([v isKindOfClass:[UIImageView class]]) {
                [v removeFromSuperview];
            }
        }
        //		[[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
		[self addSubview:imageView];
		imageView.frame = self.bounds;
		[imageView setNeedsLayout]; // is this necessary if superview gets setNeedsLayout?
		[self setNeedsLayout];
	}
    [data release];
    data = nil;
}

- (UIImage *)scaleAndRotateImage:(UIImage *)imgPic
{
	int kMaxResolution = 640; // Or whatever
    CGImageRef imgRef = imgPic.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution)
	{
        CGFloat ratio = width/height;
        if (ratio > 1)
		{
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else
		{
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = imgPic.imageOrientation;
    switch(orient)
	{
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
			
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
			
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
			
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
			
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
			
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
			
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
			
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
	
    UIGraphicsBeginImageContext(bounds.size);
	
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
	{
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
	{
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
	
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();	
    return imageCopy;	
}

@end