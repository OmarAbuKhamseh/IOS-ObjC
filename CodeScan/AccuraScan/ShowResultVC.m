//
//  ShowResultVC.m

#import "ShowResultVC.h"
#import <ZoomAuthenticationHybrid/ZoomAuthenticationHybrid.h>
#import "SVProgressHUD.h"
#import "NSFaceRegion.h"
#import "EngineWrapper.h"
#import "Accura_Scan-Swift.h"
#import "UserImgTableCell1.h"
#import "WebServiceUrl.h"
#import "WebAPIRequest.h"
#import "CustomAfnetwork/CustomAFNetWorking.h"
#import "ResultTableCell1.h"
#import "DocumentTableCell1.h"
#import <MessageUI/MessageUI.h>
#import "GlobalMethods/GlobalMethods.h"

#define APPNAME @"ACCURA FACE MATCH"


NSString* MY_ZOOM_DEVELOPER_TOKEN = @"dUfNhktz2Tcl32pGgbPTZ57QujOQBluh";


@interface ShowResultVC ()< UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSString *uniqStr;
    NSString *mrz_val;
    
}
@end

@implementation ShowResultVC

extern int retval;
extern NSString* lines;
extern bool success;
extern NSString* passportType;
extern NSString* country;
extern NSString* surName;
extern NSString* givenNames;
extern NSString* passportNumber;
extern NSString* passportNumberChecksum;
extern NSString* nationality;
extern NSString* birth;
extern NSString* birthChecksum;
extern NSString* sex;
extern NSString* expirationDate;
extern NSString* otherID;
extern NSString* expirationDateChecksum;
extern NSString* personalNumber;
extern NSString* personalNumberChecksum;
extern NSString* secondRowChecksum;
extern NSString* placeOfBirth;
extern NSString* placeOfIssue;
extern UIImage* photoImage;
extern UIImage* documentImage;
extern UIImage* docfrontImage;
extern NSString* stLivenessResult;

bool isFirst = false;
UIImagePickerController* picker;
UIImage *matchImage;
UIImage *liveImage;
NSFaceRegion* faceRegion;
NSMutableArray *arrDocumentData;
NSMutableDictionary *dictDataShow;
NSMutableArray *appDocumentImage;

NSString *KEY_TITLE          = @"KEY_TITLE";
NSString *KEY_VALUE          = @"KEY_VALUE";
NSString *KEY_FACE_IMAGE     = @"KEY_FACE_IMAGE";
NSString *KEY_FACE_IMAGE2    = @"KEY_FACE_IMAGE2";
NSString *KEY_DOC1_IMAGE     = @"KEY_DOC1_IMAGE";
NSString *KEY_DOC2_IMAGE     = @"KEY_DOC2_IMAGE";
NSString *stLivenessResult;

UIImage *imageFace;
UIImage *imageFace2;
UIImage *imageDoc;
UIImage *imageDoc2;

NSString* fontImgRotation = @"";
NSString* BackImgRotation = @"";

