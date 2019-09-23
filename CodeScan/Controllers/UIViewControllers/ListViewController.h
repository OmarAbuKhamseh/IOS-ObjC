//
//  ListViewController.h
//  AccuraSDK
//
//  Created by SSD on 13/07/18.
//  Copyright © 2018 Alexander Shishkov & Kirill Kornyakov. All rights reserved.
//
#import <UIKit/UIKit.h>

@class CodeScanVC;
@class PlaceViewController;
@interface ListViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tblList;
@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
@property (nonatomic, retain) NSString *navTitle;

@end
