//
//  ListTableViewCell.h
//  AccuraSDK
//
//  Created by SSD on 13/07/18.
//  Copyright © 2018 Alexander Shishkov & Kirill Kornyakov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_list_title;
@property (weak, nonatomic) IBOutlet UIView *vw;
@property (weak, nonatomic) IBOutlet UIImageView *img;

@end
