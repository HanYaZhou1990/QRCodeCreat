//
//  ViewController.h
//  QRCodeCreat
//
//  Created by 韩亚周 on 15/10/28.
//  Copyright © 2015年 韩亚周. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+RoundRect.h"
#import "YYQRCode.h"
#import <ZXingObjC/ZXingObjC.h>

@interface ViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImageView     *codeImageView;
@property (nonatomic, strong) UIImageView     *codeImageView1;
@property (nonatomic, strong) ZXCapture       *capture;

@end