- (void)viewDidLoad {
    [super viewDidLoad];
    _btnLiveness.hidden = YES;
    arrDocumentData = [[NSMutableArray alloc] init];
    dictDataShow = [[NSMutableDictionary alloc]init];
    appDocumentImage = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *dictScanningData = [[NSMutableDictionary alloc]init];
    isFirst= true;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   
    /*
     SDK method call to engineWrapper init
     @Return: init status bool value
     */
    bool fmInit = [EngineWrapper IsEngineInit];
    if (!fmInit)
        [EngineWrapper FaceEngineInit]; // init enginewrapper
  
    /*
     SDK method call to get engineWrapper load status
     @Return: init status Int value
     */
    
    int fmValue = [EngineWrapper GetEngineInitValue];
    if (fmValue == -20)
        [self showAlertView:@"key not found" withViewController:self];
    else if (fmValue == -15)
        [self showAlertView:@"License Invalid" withViewController:self];
    
    // check the viewcontroller type
    if ([appDelegate.firstVcType isEqual:@"ocr"]){
        _btnLiveness.hidden = YES;
        _btnFaceMathch.hidden = YES;
        _btnCancel.hidden = NO;
    } else{
        _btnCancel.hidden = NO;
        _btnFaceMathch.hidden = NO;
        _btnLiveness.hidden = NO;
        
        [self initializeZoom]; //Set Zoom Controller
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPhotoCaptured) name:@"_UIImagePickerControllerUserDidCaptureItem" object:nil];
    
    //Chcek scanning Type
    if([_isFrom isEqualToString:@"2"] || [_isFrom isEqualToString:@"3"]){
        dictScanningData = [appDelegate dictStoreScanningData]; // Get Local Store Dictionary
    }else{
        // Get data from userdefaults
        dictScanningData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ScanningData"];
        fontImgRotation = [dictScanningData valueForKey:@"fontImageRotation"];
        BackImgRotation = [dictScanningData valueForKey:@"backImageRotation"];
    }
    
    
    // ------ filter scaning data -------
    if ([_isFrom isEqualToString:@"2"]){
        NSString *strImgURL = [dictScanningData valueForKey:@"scan_image"];
        if (strImgURL != nil){
            // convert to data
            photoImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dictScanningData valueForKey:@"scan_image"]]]];
            faceRegion = nil;
            if(photoImage != nil){
                /*
                 FaceMatch SDK method call to Identify face in Document scanning image
                 @Params: BackImage, Front Face Image
                 @Return: Face data
                 */
                faceRegion = [EngineWrapper DetectSourceFaces:photoImage];
            }
            [_tblView reloadData];
        }
        
        NSString *stCard = [dictScanningData valueForKey:@"card"];
        passportType = stCard;
        
        
        NSString *stDOB = [dictScanningData valueForKey:@"date of birth"];
        birth = stDOB;
        
        NSString *stName = [dictScanningData valueForKey:@"name"];
        givenNames = stName;
        
        NSString *stSName = [dictScanningData valueForKey:@"second_name"];
        surName = stSName;
        
        NSString *stPanCardNo = [dictScanningData valueForKey:@"pan_card_no"];
        passportNumber = stPanCardNo;
        
        if (appDelegate.imgPanClick != nil){
            [appDocumentImage addObject:appDelegate.imgPanClick];
        }
        
        country = @"IND";
        
    }else if ([_isFrom isEqualToString:@"3"]){
        NSString *strImgURL = [dictScanningData valueForKey:@"scan_image"];
        if (strImgURL != nil){
            photoImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dictScanningData valueForKey:@"scan_image"]]]];
            faceRegion = nil;
            if(photoImage != nil){
                /*
                 FaceMatch SDK method call to Identify face in Document scanning image
                 @Params: BackImage, Front Face Image
                 @Return: Face data
                 */
                faceRegion = [EngineWrapper DetectSourceFaces:photoImage];
            }
             [_tblView reloadData];
        }
        
        NSString *stCard = [dictScanningData valueForKey:@"card"];
        passportType = stCard;
        
        
        NSString *stDOB = [dictScanningData valueForKey:@"date of birth"];
        birth = stDOB;
        
        NSString *stName = [dictScanningData valueForKey:@"name"];
        givenNames = stName;
        
        NSString *stSex = [dictScanningData valueForKey:@"sex"];
        sex = stSex;
        
        NSString *staadharCardNo = [dictScanningData valueForKey:@"aadhar_card_no"];
        passportNumber = staadharCardNo;
        
        if (appDelegate.imgPanClick != nil){
            [appDocumentImage addObject:appDelegate.imgPanClick];
        }
        country = @"IND";
    }else{
        NSString *strline = [dictScanningData valueForKey:@"lines"];
        lines = strline;
        
        NSString *strpassportType = [dictScanningData valueForKey:@"passportType"];
        passportType = strpassportType;
        
        NSString *stRetval = [dictScanningData valueForKey:@"retval"];
        retval = [stRetval integerValue];
        
        NSString *strcountry = [dictScanningData valueForKey:@"country"];
        country = strcountry;
        
        NSString *strsurName = [dictScanningData valueForKey:@"surName"];
        surName = strsurName;
        
        NSString *strgivenNames = [dictScanningData valueForKey:@"givenNames"];
        givenNames = strgivenNames;
        
        NSString *strpassportNumber = [dictScanningData valueForKey:@"passportNumber"];
        passportNumber = strpassportNumber;
        
        NSString *strpassportNumberChecksum = [dictScanningData valueForKey:@"passportNumberChecksum"];
        passportNumberChecksum = strpassportNumberChecksum;
        
        NSString *strnationality = [dictScanningData valueForKey:@"nationality"];
        nationality = strnationality;
        
        NSString *strbirth = [dictScanningData valueForKey:@"birth"];
        birth = strbirth;
        
        NSString *stbirthChecksum = [dictScanningData valueForKey:@"BirthChecksum"];
        birthChecksum = stbirthChecksum;
        
        
        NSString *strsex = [dictScanningData valueForKey:@"sex"];
        sex = strsex;
        
        NSString *strexpirationDate = [dictScanningData valueForKey:@"expirationDate"];
        expirationDate = strexpirationDate;
        
        NSString *strexpirationDateChecksum = [dictScanningData valueForKey:@"expirationDateChecksum"];
        expirationDateChecksum = strexpirationDateChecksum;
        
        NSString *strpersonalNumber = [dictScanningData valueForKey:@"personalNumber"];
        personalNumber = strpersonalNumber;
        
        NSString *strpersonalNumberChecksum = [dictScanningData valueForKey:@"personalNumberChecksum"];
        personalNumberChecksum = strpersonalNumberChecksum;
        
        NSString *strsecondRowChecksum = [dictScanningData valueForKey:@"secondRowChecksum"];
        secondRowChecksum = strsecondRowChecksum;
        
        NSString *strplaceOfBirth = [dictScanningData valueForKey:@"placeOfBirth"];
        placeOfBirth = strplaceOfBirth;
        
        NSString *strplaceOfIssue = [dictScanningData valueForKey:@"placeOfIssue"];
        placeOfIssue = strplaceOfIssue;
        
        NSData *image_photoImage = [dictScanningData valueForKey:@"photoImage"];
        photoImage = [UIImage imageWithData:image_photoImage];
        faceRegion = nil;
        //Check ImageData is exist or not
        if(photoImage != nil){
            /*
             FaceMatch SDK method call to Identify face in Document scanning image
             @Params: BackImage, Front Face Image
             @Return: Face data
             */
            faceRegion = [EngineWrapper DetectSourceFaces:photoImage];
        }
        NSData *image_documentFontImage = [dictScanningData valueForKey:@"docfrontImage"];
        if (image_documentFontImage != nil){
        docfrontImage = [UIImage imageWithData:image_documentFontImage];
        [appDocumentImage addObject:docfrontImage];
        }
        NSData *image_documentImage = [dictScanningData valueForKey:@"documentImage"];
        if (image_documentImage != nil){
        documentImage = [UIImage imageWithData:image_documentImage];
        [appDocumentImage addObject:documentImage];
        }
    }
    // tableview cell register
    [self.tblView registerNib:[UINib nibWithNibName:@"UserImgTableCell1" bundle:nil]
       forCellReuseIdentifier:@"UserImgTableCell1"];
    [self.tblView registerNib:[UINib nibWithNibName:@"ResultTableCell1" bundle:nil]
       forCellReuseIdentifier:@"ResultTableCell1"];
    [self.tblView registerNib:[UINib nibWithNibName:@"DocumentTableCell1" bundle:nil]
       forCellReuseIdentifier:@"DocumentTableCell1"];
}

