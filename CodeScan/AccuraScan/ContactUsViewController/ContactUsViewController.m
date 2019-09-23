//
//  ContactUsViewController.m
//  Passport
//
//  Created by akshay on 3/14/17.
//  Copyright © 2017 Alexander Shishkov & Kirill Kornyakov. All rights reserved.
//

#import "ContactUsViewController.h"
#import "WebServiceUrl.h"
#import "WebAPIRequest.h"
#import "SVProgressHUD.h"
#import "GlobalMethods.h"
#import "ModelManager.h"
#import <MessageUI/MessageUI.h>
#import "NDHTMLtoPDF.h"
#import "MenuViewController.h"
//#import "LibXL/libxl.h"
#import "WebAPIRequest.h"
@interface ContactUsViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate,UIActionSheetDelegate,NDHTMLtoPDFDelegate,UIScrollViewDelegate>
{
    NSMutableArray *arr_country;
    NSMutableDictionary *dataDict;
    NSMutableArray *dataArr,*scanInfoArray;
    ModelManager *mgrObj;
    BOOL isPdf;
    NSString *contry;

}
@end

@implementation ContactUsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    mgrObj=[ModelManager getInstance];
    

    if ([_fromMenu isEqualToString:@"1"])
    {
        btn_back.hidden = YES;
        btnCancel.hidden = NO;
    
    }
    else
    {
        btn_back.hidden = NO;
        btnCancel.hidden = YES;
    }
//    scoll.delaysContentTouches = true;
//    scoll.canCancelContentTouches = true;
    // for place holder color
    txtMsg.textColor = [UIColor whiteColor];
    txtMsg.text = @"LEAVE YOUR MESSAGE";
    txtMsg.delegate=self;
    [txtCompanyName setValue:PLACEHOLDER forKeyPath:@"_placeholderLabel.textColor"];
    [txtCountry setValue:PLACEHOLDER forKeyPath:@"_placeholderLabel.textColor"];
    [txtEmailID setValue:PLACEHOLDER forKeyPath:@"_placeholderLabel.textColor"];
    [txtCell setValue:PLACEHOLDER forKeyPath:@"_placeholderLabel.textColor"];
    [txtName setValue:PLACEHOLDER forKeyPath:@"_placeholderLabel.textColor"];
    // for picker view
    country_list_picker.showsSelectionIndicator = YES;
    country_list_picker.delegate = self;
    country_list_picker.hidden = YES;
    toolbar.hidden = YES;

    // array for country
    arr_country=[[NSMutableArray alloc]init];
    arr_country = [@[@"Afghanistan",
                     @"Albania",
                     @"Algeria",
                     @"Andorra",
                     @"Angola",
                     @"Antigua and Barbuda",
                     @"Argentina",
                     @"Armenia",
                     @"Aruba",
                     @"Australia",
                     @"Austria",
                     @"Azerbaijan",
                     @"Bahamas",
                     @"Bahrain",
                     @"Bangladesh",
                     @"Barbados",
                     @"Belarus",
                     @"Belgium",
                     @"Belize",
                     @"Benin",
                     @"Bhutan",
                     @"Bolivia",
                     @"Bosnia and Herzegovina",
                     @"Botswana",
                     @"Brazil",
                     @"Brunei",
                     @"Bulgaria",
                     @"Burkina Faso",
                     @"Burma",
                     @"Burundi",
                     @"Cambodia",
                     @"Cameroon",
                     @"Canada",
                     @"Cabo Verde",
                     @"Central African Republic",
                     @"Chad",
                     @"Chile",
                     @"China",
                     @"Colombia",
                     @"Comoros",
                     @"Czech Republic",
                     @"Costa Rica",
                     @"Cote d'Ivoire",
                     @"Croatia",
                     @"Cuba",
                     @"Curacao",
                     @"Cyprus",
                     @"Czechia",
                     @"Denmark",
                     @"Democratic Republic of Congo",
                     @"Djibouti",
                     @"Dominica",
                     @"Dominican Republic",
                     @"East Timor (see Timor-Leste)",
                     @"Ecuador",
                     @"Egypt",
                     @"El Salvador",
                     @"Equatorial Guinea",
                     @"Eritrea",
                     @"Estonia",
                     @"Ethiopia",
                     @"Fiji",
                     @"Finland",
                     @"France",
                     @"Gabon",
                     @"Gambia, The",
                     @"Georgia",
                     @"Germany",
                     @"Ghana",
                     @"Greece",
                     @"Grenada",
                     @"Guatemala",
                     @"Guinea",
                     @"Guinea-Bissau",
                     @"Guyana",
                     @"Haiti",
                     @"Holy See",
                     @"Honduras",
                     @"Hong Kong",
                     @"Hungary",
                     @"Iceland",
                     @"India",
                     @"Indonesia",
                     @"Iran",
                     @"Iraq",
                     @"Ireland",
                     @"Israel",
                     @"Italy",
                     @"Jamaica",
                     @"Japan",
                     @"Jordan",
                     @"Kazakhstan",
                     @"Kenya",
                     @"Kiribati",
                     @"Korea, North",
                     @"Korea, South",
                     @"Kosovo",
                     @"Kuwait",
                     @"Kyrgyzstan",
                     @"Laos",
                     @"Latvi",
                     @"Lebanon",
                     @"Lesotho",
                     @"Liberia",
                     @"Libya",
                     @"Liechtenstein",
                     @"Lithuania",
                     @"Luxembourg",
                     @"Macau",
                     @"Macedonia",
                     @"Madagascar",
                     @"Malawi",
                     @"Malaysia",
                     @"Maldives",
                     @"Mali",
                     @"Malta",
                     @"Marshall Islands",
                     @"Mauritania",
                     @"Mauritius",
                     @"Mexico",
                     @"Micronesia",
                     @"Monaco",
                     @"Mongolia",
                     @"Montenegro",
                     @"Morocco",
                     @"Mozambique",
                     @"Namibia",
                     @"Nauru",
                     @"Nepal",
                     @"Netherlands",
                     @"New Zealand",
                     @"Nicaragua",
                     @"Niger",
                     @"Nigeria",
                     @"North Korea",
                     @"Norway",
                     @"Oman",
                     @"Pakistan",
                     @"Palau",
                     @"Palestinian Territories",
                     @"Panama",
                     @"Papua New Guinea",
                     @"Paraguay",
                     @"Peru",
                     @"Philippines",
                     @"Poland",
                     @"Portugal",
                     @"Qatar",
                     @"Romania",
                     @"Russia",
                     @"Rwanda",
                     @"Saint Kitts and Nevis",
                     @"Saint Lucia",
                     @"Saint Vincent and the Grenadines",
                     @"Samoa",
                     @"San Marino",
                     @"Sao Tome and Principe",
                     @"Saudi Arabia",
                     @"Senegal",
                     @"Serbia",
                     @"Seychelles",
                     @"Sierra Leone",
                     @"Singapore",
                     @"Sint Maarten",
                     @"Slovakia",
                     @"Slovenia",
                     @"Solomon Islands",
                     @"Somalia",
                     @"South Africa",
                     @"South Korea",
                     @"South Sudan",
                     @"Spain",
                     @"Sri Lanka",
                     @"Sudan",
                     @"Suriname",
                     @"Swaziland",
                     @"Sweden",
                     @"Switzerland",
                     @"Syria",
                     @"Taiwan",
                     @"Tajikistan",
                     @"Tanzania",
                     @"Thailand",
                     @"Timor-Leste",
                     @"Togo",
                     @"Tonga",
                     @"Trinidad and Tobago",
                     @"Tunisia",
                     @"Turkey",
                     @"Turkmenistan",
                     @"Tuvalu",
                     @"Uganda",
                     @"Ukraine",
                     @"United Arab Emirates",
                     @"United Kingdom",
                     @"Uruguay",
                     @"Uzbekistan",
                     @"Vanuatu",
                     @"Venezuela",
                     @"Vietnam",
                     @"Yemen",
                     @"Zambia",
                     @"Zimbabwe"
                     ]mutableCopy];
