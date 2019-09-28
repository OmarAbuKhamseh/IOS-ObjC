//
//  FaceMatchController.m


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
    
    /*
     SDK method call to engineWrapper init
     @Return: init status bool value
     */
    bool bInit = [EngineWrapper IsEngineInit];
    if (!bInit)
        [EngineWrapper FaceEngineInit]; //Declaration EngineWrapper
    [self.imgSource setHidden:false];
    [self.imgTarget setHidden:false];
    [self.lblUpload setHidden:false];
    [self.imgUpload setHidden:false];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    /*
     SDK method call to get engineWrapper load status
     @Return: init status Int value
     */
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
    /*
     SDK method call to engine deinit
     */
    [EngineWrapper FaceEngineClose];
    
}

//MARK:- Image Rotation
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

/**
 * This method use get captured view
 * Parameters to Pass: UIView
 *
 * This method will return array of UIImageview
 */
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

//MARK:- ImagePicker delegate
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

/**
 * This method use image convert particular size
 * Parameters to Pass: UIImage and covert size
 *
 * This method will return convert UIImage
 */
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


/**
 * This method use calculate faceMatch score
 * Parameters to Pass: selected uiimage
 *
 */
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
    /*
     FaceMatch SDK method call to Identify face in Document scanning image
     @Params: BackImage, Front Face Image
     @Return: Face data
     */
    faceRegion = [EngineWrapper DetectSourceFaces:image];
    else {
        NSFaceRegion* face1 = [[self srcFView] getFaceRegion]; //Find UIImage in face
        if (face1 == nil) {
            /*
             FaceMatch SDK method call to Identify face in Document scanning image
             @Params: BackImage, Front Face Image
             @Return: Face data
             */
            faceRegion = [EngineWrapper DetectSourceFaces:image];
        } else {
            /*
             FaceMatch SDK method call to detect Face in back image
             @Params: BackImage, Front Face Image faceRegion
             @Return: Face Image Frame
             */
            faceRegion = [EngineWrapper DetectTargetFaces:image feature1:face1.feature];
        }
    }

    if (selIndex == 1) {
        if (faceRegion != nil){
            [self.imgSource setHidden:true];
            /*
             SDK method call to draw square face around
             @Params: BackImage, Front Image faceRegion Data
             */
            [[self srcFView] setFaceRegion:faceRegion];
            /*
             SDK method call to draw square face around
             @Params: BackImage, Front faceRegion Image
             */
            [[self srcFView] setImage:faceRegion.image];
            [[self srcFView] setNeedsDisplay];

        }

        NSFaceRegion* face2 = [[self tgtFView] getFaceRegion]; // Get image data
        if (face2 != nil) {
            NSFaceRegion* face1 = [[self srcFView] getFaceRegion]; // Get image data
            NSFaceRegion* faceRegion2;
            if (face1 == nil) {
                /*
                 FaceMatch SDK method call to Identify face in Document scanning image
                 @Params: BackImage, Front Face Image
                 @Return: Face data
                 */
                faceRegion2 = [EngineWrapper DetectSourceFaces:face2.image];
            } else {
                /*
                 FaceMatch SDK method call to detect Face in back image
                 @Params: BackImage, Front Face Image faceRegion
                 @Return: Face Image Frame
                 */
                faceRegion2 = [EngineWrapper DetectTargetFaces:face2.image feature1:face1.feature];
            }
            if (faceRegion2 != nil){
                /*
                 SDK method call to draw square face around
                 @Params: BackImage, Front Image faceRegion Data
                 */
                [[self tgtFView] setFaceRegion:faceRegion2];
                /*
                 SDK method call to draw square face around
                 @Params: BackImage, Front faceRegion Image
                 */
                [[self tgtFView] setImage:faceRegion2.image];
                [[self tgtFView] setNeedsDisplay];
            }
        }
    } else {
        if (faceRegion != nil){
            [self.imgTarget setHidden:true];
            [self.lblUpload setHidden:true];
            [self.imgUpload setHidden:true];
            /*
             SDK method call to draw square face around
             @Params: BackImage, Front Image faceRegion Data
             */
            [[self tgtFView] setFaceRegion:faceRegion];
            /*
             SDK method call to draw square face around
             @Params: BackImage, Front faceRegion Image
             */
            [[self tgtFView] setImage:faceRegion.image];
            [[self tgtFView] setNeedsDisplay];
        }

    }
    NSFaceRegion* face1 = [[self srcFView] getFaceRegion]; // Get image data
    NSFaceRegion* face2 = [[self tgtFView] getFaceRegion]; // Get image data

     [SVProgressHUD dismiss];
    if (imageFirst == nil || imageSecond == nil) {
        [[self lblScore] setText:@"Match Score : 0 %"];
        return;
    }
    
    /*
     SDK method call to get FaceMatch Score
     @Params: FrontImage Face, BackImage Face
     @Return: Match Score
     */
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

//MARK:- UIButton Action
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
