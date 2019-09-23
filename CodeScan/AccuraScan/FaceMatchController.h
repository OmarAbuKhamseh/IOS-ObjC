//
//  FaceMatchController.h
//  Accura Scan
//
//  Created by iOS on 28/7/2019.
//  Copyright © 2019 Elite Development LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FaceMatchController : UIViewController{
    int viewIndex;
    int selIndex;
}

@property (strong, nonatomic) IBOutlet UILabel *lblScore;
@property (strong, nonatomic) IBOutlet UIImageView *imgSource;
@property (strong, nonatomic) IBOutlet UIImageView *imgTarget;
@property (strong, nonatomic) IBOutlet UIImageView *imgUpload;
@property (strong, nonatomic) IBOutlet UILabel *lblUpload;
@property (strong, nonatomic) IBOutlet FaceView *srcFView;
@property (strong, nonatomic) IBOutlet FaceView *tgtFView;
@property (strong, nonatomic) IBOutlet UIImageView *imgTopUpload;
@property (strong, nonatomic) IBOutlet UILabel *lblTopUpload;


- (IBAction)menuAction:(id)sender;
- (IBAction)galleryAction1:(id)sender;
- (IBAction)cameraAction1:(id)sender;
- (IBAction)galleryAction2:(id)sender;

- (IBAction)cameraAction2:(id)sender;

@end

NS_ASSUME_NONNULL_END
