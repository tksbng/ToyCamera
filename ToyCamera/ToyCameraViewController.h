//
//  ToyCameraViewController.h
//  ToyCamera
//
//  Created by Takeshi Bingo on 2013/08/15.
//  Copyright (c) 2013年 Takeshi Bingo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToyCameraViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, retain) IBOutlet UIImageView *aImageView;

-(IBAction)doCamera:(id)sender;
-(IBAction)doFilter:(id)sender;
-(IBAction)doSave:(id)sender;

@end
