//
//  YYQRCode.h
//  QRCodeCreat
//
//  Created by 韩亚周 on 15/10/28.
//  Copyright © 2015年 韩亚周. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIImage+RoundRect.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface YYQRCode : NSObject
/*!创建普通二维码,会模糊*/
+ (CIImage *)creatQRCodeWithString:(NSString *)string;
/*!创建普通二维码并重绘，不会模糊*/
+ (UIImage *)resizeUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;
/*!创建一个自定义颜色的二维码（十六进制）*/
+ (UIImage *)customColorImage:(UIImage*)image withColor:(UIColor *)color;
/*!创建自定义颜色的二维码（RGB）*/
+ (UIImage *)customRGBColorImage:(UIImage*)image withRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
/*!给创建好的二维码添加小图标*/
+ (UIImage *)addImageToQRCodeImage:(UIImage *)image withImage:(UIImage *)image withScale:(CGFloat)scale;

@end
