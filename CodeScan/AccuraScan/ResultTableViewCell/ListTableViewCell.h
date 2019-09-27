//
//  ListTableViewCell.h


#import <UIKit/UIKit.h>

@interface ListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_list_title;
@property (weak, nonatomic) IBOutlet UIView *vw;
@property (weak, nonatomic) IBOutlet UIImageView *img;

@end
