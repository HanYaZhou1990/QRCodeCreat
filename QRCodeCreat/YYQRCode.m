//
//  YYQRCode.m
//  QRCodeCreat
//
//  Created by 韩亚周 on 15/10/28.
//  Copyright © 2015年 韩亚周. All rights reserved.
//

#import "YYQRCode.h"

@implementation YYQRCode

#pragma mark - Private Methods
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}

+ (CIImage *)creatQRCodeWithString:(NSString *)string{
        // 6. 将CIImage转换成UIImage，并放大显示
    /*将字符串转换成NSData*/
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    /* 实例化二维码滤镜*/
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    /*恢复滤镜的默认属性*/
    [filter setDefaults];
    /*通过KVO设置滤镜inputMessage数据*/
    [filter setValue:data forKey:@"inputMessage"];
    /*设置纠错等级越高；即识别越容易，值可设置为L(Low) |  M(Medium) | Q | H(High)*/
    [filter setValue:@"Q" forKey:@"inputCorrectionLevel"];
    /*获得滤镜输出的图像*/
    return filter.outputImage;
}

+ (UIImage *)resizeUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    /*创建bitmap*/
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    /*保存bitmap到图片*/
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
+ (UIImage *)customRGBColorImage:(UIImage*)image withRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
        //Create context
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef contextRef = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpaceRef, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
        //Traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    NSLog(@"---%u***%d",*pCurPtr,pixelNum);
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
                //Change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
     NSLog(@"***%u---%d",*pCurPtr,pixelNum);
        //Convert to image
    CGDataProviderRef dataProviderRef = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpaceRef,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProviderRef,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProviderRef);
    UIImage* img = [UIImage imageWithCGImage:imageRef];
    
        //Release
    CGImageRelease(imageRef);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpaceRef);
    return img;
}
+ (UIImage *)customColorImage:(UIImage*)image withColor:(UIColor *)color{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
        //Create context
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef contextRef = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpaceRef, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    const CGFloat *components = CGColorGetComponents(color.CGColor);
        //Traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
                //Change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = components[0]*255; //0~255
            ptr[2] = components[1]*255;
            ptr[1] = components[2]*255;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
        //Convert to image
    CGDataProviderRef dataProviderRef = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpaceRef,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProviderRef,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProviderRef);
    UIImage* img = [UIImage imageWithCGImage:imageRef];
    
        //Release
    CGImageRelease(imageRef);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpaceRef);
    return img;
}

+ (UIImage *)addImageToQRCodeImage:(UIImage *)QRCodeImage withImage:(UIImage *)image withScale:(CGFloat)scale{
    UIGraphicsBeginImageContext(QRCodeImage.size);
    /*通过两张图片进行位置和大小的绘制*/
    CGFloat widthOfImage = QRCodeImage.size.width;
    CGFloat heightOfImage = QRCodeImage.size.height;
    CGFloat widthOfIcon = widthOfImage*scale;
    CGFloat heightOfIcon = heightOfImage*scale;
    
    [QRCodeImage drawInRect:CGRectMake(0, 0, widthOfImage, heightOfImage)];
    image = [UIImage clipCornerWithImage:image withSize:CGSizeMake(widthOfIcon, heightOfIcon) withRadius:8.0];
    [image drawInRect:CGRectMake((widthOfImage-widthOfIcon)/2, (heightOfImage-heightOfIcon)/2,
                                widthOfIcon, heightOfIcon)];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return img;
}

@end