//    [arr_country addObject:@"Austria"];
//    [arr_country addObject:@"Afghanistan"];
//    [arr_country addObject:@"Brazil"];
//    [arr_country addObject:@"Belgium"];
//    [arr_country addObject:@"Cambodia"];
//    [arr_country addObject:@"China"];
//    [arr_country addObject:@"Colombia"];
//    [arr_country addObject:@"Canada"];
//    [arr_country addObject:@"Denmark"];
//    [arr_country addObject:@"Dominica"];
//    [arr_country addObject:@"Estonia"];
//    [arr_country addObject:@"Ethiopia"];
//    [arr_country addObject:@"France"];
//    [arr_country addObject:@"Germany"];
//    [arr_country addObject:@"Gabon"];
//    [arr_country addObject:@"Iceland"];
//    [arr_country addObject:@"India"];
//    [arr_country addObject:@"Iran"];
//    [arr_country addObject:@"Iraq"];
//    [arr_country addObject:@"Ireland"];
//    [arr_country addObject:@"Japan"];
//    [arr_country addObject:@"Kuwait"];
//    [arr_country addObject:@"Malaysia"];
//    [arr_country addObject:@"Nepal"];
//    [arr_country addObject:@"Netherlands"];
//    [arr_country addObject:@"New Zealand"];
//    [arr_country addObject:@"Norway"];
//    [arr_country addObject:@"Oman"];
//    [arr_country addObject:@"Pakistan"];
//    [arr_country addObject:@"Peru"];
//    [arr_country addObject:@"Qatar"];
//    [arr_country addObject:@"Russia"];
//    [arr_country addObject:@"Singapore"];
//    [arr_country addObject:@"Switzerland"];
//    [arr_country addObject:@"Turkey"];
//    [arr_country addObject:@"United States of America (USA)"];
//    [arr_country addObject:@"United Kingdom (UK)"];
//    [arr_country addObject:@"Venezuela"];
//    [arr_country addObject:@"Yemen"];
//    [arr_country addObject:@"Zambia"];
//    [arr_country addObject:@"Zimbabwe"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated
{
   

//    [btnSend setBackgroundColor:[UIColor greenColor]];
//    [btnSend setFrame:CGRectMake(lblContent.frame.origin.x ,lblContent.frame.origin.y + 50 , btnSend.frame.size.width, btnSend.frame.size.height)];
//    [viewInsideScroll addSubview:btnSend];
//    [scoll addSubview:viewInsideScroll];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma textfiled delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"done");
    country_list_picker.hidden = YES;
    toolbar.hidden = YES;

}
#pragma button action

- (IBAction)Done:(id)sender
{
    if (contry == nil)
    {
        txtCountry.text = [arr_country objectAtIndex:0];
    }
    else
    {
    txtCountry.text = contry;
    }
    country_list_picker.hidden=YES;
    toolbar.hidden=YES;
}

- (IBAction)cancel:(id)sender
{
    txtCountry.text = @"";
    country_list_picker.hidden=YES;
    toolbar.hidden=YES;
}


