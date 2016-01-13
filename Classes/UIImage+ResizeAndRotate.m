//
//  UIImage+ResizeAndRotate.m
//  TetsPhotoCompressionAndResize
//
//  Created by HiddenBrains.
//  Copyright (c) 2013 HiddenBrains. All rights reserved.
//

#import "UIImage+ResizeAndRotate.h"

@implementation UIImage (ResizeAndRotate)

+ (UIImage *)makeResizedImage:(CGSize)newSize quality:(CGInterpolationQuality)interpolationQuality withImage:(UIImage*)oldImage{
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
      oldImage = [self rotateImage:oldImage];
    CGImageRef imageRef = [oldImage CGImage];
    CGSize mySize = [oldImage size];
    CGFloat imageWidth = mySize.width;
    CGFloat imageHeight = mySize.height;
    CGRect tempRect = [self aspectFittedRect:CGRectMake(0, 0,imageWidth, imageHeight) max:newRect];
    newRect = tempRect;
    size_t bytesPerRow = CGImageGetBitsPerPixel(imageRef) / CGImageGetBitsPerComponent(imageRef) * newRect.size.width;
    bytesPerRow = (bytesPerRow + 15) & ~15;    
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                bytesPerRow,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    CGContextSetInterpolationQuality(bitmap, interpolationQuality);
    CGContextDrawImage(bitmap, newRect, imageRef);
    CGImageRef resizedImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *resizedImage = [UIImage imageWithCGImage:resizedImageRef];
    
    CGContextRelease(bitmap);
    CGImageRelease(resizedImageRef);
    
    return resizedImage;
}
+ (CGRect) aspectFittedRect:(CGRect)inRect max:(CGRect)maxRect
{

    float currentHeight = CGRectGetHeight(inRect);
    float currentWidth = CGRectGetWidth(inRect);
    float liChange ;
    CGSize newSize ;
    if (currentWidth == currentHeight) // image is square
    {
        liChange = CGRectGetHeight(maxRect) / currentHeight;
        newSize.height = currentHeight * liChange;
        newSize.width = currentWidth * liChange;
    }
    else if (currentHeight > currentWidth) // image is landscape
    {
        liChange  = CGRectGetWidth(maxRect) / currentWidth;
        newSize.height = currentHeight * liChange;
        newSize.width = CGRectGetWidth(maxRect);
    }
    else                                // image is Portrait
    {
        liChange =CGRectGetHeight(maxRect) / currentHeight;
        newSize.height= CGRectGetHeight(maxRect);
        newSize.width = currentWidth * liChange;
    }
    return CGRectMake(0, 0, newSize.width, newSize.height);
}

+ (UIImage*)rotateImage:(UIImage*)image{
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
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
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
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
