//
//  DPImageBuffer.m
//  testt
//
//  Created by Andrew on 2017/8/18.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "DPImageBlurTool.h"
#import <Accelerate/Accelerate.h>

@interface DPImageBlurTool ()

@end

@implementation DPImageBlurTool

+ (UIImage *)setGaussianBlur:(UIImage *)image
{
    return [[self alloc] blurryImage:image withBlurLevel:0.4];
}

+ (UIImage *)setGaussianBlur:(UIImage *)image withBlurLevel:(CGFloat)blurLevel
{
    return [[self alloc] blurryImage:image withBlurLevel:blurLevel];
}

+ (void)removGaussianBlur:(UIImage *)image withImageView:(UIImageView *)imageView
{
    [self removGaussianBlur:image withImageView:imageView duration:0 imageBlurLevel:0];
}

+ (void)removGaussianBlur:(UIImage *)image withImageView:(UIImageView *)imageView duration:(NSTimeInterval)duration imageBlurLevel:(CGFloat)blurLevel
{
    if (duration == 0 || blurLevel == 0) {
        imageView.image = [[self alloc] blurryImage:image withBlurLevel:0.025f];
        return;
    }
    
    //时长毫秒
    CGFloat milliseconds = duration * 1000;
    
    int eachSecondRunTime = 10;
    
    int runTimes = eachSecondRunTime * duration;
    
    //根据去除模糊时长计算去除粒度
    CGFloat eachBlur = blurLevel / runTimes;
    
    CGFloat __block kblurLevel = blurLevel;
    
    dispatch_async(dispatch_queue_create("DPImageBufferQueue", DISPATCH_QUEUE_CONCURRENT),^{
        
        for (int i = 0 ; i < eachSecondRunTime * duration; i ++) {
            dispatch_async(dispatch_get_main_queue(), ^{
                kblurLevel = kblurLevel - eachBlur;
                imageView.image = [[self alloc] blurryImage:image withBlurLevel:kblurLevel];
            });
            [NSThread sleepForTimeInterval:(milliseconds / runTimes) / 1000];
            
        }
    });
}

- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur
{
    if (image == nil) {
        return nil;
    }
    if (blur == 0) {
        return image;
    }
    //模糊度
    if (blur < 0.025f) {
        blur = 0.025f;
    } else if (blur > 1.0f) {
        blur = 1.0f;
    }
    
    //boxSize必须大于0
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    //图像处理
    CGImageRef img = image.CGImage;
    
    //图像缓存,输入缓存，输出缓存
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    //像素缓存
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    // provider’s data.
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    //宽，高，字节/行，data
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //像数缓存，字节行*图片高
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    // 第三个中间的缓存区,抗锯齿的效果
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    //Convolves a region of interest within an ARGB8888 source image by an implicit M x N kernel that has the effect of a box filter.
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    //颜色空间DeviceRGB
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //用图片创建上下文,CGImageGetBitsPerComponent(img),7,8
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, CGImageGetBitmapInfo(image.CGImage));
    
    //根据上下文，处理过的图片，重新组件
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);   //多余的释放
    CGImageRelease(imageRef);
    return returnImage;
}

@end