- (IBAction)exportDataAction:(id)sender
{
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select Sharing option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Export Excel Sheet",
                            @"Export PDF",
                            nil];
    popup.tag = 1;
    [popup showInView:self.view];
    
    
    

}
-(void)createExcel
{
    isPdf=NO;
    dataArr = [mgrObj displayData:@"forScanData"];
    NSLog(@"%@",dataArr);
    scanInfoArray=[[NSMutableArray alloc]init];
    
    for (int i = 0;i<dataArr.count;i++)
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setValue:[NSString stringWithFormat:@"%d",i+1] forKey:@"SR NO"];
        [dict setValue:[[dataArr objectAtIndex:i]valueForKey:@"docType"] forKey:@"DOCUMENT TYPE"];
        [dict setValue:[[dataArr objectAtIndex:i]valueForKey:@"first_name"] forKey:@"FIRST NAME"];
        [dict setValue:[[dataArr objectAtIndex:i]valueForKey:@"last_name"] forKey:@"LAST NAME"];
        [dict setValue:[[dataArr objectAtIndex:i] valueForKey:@"DOB"] forKey:@"DOB"];
        [dict setValue:[[dataArr objectAtIndex:i] valueForKey:@"DOE"] forKey:@"DOE"];
        [dict setValue:[[dataArr objectAtIndex:i] valueForKey:@"country"] forKey:@"COUNTRY"];
//        [dict setValue:[[dataArr objectAtIndex:i] valueForKey:@"date"] forKey:@"DATE"];
        [dict setValue:[[dataArr objectAtIndex:i] valueForKey:@"gender"]forKey:@"GENDER"];
        [dict setValue:[[dataArr objectAtIndex:i] valueForKey:@"passport_no"] forKey:@"DOCUMENT NO"];
        
        
        [scanInfoArray addObject:dict];
        
    }
    if ([dataArr count] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:APPNAME
                                                            message:@"No data to export"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        [self callExcel];
        
    }
    

}
-(void)createPdf
{
    isPdf=YES;

    dataArr = [mgrObj displayData:@"forScanData"];
    NSLog(@"%@",dataArr);
    scanInfoArray=[[NSMutableArray alloc]init];
    
    for (int i = 0;i<dataArr.count;i++)
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setValue:[NSString stringWithFormat:@"%d",i+1] forKey:@"SR NO"];
        [dict setValue:[[dataArr objectAtIndex:i]valueForKey:@"docType"] forKey:@"DOCUMENT TYPE"];
        [dict setValue:[[dataArr objectAtIndex:i]valueForKey:@"first_name"] forKey:@"FIRST NAME"];
        [dict setValue:[[dataArr objectAtIndex:i]valueForKey:@"last_name"] forKey:@"LAST NAME"];
        [dict setValue:[[dataArr objectAtIndex:i] valueForKey:@"DOB"] forKey:@"DOB"];
        [dict setValue:[[dataArr objectAtIndex:i] valueForKey:@"DOE"] forKey:@"DOE"];
        [dict setValue:[[dataArr objectAtIndex:i] valueForKey:@"country"] forKey:@"COUNTRY"];
//        [dict setValue:[[dataArr objectAtIndex:i] valueForKey:@"date"] forKey:@"DATE"];
        [dict setValue:[[dataArr objectAtIndex:i] valueForKey:@"gender"]forKey:@"GENDER"];
        [dict setValue:[[dataArr objectAtIndex:i] valueForKey:@"passport_no"] forKey:@"DOCUMENT NO"];
        
        
        [scanInfoArray addObject:dict];
        
    }
    if ([dataArr count] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:APPNAME
                                                            message:@"No data to export"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        [self callPdf];
        
    }

}
-(void)callCsv
{
    
    NSMutableString *csvString = [[NSMutableString alloc]initWithCapacity:0];
    [csvString appendString:@"SRNO, DOCUMENTTYPE, FIRSTNAME, LASTNAME, DOB, DOE, COUNTRY, GENDER, DOCUMENTNO, PHOTO\n"];
    int i=1;
    
    for (NSDictionary *dct in dataArr)
    {
        UIImage *img1=[self loadImage:[dct valueForKey:@"img"]];
        NSString *img = [self imageToNSString:img1];
        [csvString appendString:@"\n"];
        
        [csvString appendString:[NSString stringWithFormat:@"%d, %@, %@, %@, %@, %@, %@, %@, %@, %@",i,[dct valueForKey:@"docType"],[dct valueForKey:@"first_name"],[dct valueForKey:@"last_name"],[dct valueForKey:@"DOB"],[dct valueForKey:@"DOE"],[dct valueForKey:@"country"],[dct valueForKey:@"gender"],[dct valueForKey:@"passport_no"],img]];
        i++;
    }
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"scanneddata.csv"];
    [csvString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSMutableDictionary* attributes = [[NSMutableDictionary alloc] init];
    NSNumber* permission = [NSNumber numberWithLong: 0640];
    [attributes setObject: permission forKey: NSFilePosixPermissions];
    NSFileManager* fileSystem = [NSFileManager defaultManager];
    if (![fileSystem createFileAtPath: @"scanneddata.csv" contents: nil attributes: attributes])
    {
        [self mail:csvString];
        
    }
    
}

