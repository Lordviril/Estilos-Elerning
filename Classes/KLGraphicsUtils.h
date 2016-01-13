
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import <math.h>

static inline CGFloat radians (CGFloat degrees) {return (CGFloat)(degrees * M_PI/180.0);}

void MyDrawText (CGContextRef myContext, CGRect contextRect, CGFloat fontSize, const char *text, int length);
void MyDrawTextAsClip (CGContextRef myContext, CGRect contextRect, CGFloat fontSize, const char *text, int length);

CGImageRef CreateCGImageFromCALayer(CALayer *sourceLayer);