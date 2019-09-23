//
//  GlobalMethods.m
//  PALS
//
//  Created by Gaurav Parmar on 15/03/16.
//  Copyright © 2016 Quantum Technolabs. All rights reserved.
//

#import "GlobalMethods.h"
#define APPNAME @"AccuraScan"

@implementation GlobalMethods
#pragma mark string null check
+ (NSString *) getNotNullString:(NSString *) aString {
    
    if ((NSNull *) aString == [NSNull null]) {
        return @"";
    }
    if ([aString containsString:@"(null)"]) {
        return @"";
    }
    
    if (aString == nil) {
        return @"";
    } else if ([aString length] == 0) {
        return @"";
    } else {
        aString = [aString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([aString length] == 0) {
            return @"";
        }
    }
    
    return aString;
}


#pragma mark
#pragma mark - Validation For Valid E-Mail
+(BOOL) IsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma mark
#pragma mark Date Conversion

+(NSString *)dateStringFromDate:(NSDate *)selectedDate
{
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
    [dateFormate setDateFormat:@"MMM dd yyyy"];
    return [dateFormate stringFromDate:selectedDate];
}
-(NSDate *)dateFromDateString:(NSString *)dateString
{
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
    [dateFormate setDateFormat:@"MMM dd,yyyy"];
    [dateFormate setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    return [dateFormate dateFromString:dateString];
}
-(NSString *)dateStringFromTime:(NSDate *)selectedDate
{
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
    [dateFormate setDateFormat:@"hh:mm aa"];
    return [dateFormate stringFromDate:selectedDate];
}
-(NSString *)dateStringFromTime24:(NSDate *)selectedDate
{
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
    [dateFormate setDateFormat:@"HH:mm:ss"];
    return [dateFormate stringFromDate:selectedDate];
}

//#pragma mark - Alert View Methods

+(void)showAlertView:(NSString *)text withViewController:(UIViewController *)view
{
    if (([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending))
    {
        // use UIAlertView
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APPNAME
                                                        message:text
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
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
+(void)showAlertViewWithAction:(NSString *)text withTitle:(NSString *)title withViewController:(UIViewController *)view
{
    if (([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending))
    {
        // use UIAlertView
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:text
                                                       delegate:view
                                              cancelButtonTitle:@"CANCEL"
                                              otherButtonTitles:@"OK",nil];
        [alert show];
    }
    else
    {
        // use UIAlertController
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:text
                                                       delegate:view
                                              cancelButtonTitle:@"CANCEL"
                                              otherButtonTitles:@"OK", nil];
        
        alert.tag = 1001;
        
        [alert show];
    }
}

+(void)showAlertView:(NSString *)text withNextviewController:(UIViewController *)nextviewcontroller withviewController:(UIViewController *)viewcontroller wintNavigation :(UINavigationController *)navigationController
{
    if (([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending))
    {
        // use UIAlertView
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APPNAME
                                                        message:text
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        // use UIAlertController
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:APPNAME
                                      message:text
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 [navigationController pushViewController:nextviewcontroller animated:YES];
                             }];
        [alert addAction:ok];
        [viewcontroller presentViewController:alert animated:YES completion:nil];
    }
}

-(void)showAlertView:(NSString *)text withDismissAction:(NSString *)segueName withViewController:(UIViewController *)view
{
    if (([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending))
    {
        // use UIAlertView
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APPNAME
                                                        message:text
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        // use UIAlertController
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:APPNAME
                                      message:text
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [alert addAction:ok];
        [view presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark base 64 encoded string
+ (NSString*)encodeStringTo64:(NSString*)fromString ;{
    NSData *plainData = [fromString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String;
    if ([plainData respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        base64String = [plainData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    } else {
        base64String = [plainData base64Encoding];                              // pre iOS7
    }
    
    return base64String;
}
+ (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
}
-(void)setUpData
{
    
   NSMutableArray *arrLike =[[NSMutableArray alloc] init];
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    dict =[[NSMutableDictionary alloc]init];
    
    [dict setValue:@"Profiel" forKey:@"title"];
    [dict setValue:@"0" forKey:@"islike"];
    [arrLike addObject:dict];
    
    dict =[[NSMutableDictionary alloc]init];
    [dict setValue:@"HoptSpots" forKey:@"title"];
    [dict setValue:@"0" forKey:@"islike"];
    // [arrLike addObject:dict];
    
    
    dict =[[NSMutableDictionary alloc]init];
    [dict setValue:@"Push notificatie" forKey:@"title"];
    [dict setValue:@"0" forKey:@"islike"];
    [arrLike addObject:dict];
    
    
    dict =[[NSMutableDictionary alloc]init];
    [dict setValue:@"Uitloggen" forKey:@"title"];
    [dict setValue:@"0" forKey:@"islike"];
    [arrLike addObject:dict];
    
    
}
+(NSString *)getJsonFromArray :(NSArray *)arrValue
{
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:arrValue options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
}
+(void)pushViewcontrollerInSearchStoriboardTo: (UIViewController *)viewcontroller andIndentifier :(NSString *)VCidentfier wintNavigation :(UINavigationController *)navigationController{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Search" bundle:nil];
    viewcontroller =[storyboard instantiateViewControllerWithIdentifier:VCidentfier];
    [navigationController pushViewController:viewcontroller animated:YES ];

}
+(void)pushViewcontrollerInSearchStoriboardTo: (UIViewController *)viewcontroller andIndentifier :(NSString *)VCidentfier
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Search" bundle:nil];
    viewcontroller =[storyboard instantiateViewControllerWithIdentifier:VCidentfier];
    [viewcontroller.navigationController pushViewController:viewcontroller animated:YES ];
}
+(void)pushViewcontrollerMessageStoriboardTo: (UIViewController *)viewcontroller andIndentifier :(NSString *)VCidentfier wintNavigation :(UINavigationController *)navigationController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Message" bundle:nil];
    viewcontroller =[storyboard instantiateViewControllerWithIdentifier:VCidentfier];
    [viewcontroller.navigationController pushViewController:viewcontroller animated:YES ];
    
}
+(void)pushViewcontrollerProfileStoriboardTo: (UIViewController *)viewcontroller andIndentifier :(NSString *)VCidentfier wintNavigation :(UINavigationController *)navigationController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    viewcontroller =[storyboard instantiateViewControllerWithIdentifier:VCidentfier];
    [navigationController pushViewController:viewcontroller animated:YES ];
    
}
+(void)pushViewcontrollerMainStoriboardTo: (UIViewController *)viewcontroller andIndentifier :(NSString *)VCidentfier wintNavigation :(UINavigationController *)navigationController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    viewcontroller =[storyboard instantiateViewControllerWithIdentifier:VCidentfier];
    [navigationController pushViewController:viewcontroller animated:YES ];

}
//-(void)showCRToastandMessage :(NSString *)strMessage
//{
//    NSDictionary *options = @{
//                              kCRToastTextKey : [NSString stringWithFormat:@"%@",strMessage],
//                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
//                              kCRToastBackgroundColorKey : APPREDCOLOR,
//                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
//                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
//                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
//                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
//                              kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
//                              kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypeCover),
//                              };
//    
//    [CRToastManager showNotificationWithOptions:options
//                                completionBlock:^{
//                                }];
//}
//+(BOOL)checkImagePermission
//{
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//    if(authStatus == AVAuthorizationStatusAuthorized) {
//        return true ;
//        // do your logic
//    } else if(authStatus == AVAuthorizationStatusDenied){
//        return false ;
//        // denied
//    } else if(authStatus == AVAuthorizationStatusRestricted){
//        return false ;
//        
//        // restricted, normally won't happen
//    } else if(authStatus == AVAuthorizationStatusNotDetermined){
//        // not determined?!
//        return true ;
//        
//        //        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
//        //            if(granted){
//        //
//        //            } else {
//        //            }
//        //        }];
//    }
//    
//    return false ;
//}

//+(BOOL)checkImagePermission
//{
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//    if(authStatus == AVAuthorizationStatusAuthorized) {
//        return true ;
//        // do your logic
//    } else if(authStatus == AVAuthorizationStatusDenied){
//        return false ;
//        // denied
//    } else if(authStatus == AVAuthorizationStatusRestricted){
//        return false ;
//
//        // restricted, normally won't happen
//    } else if(authStatus == AVAuthorizationStatusNotDetermined){
//        // not determined?!
//        return true ;
//
////        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
////            if(granted){
////                
////            } else {
////            }
////        }];
//    }
//    
//    return false ;
//}
+ (NSString *)extractNumberFromText:(NSString *)text
{
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSString *number =[[text componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
    return number;
}
+(NSArray *)getArrayFromString :(NSString *)jsonString
{
    NSArray *jsonArray =[[NSArray alloc] init];
    if (jsonString.length > 0) {
        NSData *myNSData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error ;
        jsonArray = [NSJSONSerialization JSONObjectWithData:myNSData options:kNilOptions error:&error];
        
        if (error != nil) {
            NSLog(@"Error parsing JSON.");
            return jsonArray ;
        }
        else {
            NSLog(@"Array: %@", jsonArray);
            return jsonArray ;
        }

    }
    else{
        return jsonArray ;

    }
    

}
 +(UIImage *)fixOrientationForImage:(UIImage*)neededImage {
    
    // No-op if the orientation is already correct
    if (neededImage.imageOrientation == UIImageOrientationUp) return neededImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (neededImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, neededImage.size.width, neededImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, neededImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, neededImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (neededImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, neededImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, neededImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, neededImage.size.width, neededImage.size.height,
                                             CGImageGetBitsPerComponent(neededImage.CGImage), 0,
                                             CGImageGetColorSpace(neededImage.CGImage),
                                             CGImageGetBitmapInfo(neededImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (neededImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,neededImage.size.height,neededImage.size.width), neededImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,neededImage.size.width,neededImage.size.height), neededImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
+ (void)saveImage: (UIImage*)image;
{
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          @"test.png" ];
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }
}
+ (UIImage*)loadImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      @"test.png" ];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage *)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect {
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return cropped;
}

@end