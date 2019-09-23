//
//  DocumentTableCell1.h
//  Accura Scan
//
//  Created by kuldeep on 8/31/19.
//  Copyright © 2019 Elite Development LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DocumentTableCell1 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblDocName;
@property (weak, nonatomic) IBOutlet UIImageView *imgDocument;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLblHight;

@end

NS_ASSUME_NONNULL_END
