//
//  MainViewController.m
//  myCameraDemo
//
//  Created by  eleven on 13-6-26.
//  Copyright (c) 2013年 memego. All rights reserved.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIButton *cameraButton = [[UIButton alloc]initWithFrame:CGRectMake((MAIN_FRAME.size.width-250)/2, 30, 250, 50)];
    cameraButton.backgroundColor = [UIColor blueColor];
    [cameraButton setTitle:@"照 相" forState:UIControlStateNormal];
    cameraButton.layer.cornerRadius = 0.5f;
    [cameraButton setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(showCamera:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraButton];
}

- (void)showCamera:(UIButton *)sender{
    UIImagePickerController *imageController = [[UIImagePickerController alloc]init];
    imageController.sourceType =
    //    UIImagePickerControllerSourceTypePhotoLibrary; //图片库,默认 先分类，再跳到图片集
    //    UIImagePickerControllerSourceTypeSavedPhotosAlbum;//胶卷 图片流的呈现方式
    UIImagePickerControllerSourceTypeCamera; //摄像头
    
    imageController.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    imageController.delegate = self;
    [self presentViewController:imageController animated:YES completion:nil];
}

#pragma UIImageControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
        
        // Save the new image (original or edited) to the Camera Roll
        UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
    }
    
    // Handle a movie capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo) {
        
        NSString *moviePath = [[info objectForKey:
                                UIImagePickerControllerMediaURL] path];
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum (
                                                 moviePath, nil, nil, nil);
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
//    [[picker parentViewController] dismissModalViewControllerAnimated: YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
