//
//  ViewController.m
//  QRCodeCreat
//
//  Created by 韩亚周 on 15/10/28.
//  Copyright © 2015年 韩亚周. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *creatItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(creatItemClicked:)];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveItemClicked:)];
    UIBarButtonItem *choiceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(choiceItemClicked:)];
    self.navigationItem.rightBarButtonItems = @[creatItem,saveItem,choiceItem];
    
    _codeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _codeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _codeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_codeImageView];
    
    _codeImageView1 = [[UIImageView alloc] initWithFrame:CGRectZero];
    _codeImageView1.translatesAutoresizingMaskIntoConstraints = NO;
    _codeImageView1.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_codeImageView1];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_codeImageView(==320)]"
                                                                      options:1.0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_codeImageView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-184-[_codeImageView(==320)]"
                                                                      options:1.0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_codeImageView)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_codeImageView1(==100)]"
                                                                      options:1.0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_codeImageView1)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[_codeImageView1(==100)]"
                                                                      options:1.0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_codeImageView1)]];
    
}

- (void)creatItemClicked:(UIBarButtonItem *)sender {
    UIImage *qrCodeImage = [YYQRCode customColorImage:[YYQRCode resizeUIImageFormCIImage:[YYQRCode creatQRCodeWithString:@"http://www.cnblogs.com/huangjianwu/p/4574993.html"] withSize:512] withColor:UIColorFromRGB(0x000000)];
    
    _codeImageView.image = [YYQRCode addImageToQRCodeImage:qrCodeImage withImage:[UIImage imageNamed:@"1.png"] withScale:0.2];

}
- (void)saveItemClicked:(UIBarButtonItem *)sender {
    _codeImageView1.image = [self imageWithScreenContents];
    
    UIImageWriteToSavedPhotosAlbum(self.codeImageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"";
    if (!error) {
        message = @"成功保存到相册";
    }else{
        message = [error description];
    }
    NSLog(@"message is %@",message);
}

- (UIImage *)imageWithScreenContents
{
    UIGraphicsBeginImageContext(_codeImageView.frame.size);
    [_codeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)choiceItemClicked:(UIBarButtonItem *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:^{}];
    }

- (void)getURLWithImage:(UIImage *)image
{
    UIImage *loadImage= image;
    CGImageRef imageToDecode = loadImage.CGImage;
    
    ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
    ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    
    NSError *error = nil;
    
    ZXDecodeHints *hints = [ZXDecodeHints hints];
    
    ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
    ZXResult *result = [reader decode:bitmap
                                hints:hints
                                error:&error];
    if (result) {
        NSString *contents = result.text;
        NSLog(@"相册图片contents == %@",contents);
        
    } else {
        NSLog(@"失败");
    }
   
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:YES completion:^{
            [self getURLWithImage:image];
        }
          ];
}

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result{
    NSLog(@"%@",result);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
