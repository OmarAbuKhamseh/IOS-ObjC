//
//  PlacePanCardViewController.h
//  AccuraSDK
//
//  Created by SSD on 13/07/18.
//  Copyright © 2018 Alexander Shishkov & Kirill Kornyakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NDHTMLtoPDF.h"

@interface PlacePanCardViewController : UIViewController
@property (nonatomic, strong) NDHTMLtoPDF *PDFCreator;

- (IBAction)backAction:(id)sender;
- (IBAction)nextAction:(id)sender;
- (IBAction)exportAction:(id)sender;

@end
