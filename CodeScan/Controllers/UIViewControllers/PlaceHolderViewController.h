//
//  PlaceHolderViewController.h
//  Passport
//
//  Created by akshay on 3/10/17.
//  Copyright © 2017 Alexander Shishkov & Kirill Kornyakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NDHTMLtoPDF.h"
#import <AVFoundation/AVFoundation.h>

@interface PlaceHolderViewController : UIViewController

@property (nonatomic, strong) NDHTMLtoPDF *PDFCreator;

- (IBAction)exportDataAction:(id)sender;
- (IBAction)menuAction:(id)sender;

-(IBAction)backToPlaceHolder:(UIStoryboardSegue *)segue;
@end

