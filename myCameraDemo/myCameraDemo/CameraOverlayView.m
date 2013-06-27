//
//  CameraOverlayView.m
//  myCameraDemo
//
//  Created by  eleven on 13-6-26.
//  Copyright (c) 2013年 memego. All rights reserved.
//

#import "CameraOverlayView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CameraOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.alpha = 0.5;
//        NSLog(@"frame:%@",NSStringFromCGRect(frame));
        self.backgroundColor = [UIColor clearColor];
        CGSize buttonSize = CGSizeMake(80, 40);
        UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(10, frame.size.height- buttonSize.height-50, buttonSize.width, buttonSize.height)];
        cancelButton.layer.cornerRadius = 10;
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:[self createImageWithColor:[UIColor blackColor]] forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:[self createImageWithColor:[UIColor blueColor]] forState:UIControlStateHighlighted];
        [cancelButton.layer setMasksToBounds:YES];
        [cancelButton addTarget:self action:@selector(cancelUIImagePickerView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
        UIButton *useButton = [[UIButton alloc]initWithFrame:CGRectMake(FULL_FRAME.size.width-buttonSize.width-10, cancelButton.frame.origin.y, buttonSize.width, buttonSize.height)];
        useButton.backgroundColor = [UIColor blackColor];
        useButton.layer.cornerRadius = 10;
        [useButton setTitle:@"确定" forState:UIControlStateNormal];
        [useButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [useButton setBackgroundImage:[self createImageWithColor:[UIColor blackColor]] forState:UIControlStateNormal];
        [useButton setBackgroundImage:[self createImageWithColor:[UIColor blueColor]] forState:UIControlStateHighlighted];
        [useButton.layer setMasksToBounds:YES];
        [useButton addTarget:self action:@selector(useUIImagePickerView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:useButton];
    }
    return self;
}

- (UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)cancelUIImagePickerView:(UIButton *)sender{
    [_delegate cancelUIImagePicker];
}

- (void)useUIImagePickerView:(UIButton *)sender{
    [_delegate useUIImagePicker];
}


//画一个实心圆
-(void)drawEllipse:(CGContextRef)context{
    
    CGContextSaveGState(context);
    
    //Set color of current context
    [[UIColor whiteColor] set];
    
    //Set shadow and color of shadow
    CGContextSetShadowWithColor(context, CGSizeZero, 10.0f, [[UIColor blackColor] CGColor]);
    
    //Draw ellipse
    CGRect ellipseRect = CGRectMake(60.0f, 150.0f, 200.0f, 200.0f);
    CGContextFillEllipseInRect(context, ellipseRect);
    
    CGContextRestoreGState(context);
    
}

//画一个空心圆
-(void)drawCircle:(CGContextRef)context{
    
//    CGContextSaveGState(context);
    
    //    //Set color of current context
    //    [[UIColor whiteColor] set];
    //
    //    //Set shadow and color of shadow
    //    CGContextSetShadowWithColor(context, CGSizeZero, 10.0f, [[UIColor blackColor] CGColor]);
    //
    //    //Draw ellipse
    //    CGRect ellipseRect = CGRectMake(60.0f, 150.0f, 200.0f, 200.0f);
    //    CGContextFillEllipseInRect(context, ellipseRect);
    
    /** Draw the Background **/
    
    //Create the path
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2, 100, 0, M_PI *2, 0);
    
    //Set the stroke color to black
//    [[UIColor blackColor]setStroke];
    [[UIColor colorWithRed:0 green:0 blue:0 alpha:100/255.0] setStroke];
    
    //Define line width and cap
    CGContextSetLineWidth(context, 2);
    CGContextSetLineCap(context, kCGLineCapButt);
    
    //draw it!
    CGContextDrawPath(context, kCGPathStroke);
    
//    CGContextRestoreGState(context);
    
}

//渐变层
-(void)drawGradient:(CGContextRef)context{
    //Define start and end colors
    CGFloat colors [8] = {
        0.0, 0.0, 1.0, 1.0, //Blue
        0.0, 1.0, 0.0, 1.0 }; //Green
    
    //Setup a color space and gradient space
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
    
    //Define the gradient direction
    CGPoint startPoint = CGPointMake(160.0f,0.0f);
    CGPoint endPoint = CGPointMake(160.0f, 400.0f);
    
    //Create and Draw the gradient
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    CGColorSpaceRelease(baseSpace);
    CGGradientRelease(gradient);
}

//创建一个中间透明的实心圆，由于中间透明，则会看到底下的层
-(void)drawEllipseWithGradient:(CGContextRef)context{
    
    CGContextSaveGState(context);
    
    //UIGraphicsBeginImageContextWith(self.frame.size);
    UIGraphicsBeginImageContextWithOptions((self.frame.size), NO, 0.0);
    
    CGContextRef newContext = UIGraphicsGetCurrentContext();

    // Translate and scale image to compnesate for Quartz's inverted coordinate system
    CGContextTranslateCTM(newContext,0.0,self.frame.size.height);
    CGContextScaleCTM(newContext, 1.0, -1.0);
    
    
    
    //Set color of current context
    [[UIColor blackColor] set];
    
    //Draw ellipse &lt;- I know we’re drawing a circle, but a circle is just a special ellipse.
    CGRect ellipseRect = CGRectMake(110.0f, 200.0f, 100.0f, 100.0f);
    CGContextFillEllipseInRect(newContext, ellipseRect);
    
    CGImageRef mask = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
    UIGraphicsEndImageContext();
    
    
    CGContextClipToMask(context, self.bounds, mask);
    
    
//    [self drawGradient:context];
    CGImageRelease(mask);
    CGContextRestoreGState(context);
    
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
//    [super drawRect:rect];
    //创建上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //call function to draw Ellipse
//    [self drawEllipse:context];
    
    
    [self drawCircle:context];
    
//    //drawGradient
//    [self drawGradient:context];
//    
//    [self drawEllipseWithGradient:context];
}


@end