- (void)viewWillAppear:(BOOL)animated{
    self.tblView.estimatedRowHeight = 100.0;
    self.tblView.rowHeight = UITableViewAutomaticDimension;
    NSLog(@"%d",retval);
    mrz_val = @"CORRECT";
    if (retval == 1)
    {
        mrz_val = @"CORRECT";
    }
    else
    {
        mrz_val = @"INCORRECT";
    }
    _img_height.constant = 0;
    [self.imgPhoto setImage:photoImage];
    
    if (isFirst){
        isFirst = false;
        [self setData]; // this function Called set data in tableView
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [Zoom.sdk preload]; // ZoomScanning SDK Reset
}

#pragma mark -------- Custom method ---------------
/**
 * This method use set scanning data
 *
 */
-(void)setData{
   //Set tableView Data
    if([_isFrom isEqualToString:@"2"]){
        for(int index = 0; index < 7 + [arrDocumentData count]; index++){
            NSDictionary *dic = [[NSDictionary alloc]init];
            switch (index) {
                case 0:
                    dic = @{ KEY_FACE_IMAGE : photoImage};
                    [arrDocumentData addObject:dic];
                    break;
                case 1:
                    dic = @{ KEY_VALUE : passportType,KEY_TITLE:@"DOCUMENT : "};
                    [arrDocumentData addObject:dic];
                    break;
                    
                case 2:
                    dic = @{ KEY_VALUE : surName,KEY_TITLE:@"LAST NAME : "};
                    [arrDocumentData addObject:dic];
                    break;
                    
                case 3:
                    dic = @{ KEY_VALUE : givenNames,KEY_TITLE:@"FIRST NAME : "};
                    [arrDocumentData addObject:dic];
                    break;
                    
                case 4:
                    dic = @{ KEY_VALUE : passportNumber,KEY_TITLE:@"PAN CARD NO : "};
                    [arrDocumentData addObject:dic];
                    break;
                    
                case 5:
                    dic = @{ KEY_VALUE : birth,KEY_TITLE:@"DATE OF BIRTH : "};
                    [arrDocumentData addObject:dic];
                    break;
                    
                case 6:
                    dic = @{ KEY_VALUE : country,KEY_TITLE:@"COUNTRY : "};
                    [arrDocumentData addObject:dic];
                    break;
                    
                case 7:
                    dic = @{ KEY_DOC1_IMAGE : appDocumentImage != nil ? appDocumentImage[0]:nil};
                    [arrDocumentData addObject:dic];
                    break;
                    
                    
                default:
                    break;
            }
        }
    } else  if([_isFrom isEqualToString:@"3"]){
        for(int index = 0; index < 7 + [arrDocumentData count]; index++){
            NSDictionary *dic = [[NSDictionary alloc]init];
            switch (index) {
                case 0:
                    dic = @{ KEY_FACE_IMAGE : photoImage};
                    [arrDocumentData addObject:dic];
                    break;
                case 1:
                    dic = @{ KEY_VALUE : passportType,KEY_TITLE:@"DOCUMENT : "};
                    [arrDocumentData addObject:dic];
                    break;
                    
                case 2:
                    dic = @{KEY_VALUE : givenNames,KEY_TITLE:@"FIRST NAME : "};
                    [arrDocumentData addObject:dic];
                    break;
                    
                case 3:
                    dic = @{ KEY_VALUE : passportNumber,KEY_TITLE:@"AADHAR CARD NO : "};
                    [arrDocumentData addObject:dic];
                    break;
                    
                case 4:
                    dic = @{ KEY_VALUE : birth,KEY_TITLE:@"DATE OF BIRTH : "};
                    [arrDocumentData addObject:dic];
                    break;
                    
                case 5:
                    dic = @{ KEY_VALUE : sex,KEY_TITLE:@"SEX : "};
                    [arrDocumentData addObject:dic];
                    break;
                    
                case 6:
                    dic = @{ KEY_VALUE : country,KEY_TITLE:@"COUNTRY : "};
                    [arrDocumentData addObject:dic];
                    break;
                    
                case 7:
                    dic = @{ KEY_DOC1_IMAGE : appDocumentImage != nil ? appDocumentImage[0]:nil};
                    [arrDocumentData addObject:dic];
                    break;
                    
                    
                default:
                    break;
            }
        }
    }else{
        NSString *strFstLetter;
        NSString *strPassportType;
        NSString *stringWithoutSpaces;
        NSString *dType;
        NSString *stSex;
        NSString *stResult;
        NSString *nullBirth;
        for(int index = 0; index < 18 + [appDocumentImage count]; index++){
            NSDictionary *dic = [[NSDictionary alloc]init];
            switch (index) {
                case 0:
                    dic = @{ KEY_FACE_IMAGE : photoImage};
                    [arrDocumentData addObject:dic];
                    break;
                    
                case 1:
                    dic = @{ KEY_VALUE : lines};
                    [arrDocumentData addObject:dic];
                    break;
                    
                case 2:
                    strPassportType = [passportType lowercaseString];
                    if (lines != nil){
                        NSString *firstLetter = [lines substringToIndex:1];
                        strFstLetter = [firstLetter lowercaseString];
                    }
                    if([strPassportType isEqualToString:@"v"] || [strFstLetter isEqualToString:@"v"]){
                        dType = @"VISA";
                    }else if([passportType isEqualToString:@"p"] || [strFstLetter isEqualToString:@"p"]){
                        dType = @"PASSPORT";
                    }else if([passportType isEqualToString:@"d"] || [strFstLetter isEqualToString:@"p"]){
                        dType = @"DRIVING LICENCE";
                    }else{
                        if ([strFstLetter isEqualToString:@"d"]) {
                            dType = @"DRIVING LICENCE";
                        }else{
                            dType = @"ID";
                        }
                    }
                    dic = @{ KEY_VALUE : dType,KEY_TITLE:@"DOCUMENT : "};
                    [arrDocumentData addObject:dic];
                    break;
                case 3:
                    dic = @{ KEY_VALUE : country,KEY_TITLE:@"COUNTRY : "};
                    [arrDocumentData addObject:dic];
                    break;
                case 4:
                    dic = @{ KEY_VALUE : surName,KEY_TITLE:@"LAST NAME : "};
                    [arrDocumentData addObject:dic];
                    break;
                    
                case 5:
                    dic = @{ KEY_VALUE : givenNames,KEY_TITLE:@"FIRST NAME : "};
                    [arrDocumentData addObject:dic];
                    break;
                    
                case 6:
                    stringWithoutSpaces = [passportNumber stringByReplacingOccurrencesOfString:@"<"withString:@""];
                    dic = @{ KEY_VALUE : stringWithoutSpaces,KEY_TITLE:@"DOCUMENT NO : "};
                    [arrDocumentData addObject:dic];
                    break;
                case 7:
                    dic = @{ KEY_VALUE : passportNumberChecksum,KEY_TITLE:@"DOCUMENT CHECK NUMBER : "};
                    [arrDocumentData addObject:dic];
                    break;
                    
                case 8:
                    dic = @{ KEY_VALUE : nationality,KEY_TITLE:@"NATIONALITY : "};
                    [arrDocumentData addObject:dic];
                    break;
                    
                case 9:
                    nullBirth = @"";
        
                    @try {
                        nullBirth = [self dateToFormatedDate:birth];
                    }
                    @catch (NSException *exception) {
                        nullBirth = @"";
                        NSLog(@"%@", exception);
                        
                    }
                    dic = @{ KEY_VALUE : nullBirth != nil ? nullBirth:@"",KEY_TITLE:@"DATE OF BIRTH : "};
                    [arrDocumentData addObject:dic];
                    NSLog(@"%@", nullBirth);
                    break;
                    
                case 10:
                    dic = @{ KEY_VALUE : birthChecksum,KEY_TITLE:@"BIRTH CHECK NUMBER : "};
                    [arrDocumentData addObject:dic];
                    break;
                case 11:
                    if ([sex isEqualToString:@"F"]){
                        stSex = @"FEMALE";
                    }
                    if ([sex isEqualToString:@"M"]) {
                        stSex = @"MALE";
                    }
                    dic = @{ KEY_VALUE :
                                 stSex,KEY_TITLE:@"SEX: "};
                    [arrDocumentData addObject:dic];
                    break;
                    
                case 12:
                      @try {
                    dic = @{ KEY_VALUE : [self dateToFormatedDate:expirationDate],KEY_TITLE:@"DATE OF EXPIRY : "};
                    [arrDocumentData addObject:dic];
                      }@catch (NSException *exception) {
                          NSLog(@"%@", exception);
                      }
                    break;
                    
                case 13:
                    dic = @{ KEY_VALUE : expirationDateChecksum,KEY_TITLE:@"EXPIRATION CHECK NUMBER : "};
                    [arrDocumentData addObject:dic];
                    break;
                    
                case 14:
                    dic = @{ KEY_VALUE : personalNumber,KEY_TITLE:@"OTHER ID : "};
                    [arrDocumentData addObject:dic];
                    break;
                    
                case 15:
                    dic = @{ KEY_VALUE : personalNumberChecksum,KEY_TITLE:@"OTHER ID CHECK : "};
                    [arrDocumentData addObject:dic];
                    break;
                    
                case 16:
                    dic = @{ KEY_VALUE : secondRowChecksum,KEY_TITLE:@"SECOND ROW CHECK NUMBER : "};
                    [arrDocumentData addObject:dic];
                    break;
                    
                case 17:
                    if(retval == 1){
                        stResult = @"CORRECT MRZ";
                    }
                    else if(retval == 2){
                        stResult = @"INCORRECT MRZ";
                    }else{
                        stResult = @"FAIL";
                    }
                    dic = @{ KEY_VALUE : stResult,KEY_TITLE:@"RESULT: "};
                    [arrDocumentData addObject:dic];
                    break;
                    
                case 18:
                    dic = @{ KEY_DOC1_IMAGE : appDocumentImage != nil ? appDocumentImage[0]:[[UIImage alloc] init]};
                    [arrDocumentData addObject:dic];
                    break;
                    
                case 19:
                    dic = @{ KEY_DOC2_IMAGE : [appDocumentImage count] == 2 ? appDocumentImage[1]:[[UIImage alloc] init]};
                    [arrDocumentData addObject:dic];
                    break;
                    
                default:
                    break;
            }
        }
    }
    NSLog(@"%lu", (unsigned long)[arrDocumentData count]);
}

-(void)showAlertView:(NSString *)text withViewController:(UIViewController *)view
{
    if (([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending))
    {
        // use UIAlertView
        
        UIAlertController *alertobj = [UIAlertController alertControllerWithTitle:APPNAME message:text preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * ok = [UIAlertAction
                              actionWithTitle:@"OK"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              { }];
        
        [alertobj addAction:ok];
        [view presentViewController:alertobj animated:YES completion:nil];
    }
    else
    {
        // use UIAlertController
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:APPNAME
                                      message:text
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [view presentViewController:alert animated:YES completion:nil];
    }
}
/*
 This method use set dateformat
 */

-(NSString *)dateToFormatedDate:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyMMdd"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    [dateFormatter setDateFormat:@"dd-MM-yy"];
    return [dateFormatter stringFromDate:date];
}

#pragma mark -------- face match method ---------------
/**
 * This method use lunchZoom setup
 * Make sure initialization was successful before launcing ZoOm
 *
 */

- (void)launchZoomToVerifyLivenessAndRetrieveFacemap {
    
    // Make sure initialization was successful before launcing ZoOm
    ZoomSDKStatus status = [Zoom.sdk getStatus];
    NSString *reason;
    
    switch(status) {
        case ZoomSDKStatusNeverInitialized:
            reason = @"Initialize was never attempted";
            break;
        case ZoomSDKStatusInitialized:
            reason = @"The app token provided was verified";
            break;
        case ZoomSDKStatusNetworkIssues:
            reason = @"The app token could not be verified";
            break;
        case ZoomSDKStatusInvalidToken:
            reason = @"The app token provided was invalid";
            break;
        case ZoomSDKStatusVersionDeprecated:
            reason = @"The current version of the SDK is deprecated";
            break;
        case ZoomSDKStatusOfflineSessionsExceeded:
            reason = @"The app token needs to be verified again";
            break;
        case ZoomSDKStatusUnknownError:
            reason = @"An unknown error occurred";
            break;
        default:
            break;
    }
    
    if(status != ZoomSDKStatusInitialized) {
        //ZoomSDKStatus is not Initialized to show alert view
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Get Ready To ZoOm."
                                     message:[@"ZoOm is not ready to be launched.\nReason: " stringByAppendingString:reason]
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}
                                   ];
        [alert addAction:okButton];

        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    UIViewController *vc = [Zoom.sdk createVerificationVCWithDelegate:self];
    NSArray* colors = [[NSArray alloc] initWithObjects: (id)[UIColor colorWithRed:0.04 green:0.71 blue:0.64 alpha:1].CGColor,
                       [UIColor colorWithRed:0.07 green:0.57 blue:0.76 alpha:1].CGColor,
                       nil ];
    
    [self configureGradientBackground:colors inLayer:vc.view.layer];
    // For proper modal presentation of ZoOm interface, modal presentation style must be set as .overFullScreen or .overCurrentContext.
    // UIModalPresentationStyles.formsheet is not currently supported, as it impedes intended ZoOm functionality and user experience.
    // Example of presenting ZoOm using cross dissolve effect
    [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    // When presenting the ZoOm interface over your own application, you can keep your application showing in the background by using this presentation style
    [vc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    // Refer to ZoomFrameCustomization for further presentation/interface customization.
    [self presentViewController:vc animated:true completion:nil];
}
// This is the conceptual code where you would add your business logic.
// Note that here we are only providing the code to retrieve the ZoOm facemap itself and not other elements of the full environment.
//
// Other elements you will/may need to consider:
// - A webserver to receive facemap data and how to upload this securely
// - Where to invoke Verification Mode in order to collect the user facemap
// - How to associate the user facemap data to the user in your backend database
// - Where to invoke Verification Mode for a user you already have facemap data for in order to authenticate her
// - Waiting for your server response before branching the user to your own success/fail screens
- (void)handleVerificationSuccessResult:(id<ZoomVerificationResult>)result {
    id<ZoomFaceBiometricMetrics> faceMetrics = result.faceMetrics;
    
    // Retrieve ZoOm facemap as NSData
    // This is the raw biometric data which can be uploaded, or may be
    // Base64 encoded in order to handle easier at the cost of processing and network usage
    if(faceMetrics != nil) {
        
        NSData *zoomFacemap = faceMetrics.zoomFacemap;
        ZoomDevicePartialLivenessResult *devicePartialLivenessResult = faceMetrics.devicePartialLivenessResult;
        // get the device partial liveness score
        float devicePartialLivenessScore = faceMetrics.devicePartialLivenessScore;
        double facem_score = 0.0;
       UIImage* faceImage2 = nil;
        if (faceMetrics.auditTrail != nil && [faceMetrics.auditTrail count] > 0)
            faceImage2 = faceMetrics.auditTrail[0];
        
        matchImage = faceImage2;
        liveImage = faceImage2;
        if (faceImage2.size.width > faceImage2.size.height) {
            UIImage *imagePortrait = [UIImage imageWithCGImage:faceImage2.CGImage scale:1.0 orientation:UIImageOrientationRight];
            faceImage2 = imagePortrait;
            NSLog(@"landscape");
        }else{
            faceImage2 = [UIImage imageWithCGImage:faceImage2.CGImage scale:1.0 orientation:UIImageOrientationRight];
        }
        if(picker.sourceType == UIImagePickerControllerSourceTypeCamera && picker.cameraDevice == UIImagePickerControllerCameraDeviceFront){
            UIImage * flippedImage = [UIImage imageWithCGImage:matchImage.CGImage scale:matchImage.scale orientation:UIImageOrientationLeftMirrored];
            matchImage = flippedImage;
            liveImage = flippedImage;
        }
        if (faceRegion != nil)
        {
            CGFloat ratio = (CGFloat)matchImage.size.width/matchImage.size.height;
            matchImage = [self imageWithImage:matchImage convertToSize:CGSizeMake(480*ratio, 480)];
            if (faceRegion != nil){
                /*
                 FaceMatch SDK method call to detect Face in back image
                 @Params: BackImage, Front Face Image faceRegion
                 @Return: Face Image Frame
                 */
                NSFaceRegion* face2 = [EngineWrapper DetectTargetFaces:matchImage feature1:faceRegion.feature];
                /*
                 SDK method call to get FaceMatch Score
                 @Params: FrontImage Face, BackImage Face
                 @Return: Match Score
                 */
                facem_score = [EngineWrapper Identify:faceRegion.feature featurebuff2:face2.feature];
            }
        }
        else{
            facem_score = 0.0;
        }
        if (facem_score != 0.0){
            bool isFindImg = false;
            for(int index = 0; index <  [arrDocumentData count]; index++){
                NSMutableDictionary * dict = (NSMutableDictionary *)arrDocumentData[index] ;
                for (NSString *key in dict.keyEnumerator) {
                    if (key == KEY_FACE_IMAGE){
                        NSDictionary *dic = @{ KEY_FACE_IMAGE2 : matchImage,KEY_FACE_IMAGE: dict[KEY_FACE_IMAGE] };
                        [arrDocumentData replaceObjectAtIndex:index withObject:dic];
                        isFindImg = true;
                    }
                    if (isFindImg){ break ;}
                }
            }
            [self removeOldValue:@"FACEMATCH SCORE : "];
            NSString *twoDecimalPlaces = [NSString stringWithFormat:@"%0.02f %%", facem_score * 100];
            NSDictionary *dic = @{ KEY_VALUE : twoDecimalPlaces ,KEY_TITLE:@"FACEMATCH SCORE : "};
            if([_isFrom isEqualToString:@"2"] || [_isFrom isEqualToString:@"3"]){
                [arrDocumentData insertObject:dic atIndex:1];
            }else{
                [arrDocumentData insertObject:dic atIndex:2];
            }
        }
        
        NSIndexPath* ip = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tblView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [_tblView reloadData];
    }
    [self handleResultFromFaceTecManagedRESTAPICall:result];
}
/**
 * This method use to get liveness score
 * Parameters to Pass: ZoomVerificationResult user scanning data
 *
 */
-(void)handleResultFromFaceTecManagedRESTAPICall:(id<ZoomVerificationResult>)result
{
    if(result.faceMetrics != nil)
    {
        NSData *zoomFacemap = result.faceMetrics.zoomFacemap;
        NSString *zoom = [zoomFacemap base64EncodedStringWithOptions:0];
        NSLog(@"call liveness api only");
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setValue:result.sessionId forKey:@"sessionId"];
        [dict setValue:zoom forKey:@"facemap"];
        CustomAFNetWorking *apiObject  =[[CustomAFNetWorking alloc]initWithPost:[NSString stringWithFormat:@"%@",WS_liveness] withTag:LivenessTag withParameter:dict];
        apiObject.delegate = self ;
    }
}

- (void)initializeZoom {
    //Initialize the ZoOm SDK using your app token
    [Zoom.sdk initializeWithAppToken:MY_ZOOM_DEVELOPER_TOKEN completion: ^ void (BOOL validationResult) {
        if(validationResult) {
            NSLog(@"AppToken validated successfully");
        }
        else {
            
            if([Zoom.sdk getStatus] != ZoomSDKStatusInitialized) {
                [self showInitFailedDialog];
            }
        }
    }];
    
    // Create the customization object
    ZoomCustomization *currentCustomization = [[ZoomCustomization alloc] init];
    currentCustomization.showPreEnrollmentScreen = false;
    
    
    // Sample UI Customization: vertically center the ZoOm frame within the device's display
    centerZoomFrameCustomization(currentCustomization);
    
    // Apply the customization changes
    [Zoom.sdk setCustomization:currentCustomization];
    [Zoom.sdk setAuditTrailType:ZoomAuditTrailTypeHeight640];
}

- (void) showInitFailedDialog {
    // initialization failed to show alert view
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Initialization Failed"
                                 message:@"Please check that you have set your ZoOm app token to the MY_ZOOM_DEVELOPER_APP_TOKEN variable in this file.  To retrieve your app token, visit https://dev.zoomlogin.com/zoomsdk/#/account."
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {}
                               ];
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) onZoomVerificationResultWithResult:(id<ZoomVerificationResult>)result {
    
    // CASE: you did not set a public key before attempting to retrieve a facemap.
    // Retrieving facemaps requires that you generate a public/private key pair per the instructions at https://dev.zoomlogin.com/zoomsdk/#/zoom-server-guide
    if([result status] == ZoomVerificationStatusFailedBecauseEncryptionKeyInvalid) {
        // encryption key invalid to show alert view
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Public Key Not Set"
                                                                                 message:@"Retrieving facemaps requires that you generate a public/private key pair per the instructions at https://dev.zoomlogin.com/zoomsdk/#/zoom-server-guide"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:true completion:nil];
    }
    // CASE: user performed a ZoOm and passed the liveness check
    else if([result status] == ZoomVerificationStatusUserProcessedSuccessfully)
    {
        // ZoOm has completed, pass the facemap to your desired API for processing
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"%@..",NSLocalizedString(@"Loading", @"")] maskType:SVProgressHUDMaskTypeBlack];
        [self handleVerificationSuccessResult:result];
        
    }
    else {
        // Handle other error
    }
}

