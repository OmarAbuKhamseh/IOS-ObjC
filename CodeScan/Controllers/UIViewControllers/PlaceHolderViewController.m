//
//  PlaceHolderViewController.m


#import "PlaceHolderViewController.h"
#import "WebServiceUrl.h"

#import "WebAPIRequest.h"
@interface PlaceHolderViewController ()<UIActionSheetDelegate>
{
}
@end

@implementation PlaceHolderViewController
- (IBAction)btnScanpress:(UIButton *)sender {
          [self performSegueWithIdentifier:@"Scan segue" sender:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)menuAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end