-(void)callExcel
//{
//    
//    NSMutableString *excel = [[NSMutableString alloc] init];
//    [excel appendString:@"<?xml version=\"1.0\"?>\n<?mso-application progid=\"Excel.Sheet\"?>\n<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:o=\"urn:schemas-microsoft-com:office:office\" "];
//    [excel appendString:@"xmlns:x=\"urn:schemas-microsoft-com:office:excel\" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:html=\"http://www.w3.org/TR/REC-html40\">\n<DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">"];
//    [excel appendString:@"<LastAuthor>Kuzora</LastAuthor>"];
//    [excel appendString:[NSString stringWithFormat:@"<Created>%@</Created>",[NSDate date]]];
//    [excel appendString:@"<Version>11.5606</Version>\n</DocumentProperties>\n<ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">\n<WindowHeight>6690</WindowHeight>\n<WindowWidth>14355</WindowWidth>"];
//    [excel appendString:@"<WindowTopX>360</WindowTopX>\n<WindowTopY>75</WindowTopY>\n<ProtectStructure>False</ProtectStructure>\n<ProtectWindows>False</ProtectWindows>\n</ExcelWorkbook>\n<Styles>"];
//    [excel appendString:@"<Style ss:ID=\"Default\" ss:Name=\"Normal\">\n<Alignment ss:Vertical=\"Bottom\"/>\n<Borders/>\n<Font/>\n<Interior/>\n<NumberFormat/>\n<Protection/>\n</Style>"];
//    [excel appendString:@"<Style ss:ID=\"s21\">\n<NumberFormat ss:Format=\"Medium Date\"/>\n</Style><Style ss:ID=\"s22\">\n<NumberFormat ss:Format=\"Short Date\"/>\n</Style></Styles>"];
//    
//    [excel appendString:@"<Worksheet ss:Name=\"User\">"];
//    [excel appendString:@"<Table ss:ExpandedColumnCount=\"8\" ss:ExpandedRowCount=\"2\" x:FullColumns=\"1\" x:FullRows=\"1\">"];
//    [excel appendString:@"<Row>"];
//    [excel appendString:@"<Cell><Data ss:Type=\"String\">SR NO</Data></Cell>"];
//    [excel appendString:@"<Cell><Data ss:Type=\"String\">DOCUMENT TYPE</Data></Cell>"];
//    [excel appendString:@"<Cell><Data ss:Type=\"String\">FIRST NAME</Data></Cell>"];
//    [excel appendString:@"<Cell><Data ss:Type=\"String\">LAST NAME</Data></Cell>"];
//    [excel appendString:@"<Cell><Data ss:Type=\"String\">DOB</Data></Cell>"];
//    [excel appendString:@"<Cell><Data ss:Type=\"String\">DOE</Data></Cell>"];
//    [excel appendString:@"<Cell><Data ss:Type=\"String\">COUNTRY</Data></Cell>"];
//    [excel appendString:@"<Cell><Data ss:Type=\"String\">GENDER</Data></Cell>"];
//    [excel appendString:@"<Cell><Data ss:Type=\"String\">DOCUMENT NO</Data></Cell>"];
//    [excel appendString:@"<Cell><Data ss:Type=\"String\">PHOTO</Data></Cell></Row>"];
//    
//    int i=1;
//    
//    for (NSDictionary *dct in dataArr)
//    {
//        UIImage *img1=[self loadImage:[dct valueForKey:@"img"]];
//        NSString *img = [self imageToNSString:img1];
//        [excel appendString:@"<Row>"];
//        [excel appendString:[NSString stringWithFormat:@"<Cell><Data ss:Type=\"Number\">%d</Data></Cell>",i]];
//        if ([dct valueForKey:@"docType"] == (id)[NSNull null] || [[dct valueForKey:@"docType"] length] == 0 || [[dct valueForKey:@"docType"] isEqualToString:@""])
//        {
//            [excel appendString:[NSString stringWithFormat:@"<Cell><Data ss:Type=\"String\"></Data></Cell>"]];
//        }
//        else
//        {
//            [excel appendString:[NSString stringWithFormat:@"<Cell><Data ss:Type=\"String\">%@</Data></Cell>",[dct valueForKey:@"docType"]]];
//        }
//        if ([dct valueForKey:@"first_name"] == (id)[NSNull null] || [[dct valueForKey:@"first_name"] length] == 0 || [[dct valueForKey:@"first_name"] isEqualToString:@""])
//        {
//            [excel appendString:[NSString stringWithFormat:@"<Cell><Data ss:Type=\"String\"></Data></Cell>"]];
//        }
//        else
//        {
//            NSCharacterSet *alphanumericSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
//            alphanumericSet = alphanumericSet.invertedSet;
//            NSString *firstname = [dct valueForKey:@"first_name"];
//            NSString *result = [firstname stringByTrimmingCharactersInSet:alphanumericSet];
//            [excel appendString:[NSString stringWithFormat:@"<Cell><Data ss:Type=\"String\">%@</Data></Cell>",result]];
//        }
//        if ([dct valueForKey:@"last_name"] == (id)[NSNull null] || [[dct valueForKey:@"last_name"] length] == 0 || [[dct valueForKey:@"last_name"] isEqualToString:@""])
//        {
//            [excel appendString:[NSString stringWithFormat:@"<Cell><Data ss:Type=\"String\"></Data></Cell>"]];
//        }
//        else
//        {
//            NSCharacterSet *alphanumericSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
//            alphanumericSet = alphanumericSet.invertedSet;
//            NSString *lastname = [dct valueForKey:@"last_name"];
//            NSString *result = [lastname stringByTrimmingCharactersInSet:alphanumericSet];
//            [excel appendString:[NSString stringWithFormat:@"<Cell><Data ss:Type=\"String\">%@</Data></Cell>",result]];
//        }
//        if ([dct valueForKey:@"DOB"] == (id)[NSNull null] || [[dct valueForKey:@"DOB"] length] == 0 ||[[dct valueForKey:@"DOB"] isEqualToString:@""] )
//        {
//            [excel appendString:[NSString stringWithFormat:@"<Cell><Data ss:Type=\"String\"></Data></Cell>"]];
//        }
//        else
//        {
//            [excel appendString:[NSString stringWithFormat:@"<Cell><Data ss:Type=\"String\">%@</Data></Cell>",[dct valueForKey:@"DOB"]]];
//        }
//        if ([dct valueForKey:@"DOE"] == (id)[NSNull null] || [[dct valueForKey:@"DOE"] length] == 0 || [[dct valueForKey:@"DOE"] isEqualToString:@""])
//        {
//            [excel appendString:[NSString stringWithFormat:@"<Cell><Data ss:Type=\"String\"></Data></Cell>"]];
//        }
//        else
//        {
//            [excel appendString:[NSString stringWithFormat:@"<Cell><Data ss:Type=\"String\">%@</Data></Cell>",[dct valueForKey:@"DOE"]]];
//        }
//        if ([dct valueForKey:@"country"] == (id)[NSNull null] || [[dct valueForKey:@"country"] length] == 0 || [[dct valueForKey:@"country"] isEqualToString:@""])
//        {
//            [excel appendString:[NSString stringWithFormat:@"<Cell><Data ss:Type=\"String\"></Data></Cell>"]];
//        }
//        else
//        {
//            
//            NSCharacterSet *alphanumericSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
//            alphanumericSet = alphanumericSet.invertedSet;
//            NSString *country = [dct valueForKey:@"country"];
//            NSString *result = [country stringByTrimmingCharactersInSet:alphanumericSet];
//            
//            [excel appendString:[NSString stringWithFormat:@"<Cell><Data ss:Type=\"String\">%@</Data></Cell>",result]];
//        }
//        if ([dct valueForKey:@"gender"] == (id)[NSNull null] || [[dct valueForKey:@"gender"] length] == 0 || [[dct valueForKey:@"gender"] isEqualToString:@""])
//        {
//            [excel appendString:[NSString stringWithFormat:@"<Cell><Data ss:Type=\"String\"></Data></Cell>"]];
//        }
//        else
//        {
//            [excel appendString:[NSString stringWithFormat:@"<Cell><Data ss:Type=\"String\">%@</Data></Cell>",[dct valueForKey:@"gender"]]];
//        }
//        if ([dct valueForKey:@"passport_no"] == (id)[NSNull null] || [[dct valueForKey:@"passport_no"] length] == 0 ||[[dct valueForKey:@"passport_no"] isEqualToString:@""])
//        {
//            [excel appendString:[NSString stringWithFormat:@"<Cell><Data ss:Type=\"String\"></Data></Cell>"]];
//        }
//        else
//        {
//            [excel appendString:[NSString stringWithFormat:@"<Cell><Data ss:Type=\"String\">%@</Data></Cell>",[dct valueForKey:@"passport_no"]]];
//        }
//        
//        [excel appendString:[NSString stringWithFormat:@"<Cell><Data ss:Type=\"String\">%@</Data></Cell>",img]];
//        [excel appendString:@"</Row>"];
//        i++;
//    }
//    [excel appendString:@"</Table><WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">"];
//    [excel appendString:@"<Selected/><LeftColumnVisible>4</LeftColumnVisible><Panes><Pane>"];
//    [excel appendString:@"<Number>3</Number><ActiveRow>2</ActiveRow><ActiveCol>2</ActiveCol>"];
//    [excel appendString:@"</Pane></Panes><ProtectObjects>False</ProtectObjects>"];
//    [excel appendString:@"<ProtectScenarios>False</ProtectScenarios></WorksheetOptions></Worksheet>"];
//    [excel appendString:@"</Workbook>"];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"scanneddata.xls"];
//    [excel writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    NSMutableDictionary* attributes = [[NSMutableDictionary alloc] init];
//    NSNumber* permission = [NSNumber numberWithLong: 0640];
//    [attributes setObject: permission forKey: NSFilePosixPermissions];
//    NSFileManager* fileSystem = [NSFileManager defaultManager];
//    if (![fileSystem createFileAtPath: @"scanneddata.xls" contents: nil attributes: attributes])
//    {
//        [self mail:excel];
//    }
//    
//}
{
    BookHandle book = xlCreateBook(); // use xlCreateXMLBook() for working with xlsx files
    
    SheetHandle sheet = xlBookAddSheet(book, "Sheet1", NULL);
    FormatHandle boldFormat = xlBookAddFormat(book, 0);
    
    xlSheetWriteStr(sheet, 1, 0, "SR NO", boldFormat);
    xlSheetWriteStr(sheet, 1, 1, "DOCUMENT TYPE", boldFormat);
    xlSheetWriteStr(sheet, 1, 2, "FIRST NAME", boldFormat);
    xlSheetWriteStr(sheet, 1, 3, "LAST NAME", boldFormat);
    xlSheetWriteStr(sheet, 1, 4, "DOB", boldFormat);
    xlSheetWriteStr(sheet, 1, 5, "DOE", boldFormat);
    xlSheetWriteStr(sheet, 1, 6, "COUNTRY", boldFormat);
    xlSheetWriteStr(sheet, 1, 7, "GENDER", boldFormat);
    xlSheetWriteStr(sheet, 1, 8, "DOCUMENT NO", boldFormat);
    //    xlSheetWriteStr(sheet, 1, 9, "PHOTO", boldFormat);
    
    int i=1;
    
    for (NSDictionary *dct in dataArr)
    {
        UIImage *img1=[self loadImage:[dct valueForKey:@"img"]];
        
        NSString *img = [self imageToNSString:img1];
        
               
        //        i,[dct valueForKey:@"docType"],[dct valueForKey:@"first_name"],[dct valueForKey:@"last_name"],[dct valueForKey:@"DOB"],[dct valueForKey:@"DOE"],[dct valueForKey:@"country"],[dct valueForKey:@"gender"],[dct valueForKey:@"passport_no"],img]];
        NSString *no = [NSString stringWithFormat:@"%d",i];
        const char *converted_back = [no UTF8String];
        const char *converted_back1,*converted_back2,*converted_back3,*converted_back4,*converted_back5,*converted_back6,*converted_back7,*converted_back8,*converted_back9;
        if ([dct valueForKey:@"docType"] == (id)[NSNull null] || [[dct valueForKey:@"docType"] length] == 0 || [[dct valueForKey:@"docType"] isEqualToString:@""])
        {
            converted_back1 = [@"" UTF8String];
        }
        else
        {
            converted_back1 = [[dct objectForKey:@"docType"] UTF8String];
            
        }
        if ([dct valueForKey:@"first_name"] == (id)[NSNull null] || [[dct valueForKey:@"first_name"] length] == 0 || [[dct valueForKey:@"first_name"] isEqualToString:@""])
        {
            converted_back2 = [@"" UTF8String];
            
        }
        else
        {
            converted_back2 = [[dct objectForKey:@"first_name"] UTF8String];
            
        }
        if ([dct valueForKey:@"last_name"] == (id)[NSNull null] || [[dct valueForKey:@"last_name"] length] == 0 || [[dct valueForKey:@"last_name"] isEqualToString:@""])
        {
            converted_back3 = [@"" UTF8String];
            
        }
        else
        {
            converted_back3 = [[dct objectForKey:@"last_name"] UTF8String];
            
        }
        if ([dct valueForKey:@"DOB"] == (id)[NSNull null] || [[dct valueForKey:@"DOB"] length] == 0 || [[dct valueForKey:@"DOB"] isEqualToString:@""])
        {
            converted_back4 = [@"" UTF8String];
            
        }
        else
        {
            converted_back4 = [[dct objectForKey:@"DOB"] UTF8String];
            
        }
        if ([dct valueForKey:@"DOE"] == (id)[NSNull null] || [[dct valueForKey:@"DOE"] length] == 0 || [[dct valueForKey:@"DOE"] isEqualToString:@""])
        {
            converted_back5 = [@"" UTF8String];
            
        }
        else
        {
            converted_back5 = [[dct objectForKey:@"DOE"] UTF8String];
            
        }
        if ([dct valueForKey:@"country"] == (id)[NSNull null] || [[dct valueForKey:@"country"] length] == 0 || [[dct valueForKey:@"country"] isEqualToString:@""])
        {
            converted_back6 = [@"" UTF8String];
            
        }
        else
        {
            converted_back6 = [[dct objectForKey:@"country"] UTF8String];
            
        }
        if ([dct valueForKey:@"gender"] == (id)[NSNull null] || [[dct valueForKey:@"gender"] length] == 0 || [[dct valueForKey:@"gender"] isEqualToString:@""])
        {
            converted_back7 = [@"" UTF8String];
            
        }
        else
        {
            converted_back7 = [[dct objectForKey:@"gender"] UTF8String];
            
        }
        if ([dct valueForKey:@"passport_no"] == (id)[NSNull null] || [[dct valueForKey:@"passport_no"] length] == 0 || [[dct valueForKey:@"passport_no"] isEqualToString:@""])
        {
            converted_back8 = [@"" UTF8String];
            
        }
        else
        {
            converted_back8 = [[dct objectForKey:@"passport_no"] UTF8String];
            
        }
        if ([dct valueForKey:@"img"] == (id)[NSNull null] || [[dct valueForKey:@"img"] length] == 0 || [[dct valueForKey:@"img"] isEqualToString:@""])
        {
            converted_back9 = [@"" UTF8String];
            
        }
        else
        {
            converted_back9 = [img UTF8String];
            
        }
        
        xlSheetWriteStr(sheet, i+2, 0, converted_back, 0);
        xlSheetWriteStr(sheet, i+2, 1, converted_back1, 0);
        xlSheetWriteStr(sheet, i+2, 2, converted_back2, 0);
        xlSheetWriteStr(sheet, i+2, 3, converted_back3, 0);
        xlSheetWriteStr(sheet, i+2, 4, converted_back4, 0);
        xlSheetWriteStr(sheet, i+2, 5, converted_back5, 0);
        xlSheetWriteStr(sheet, i+2, 6, converted_back6, 0);
        xlSheetWriteStr(sheet, i+2, 7, converted_back7, 0);
        xlSheetWriteStr(sheet, i+2, 8, converted_back8, 0);
        //        xlSheetWriteComment(sheet, i+2, 9, converted_back9,nil,200,50);
        
        i++;
    }
    
    
    NSString *documentPath =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [documentPath stringByAppendingPathComponent:@"scanneddata.xls"];
    xlBookSave(book, [filename UTF8String]);
    
    xlBookRelease(book);
    
    NSURL *URL = [NSURL fileURLWithPath:filename];
    NSArray *activityItems = [NSArray arrayWithObjects:URL, nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}

-(void)callPdf
{
    NSMutableString *csvString = [[NSMutableString alloc]initWithCapacity:0];
        [csvString appendString:@"<table  border=\"1\">"];
        [csvString appendString:@"<tr>"];
        [csvString appendString:@"<th>SR NO</th><th>DOCUMENT TYPE</th><th>FIRST NAME</th><th>LAST NAME</th><th>DOB</th><th>DOE</th><th>COUNTRY</th><th>GENDER</th><th>DOCUMENT NO</th><th>PHOTO</th>"];
        [csvString appendString:@"</tr>"];
    
        for (NSDictionary *dct in dataArr)
        {
            int i = 1;
            [csvString appendString:@"<tr>"];
           UIImage *img1=[self loadImage:[dct valueForKey:@"img"]];
    
            NSString *img = [self imageToNSString:img1];
    
            [csvString appendString:[NSString stringWithFormat:@"<td>%d</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td><img src=\"data:image/jpg;base64,%@\" alt=\"\" style=\"width: 100px;\"/></td>",i,[dct valueForKey:@"docType"],[dct valueForKey:@"first_name"],[dct valueForKey:@"last_name"],[dct valueForKey:@"DOB"],[dct valueForKey:@"DOE"],[dct valueForKey:@"country"],[dct valueForKey:@"gender"],[dct valueForKey:@"passport_no"],img]];
            [csvString appendString:@"</tr>"];
            i++;
    
        }
        [csvString appendString:@"<table>"];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"scanneddata.pdf"];
    self.PDFCreator = [NDHTMLtoPDF createPDFWithHTML:csvString pathForPDF:filePath delegate:self pageSize:kPaperSizeA4 margins:UIEdgeInsetsMake(10, 5, 10, 5)];
    
    
    
//        [csvString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//        NSMutableDictionary* attributes = [[NSMutableDictionary alloc] init];
//        NSNumber* permission = [NSNumber numberWithLong: 0640];
//        [attributes setObject: permission forKey: NSFilePosixPermissions];
//        NSFileManager* fileSystem = [NSFileManager defaultManager];
//        if (![fileSystem createFileAtPath: @"EmployeeRecords.pdf" contents: nil attributes: attributes])
//        {
//            [self mail:csvString];
//            
//        }


}
#pragma mark NDHTMLtoPDFDelegate

