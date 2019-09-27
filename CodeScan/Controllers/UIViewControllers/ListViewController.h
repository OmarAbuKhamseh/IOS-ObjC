//
//  ListViewController.h

#import <UIKit/UIKit.h>

@class CodeScanVC;
@class PlaceViewController;
@interface ListViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
@property (nonatomic, retain) NSString *navTitle;

@end
