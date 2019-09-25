//
//  ImageViewController.m
//  AccuraSDK
//
//  Created by SSD on 13/07/18.
//  Copyright © 2018 Alexander Shishkov & Kirill Kornyakov. All rights reserved.
//

#import "ImageViewController.h"
#import "GlobalMethods.h"
#import "WebServiceUrl.h"
#import "WebAPIRequest.h"
#import "SVProgressHUD.h"
#import "ShowResultVC.h"
#import "Accura_Scan-Swift.h"
#import "CustomAFNetWorking.h"

@interface ImageViewController ()<AVCapturePhotoCaptureDelegate>
{
   AVCaptureSession *session;
   AVCapturePhotoOutput *stillImageOutput;
   AVCaptureVideoPreviewLayer *videoPreviewLayer;
    UIImage *originalImage;
}
@end

@implementation ImageViewController
UIImage* doc_Image = nil;
UIImage* imgwithCroped;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self ChangedOrintation];
     [[NSNotificationCenter defaultCenter]addObserver:self selector: @selector(buttonClicked:) name:UIDeviceOrientationDidChangeNotification object:nil];
     _isDismiss = true;
}

/*
 This method use image rotated particular degrees
 Parameters to Pass: UIImage and croping degrees
 
 This method will return crop UIImage
 and then explain the use of return value
 
 */
- (UIImage *)imageRotatedByDegrees:(UIImage*)oldImage deg:(CGFloat)degrees{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,oldImage.size.width, oldImage.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degrees);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, (degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-oldImage.size.width / 2, -oldImage.size.height / 2, oldImage.size.width, oldImage.size.height), [oldImage CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void) buttonClicked:(UIButton*)sender {
    [self ChangedOrintation]; //scanning frame orintation set
}

/*
 This method use scanning frame
 Device orientation acoding set scanning view frame
 */
-(void)ChangedOrintation {
    if ( ([[UIDevice currentDevice] orientation] ==  UIDeviceOrientationLandscapeLeft)  )
    {
        //do something or rather]
        _imageViewLogo.hidden = YES;
        [self
         shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
        NSLog(@"landscape left");
        
        CGFloat hite = [UIScreen mainScreen].bounds.size.width;
        hite = hite * 0.75;
        
        CGFloat with = [UIScreen mainScreen].bounds.size.height;
        with = with * 0.65;
        __constant_width.constant = hite;
        __constant_heigtt.constant = with;
    }
    if ( ([[UIDevice currentDevice] orientation] ==  UIDeviceOrientationLandscapeRight)  )
    {        //do something or rather
        _imageViewLogo.hidden = YES;
        [self
         shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
        NSLog(@"landscape right");
        
        CGFloat hite = [UIScreen mainScreen].bounds.size.width;
        hite = hite * 0.75;
        
        CGFloat with = [UIScreen mainScreen].bounds.size.height;
        with = with * 0.65;
        __constant_width.constant = hite;
        __constant_heigtt.constant = with;
      
    }
    if ( ([[UIDevice currentDevice] orientation] ==  UIDeviceOrientationPortrait)  )
    {
        _imageViewLogo.hidden = NO;
        //do something or rather
        [self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortrait];
        NSLog(@"portrait");
        
        CGFloat with = [UIScreen mainScreen].bounds.size.width;
        CGFloat hite = [UIScreen mainScreen].bounds.size.height;
        with = with * 0.95;
        hite = hite * 0.35;
        
        __constant_heigtt.constant = hite;
        __constant_width.constant = with;
    }
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
        //code with animation
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        //code for completion
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Setup your camera here...
    session = [AVCaptureSession new];
    session.sessionPreset = AVCaptureSessionPresetPhoto;
    AVCaptureDevice *backCamera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!backCamera) {
        NSLog(@"Unable to access back camera!");
        return;
    }
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera
                                                                        error:&error];
    if (!error) {
        //Step 9
       stillImageOutput = [AVCapturePhotoOutput new];
        if ([session canAddInput:input] && [session canAddOutput:stillImageOutput]) {
            
            [session addInput:input];
            [session addOutput:stillImageOutput];
            [self setupLivePreview];
        }
    }
    else {
        NSLog(@"Error Unable to initialize back camera: %@", error.localizedDescription);
    }
    
    CGFloat with = [UIScreen mainScreen].bounds.size.width;
    CGFloat hite = [UIScreen mainScreen].bounds.size.height;
    with = with * 0.95;
    hite = hite * 0.35;
    __constant_heigtt.constant = hite;
    __constant_width.constant = with;
    _FrameView.layer.borderColor = [UIColor redColor].CGColor;
    _FrameView.layer.borderWidth = 3.0f;
    _img.frame = _FrameView.frame;
    
}

