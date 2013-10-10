//
//  ToyCameraViewController.m
//  ToyCamera
//
//  Created by Takeshi Bingo on 2013/08/15.
//  Copyright (c) 2013年 Takeshi Bingo. All rights reserved.
//

#import "ToyCameraViewController.h"

@interface ToyCameraViewController ()

@end

@implementation ToyCameraViewController

//「フィルタ」ボタンをクリックされたときに呼ばれるメソッド
-(IBAction)doFilter:(id)sender {
    NSLog(@"フィルタ");
    //アクションシートを表示
    UIActionSheet *aSheet = [[UIActionSheet alloc]
                             initWithTitle:@"フィルター選択" delegate:self cancelButtonTitle:@"キャンセル" destructiveButtonTitle:nil otherButtonTitles:@"セピア", @"ボタン２",@"ボタン３",nil];
    [aSheet setActionSheetStyle:UIActionSheetStyleDefault];
    [aSheet showInView:[self view]];

}
//「カメラ」ボタンをクリックされたときに呼ばれるメソッド
-(IBAction)doCamera:(id)sender{
    NSLog(@"カメラ");
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        return;
    }
    //カメラを起動する
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    [ipc setSourceType:sourceType];
    [ipc setDelegate:self];
    [ipc setAllowsEditing:YES];
    [self presentViewController:ipc animated:YES completion:nil];
}
//「保存」ボタンをクリックされたときに呼ばれるメソッド
-(IBAction)doSave:(id)sender{
    NSLog(@"保存");
    UIImage *aImage = [_aImageView image];
    if (aImage == nil) {
        return;
    }
    UIImageWriteToSavedPhotosAlbum(aImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
//撮影画面表示時に呼ばれるUINavigationControllerDelegateメソッド
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSLog(@"撮影画面表示直前");
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSLog(@"撮影画面表示直後");
}
//撮影完了時に呼ばれるUIImagePickerControllerDelegateメソッド
- (void)imagePickerController: (UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"撮影");
    UIImage *aImage = [info
                       objectForKey:UIImagePickerControllerEditedImage];
    [_aImageView setImage:aImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}//撮影キャンセル時に呼ばれるUIImagePickerControllerDelegateメソッド
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"キャンセル");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//アクションシートのボタンをクリックされたときに呼ばれるメソッド
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //ボタン１
    if (buttonIndex == 0) {
        NSLog(@"セピア");
        [self toSepia];
    //ボタン２
    } else if (buttonIndex == 1) {
        NSLog(@"ボタン２");
    //ボタン3
    } else if (buttonIndex == 2) {
        NSLog(@"ボタン３");
    //キャンセルを含めてそれ以外
    } else {
        NSLog(@"キャンセルを含めてそれ以外");
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"保存終了");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存終了" message:@"写真アルバムに画像を保存しました。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

//画像をCGContext型のオブジェクトを生成
CGContextRef CreateARGBBitmapContextBySize(size_t pixelsWide,size_t pixelsHigh){
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData;
    int bitmapByteCount;
    int bitmapBytesPerRow;
    bitmapBytesPerRow = (pixelsWide * 4);
    bitmapByteCount = (bitmapBytesPerRow * pixelsHigh);
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL) {
        NSLog(@"Error allocating color space");
        return NULL;
    }
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL) {
        NSLog(@"Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    context = CGBitmapContextCreate(
                                    bitmapData,
                                    pixelsWide,
                                    pixelsHigh,
                                    8,
                                    bitmapBytesPerRow,
                                    colorSpace,
                                    kCGImageAlphaPremultipliedFirst
                                    );
    if (context == NULL) {
        free (bitmapData);
        NSLog(@"Context not created!");
    }
    CGColorSpaceRelease( colorSpace );
    return context;
}

//ARGB値のアンダーフロー・オーバーフロー抑制の関数
unsigned char roundCGFloatToUChar( CGFloat p ) {
    if ( p < 0 ) return 0;
    if ( p > 255 ) return 255;
    return p;
}

//セピア色にフィルターを掛けるメソッド
-(void)filterSepia:(CGContextRef)cgctx  {
    CGFloat width = CGBitmapContextGetWidth(cgctx);
    CGFloat height = CGBitmapContextGetHeight(cgctx);
    unsigned char* data = CGBitmapContextGetData(cgctx);
    CGFloat Gray;
    unsigned char A,R,G,B;
    CGFloat Alpha,Red,Green,Blue;
    long startByte;
    int x,y;
    for (y=0; y<height; y++) {
        for (x = 0; x<width; x++) {
            // ARGB値の取り出し
            startByte = (y*width+x)*4;
            A = data[startByte+0];
            R = data[startByte+1];
            G = data[startByte+2];
            B = data[startByte+3];
            
            // NTSC系加重平均法
            Gray  = 0.298912 * R + 0.586611 * G + 0.114478 * B;
            // セピア化
            Alpha = A;
            Red   = Gray + 20.01;
            Green = Gray -  2.46;
            Blue  = Gray - 41.28;
            
            // アンダーフロー/オーバーフローの抑制
            A = roundCGFloatToUChar(Alpha);
            R = roundCGFloatToUChar(Red);
            G = roundCGFloatToUChar(Green);
            B = roundCGFloatToUChar(Blue);
            
            // ARGB値の書き戻し
            data[startByte+0] = A;
            data[startByte+1] = R;
            data[startByte+2] = G;
            data[startByte+3] = B;
        }
    }
}

-(void)toSepia {
    UIImage *orgImage = [_aImageView image];
    if ( orgImage == nil ) {
        return;
    }
    //画像サイズを取得しCGContext型オブジェクトを生成
    CGFloat width = [orgImage size].width;
    CGFloat height = [orgImage size].height;
    CGContextRef cgctxPhoto = CreateARGBBitmapContextBySize(width, height);
    CGContextDrawImage(cgctxPhoto, CGRectMake(0.0f, 0.0f,width,height),[orgImage CGImage]);
    //セピアフィルタの呼び出し
    [self filterSepia:cgctxPhoto];
    //画面にUIImageをセット
    CGImageRef cgimagerefPhoto = CGBitmapContextCreateImage( cgctxPhoto );
    UIImage *imagePhoto = [[UIImage alloc] initWithCGImage:cgimagerefPhoto];
    [_aImageView setImage:imagePhoto];
    //CGContext型オブジェクトを解放
    CGImageRelease( cgimagerefPhoto );
    free(CGBitmapContextGetData( cgctxPhoto ));
    CGContextRelease( cgctxPhoto );
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