- (void)HTMLtoPDFDidSucceed:(NDHTMLtoPDF*)htmlToPDF
{
    NSString *result = [NSString stringWithFormat:@"%@", htmlToPDF.PDFpath];
    NSLog(@"%@",result);
    [self mail:result];

}

- (void)HTMLtoPDFDidFail:(NDHTMLtoPDF*)htmlToPDF
{
    NSString *result = [NSString stringWithFormat:@"HTMLtoPDF did fail (%@)", htmlToPDF];
    NSLog(@"%@",result);
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
- (UIImage *)loadImage:(NSString *)imageName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithString:imageName] ];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}
- (void) mail: (NSString*) filePath
{

    if (![MFMailComposeViewController canSendMail])
    {
        //Show alert that device cannot send email, this is because an email account     hasn't been setup.
    }
    
    else
    {
        
        //**EDIT HERE**
        //Use this to retrieve your recently saved file
        if (isPdf)
        {
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
            NSString *filename = [documentPath stringByAppendingPathComponent:@"scanneddata.pdf"];
            NSURL *URL = [NSURL fileURLWithPath:filename];
            NSArray *activityItems = [NSArray arrayWithObjects:URL, nil];
            UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            [self presentViewController:activityViewController animated:YES completion:nil];
//            //**END OF EDIT**
//            
//            NSString *mimeType = @"application/pdf"; //This should be the MIME type for els files. May want to double check.
//            NSData *fileData = [NSData dataWithContentsOfFile:filename];
//            NSString *fileNameWithExtension = @"scanneddata.pdf"; //This is what you want the file to be called on the email along with it's extension:
//            
//            //If you want to then delete the file:
//            NSError *error;
//            if (![[NSFileManager defaultManager] removeItemAtPath:filename error:&error])
//                NSLog(@"ERROR REMOVING FILE: %@", [error localizedDescription]);
//            
//            
//            //Send email
//            MFMailComposeViewController *mailMessage = [[MFMailComposeViewController alloc] init];
//            [mailMessage setMailComposeDelegate:self];
//            [mailMessage addAttachmentData:fileData mimeType:mimeType fileName:fileNameWithExtension];
//            [self presentViewController:mailMessage animated:YES completion:nil];
        }
        else
        {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filename = [documentPath stringByAppendingPathComponent:@"scanneddata.xls"];
            NSURL *URL = [NSURL fileURLWithPath:filename];
            NSArray *activityItems = [NSArray arrayWithObjects:URL, nil];
            UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            [self presentViewController:activityViewController animated:YES completion:nil];
//        //**END OF EDIT**
//        
//        NSString *mimeType = @"application/vnd.ms-excel"; //This should be the MIME type for els files. May want to double check.
//        NSData *fileData = [NSData dataWithContentsOfFile:filename];
//        NSString *fileNameWithExtension = @"scanneddata.xls"; //This is what you want the file to be called on the email along with it's extension:
//        
//        //If you want to then delete the file:
//        NSError *error;
//        if (![[NSFileManager defaultManager] removeItemAtPath:filename error:&error])
//            NSLog(@"ERROR REMOVING FILE: %@", [error localizedDescription]);
//        
//        
//        //Send email
//        MFMailComposeViewController *mailMessage = [[MFMailComposeViewController alloc] init];
//        [mailMessage setMailComposeDelegate:self];
//        [mailMessage addAttachmentData:fileData mimeType:mimeType fileName:fileNameWithExtension];
//        [self presentViewController:mailMessage animated:YES completion:nil];
        }
    }
}
- (NSString *)imageToNSString:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    
    return [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnSend:(id)sender
{
    //[WebAPIRequest postConatctData:self name:self.txtName.text phone:self.txtContactNumber.text email:self.txtEmail.text message:self.tvcDescription.text country_id:strId];
    if (txtCompanyName.text.length <= 0)
    {
        [GlobalMethods showAlertView:@"Please enter company name." withViewController:self];
        
    }
    else if (txtName.text.length <= 0)
    {
        [GlobalMethods showAlertView:@"Please enter name." withViewController:self];
        
    }
    else if (txtEmailID.text.length <= 0)
    {
        [GlobalMethods showAlertView:@"Please enter email." withViewController:self];
        
    }
    else if (![GlobalMethods IsValidEmail:txtEmailID.text]) {
        [GlobalMethods showAlertView:@"Invalid Email Address." withViewController:self];
        
    }
    else  if (txtCell.text.length <= 0)
    {
        [GlobalMethods showAlertView:@"Please enter phone no." withViewController:self];
        
    }
    else  if (txtCell.text.length > 12)
    {
        [GlobalMethods showAlertView:@"Please enter valid phone no." withViewController:self];
        
    }

    else if (txtCountry.text.length <= 0)
    {
        [GlobalMethods showAlertView:@"Please select country." withViewController:self];
        
    }
    else if (txtMsg.text.length <= 0)
    {
        [GlobalMethods showAlertView:@"Please leave your Message." withViewController:self];
        
    }
    else
    {
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"%@..",NSLocalizedString(@"Loading", @"")] maskType:SVProgressHUDMaskTypeBlack];
        
         [WebAPIRequest postConatctData:self name:txtName.text phone:txtCell.text email:txtEmailID.text companyName:txtCompanyName.text country:txtCountry.text q:@"contact" message:txtMsg.text];
    }
    //[WebAPIRequest postConatctData:self userID:@"1" contryID:@"1"];
}

