//
//  ContactUsViewController.h
//  Passport
//
//  Created by akshay on 3/14/17.
//  Copyright © 2017 Alexander Shishkov & Kirill Kornyakov. All rights reserved.
//

#import "ViewController.h"
#import "NDHTMLtoPDF.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface ContactUsViewController : ViewController<UITextViewDelegate>

{
    IBOutlet UIView *viewInsideScroll;
    __weak IBOutlet UITextField *txtName;
    __weak IBOutlet UITextView *txtMsg;
    IBOutlet UIButton *menubtn;
    IBOutlet UIToolbar *toolbar;
    IBOutlet TPKeyboardAvoidingScrollView *scoll;
    IBOutlet UILabel *lblContent;
    
    IBOutlet UIButton *btnSend;
    IBOutlet UIButton *btnCancel;
    IBOutlet UIButton *btn_back;
    __weak IBOutlet UIPickerView *country_list_picker;
    __weak IBOutlet UITextField *txtCountry;
    __weak IBOutlet UITextField *txtCell;
    __weak IBOutlet UITextField *txtEmailID;
    __weak IBOutlet UITextField *txtCompanyName;
}
- (IBAction)menuClick:(id)sender;
@property (nonatomic, strong) NDHTMLtoPDF *PDFCreator;
@property (nonatomic, strong) NSString *fromMenu;

- (IBAction)Done:(id)sender;
- (IBAction)cancel:(id)sender;

- (IBAction)exportDataAction:(id)sender;
- (IBAction)btnSend:(id)sender;
- (IBAction)btnCountry:(id)sender;
@end
