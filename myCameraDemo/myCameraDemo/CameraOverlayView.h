//
//  CameraOverlayView.h
//  myCameraDemo
//
//  Created by  eleven on 13-6-26.
//  Copyright (c) 2013年 memego. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CameraOverlayViewDelegate <NSObject>
@optional
- (void)cancelUIImagePicker;
- (void)useUIImagePicker;

@end


@interface CameraOverlayView : UIView
@property(nonatomic, weak) id<CameraOverlayViewDelegate> delegate;
@end
