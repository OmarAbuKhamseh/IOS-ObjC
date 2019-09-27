//
//  GlobalMethods.h


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface GlobalMethods : NSObject

+(NSString *)dateStringFromDate:(NSDate *)selectedDate;

+(void)showAlertView:(NSString *)text withViewController:(UIViewController *)view;


// Push View Controller Methods
+(void)showAlertView:(NSString *)text withNextviewController:(UIViewController *)nextviewcontroller withviewController:(UIViewController *)viewcontroller wintNavigation :(UINavigationController *)navigationController;

+ (void)saveImage: (UIImage*)image;
+ (UIImage*)loadImage;
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize; //addedByJJH_20190912
+ (UIImage *)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect;

@end
