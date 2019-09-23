//
//  ListViewController.m
//  AccuraSDK
//
//  Created by SSD on 13/07/18.
//  Copyright © 2018 Alexander Shishkov & Kirill Kornyakov. All rights reserved.
//

#import "ListViewController.h"
#import "ListTableViewCell.h"
#import "PlaceHolderViewController.h"
#import "Accura_Scan-Swift.h"
#import "PlacePanCardViewController.h"
#import "PlaceAdharViewController.h"
#import "GlobalMethods.h"
#import "FirstViewController.h"

@interface ListViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
     UIImagePickerController *imagePicker;
}
@end

@implementation ListViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // add notificaiton
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _titleLbl.text = _navTitle;
}

- (IBAction)backBtnPressed:(id)sender
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        //Do not forget to import AnOldViewController.h
        if ([controller isKindOfClass:[FirstViewController class]]) {
            [self.navigationController popToViewController:controller
                                                  animated:YES];
            break;
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark ----- tableview delegate and datasource method -----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListTableViewCell"];
    if (cell == nil)
    {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ListTableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    switch (indexPath.row)
    {
            // check the card
        case 0:
        {
            cell.lbl_list_title.text = @"Passport & ID MRZ";
            [cell.vw setBackgroundColor:[UIColor colorWithRed:213.0 / 255.0 green:50.0 / 255.0 blue:63.0 / 255.0 alpha:1.0]];
            cell.vw.layer.cornerRadius = 10;
            cell.img.image = [UIImage imageNamed:@"pass_mrz_ic"];
            cell.vw.layer.masksToBounds = true;
        }
            break;
        case 1:
        {
            cell.lbl_list_title.text = @"USA Driving License";
            [cell.vw setBackgroundColor:[UIColor colorWithRed:154.0 / 255.0 green:154.0 / 255.0 blue:154.0 / 255.0 alpha:1.0]];
            cell.vw.layer.cornerRadius = 10;
            cell.img.image = [UIImage imageNamed:@"usa_driving_ic"];
            cell.vw.layer.masksToBounds = true;
        }
            break;
       
        case 2:
        {
            cell.lbl_list_title.text = @"Pan Card India";
            [cell.vw setBackgroundColor:[UIColor colorWithRed:213.0 / 255.0 green:50.0 / 255.0 blue:63.0 / 255.0 alpha:1.0]];
            cell.vw.layer.cornerRadius = 10;
            cell.img.image = [UIImage imageNamed:@"pan_card"];
            cell.vw.layer.masksToBounds = true;
        }
            break;
        case 3:
        {
            cell.lbl_list_title.text = @"Aadhaar Card India";
            [cell.vw setBackgroundColor:[UIColor colorWithRed:154.0 / 255.0 green:154.0 / 255.0 blue:154.0 / 255.0 alpha:1.0]];
            cell.vw.layer.cornerRadius = 10;
            cell.img.image = [UIImage imageNamed:@"aadhar_card"];
            cell.vw.layer.masksToBounds = true;
        }
            break;
        case 4:
        {
            cell.lbl_list_title.text = @"Barcode & PDF417";
            [cell.vw setBackgroundColor:[UIColor colorWithRed:213.0 / 255.0 green:50.0 / 255.0 blue:63.0 / 255.0 alpha:1.0]];
            cell.vw.layer.cornerRadius = 10;
            cell.img.image = [UIImage imageNamed:@"white"];
            cell.vw.layer.masksToBounds = true;
        }
            break;
        case 5:
        {
            cell.lbl_list_title.text = @"Upload Image";
            [cell.vw setBackgroundColor:[UIColor colorWithRed:154.0 / 255.0 green:154.0 / 255.0 blue:154.0 / 255.0 alpha:1.0]];
            cell.vw.layer.cornerRadius = 10;
            cell.img.image = [UIImage imageNamed:@"white"];
            cell.vw.layer.masksToBounds = true;
        }
            break;
        default:
        {
            return  nil;
        }
            break;
            
    }
    return cell;
}

#pragma tableview datasource method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    switch (indexPath.row)
    {
       
        case 0:
        {
            NSLog(@"About us");
            UIStoryboard* MainStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
            PlaceHolderViewController *placeVC =(PlaceHolderViewController *)[MainStoryBoard instantiateViewControllerWithIdentifier:@"PlaceHolderViewController"];
            appDelegate.cardVcType = @"mrz";
            [self.navigationController pushViewController:placeVC animated:YES];
        }
            break;
        case 1:
        {
            NSLog(@"Documents Supported");
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"isFromUSA"];
            UIStoryboard* codeStory = [UIStoryboard storyboardWithName:@"CodeScanVC" bundle:nil];
            PlaceViewController *placeVC =(PlaceViewController *)[codeStory instantiateViewControllerWithIdentifier:@"PlaceViewController"];
            appDelegate.cardVcType = @"driving";
            [self.navigationController pushViewController:placeVC animated:YES];
            
        }
            break;
       
        case 2:
        {
            NSLog(@"Disclaimer");
            UIStoryboard* MainStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
            PlacePanCardViewController *placeVC =(PlacePanCardViewController *)[MainStoryBoard instantiateViewControllerWithIdentifier:@"PlacePanCardViewController"];
            appDelegate.cardVcType = @"pan";
            [self.navigationController pushViewController:placeVC animated:YES];
            
        }
            break;
        case 3:
        {
            NSLog(@"Disclaimer");
            UIStoryboard* MainStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
            PlaceAdharViewController *placeVC =(PlaceAdharViewController *)[MainStoryBoard instantiateViewControllerWithIdentifier:@"PlaceAdharViewController"];
            appDelegate.cardVcType = @"adhar";
            [self.navigationController pushViewController:placeVC animated:YES];
        }
            break;
        case 4               :
        {
            NSLog(@"Disclaimer");
            NSLog(@"Documents Supported");
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"isFromUSA"];
            UIStoryboard* codeStory = [UIStoryboard storyboardWithName:@"CodeScanVC" bundle:nil];
            PlaceViewController *placeVC =(PlaceViewController *)[codeStory instantiateViewControllerWithIdentifier:@"PlaceViewController"];
            appDelegate.cardVcType = @"barcode";
            [self.navigationController pushViewController:placeVC animated:YES];
        }
            break;
      
        case 5:
        {
            NSLog(@"upload");
            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
                // Cancel button tappped do nothing.3
                [self dismissViewControllerAnimated:YES completion:^{
                }];
                
            }]];
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                // take photo button tapped.
                [self dismissViewControllerAnimated:YES completion:nil];
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    self->imagePicker = [[UIImagePickerController alloc]init];
                    self->imagePicker.delegate = self;
                    self->imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    self->imagePicker.allowsEditing = YES;
                    
                    
                }else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Camera Unavailable"
                                                                   message:@"Unable to find a camera on your device."
                                                                  delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil, nil];
                    [alert show];
                    alert = nil;
                }
                [self presentViewController:self->imagePicker animated:YES completion:nil];
            }]];
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Choose photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self dismissViewControllerAnimated:YES completion:nil];
                
                // choose photo button tapped.
                self->imagePicker = [[UIImagePickerController alloc]init];
                self->imagePicker.delegate = self;
                self->imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                self->imagePicker.allowsEditing = YES;
                [self presentViewController:self->imagePicker animated:YES completion:nil];
                
            }]];
            actionSheet.popoverPresentationController.sourceView = self.view;
            actionSheet.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0);

            [self presentViewController:actionSheet animated:YES completion:nil];
           }
            break;
            
        default:
        {
        }
            break;
            
    }
    
}
# pragma imagepickercontroller method
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    UIImage *image1 = [self scaleAndRotateImage:image];
    [self dismissViewControllerAnimated:NO completion:^{
        [GlobalMethods saveImage:image1];
    }];
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:NO completion:^{
        
        [self.navigationController popViewControllerAnimated:NO];
    }];
    
    
}

#pragma mark ------ image orientation ----------
- (UIImage *)scaleAndRotateImage:(UIImage *) image
{
    int kMaxResolution = 450;
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

@end
