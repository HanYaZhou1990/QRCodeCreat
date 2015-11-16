//
//  UIImage+RoundRect.h
//  QRCodeCreat
//
//  Created by 韩亚周 on 15/10/28.
//  Copyright © 2015年 韩亚周. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RoundRect)

+ (UIImage *)clipCornerWithImage:(UIImage *)image withSize:(CGSize)size withRadius:(NSInteger)radius;

@end