- (void)configureGradientBackground:(NSArray*)colors inLayer:(CALayer*)layer {
    CAGradientLayer* gradient = [[CAGradientLayer alloc] init];
    
    gradient.frame = [UIScreen mainScreen].bounds;
    gradient.colors = colors;
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint   = CGPointMake(1, 0);
    
    [layer addSublayer:gradient];
}

/**
 * This method use set custom Frame lunchZoom
 * Sets top margin of the ZoOm frame so that the frame is centered vertically on the device's display
 */

static void centerZoomFrameCustomization(ZoomCustomization *currentCustomization) {
    
    CGFloat screenHeight = UIScreen.mainScreen.fixedCoordinateSpace.bounds.size.height;
    CGFloat frameHeight = screenHeight * currentCustomization.frameCustomization.sizeRatio;
    // Detect iPhone X and iPad displays
    if(UIScreen.mainScreen.fixedCoordinateSpace.bounds.size.height >= 812) {
        frameHeight = UIScreen.mainScreen.fixedCoordinateSpace.bounds.size.width * (16.0/9.0) * currentCustomization.frameCustomization.sizeRatio;
    }
    CGFloat topMarginToCenterFrame = (screenHeight - frameHeight)/2.0;
    
    currentCustomization.frameCustomization.topMargin = topMarginToCenterFrame;
}

