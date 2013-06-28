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
#import "CameraOverlayView.h"

@interface MainViewController ()<CameraOverlayViewDelegate>
{
    UIImagePickerController *imageController;
}
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
    UIButton *cameraButton = [[UIButton alloc]initWithFrame:CGRectMake((FRAME_WITH_STATUS_BAR.size.width-250)/2, 30, 250, 50)];
    cameraButton.backgroundColor = [UIColor blueColor];
    [cameraButton setTitle:@"照 相" forState:UIControlStateNormal];
    cameraButton.layer.cornerRadius = 0.5f;
    [cameraButton setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(showCamera:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraButton];
    imageController = [[UIImagePickerController alloc]init];
}

- (void)showCamera:(UIButton *)sender{
    
    imageController.sourceType =
    //    UIImagePickerControllerSourceTypePhotoLibrary; //图片库,默认 先分类，再跳到图片集
    //    UIImagePickerControllerSourceTypeSavedPhotosAlbum;//胶卷 图片流的呈现方式
    UIImagePickerControllerSourceTypeCamera; //摄像头
    
    imageController.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    CameraOverlayView *overlayView = [[CameraOverlayView alloc]initWithFrame:CGRectMake(0, 0, 320, FULL_FRAME.size.height-1)];
    overlayView.delegate = self;
    imageController.cameraOverlayView = overlayView;
//    NSLog(@"MAIN_FRAME_NOT_BOUNDS:%@",NSStringFromCGRect(FULL_FRAME));
    imageController.showsCameraControls = NO;
    imageController.delegate = self;
//    CGAffineTransform cameraTransform = CGAffineTransformMakeScale(1.23, 1.23);
//    imageController.cameraViewTransform = cameraTransform;
    [self presentViewController:imageController animated:YES completion:nil];
}

#pragma CameraOverlayViewDelegate
- (void)cancelUIImagePicker{
    [imageController dismissModalViewControllerAnimated:YES];
}

- (void)useUIImagePicker{
    NSLog(@"useUIImagePicker");
    [imageController takePicture];
}

- (void)openPhotoLibrary{
    imageController.sourceType =
    UIImagePickerControllerSourceTypePhotoLibrary; //图片库,默认 先分类，再跳到图片集
    //    UIImagePickerControllerSourceTypeSavedPhotosAlbum;//胶卷 图片流的呈现方式
//    UIImagePickerControllerSourceTypeCamera; //摄像头
}

#pragma UIImageControllerDelegate
//拍照与选取图片都会走这个方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo && [info objectForKey:UIImagePickerControllerMediaMetadata]!=nil) {//UIImagePickerControllerMediaMetadata不为nil表示拍照
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
        NSData *imageData = UIImageJPEGRepresentation(imageToSave, 0.032);
        imageToSave = [[UIImage alloc]initWithData:imageData];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
