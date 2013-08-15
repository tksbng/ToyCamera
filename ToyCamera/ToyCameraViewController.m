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
