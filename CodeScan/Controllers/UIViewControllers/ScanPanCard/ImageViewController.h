//
//  ImageViewController.h
//  AccuraSDK
//
//  Created by SSD on 13/07/18.
//  Copyright © 2018 Alexander Shishkov & Kirill Kornyakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ImageViewController : UIViewController 
- (IBAction)getInfoAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) NSString *isFrom;
@property (weak, nonatomic) IBOutlet UIButton *btn_get_info;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;
@property (nonatomic,assign) BOOL isDismiss;
@property (weak, nonatomic) IBOutlet UIView *FrameView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* _constant_heigtt;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* _constant_width;
@property (weak, nonatomic) IBOutlet UIView *previewView;
- (IBAction)usePhotoAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnUse;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;

@end
