
#import "KLTile.h"
#import "KLDate.h"
#import "KLColors.h"

static CGGradientRef TextFillGradient;

__attribute__((constructor))        // Makes this function run when the app loads
static void InitKLTile()
{
    // prepare the gradient
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGColorRef rawColors[2];
    rawColors[0] = CreateRGB(0.173f, 0.212f, 0.255f, 1.0f);
    rawColors[1] = CreateRGB(0.294f, 0.361f, 0.435f, 1.0f);
    
    CFArrayRef colors = CFArrayCreate(NULL, (void*)&rawColors, 2, NULL);

    // create it
    TextFillGradient = CGGradientCreateWithColors(colorSpace, colors, NULL);

    CGColorRelease(rawColors[0]);
    CGColorRelease(rawColors[1]);
    CFRelease(colors);
    CGColorSpaceRelease(colorSpace);
    
}

@interface KLTile ()
- (CGFloat)thinRectangleWidth;
@end

@implementation KLTile

@synthesize text = _text, date = _date;

- (id)init
{
    if (![super initWithFrame:CGRectMake(0.f, 0.f, 44.f, 44.f)])
        return nil;

    self.backgroundColor = [UIColor colorWithCGColor:kCalendarBodyLightColor];
    [self setTextTopColor:kTileRegularTopColor];
    [self setTextBottomColor:kTileRegularBottomColor];
    
    self.clipsToBounds = YES;
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event { [[self superview] touchesBegan:touches withEvent:event]; }
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event { [[self superview] touchesMoved:touches withEvent:event]; }

- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	UITouch *touch = [touches anyObject];
    if ([touch tapCount] == 1)
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    else
        [[self superview] touchesEnded:touches withEvent:event];
}

- (void)drawInnerShadowRect:(CGRect)rect percentage:(CGFloat)percentToCover context:(CGContextRef)ctx
{
    CGFloat width = floorf(rect.size.width);
    CGFloat height = floorf(rect.size.height) + 4;
    CGFloat gradientLength = percentToCover * height;
    
    CGColorRef startColor = CreateRGB(0.0f, 0.0f, 0.0f, 0.4f);  // black 40% opaque
    CGColorRef endColor = CreateRGB(0.0f, 0.0f, 0.0f, 0.0f);    // black  0% opaque
    CGColorRef rawColors[2] = { startColor, endColor };
    CFArrayRef colors = CFArrayCreate(NULL, (void*)&rawColors, 2, NULL);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, NULL);

    CGContextClipToRect(ctx, rect);
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0,0), CGPointMake(0, gradientLength), kCGGradientDrawsAfterEndLocation); // top
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(width,0), CGPointMake(width-gradientLength, 0) , kCGGradientDrawsAfterEndLocation); // right
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0,height), CGPointMake(0, height-gradientLength), kCGGradientDrawsAfterEndLocation); // bottom
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0,0), CGPointMake(gradientLength, 0) , kCGGradientDrawsAfterEndLocation); // left

    CGGradientRelease(gradient);
    CFRelease(colors);
    CGColorSpaceRelease(colorSpace);
    CGColorRelease(startColor);
    CGColorRelease(endColor);
}

- (CGFloat)thinRectangleWidth { return 1+floorf(0.02f * self.bounds.size.width); }        // 1pt width for 46pt tile width (2pt for 4x scale factor)