- (void)setupLivePreview {
    //Setup camera view
   videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    if (videoPreviewLayer) {//Chcek camera session is start
        
        videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect; //VideoView set contentMode
        videoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait; //VideoView set video Orientation
        [self.previewView.layer addSublayer:videoPreviewLayer];
        
        //Step12
        dispatch_queue_t globalQueue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(globalQueue, ^{
            [self->session startRunning]; // Start camera session
            //Step 13
            dispatch_async(dispatch_get_main_queue(), ^{
                self->videoPreviewLayer.frame = self.previewView.bounds; // set videoView frame
                
            });
        });
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.btnUse.hidden = true;
    self.btn_get_info.hidden = false;
    self.FrameView.hidden = false;
    self.img.hidden = YES;
    if (_isDismiss)
    {
        CGFloat with = [UIScreen mainScreen].bounds.size.width;
        CGFloat hite = [UIScreen mainScreen].bounds.size.height;
        with = with * 0.95;
        hite = hite * 0.35;
        __constant_heigtt.constant = hite;
        __constant_width.constant = with;
        _FrameView.layer.borderColor = [UIColor redColor].CGColor;
        _FrameView.layer.borderWidth = 3.0f;
        
    }
     _img.frame = _FrameView.frame;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];\
}

- (IBAction)getInfoAction:(id)sender
{
    if (@available(iOS 11.0, *)) {
        AVCapturePhotoSettings *settings = [AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey: AVVideoCodecTypeJPEG}]; //Capture Image formate set
        [stillImageOutput capturePhotoWithSettings:settings delegate:self]; //Capture image
    } else {
        // Fallback on earlier versions
    }
}

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(nullable NSError *)error  API_AVAILABLE(ios(11.0)){
    
    NSData *imageData = photo.fileDataRepresentation;
    if (imageData) { //Check imageData is exist
        UIImage *image = [UIImage imageWithData:imageData];
        doc_Image = image;
        image = [self fixedOrientation:image]; //Set image orientation
        self.img.image = image;
        self.img.hidden = NO;
        originalImage = [self croppIngimageByImageName:self->_img toRect:self->_FrameView.frame]; //call cropimage method
        [session stopRunning];
        self.img.image = nil;
        //Check device orientation
        //Capture image rotation
        if (([[UIDevice currentDevice] orientation] ==  UIDeviceOrientationLandscapeLeft))
        {
            originalImage = [self imageRotatedByDegrees:originalImage deg:M_PI * 1.5];
            self->_img.image = originalImage;
        }
        else if (([[UIDevice currentDevice] orientation] ==  UIDeviceOrientationLandscapeRight))
        {
            originalImage = [self imageRotatedByDegrees:originalImage deg:M_PI * 90 / 180.0];
            self->_img.image = originalImage;
        }
        else
        {
            self->_img.image = originalImage;
        }
        
        [videoPreviewLayer removeFromSuperlayer];
        [self.view bringSubviewToFront:_img];
        _btn_get_info.hidden = true;
        _btnUse.hidden = false;
        self.FrameView.hidden = true;
        
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [session stopRunning];
}

- (IBAction)cancelAction:(id)sender
{
        [self.navigationController popViewControllerAnimated:YES];
}

/*
 This method use image crop particular size
 Parameters to Pass: UIImage and croping size
 
 This method will return crop UIImage
 and then explain the use of return value
 
 */
- (UIImage *)croppIngimageByImageName:(UIImageView *)imageToCrop toRect:(CGRect)rect
{
    UIImage *image  = imageToCrop.image;
    CGRect deviceScreen = _previewView.bounds;
    CGFloat width = deviceScreen.size.width;
    CGFloat height = deviceScreen.size.height;
    
    NSLog(@"WIDTH %f", width);
    NSLog(@"HEIGHT %f", height);
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [image drawInRect: CGRectMake(0,0, width, height)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    rect.origin.y = rect.origin.y - 50;
    rect.size.height = rect.size.height + 100;
    CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return cropped;
}

/*
 This method use image Orientation particular angle
 Parameters to Pass: UIImage
 
 This method will return  UIImage
 and then explain the use of return value
 
 */
-(UIImage *) fixedOrientation:(UIImage *) image {
    
    if (image.imageOrientation == UIImageOrientationUp) {
        return image;
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation)
    {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        default: break;
    }
    
    switch (image.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            CGAffineTransformTranslate(transform, image.size.width, 0);
            CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            CGAffineTransformTranslate(transform, image.size.height, 0);
            CGAffineTransformScale(transform, -1, 1);
            break;
            
        default: break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(nil, image.size.width, image.size.height, CGImageGetBitsPerComponent(image.CGImage), 0, CGImageGetColorSpace(image.CGImage), kCGImageAlphaPremultipliedLast);
    
    CGContextConcatCTM(ctx, transform);
    
    switch (image.imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0, 0, image.size.height, image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
            break;
    }
    
    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    
    return [UIImage imageWithCGImage:cgImage];
}
- (IBAction)usePhotoAction:(id)sender
{
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"%@..",NSLocalizedString(@"Loading", @"")] maskType:SVProgressHUDMaskTypeBlack];
    
    if (originalImage == nil)
        
    {
        [GlobalMethods showAlertView:@"No Image" withViewController:self];
    }
    else
    {
        CGFloat with = [UIScreen mainScreen].bounds.size.width;
        CGFloat hite = [UIScreen mainScreen].bounds.size.height;
        with = with * 0.95;
        hite = hite * 0.35;
        imgwithCroped = [self imageWithResizeImage:originalImage convertToSize:(CGSizeMake(with, hite))]; //Crop image
        [WebAPIRequest sendImage:self img:imgwithCroped isFrom:self->_isFrom]; //Call API
    }
}

/*
 This method use image crop particular size
 Parameters to Pass: UIImage and croping size
 
 This method will return crop UIImage
 and then explain the use of return value
 
 */
- (UIImage *)imageByCroppingImage:(UIImage* )image toSize:(CGSize)size
{
    // not equivalent to image.size (which depends on the imageOrientation)!
    
    double width = (size.width * 2);
    double hidth = (size.height * 2);
    double fullWidth = image.size.width;
    double getX = fullWidth - width;
    
    double fullHeigtht = image.size.height;
    double getY = fullHeigtht / 2;
    getY = hidth / 4;
    
    double with = fullWidth * 0.95;
    double hite = fullHeigtht * 0.35;
    
    width = with ;
    hidth = hite;
    getX = fullWidth - with;
    getY = (fullHeigtht / 2);
    getY = getY - (hite / 2);
    
    CGRect cropRect = CGRectMake((getX/2), getY - 40 , width, hidth);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage],  cropRect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return cropped;
}

/*
 This method use image resize particular size
 Parameters to Pass: UIImage and resize size
 
 This method will return resize UIImage
 and then explain the use of return value
 
 */
- (UIImage *)imageWithResizeImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}
@end