// ----------      image rotation    ---------
- (void)loadPhotoCaptured
{
    UIImage *img = [[[self allImageViewsSubViews:[[[picker viewControllers]firstObject] view]] lastObject] image];
    if (img)
    {
        [self imagePickerController:picker didFinishPickingMediaWithInfo:[NSDictionary dictionaryWithObject:img forKey:UIImagePickerControllerOriginalImage]];
    }
    else
    {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

/**
 * This method use get captured view
 * Parameters to Pass: UIView
 *
 * This method will return array of UIImageview
 */
- (NSMutableArray*)allImageViewsSubViews:(UIView *)view
{
    NSMutableArray *arrImageViews=[NSMutableArray array];
    if ([view isKindOfClass:[UIImageView class]])
    {
        [arrImageViews addObject:view];
    }
    else
    {
        for (UIView *subview in [view subviews])
        {
            [arrImageViews addObjectsFromArray:[self allImageViewsSubViews:subview]];
        }
    }
    return arrImageViews;
}

//           ---- image picker controller method -----
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage* image ;
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"%@..",NSLocalizedString(@"Loading", @"")] maskType:SVProgressHUDMaskTypeBlack];
            
            if (image.size.width > image.size.height) {
                UIImage *imagePortrait = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationRight];
                matchImage = imagePortrait;
                NSLog(@"landscape");
            }else{
                matchImage = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationRight];
            }
            
            
            float facem_score = 0.0;
            if(picker.sourceType == UIImagePickerControllerSourceTypeCamera && picker.cameraDevice == UIImagePickerControllerCameraDeviceFront){
                UIImage * flippedImage = [UIImage imageWithCGImage:matchImage.CGImage scale:matchImage.scale orientation:UIImageOrientationLeftMirrored];
                matchImage = flippedImage; //capture image filp leftmirrored
            }
            
            CGSize scaledSize = CGSizeMake(image.size.width * 600/image.size.height, 600);
            matchImage = [GlobalMethods imageWithImage:image scaledToSize:scaledSize]; //Convert Image particular size
            
            if (faceRegion != nil){
                /*
                 FaceMatch SDK method call to detect Face in back image
                 @Params: BackImage, Front Face Image faceRegion
                 @Return: Face Image Frame
                 */
                NSFaceRegion* face2 = [EngineWrapper DetectTargetFaces:matchImage feature1:faceRegion.feature];
                /*
                 SDK method call to get FaceMatch Score
                 @Params: FrontImage Face, BackImage Face
                 @Return: Match Score
                 */
                facem_score = [EngineWrapper Identify:faceRegion.feature featurebuff2:face2.feature];
                matchImage = face2.image;
            }
            //Check FaceMatch score is zero or not
            if (facem_score != 0.0){
                bool isFindImg = false;
                //Update Facematch score
                for(int index = 0; index <  [arrDocumentData count]; index++){
                    NSMutableDictionary * dict = (NSMutableDictionary *)arrDocumentData[index] ;
                    for (NSString *key in dict.keyEnumerator) {
                        if (key == KEY_FACE_IMAGE){
                            NSDictionary *dic = @{ KEY_FACE_IMAGE2 : matchImage,KEY_FACE_IMAGE: dict[KEY_FACE_IMAGE] };
                            [arrDocumentData replaceObjectAtIndex:index withObject:dic];
                            isFindImg = true;
                        }
                        if (isFindImg){ break ;}
                    }
                }
                
                [self removeOldValue:@"LIVENESS SCORE : "];
                self->_btnFaceMathch.hidden = YES;
                [self removeOldValue:@"FACEMATCH SCORE : "];
                NSString *twoDecimalPlaces = [NSString stringWithFormat:@"%0.02f %%", facem_score * 100];
                NSDictionary *dic = @{ KEY_VALUE : twoDecimalPlaces ,KEY_TITLE:@"FACEMATCH SCORE : "};
                if([self->_isFrom isEqualToString:@"2"] || [self->_isFrom isEqualToString:@"3"]){
                    [arrDocumentData insertObject:dic atIndex:1];
                }else{
                    [arrDocumentData insertObject:dic atIndex:2];
                }
                [SVProgressHUD dismiss];
                [self->_tblView reloadData];
                NSIndexPath* ip = [NSIndexPath indexPathForRow:0 inSection:0];
                [self->_tblView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }else{
                [SVProgressHUD dismiss];
            }
        });
    });
}

