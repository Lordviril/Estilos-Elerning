

#import "KLGraphicsUtils.h"
#import <QuartzCore/QuartzCore.h>

void MyDrawText (CGContextRef myContext, CGRect contextRect, CGFloat fontSize, const char *text, int length)
{
    //float w=0.0, h=0.0;
//    w = contextRect.size.width;
//    h = contextRect.size.height;
    
    CGContextSaveGState(myContext);
    CGContextSelectFont (myContext,
                         "Helvetica-Bold",
                         fontSize,
                         kCGEncodingMacRoman);
    CGContextSetCharacterSpacing (myContext, 1);
    CGContextSetTextDrawingMode (myContext, kCGTextFill);
    CGContextSetRGBFillColor (myContext, 0, 0, 0, 1);
    CGContextShowTextAtPoint (myContext, contextRect.origin.x, contextRect.origin.y, text, length);
    CGContextRestoreGState(myContext);
}

void MyDrawTextAsClip (CGContextRef myContext, CGRect contextRect, CGFloat fontSize, const char *text, int length)
{
   // float w, h;
//    w = contextRect.size.width;
//    h = contextRect.size.height;
    
    CGContextSelectFont (myContext,
                         "Helvetica-Bold",
                         fontSize,
                         kCGEncodingMacRoman);
    CGContextSetCharacterSpacing (myContext, 1);
    CGContextSetTextDrawingMode (myContext, kCGTextClip);
    CGContextSetRGBFillColor (myContext, 0, 0, 0, 1);
    CGContextShowTextAtPoint (myContext, contextRect.origin.x, contextRect.origin.y, text, length);
}

// --------------------------------------------------------------------------------------------
//      CreateCGImageFromCALayer()
// 
//      Given a Core Animation layer, render it in a bitmap context and return the CGImageRef
//
CGImageRef CreateCGImageFromCALayer(CALayer *sourceLayer)
{
    CGFloat width = sourceLayer.bounds.size.width;
    CGFloat height = sourceLayer.bounds.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(NULL, width, height, 8, 4*width, colorSpace, kCGImageAlphaPremultipliedLast);
    NSCAssert(ctx, @"failed to create bitmap context from CALayer");
    
    // rotate 180 degrees and flip vertically (otherwise the CALayer will render backwards)
    CGAffineTransform xform = CGAffineTransformMake(1.0f, 0.0f, 0.0f, -1.0f, 0.0f, width);
    CGContextConcatCTM(ctx, xform);
    
    // rasterize the UIView's backing layer
    [sourceLayer renderInContext:ctx];
    CGImageRef raster = CGBitmapContextCreateImage(ctx);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(ctx);
    
    return raster;
}
