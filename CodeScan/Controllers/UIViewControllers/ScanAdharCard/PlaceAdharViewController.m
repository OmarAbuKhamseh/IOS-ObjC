//
//  PlaceAdharViewController.m


#import "PlaceAdharViewController.h"
#import "WebServiceUrl.h"

#import "ImageViewController.h"
@interface PlaceAdharViewController ()<UIActionSheetDelegate>
{
    
}

@end

@implementation PlaceAdharViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)nextAction:(id)sender
{
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(status == AVAuthorizationStatusAuthorized) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
        ImageViewController *placeVC =(ImageViewController *)[MainStoryBoard instantiateViewControllerWithIdentifier:@"ImageViewController"];
        placeVC.isFrom = @"3";
        [self.navigationController pushViewController:placeVC animated:NO];
        });
        
        // authorized
    } else if(status == AVAuthorizationStatusDenied){
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:APPNAME
                                     message:@"It looks like your privacy settings are preventing us from accessing your camera."
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        //Add Buttons
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        BOOL canOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
                                        if (canOpenSettings) {
                                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                        }
                                        
                                    }];
        
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        // denied
    } else if(status == AVAuthorizationStatusRestricted){
        // restricted
    } else if(status == AVAuthorizationStatusNotDetermined){
        // not determined
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                NSLog(@"Granted access");
                dispatch_async(dispatch_get_main_queue(), ^{
                ImageViewController *placeVC =(ImageViewController *)[MainStoryBoard instantiateViewControllerWithIdentifier:@"ImageViewController"];
                placeVC.isFrom = @"2";
                [self.navigationController pushViewController:placeVC animated:NO];
                });
                
            } else {
                NSLog(@"Not granted access");
                
            }
        }];
    }
}

@end