- (void)drawTextInContext:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
   // CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat numberFontSize = 20;//floorf(0.5f * width);
    
    // create a clipping mask from the text for the gradient
    // NOTE: this is a pain in the ass because clipping a string with more than one letter
    //       results in the clip of each letter being superimposed over each other,
    //       so instead I have to manually clip each letter and draw the gradient
    CGContextSetFillColorWithColor(ctx, kDarkCharcoalColor);
    CGContextSetTextDrawingMode(ctx, kCGTextClip);
    for (NSInteger i = 0; i < [self.text length]; i++) {
        NSString *letter = [self.text substringWithRange:NSMakeRange(i, 1)];
		
        CGSize letterSize = [letter sizeWithFont:[UIFont boldSystemFontOfSize:numberFontSize]];
        
        CGContextSaveGState(ctx);  // I will need to undo this clip after the letter's gradient has been drawn
        [letter drawAtPoint:CGPointMake(40.0f+(letterSize.width*i), 20.0f) withFont:[UIFont boldSystemFontOfSize:numberFontSize]];

        if ([self.date isToday]) {
            CGContextSetFillColorWithColor(ctx, kWhiteColor);
            CGContextFillRect(ctx, self.bounds);  
		} else if ([self.date isSelDate:selDate]) {
		   
			CGContextSetFillColorWithColor(ctx, kWhiteColor);
            CGContextFillRect(ctx, self.bounds);  
            // nice gradient fill for all tiles except today
            
        }
		else {
			CGContextDrawLinearGradient(ctx, TextFillGradient, CGPointMake(0,0), CGPointMake(0, height/3), kCGGradientDrawsAfterEndLocation);
		}


        CGContextRestoreGState(ctx);  // get rid of the clip for the current letter        
    }
    
    CGContextRestoreGState(ctx);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat lineThickness = 2;  // for grid shadow and highlight
    
    // dark grid line
    CGContextSetFillColorWithColor(ctx, kGridDarkColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, width, lineThickness));                    // top
    CGContextFillRect(ctx, CGRectMake(width-lineThickness, 0, lineThickness, height)); // right
    
    // highlight
    CGContextSetFillColorWithColor(ctx, kGridLightColor);
    CGContextFillRect(ctx, CGRectMake(0, lineThickness, width-lineThickness, lineThickness));                    // top
    CGContextFillRect(ctx, CGRectMake(width-2*lineThickness, lineThickness, lineThickness, height-lineThickness)); // right

    // Highlight if this tile represents today
    if ([self.date isToday]) {
        CGContextSaveGState(ctx);
        CGRect innerBounds = self.bounds;
        innerBounds.size.width -= lineThickness;
        innerBounds.size.height -= lineThickness;
        innerBounds.origin.y += lineThickness;
        CGContextSetFillColorWithColor(ctx, kSlateBlueColor);
        CGContextFillRect(ctx, innerBounds);
        [self drawInnerShadowRect:innerBounds percentage:0.1f context:ctx];
        CGContextRestoreGState(ctx);
    }
	if ([self.date isSelDate:selDate]) {
        CGContextSaveGState(ctx);
        CGRect innerBounds = self.bounds;
        innerBounds.size.width -= lineThickness;
        innerBounds.size.height -= lineThickness;
        innerBounds.origin.y += lineThickness;
        CGContextSetFillColorWithColor(ctx, kCalendarHeaderDarkColor);
        CGContextFillRect(ctx, innerBounds);
        [self drawInnerShadowRect:innerBounds percentage:0.1f context:ctx];
        CGContextRestoreGState(ctx);
    }
    
    // Draw the # for this tile
    [self drawTextInContext:ctx];
}

// --------------------------------------------------------------------------------------------
//      flash
// 
//       Flash the tile so that the user knows the tap was register but nothing will happen.
//      
- (void)flash:(NSDate*)seldate
{
    //self.backgroundColor = [UIColor colorWithCGColor:kTileRegularTopColor];
    self.backgroundColor = [UIColor colorWithRed:68.0/255.0 green:92.0/255.0 blue:94.0/255.0 alpha:1.0];
	
	
        NSInteger year, month, day;
        CFAbsoluteTime absoluteTime = CFDateGetAbsoluteTime((CFDateRef)seldate);
        CFCalendarRef calendar = CFCalendarCopyCurrent();
        CFCalendarDecomposeAbsoluteTime(calendar, absoluteTime, "yMd", &year, &month, &day);
        CFRelease(calendar);
        selDate = [[KLDate alloc] initWithYear:year month:month day:day];
   
	
  
	
	[self drawRect:CGRectMake(0, 0, 0, 0)];
	//[self performSelector:@selector(restoreBackgroundColor) withObject:nil afterDelay:0.1f];
}

// --------------------------------------------------------------------------------------------
//      restoreBackgroundColor
// 
//       The inverse of flashTile, this is called at the end of the flash duration
//       to restore the tile's origianl background color.
//      
- (void)restoreBackgroundColor
{
	CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
	[self drawRect:CGRectMake(0, 0, width, height)];
	selDate=nil;
    self.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
}

- (CGColorRef)textTopColor { return _textTopColor; }
- (void)setTextTopColor:(CGColorRef)color
{
    if (color != _textTopColor) {
        CGColorRelease(_textTopColor);
        _textTopColor = CGColorRetain(color);
    }
}

- (CGColorRef)textBottomColor { return _textBottomColor; }
- (void)setTextBottomColor:(CGColorRef)color
{
    if (color != _textBottomColor) {
        CGColorRelease(_textBottomColor);
        _textBottomColor = CGColorRetain(color);
    }
}

- (void)dealloc
{
    [_date release];
    [_text release];
    CGColorRelease(_textTopColor);
    CGColorRelease(_textBottomColor);
    [super dealloc];
}

@end











