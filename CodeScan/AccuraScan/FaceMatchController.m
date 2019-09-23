//
//  FaceMatchController.m
//  Accura Scan
//
//  Created by iOS on 28/7/2019.
//  Copyright © 2019 Elite Development LLC. All rights reserved.
//

#import "FaceMatchController.h"
#import "FirstViewController.h"
#import "DetectResult.h"
#import "EngineWrapper.h"
#import "ImageHelper.h"
#import "NSFaceRegion.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "SVProgressHUD.h"
#import "WebAPIRequest.h"
#import "CustomAFNetWorking.h"
#import "AFNetworking.h"
#import "Accura_Scan-Swift.h"
#import "GlobalMethods/GlobalMethods.h"

#define APPNAME @"ACCURA FACE MATCH"

@interface FaceMatchController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation FaceMatchController
UIImage *imageFirst;
UIImage *imageSecond;
UIImagePickerController* picker;

- (void)viewDidLoad {
    [super viewDidLoad];
    picker = [[UIImagePickerController alloc] init];

    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPhotoCaptured) name:@"_UIImagePickerControllerUserDidCaptureItem" object:nil];

    selIndex = 0;
    [[self lblScore] setText:@"Match Score : 0 %"];
    
    //Check enginewrapper engine is init
    bool bInit = [EngineWrapper IsEngineInit];
    if (!bInit)
        [EngineWrapper FaceEngineInit];
    [self.imgSource setHidden:false];
    [self.imgTarget setHidden:false];
    [self.lblUpload setHidden:false];
    [self.imgUpload setHidden:false];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    int nRet = [EngineWrapper GetEngineInitValue];
    if (nRet == -20)
        [self showAlertView:@"key not found" withViewController:self];
    else if (nRet == -15)
        [self showAlertView:@"License Invalid" withViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [EngineWrapper FaceEngineClose]; // enginewrapper engine deinit
    
}


- (void)loadPhotoCaptured
{
    UIImage *img = [[[self allImageViewsSubViews:[[[picker viewControllers]firstObject] view]] lastObject] image];
    if (img)
    {
        [self imagePickerController:picker didFinishPickingMediaWithInfo:[NSDictionary dictionaryWithObject:img forKey:UIImagePickerControllerOriginalImage]];
    }
    else
    {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (NSMutableArray*)allImageViewsSubViews:(UIView *)view
{
    NSMutableArray *arrImageViews=[NSMutableArray array];
    if ([view isKindOfClass:[UIImageView class]])
    {
        [arrImageViews addObject:view];
    }
    else
    {
        for (UIView *subview in [view subviews])
        {
            [arrImageViews addObjectsFromArray:[self allImageViewsSubViews:subview]];
        }
    }
    return arrImageViews;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
        [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage* image ;
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        UIImage* picture = [info objectForKey:UIImagePickerControllerOriginalImage];
        image = picture;
        // **You can now do something with the picture.
 
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera && picker.cameraDevice == UIImagePickerControllerCameraDeviceFront){
        UIImage * flippedImage = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationLeftMirrored];
        image = flippedImage; //capture image filp leftmirrored
    }
    
    CGSize scaledSize = CGSizeMake(image.size.width * 600/image.size.height, 600); //Convert Image particular
    image = [GlobalMethods imageWithImage:image scaledToSize:scaledSize];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
     [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"%@..",NSLocalizedString(@"Loading", @"")] maskType:SVProgressHUDMaskTypeBlack];
    double delayInSeconds = 0.01;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self match:image];
    });
   
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
}