- (IBAction)btnCountry:(id)sender
{
    [self.view endEditing:YES];
    country_list_picker.hidden = NO;
    toolbar.hidden= NO;
}
#pragma mark - UIPicker view delegate method -

//Columns in picker views

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView; {
    
    return 1;
}
//Rows in each Column

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return arr_country.count;
}

-(NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [arr_country objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    //tag chage
   contry=[arr_country objectAtIndex:row];
   

    
}

#pragma mark - WebResponse delegate

-(void)setData:(NSString *)message items:(NSString *)items withtag:(int)tag
{
    [SVProgressHUD dismiss];
    switch (tag)
    {
            case ContactUsTag:
            if([message length] == 0)
            {
                if([items length] != 0)
                {
                    
                    NSMutableDictionary *dicResponse = [items JSONValue];
                    
                    if ([[dicResponse valueForKey:@"status"]intValue] == 1)
                    {
                        
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:APPNAME
                                                                            message:[dicResponse valueForKey:@"message"]
                                                                           delegate:self
                                                                  cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil, nil];
                        alertView.delegate = self;
                        alertView.tag=10003;
                        [alertView show];

                    }
                    else
                    {
                        [GlobalMethods showAlertView:[dicResponse valueForKey:@"message"] withViewController:self];
                        txtCountry.text=@"";
                        txtCell.text=@"";
                        txtName.text=@"";
                        txtEmailID.text=@"";
                        txtCompanyName.text=@"";
                        txtMsg.text=@"";

                    }
                }
            }
            break;
            default:
            break;
    }
}
#pragma alert delegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10003)
    {
        
  
    if( 0 == buttonIndex )
    { //cancel button
        txtCountry.text=@"";
        txtCell.text=@"";
        txtName.text=@"";
        txtEmailID.text=@"";
        txtCompanyName.text=@"";
        txtMsg.text=@"";
        [self.navigationController popToRootViewControllerAnimated:YES];

    }
    else if ( 1 == buttonIndex )
    {
       
    }
          }
}
#pragma scroll view  Delegate

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    if ( [view isKindOfClass:[UIButton class]] ) {
        return YES;
    }
    
}
#pragma TEXT FEILD  Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
// return NO to disallow editing.
{
//    [self keyBoardAppeared];
    return YES;

}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
//    [self keyBoardDisappeared];
    return YES;
}
// became first responder