/*
 This method use image convert particular size
 Parameters to Pass: UIImage and convert size
 
 This method will return convert UIImage
 and then explain the use of return value
 
 */
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

#pragma mark ------------ UITableView DataSource And Delegate ------
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSMutableDictionary *dictResultData;
    dictResultData = [[NSMutableDictionary alloc] init];
    dictResultData = arrDocumentData[indexPath.row];
    if (dictResultData[KEY_FACE_IMAGE] != nil){
        //Set User Image
        UserImgTableCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"UserImgTableCell1"];
        if (cell == nil) {
            cell = [[UserImgTableCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserImgTableCell1"];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if ((imageFace = dictResultData[KEY_FACE_IMAGE])) {
            cell.User_img2.hidden = YES;
            [cell.user_img setImage:imageFace];
        }
        if (dictResultData[KEY_FACE_IMAGE2] != nil){
            cell.User_img2.hidden = NO;
            if ((imageFace2 = dictResultData[KEY_FACE_IMAGE2])) {
                [cell.User_img2 setImage:imageFace2];
            }
        }
        return cell;
    }else if (dictResultData[KEY_TITLE] != nil || dictResultData[KEY_VALUE] != nil){
        //Set Document data
        ResultTableCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultTableCell1"];
        if (cell == nil) {
            cell = [[ResultTableCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserImgTableCell1"];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if ((dictResultData[KEY_TITLE] == nil && dictResultData[KEY_VALUE] != nil)){
            cell.lblValue.hidden = YES;
            cell.lblName.hidden = YES;
            cell.lblSingevalue.hidden = NO;
        }else{
            cell.lblValue.hidden = NO;
            cell.lblName.hidden = NO;
            cell.lblSingevalue.hidden = YES;
        }
        if ([dictResultData[KEY_TITLE] isEqualToString: @"FACEMATCH SCORE : "] || [dictResultData[KEY_TITLE] isEqualToString: @"LIVENESS SCORE : "])
        {
            cell.lblName.font = [UIFont boldSystemFontOfSize:14];
            cell.lblValue.font = [UIFont boldSystemFontOfSize:14];
            cell.lblName.textColor = [UIColor blackColor];
            cell.lblValue.textColor = [UIColor blackColor];
        }else{
            cell.lblName.font = [UIFont systemFontOfSize:14];
            cell.lblValue.font = [UIFont systemFontOfSize:14];
            cell.lblName.textColor = [UIColor darkGrayColor];
            cell.lblValue.textColor = [UIColor darkGrayColor];
        }
        cell.lblSingevalue.text = dictResultData[KEY_VALUE];
        cell.lblName.text = dictResultData[KEY_TITLE];
        cell.lblValue.text = dictResultData[KEY_VALUE];
        return cell;
    }else{
        //Set Document Images
        DocumentTableCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"DocumentTableCell1"];
        if (cell == nil) {
            cell = [[DocumentTableCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserImgTableCell1"];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.imgDocument.contentMode = UIViewContentModeScaleToFill;
        if (dictResultData[KEY_DOC1_IMAGE] != nil) {
            if([_isFrom isEqualToString:@"2"] || [_isFrom isEqualToString:@"3"]){
                cell.lblDocName.text = @"";
                cell.constraintLblHight.constant = 0;
            }else{
                cell.lblDocName.text = @"Front Side :";
                cell.constraintLblHight.constant = 25;
            }
            if ((imageDoc = dictResultData[KEY_DOC1_IMAGE])) {
                if ([fontImgRotation  isEqual: @"Left"]){
                    [cell.imgDocument setImage:[UIImage imageWithCGImage:imageDoc.CGImage scale:imageDoc.scale orientation:UIImageOrientationLeft]];
                }else if ([fontImgRotation  isEqual: @"Right"]){
                    [cell.imgDocument setImage:[UIImage imageWithCGImage:imageDoc.CGImage scale:imageDoc.scale orientation:UIImageOrientationRight]];
                }else{
                    [cell.imgDocument setImage:imageDoc];
                }
                
            }
        }else{
            cell.lblDocName.text = @"";
            cell.constraintLblHight.constant = 0;
        }
        if (dictResultData[KEY_DOC2_IMAGE] != nil) {
            if([_isFrom isEqualToString:@"2"] || [_isFrom isEqualToString:@"3"]){
                cell.lblDocName.text = @"";
                cell.constraintLblHight.constant = 0;
            }else{
                cell.lblDocName.text = @"Back Side :";
                cell.constraintLblHight.constant = 25;
            }
            if ((imageDoc2 = dictResultData[KEY_DOC2_IMAGE])) {
                
                if ([BackImgRotation  isEqual: @"Left"]){
                    [cell.imgDocument setImage:[UIImage imageWithCGImage:imageDoc2.CGImage scale:imageDoc2.scale orientation:UIImageOrientationLeft]];
                }else if ([BackImgRotation  isEqual: @"Right"]){
                    [cell.imgDocument setImage:[UIImage imageWithCGImage:imageDoc2.CGImage scale:imageDoc2.scale orientation:UIImageOrientationRight]];
                }else{
                    [cell.imgDocument setImage:imageDoc2];
                }
          }
        }else{
            cell.lblDocName.text = @"";
            cell.constraintLblHight.constant = 0;
        }
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrDocumentData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dictResultData;
    dictResultData = [[NSMutableDictionary alloc] init];
    dictResultData = arrDocumentData[indexPath.row];
    if (dictResultData[KEY_FACE_IMAGE] != nil){
        return 140.0;
    } else if (dictResultData[KEY_TITLE] == nil && dictResultData[KEY_VALUE] != nil){
        return 90.0;
    }else if (dictResultData[KEY_TITLE] != nil || dictResultData[KEY_VALUE] != nil){
        return 44.0;
    }else if (dictResultData[KEY_DOC1_IMAGE] != nil || dictResultData[KEY_DOC2_IMAGE] != nil){
        return 240.0;
    }else{
        return 0.0;
    }
}

#pragma mark ------------ UIButton Action ------
- (IBAction)btnLivenessAction:(UIButton *)sender {
    
    uniqStr= [[NSProcessInfo processInfo] globallyUniqueString];

    if (photoImage != nil)
    {
        [self launchZoomToVerifyLivenessAndRetrieveFacemap]; //lunchZoom setup
    }
    else
    {
        [self launchZoomToVerifyLivenessAndRetrieveFacemap]; //lunchZoom setup
    }
}

- (IBAction)btnFaceMatchAction:(UIButton *)sender {
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsImageEditing = NO;
    picker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    [self presentModalViewController:picker animated:YES];
}

- (IBAction)btnCancelAction:(UIButton *)sender {
   [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnBackAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -------------------------------- API Delegate ---------------------
- (void)customURLConnectionDidFinishLoading:(CustomAFNetWorking *)connection withTag:(int)tagCon withResponse:(id)response
{
    [SVProgressHUD dismiss];
    if (tagCon == LivenessTag){
        NSDictionary * dictResponse  = (NSDictionary *)response ;
        NSDictionary *dictFinalResponse = [dictResponse valueForKey:@"data"];
        
        if ([dictFinalResponse valueForKey:@"livenessResult"] != nil){
            stLivenessResult = [dictFinalResponse valueForKey:@"livenessResult"];
        }
        
        if ([dictFinalResponse valueForKey:@"livenessScore"] != nil){
            [self removeOldValue:@"LIVENESS SCORE : "];
            _btnLiveness.hidden = YES;
            double livenessScore = [[dictFinalResponse valueForKey:@"livenessScore"] doubleValue];
            NSString *twoDecimalPlaces = [NSString stringWithFormat:@"%0.02f %%", livenessScore];
            NSDictionary *dic = @{ KEY_VALUE : twoDecimalPlaces ,KEY_TITLE:@"LIVENESS SCORE : "};
            if([_isFrom isEqualToString:@"2"] || [_isFrom isEqualToString:@"3"]){
                [arrDocumentData insertObject:dic atIndex:1];
            }else{
                [arrDocumentData insertObject:dic atIndex:2];
            }
            [_tblView reloadData];
            NSIndexPath* ip = [NSIndexPath indexPathForRow:0 inSection:0];
            [_tblView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
}

- (void)customURLConnection:(CustomAFNetWorking *)connection withTag:(int)tagCon didFailWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
}

//Remove Same Value
- (void)removeOldValue:(NSString *)removeKey
{
    NSString *removeIndex;
    for(int index = 0; index <  [arrDocumentData count]; index++){
        NSDictionary * dict = (NSDictionary *)arrDocumentData[index] ;
        if (dict[KEY_TITLE] != nil){
            if ([dict valueForKey:KEY_TITLE] == removeKey){
                removeIndex = [[NSNumber numberWithInt:index] stringValue];;
            }
            [_tblView reloadData];
        }
    }
    if (removeIndex != nil) {
        [arrDocumentData removeObjectAtIndex:([removeIndex integerValue])];
    }
}
@end
