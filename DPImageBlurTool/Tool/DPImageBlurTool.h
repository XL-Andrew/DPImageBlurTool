//
//  DPImageBuffer.h
//  testt
//
//  Created by Andrew on 2017/8/18.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DPImageBlurTool : NSObject

/**
 设置图片模糊 default blur 0.4

 @param image 模糊处理的图片
 @return 处理后的图片
 */
+ (UIImage *)setGaussianBlur:(UIImage *)image;

/**
 设置图片模糊
 
 @param image 模糊处理的图片
 @param blurLevel 模糊度 0.1 - 1
 @return 处理后的图片
 */
+ (UIImage *)setGaussianBlur:(UIImage *)image withBlurLevel:(CGFloat)blurLevel;

/**
 消除模糊效果

 @param image 消除模糊图像
 @param imageView image对应imageView
 */
+ (void)removGaussianBlur:(UIImage *)image withImageView:(UIImageView *)imageView;

/**
 消除模糊效果（渐变效果）

 @param image 消除模糊图像
 @param imageView image对应imageView
 @param duration 消失时长
 */
+ (void)removGaussianBlur:(UIImage *)image withImageView:(UIImageView *)imageView duration:(NSTimeInterval)duration imageBlurLevel:(CGFloat)blurLevel;

@end
