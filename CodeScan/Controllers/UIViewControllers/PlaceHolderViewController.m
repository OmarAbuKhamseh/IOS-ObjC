//
//  PlaceHolderViewController.m
//  Passport
//
//  Created by akshay on 3/10/17.
//  Copyright © 2017 Alexander Shishkov & Kirill Kornyakov. All rights reserved.
//

#import "PlaceHolderViewController.h"
#import "ModelManager.h"
#import "WebServiceUrl.h"
#import <MessageUI/MessageUI.h>
#import "NDHTMLtoPDF.h"
#include "LibXL/libxl.h"

#import "WebAPIRequest.h"
@interface PlaceHolderViewController ()<UIActionSheetDelegate,NDHTMLtoPDFDelegate,MFMailComposeViewControllerDelegate>
{
    BOOL isPdf;
    NSMutableArray *dataArr,*scanInfoArray;
    ModelManager *mgrObj;
    
    
}
@end

@implementation PlaceHolderViewController
- (IBAction)btnScanpress:(UIButton *)sender {
          [self performSegueWithIdentifier:@"Scan segue" sender:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    mgrObj=[ModelManager getInstance];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)exportDataAction:(id)sender
{
}

- (IBAction)menuAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)backToPlaceHolder:(UIStoryboardSegue *)segue
{
    NSLog(@"I did an unwind segway! Holy crap!");

}

@end


