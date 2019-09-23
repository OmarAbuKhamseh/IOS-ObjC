//
//  Model.h
//  DataBaseDemo
//
//  Created by TheAppGuruz-New-6 on 22/02/14.
//  Copyright (c) 2014 TheAppGuruz-New-6. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
@property (nonatomic,strong) NSString *fName;
@property (nonatomic,strong) NSString *lName;
@property (nonatomic,strong) NSString *passNo;
@property (nonatomic,strong) NSString *country;
@property (nonatomic,strong) NSString *sex;
@property (nonatomic,strong) NSString *dob;
@property (nonatomic,strong) NSString *doe;
@property (nonatomic,strong) NSString *img;
@property (nonatomic,strong) NSString *grpId;
@property (nonatomic,strong) NSString *grpName;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *add;

@property (nonatomic,strong) NSString *docType;


// for grp data
@property(nonatomic,strong)NSString *grp_id;
@property (nonatomic,strong) NSString *group_name;
@property (nonatomic,strong) NSString *status;
@property(nonatomic,strong) NSString *user_id;
@property (nonatomic,strong) NSString *created_at;
@property (nonatomic,strong) NSString *updated_at;
@property (nonatomic,strong) NSString *group_scan_count;

// for zoom sdk

@property(nonatomic,strong)NSString *is_auth;
@property(nonatomic,strong)NSString *glass_des;
@property(nonatomic,strong)NSString *glass_scr;
@property(nonatomic,strong)NSString *live_res;
@property(nonatomic,strong)NSString *live_res_auth_face;
@property(nonatomic,strong)NSString *live_res_enrl_face;
@property(nonatomic,strong)NSString *live_scr;
@property(nonatomic,strong)NSString *live_scr_auth_face;
@property(nonatomic,strong)NSString *live_scr_enrl_face;
@property(nonatomic,strong)NSString *match_scr;
@property(nonatomic,strong)NSString *retry_sug;




@end