- (IBAction)menuAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backToViewController
{
    imageFirst=nil;
    imageSecond=nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) match:(UIImage*)image {
    
    if (selIndex == 1){
        [self.lblTopUpload setHidden:true];
        [self.imgTopUpload setHidden:true];
        imageFirst = image;
        [self.imgSource setImage:image];
        
    }
    else{
        [self.lblUpload setHidden:true];
        [self.imgUpload setHidden:true];
        imageSecond =  image;
        [self.imgTarget setImage:image];
    }
    
    if(imageSecond==nil || imageFirst==nil){
       [SVProgressHUD dismiss];
    }
    
    NSFaceRegion* faceRegion;
    if (selIndex == 1)
    //EngineWrapper in pass UIImage
    //retun face Image
    faceRegion = [EngineWrapper DetectSourceFaces:image];
    else {
        NSFaceRegion* face1 = [[self srcFView] getFaceRegion]; //Find UIImage in face
        if (face1 == nil) { //Check face is exist or not
            faceRegion = [EngineWrapper DetectSourceFaces:image];
        } else {
            // EngineWrapper DetectTargetFaces method in pass two images
            //method return value is face match score
            faceRegion = [EngineWrapper DetectTargetFaces:image feature1:face1.feature];
        }
    }

    if (selIndex == 1) {
        if (faceRegion != nil){
            [self.imgSource setHidden:true];
            [[self srcFView] setFaceRegion:faceRegion];
            [[self srcFView] setImage:faceRegion.image];
            [[self srcFView] setNeedsDisplay];

        }

        NSFaceRegion* face2 = [[self tgtFView] getFaceRegion];
        if (face2 != nil) {
            NSFaceRegion* face1 = [[self srcFView] getFaceRegion];
            NSFaceRegion* faceRegion2;
            if (face1 == nil) {
                faceRegion2 = [EngineWrapper DetectSourceFaces:face2.image]; //Find UIImage in face
            } else {
                // EngineWrapper DetectTargetFaces method in pass two images
                //method return value is face faceRegion
                faceRegion2 = [EngineWrapper DetectTargetFaces:face2.image feature1:face1.feature];
            }
            if (faceRegion2 != nil){
                [[self tgtFView] setFaceRegion:faceRegion2];
                [[self tgtFView] setImage:faceRegion2.image];
                [[self tgtFView] setNeedsDisplay];
            }
        }
    } else {
        if (faceRegion != nil){
            [self.imgTarget setHidden:true];
            [self.lblUpload setHidden:true];
            [self.imgUpload setHidden:true];
            [[self tgtFView] setFaceRegion:faceRegion];
            [[self tgtFView] setImage:faceRegion.image];
            [[self tgtFView] setNeedsDisplay];
        }

    }
    NSFaceRegion* face1 = [[self srcFView] getFaceRegion];
    NSFaceRegion* face2 = [[self tgtFView] getFaceRegion];

     [SVProgressHUD dismiss];
    if (imageFirst == nil || imageSecond == nil) {
        [[self lblScore] setText:@"Match Score : 0 %"];
        return;
    }
    
    // EngineWrapper DetectTargetFaces method in pass two FaceRegion
    //method return value is face match score
    double score = [EngineWrapper Identify:face1.feature featurebuff2:face2.feature];
    double finalScore = score * 100;
    NSString* strScore = [NSString stringWithFormat:@"Match Score : %0.2f %%", finalScore];
    [[self lblScore] setText:strScore];
    
}

-(void)showAlertView:(NSString *)text withViewController:(UIViewController *)view
{
    if (([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending))
    {
        // use UIAlertView
        
        UIAlertController *alertobj = [UIAlertController alertControllerWithTitle:APPNAME message:text preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * ok = [UIAlertAction
                              actionWithTitle:@"OK"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              { }];
        
        [alertobj addAction:ok];
        [view presentViewController:alertobj animated:YES completion:nil];
    }
    else
    {
        // use UIAlertController
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:APPNAME
                                      message:text
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [view presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)galleryAction1:(id)sender {
    selIndex = 1;
    picker.delegate = self;
    picker.editing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)cameraAction1:(id)sender {
    selIndex = 1;
    picker.delegate = self;
    picker.editing = NO;
    picker.sourceType =  UIImagePickerControllerSourceTypeCamera;

    [self presentViewController:picker animated:YES completion:nil];
    
}

- (IBAction)galleryAction2:(id)sender {
    selIndex = 2;
    picker.delegate = self;
    picker.editing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];
}
- (IBAction)cameraAction2:(id)sender {
    selIndex = 2;
    picker.delegate = self;
    picker.editing = NO;
    picker.sourceType =  UIImagePickerControllerSourceTypeCamera;

    [self presentViewController:picker animated:YES completion:nil];
}


@end
