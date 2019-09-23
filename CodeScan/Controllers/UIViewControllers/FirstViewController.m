//
//  FirstViewController.m
//  Accura Scan
//
//  Created by iOS on 27/7/2019.
//  Copyright © 2019 Elite Development LLC. All rights reserved.
//

#import "FirstViewController.h"
#import "FirstTableViewCell.h"
#import "ListViewController.h"
#import "FaceMatchController.h"
#import "Accura_Scan-Swift.h"

@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

# pragma mark ------ tableview delegate and datasource method -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FirstTableViewCell"];
    if (cell == nil)
    {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FirstTableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    switch (indexPath.row)
    {
            // check the accura scan type
        case 0:
        {
            cell.lblTitle.text = @"ACCURA OCR";
            cell.lblContent.text = @"Recognizes Passport & ID MRZ. Pan & Aadhaar Cards India, USA DL and All Barcodes. Works Offline";
            [cell.view setBackgroundColor:[UIColor colorWithRed:213.0 / 255.0 green:50.0 / 255.0 blue:63.0 / 255.0 alpha:1.0]];
            cell.view.layer.cornerRadius = 10;
            cell.imgIcon.image = [UIImage imageNamed:@"ocr"];
            cell.view.layer.masksToBounds = true;
        }
            break;
        case 1:
        {
            cell.lblTitle.text = @"ACCURA FACE MATCH";
            cell.lblContent.text = @"AI & ML Based Powerful Face Detection & Recognition Solution. 1:1 and 1:N. Works Offline";
            [cell.view setBackgroundColor:[UIColor colorWithRed:154.0 / 255.0 green:154.0 / 255.0 blue:154.0 / 255.0 alpha:1.0]];
            cell.view.layer.cornerRadius = 10;
            cell.imgIcon.image = [UIImage imageNamed:@"face_scan"];
            cell.view.layer.masksToBounds = true;
        }
            break;
            
        case 2:
        {
            cell.lblTitle.text = @"ACCURA AUTHENTICATION";
            cell.lblContent.text = @"eKYC and Digital Customer On-Boarding & Real Time Face Biometrics with Zoom Certified Liveness Detection for Real Time User Authentication";
            [cell.view setBackgroundColor:[UIColor colorWithRed:213.0 / 255.0 green:50.0 / 255.0 blue:63.0 / 255.0 alpha:1.0]];
            cell.view.layer.cornerRadius = 10;
            cell.imgIcon.image = [UIImage imageNamed:@"scan"];
            cell.view.layer.masksToBounds = true;
        }
            break;
        
        default:
        {
            return  nil;
        }
            break;
            
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    switch (indexPath.row)
    {
        case 0:
        {
            NSLog(@"Accura OCR");
            UIStoryboard* MainStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
            ListViewController *ocrVC =(ListViewController *)[MainStoryBoard instantiateViewControllerWithIdentifier:@"ListViewController"];
            ocrVC.navTitle = @"ACCURA OCR";
            appDelegate.firstVcType = @"ocr";
            [self.navigationController pushViewController:ocrVC animated:YES];
        }
            break;
        case 1:
        {
            NSLog(@"Face Match");
            UIStoryboard* MainStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
            FaceMatchController *faceVC =(FaceMatchController *)[MainStoryBoard instantiateViewControllerWithIdentifier:@"FaceMatchController"];
            
            [self.navigationController pushViewController:faceVC animated:YES];
        }
            break;
            
        case 2:
        {
            NSLog(@"Accura Scan");
            UIStoryboard* MainStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
            ListViewController *scanVC =(ListViewController *)[MainStoryBoard instantiateViewControllerWithIdentifier:@"ListViewController"];
            scanVC.navTitle = @"ACCURA SCAN";
            appDelegate.firstVcType = @"accura";
            [self.navigationController pushViewController:scanVC animated:YES];
            
        }
            break;
            
        default:
        {
        }
            break;
            
    }
    
}


@end
