//
//  ShowResultVC.h
//  Accura Scan
//
//  Created by kuldeep on 8/29/19.
//  Copyright © 2019 Elite Development LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowResultVC : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *img_height;
@property (weak, nonatomic) IBOutlet UILabel *lblLinestitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (weak, nonatomic) IBOutlet UIButton *btnLiveness;
@property (weak, nonatomic) IBOutlet UIButton *btnFaceMathch;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) NSString *isFrom;
@property (weak, nonatomic) IBOutlet UITableView *tblView;


- (IBAction)btnLivenessAction:(UIButton *)sender;
- (IBAction)btnFaceMatchAction:(UIButton *)sender;
- (IBAction)btnCancelAction:(UIButton *)sender;
- (IBAction)btnBackAction:(UIButton *)sender;



@end

NS_ASSUME_NONNULL_END