#pragma textview Delegate

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
//        [self keyBoardAppeared];

        txtMsg.text = @"";
        txtMsg.textColor = [UIColor whiteColor];
        country_list_picker.hidden = YES;
        toolbar.hidden = YES;

    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
//    [self keyBoardDisappeared];
    return YES;

}
-(void) keyBoardDisappeared
{
    CGRect frame = self.view.frame;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         self.view.frame = CGRectMake(frame.origin.x, frame.origin.y+215, frame.size.width, frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
}
-(void) keyBoardAppeared
{
    CGRect frame = self.view.frame;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         self.view.frame = CGRectMake(frame.origin.x, frame.origin.y-215, frame.size.width, frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
}
-(void) textViewDidChange:(UITextView *)textView
{
    country_list_picker.hidden = YES;
    toolbar.hidden = YES;

    if(txtMsg.text.length == 0){
        txtMsg.textColor = [UIColor whiteColor];
        txtMsg.text = @"LEAVE YOUR MESSAGE";
        [txtMsg resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    country_list_picker.hidden = YES;
    toolbar.hidden = YES;

    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if(txtMsg.text.length == 0){
            txtMsg.textColor = [UIColor whiteColor];
            txtMsg.text = @"LEAVE YOUR MESSAGE";
            [txtMsg resignFirstResponder];
        }
        return NO;
    }
    
    return YES;
}
#pragma  action sheet delegate
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self createExcel];
                    break;
                case 1:
                    [self createPdf];
                    break;
                    default:
                    break;
            }
            break;
        }
        
        default:
            break;
    }
}
- (IBAction)menuClick:(id)sender
{
    if ([_fromMenu isEqualToString:@"1"])
    {
        _fromMenu = @"0";
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        
    }
}

@end
