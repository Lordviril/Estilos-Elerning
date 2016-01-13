//
//  UIImage+ResizeAndRotate.h
//  TetsPhotoCompressionAndResize
//
//  Created by HiddenBrains.
//  Copyright (c) 2013 HiddenBrains. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ResizeAndRotate)

+ (UIImage*)rotateImage:(UIImage*)image;
+ (CGRect) aspectFittedRect:(CGRect)inRect max:(CGRect)maxRect;
+ (UIImage *)makeResizedImage:(CGSize)newSize quality:(CGInterpolationQuality)interpolationQuality withImage:(UIImage*)oldImage;

@end