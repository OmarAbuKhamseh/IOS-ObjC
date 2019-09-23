//
//  ModelManager.m
//  DataBaseDemo
//
//  Created by TheAppGuruz-New-6 on 22/02/14.
//  Copyright (c) 2014 TheAppGuruz-New-6. All rights reserved.
//

#import "ModelManager.h"
#import "FMDatabaseAdditions.h"
#import "GlobalMethods.h"
@implementation ModelManager

static ModelManager *instance=nil;

@synthesize database=_database;

+(ModelManager *) getInstance
{
    
    if(!instance)
    {
        instance=[[ModelManager alloc]init];
        instance.database=[FMDatabase databaseWithPath:[Util getFilePath:@"AccuraScan.sqlite"]];
    }
    return instance;
}

#pragma mark --------------------------- for insert data -------------------------

-(BOOL)insertData:(Model *)data isFor:(NSString *)strIsFor
{
    // for insert scan data
        BOOL isInserted;
        [instance.database open];
        NSString *date=[GlobalMethods dateStringFromDate:[NSDate date]];
        NSString *qry=[NSString stringWithFormat:@"INSERT INTO scanInfo first_name = %@ ,last_name = %@,passport_no = %@,country = %@,gender = %@,DOB =%@,DOE = %@,img = %@,group_id = %@,grpName = %@,date =%@,user_id = %@ docType = %@",data.fName,data.lName,data.passNo,data.country,data.sex,data.dob,data.doe,data.img,data.grpId,data.grpName,date,[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"],data.docType];
            NSLog(@"%@",qry);

    
            if ([data.docType isEqualToString:@"V"] || [data.docType isEqualToString:@"v"] )
            {
                data.docType = @"Visa";
            }
            else if ([data.docType isEqualToString:@"p"] || [data.docType isEqualToString:@"P"])
            {
                data.docType = @"Passport";
            }
            else if ([data.docType isEqualToString:@"d"] || [data.docType isEqualToString:@"D"])
            {
                data.docType = @"Driving Licence";
            }
            else
            {
                data.docType = @"ID";
            }
           

    
//        isInserted=[instance.database executeUpdate:@"INSERT INTO scanInfo (first_name,last_name,passport_no,country,gender,DOB,DOE,img,group_id,grpName,date,user_id,docType) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)",data.fName,data.lName,data.passNo,data.country,data.sex,data.dob,data.doe,data.img,data.grpId,data.grpName,date,[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"],data.docType];
    
    
//    is_auth
//
//    glass_des
//
//    glass_scr,
//
//    “live_res"
//
//     “live_res_auth_face"
//
//    “live_res_enrl_face"
//
//     “live_scr"
//
//     “live_scr_auth_face"
//
//     “live_scr_enrl_face"
//
//     “match_scr"
    
//     "retry_sug"
    
    NSLog(@"%@",data.live_scr_enrl_face);
    isInserted=[instance.database executeUpdate:@"INSERT INTO scanInfo (first_name,last_name,passport_no,country,gender,DOB,DOE,img,group_id,grpName,date,user_id,docType,is_auth,glass_des,glass_scr,live_res,live_res_auth_face,live_res_enrl_face,live_scr,live_scr_auth_face,live_scr_enrl_face,match_scr,retry_sug) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",data.fName,data.lName,data.passNo,data.country,data.sex,data.dob,data.doe,data.img,data.grpId,data.grpName,date,[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"],data.docType,data.is_auth,data.glass_des,data.glass_scr,data.live_res,data.live_res_auth_face,data.live_res_enrl_face,data.live_scr,data.live_scr_auth_face,data.live_scr_enrl_face,data.match_scr,data.retry_sug];
        [instance.database close];
        
        if(isInserted)
        {
            BOOL isDeleted=[instance.database executeUpdate:@"DELETE FROM scanInfo WHERE id NOT IN (SELECT id FROM (SELECT id FROM scanInfo ORDER BY id DESC LIMIT 0,10))"];
            if (isDeleted)
            {
                NSLog(@"delete Successfully");

            }
            else
            {
                NSLog(@"delete not Successfully");

            }
            NSLog(@"Inserted Successfully");
            
            return YES;
        }
        else
        {
            NSLog(@"Error occured while inserting");
            return NO;
        }
    
    
}

#pragma mark --------------------------- for update data -------------------------

-(void)updateData:(Model *)data
{
//    [instance.database open];
//    BOOL isUpdated=[instance.database executeUpdate:@"UPDATE userInfo SET fName=? WHERE lName=?",data.name,data.rollnum];
//    [instance.database close];
//    
//    if(isUpdated)
//        NSLog(@"Updated Successfully");
//    else
        NSLog(@"Error occured while Updating");
    
   // UPDATE scanInfo SET isSync=1 WHERE id=3
}

#pragma mark --------------------------- for delete data -------------------------

-(void)deleteData:(Model *)data isFor:(NSString *)strIsFor
{
    // for group data
    
    if ([strIsFor isEqualToString:@"forgrp"])
    {
        [instance.database open];
        NSString *qry=[NSString stringWithFormat:@"DELETE FROM groupInfo where user_id = %@",[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"]];
        NSLog(@"%@",qry);

        BOOL isDeleted=[instance.database executeUpdate:@"DELETE FROM groupInfo where user_id = ?",[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"]];
        [instance.database close];
        
        if(isDeleted)
            NSLog(@"Deleted Successfully");
        else
            NSLog(@"Error occured while Deleting");
    }
    // for scan data
    if ([strIsFor isEqualToString:@"forScanData"])
    {
        [instance.database open];
        NSString *qry=[NSString stringWithFormat:@"DELETE FROM scanInfo where user_id = %@",[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"]];
        NSLog(@"%@",qry);
        

        BOOL isDeleted=[instance.database executeUpdate:@"DELETE FROM scanInfo where user_id = ?",[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"]];
        [instance.database close];
        
        if(isDeleted)
            NSLog(@"Deleted Successfully");
        else
            NSLog(@"Error occured while Deleting");
    }
  
}
#pragma mark --------------------------- for sync delete data -------------------------

-(void)deleteData:(Model *)data isFor:(NSString *)strIsFor arrId:(NSString *)arrId
{
       // for scan data
    if ([strIsFor isEqualToString:@"forScanData"])
    {
        [instance.database open];
        NSString *qry=[NSString stringWithFormat:@"DELETE FROM scanInfo where user_id = %@ and id = %@",[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"],arrId];
        NSLog(@"%@",qry);
        
        
        BOOL isDeleted=[instance.database executeUpdate:@"DELETE FROM scanInfo where user_id = ? and id = ?",[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"],arrId];
        [instance.database close];
        
        if(isDeleted)
        {
            NSLog(@"Deleted Successfully");
            NSArray *arr=[self displayData:@"forScanData"];
            NSLog(@"%@",arr);

        }
        else
            NSLog(@"Error occured while Deleting");
    }
    
}


#pragma mark --------------------------- for display data -------------------------

-(NSMutableArray *) displayData:(NSString *)strIsFor
{
    NSMutableArray *grparr;
    
    // for display group data
    
    if ([strIsFor isEqualToString:@"forgrp"])
    {
        grparr=[[NSMutableArray alloc]init];
        [instance.database open];
        NSString *qry=[NSString stringWithFormat:@"SELECT * FROM groupInfo where user_id = %@",[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"]];
        NSLog(@"%@",qry);
        FMResultSet *resultSet=[instance.database executeQuery:@"SELECT * FROM groupInfo where user_id = ?",[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"]];
        if(resultSet)
        {
            while([resultSet next])
            [grparr addObject:[resultSet resultDictionary]];
        }
        [instance.database close];

    }
    
    // for display scan data

//    if ([strIsFor isEqualToString:@"forScanData"])
//    {
//        grparr=[[NSMutableArray alloc]init];
//        [instance.database open];
//        NSString *qry=[NSString stringWithFormat:@"SELECT * FROM scanInfo where user_id = %@",[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"]];
//        NSLog(@"%@",qry);
//
//        FMResultSet *resultSet=[instance.database executeQuery:@"SELECT * FROM scanInfo where user_id = ?",[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"]];
//        if(resultSet)
//        {
//            while([resultSet next])
//                [grparr addObject:[resultSet resultDictionary]];
//        }
//        [instance.database close];
//    }
    if ([strIsFor isEqualToString:@"forScanData"])
    {
        grparr=[[NSMutableArray alloc]init];
        [instance.database open];
        NSString *qry=[NSString stringWithFormat:@"SELECT * FROM scanInfo"];
        NSLog(@"%@",qry);
        
        FMResultSet *resultSet=[instance.database executeQuery:@"SELECT * FROM scanInfo ORDER  BY id desc limit 0 , 10"];
        if(resultSet)
        {
            while([resultSet next])
                [grparr addObject:[resultSet resultDictionary]];
        }
        [instance.database close];
    }

    return grparr;

}

#pragma mark --------------------------- for delete data group wise  -------------------------
-(void)deleteData:(Model *)data isFor:(NSString *)strIsFor grp_id:(NSString *)grp_id arrid:(NSString *)arrid
{
       if ([strIsFor isEqualToString:@"forScanData"]) {
        [instance.database open];
           NSString *qry=[NSString stringWithFormat:@"DELETE FROM scanInfo where group_id = %@ and user_id = %@ and id = %@",grp_id,[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"],arrid];
           NSLog(@"%@",qry);
        BOOL isDeleted=[instance.database executeUpdate:@"DELETE FROM scanInfo where group_id = ? and user_id = ? and id = ?",grp_id,[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"],arrid];
        [instance.database close];
        
        if(isDeleted)
        {
            NSLog(@"Deleted Successfully");
           NSArray *arr=[self displayData:@"forScanData"];
        }
        else
            NSLog(@"Error occured while Deleting");
    }
    
}
#pragma mark --------------------------- for DELETE data group wise  -------------------------

-(void)deleteData:(Model *)data isFor:(NSString *)strIsFor grp_id:(NSString *)grp_id
{
    if ([strIsFor isEqualToString:@"forScanData"]) {
        [instance.database open];
        NSString *qry=[NSString stringWithFormat:@"DELETE FROM scanInfo where group_id = %@ and user_id = %@",grp_id,[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"]];
        NSLog(@"%@",qry);
        BOOL isDeleted=[instance.database executeUpdate:@"DELETE FROM scanInfo where group_id = ? and user_id = ?",grp_id,[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"]];
        [instance.database close];
        
        if(isDeleted)
        {
            NSLog(@"Deleted Successfully");
            NSArray *arr=[self displayData:@"forScanData"];
        }
        else
            NSLog(@"Error occured while Deleting");
    }
}


#pragma mark --------------------------- for display data group wise  -------------------------

-(NSMutableArray *) displayData:(NSString *)strIsFor grp_id:(NSString *)grp_id
{
    NSMutableArray *grparr;
   
    if ([strIsFor isEqualToString:@"forScanData"])
    {
        grparr=[[NSMutableArray alloc]init];
        [instance.database open];
        
        NSString *qry=[NSString stringWithFormat:@"SELECT * FROM scanInfo where group_id = %@ and user_id = %@",grp_id,[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"]];
        NSLog(@"%@",qry);

        
        FMResultSet *resultSet=[instance.database executeQuery:@"SELECT * FROM scanInfo where group_id = ? and user_id = ?",grp_id,[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"]];
        if(resultSet)
        {
            while([resultSet next])
                [grparr addObject:[resultSet resultDictionary]];
        }
        [instance.database close];
    }
    return grparr;
    
}

#pragma mark --------------------------- for count total scan data  -------------------------

-(bool)countData:(NSString *)passNo
{
    [instance.database open];
   // FMResultSet *resultSet=[instance.database executeQuery:[NSString stringWithFormat:@"SELECT COUNT() as totalscan FROM scanInfo WHERE passNo LIKE '%@'",passNo]];
    NSString *qry=[NSString stringWithFormat:@"SELECT COUNT() as totalscan FROM scanInfo where user_id = %@",[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"]];
    NSLog(@"%@",qry);
    FMResultSet *resultSet=[instance.database executeQuery:@"SELECT COUNT() as totalscan FROM scanInfo where user_id = ?",[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"]];

    NSLog(@"%@",resultSet);
    NSString *count;
    if(resultSet)
    {
        while([resultSet next])
        {
            NSLog(@"count : %@",[resultSet stringForColumn:@"totalscan"]);
            count = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"totalscan"]];
        }
       
      
    }
    [instance.database close];
    if ([count intValue]<15)
    {
        return  YES;
    }
    else
    {
        return NO;
    }
    
}

#pragma mark --------------------------- for count total scan data of today(current date)  -------------------------

-(int)countScanTotal
{
    [instance.database open];
    // FMResultSet *resultSet=[instance.database executeQuery:[NSString stringWithFormat:@"SELECT COUNT() as totalscan FROM scanInfo WHERE passNo LIKE '%@'",passNo]];
   // FMResultSet *resultSet=[instance.database executeQuery:@"SELECT COUNT() as totalscan FROM scanInfo"];
    
    NSString *qry=[NSString stringWithFormat:@"SELECT COUNT() as totalscan FROM scanInfo where date =  DATE() and user_id = %@",[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"]];
    NSLog(@"%@",qry);
    FMResultSet *resultSet=[instance.database executeQuery:@"SELECT COUNT() as totalscan FROM scanInfo where date =  DATE() and user_id = ?",[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"]];
    NSLog(@"%@",resultSet);
    NSString *count;
    if(resultSet)
    {
        while([resultSet next])
        {
            NSLog(@"count : %@",[resultSet stringForColumn:@"totalscan"]);
            count = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"totalscan"]];
        }
    }
    [instance.database close];
    return [count intValue];
}

#pragma mark --------------------------- for count total scan data offline -------------------------

-(int)countScanOffline
{
    NSArray *arr=[self displayData:@"forScanData"];
    [instance.database open];
    // FMResultSet *resultSet=[instance.database executeQuery:[NSString stringWithFormat:@"SELECT COUNT() as totalscan FROM scanInfo WHERE passNo LIKE '%@'",passNo]];
    NSString *qry=[NSString stringWithFormat:@"SELECT COUNT() as totalscan FROM scanInfo where isSync = 0 and user_id = %@",[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"]];
    NSLog(@"%@",qry);
    FMResultSet *resultSet=[instance.database executeQuery:@"SELECT COUNT() as totalscan FROM scanInfo where isSync = 0 and user_id = ?",[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"]];
    
    NSLog(@"%@",resultSet);
    NSString *count;
    if(resultSet)
    {
        while([resultSet next])
        {
            NSLog(@"count : %@",[resultSet stringForColumn:@"totalscan"]);
            count = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"totalscan"]];
        }
        
    }
    [instance.database close];
    return [count intValue];
    
}

#pragma mark --------------------------- for count total scan group wise -------------------------

-(int)countScanTotal:(NSString *)grp_id
{
    [instance.database open];
    NSString *qry=[NSString stringWithFormat:@"SELECT COUNT() as totalscan FROM scanInfo where group_id = %@ and user_id = %@",grp_id,[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"]];
    NSLog(@"%@",qry);
    FMResultSet *resultSet=[instance.database executeQuery:@"SELECT COUNT() as totalscan FROM scanInfo where group_id = ? and user_id = ?",grp_id,[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"]];
    NSLog(@"%@",resultSet);
    NSString *count;
    if(resultSet)
    {
        while([resultSet next])
        {
            NSLog(@"count : %@",[resultSet stringForColumn:@"totalscan"]);
            count = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"totalscan"]];
        }
    }
    [instance.database close];
    return [count intValue];
}
#pragma mark --------------------------- for count total  group  -------------------------]
-(NSUInteger)countGroupTotal:(NSMutableArray *)grpIdArr
{
    [instance.database open];
   // FMResultSet *resultSet=[instance.database executeQuery:@"select count(group_id) as cnt from scanInfo"];
    NSString *qry=[NSString stringWithFormat:@"SELECT group_id FROM scanInfo where user_id = %@ group by group_id",[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"]];
    NSLog(@"%@",qry);
    FMResultSet *resultSet=[instance.database executeQuery:@"SELECT group_id FROM scanInfo where user_id = ? group by group_id",[[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"]];
    
   NSMutableArray *grparr=[[NSMutableArray alloc]init];


    if(resultSet)
    {
        while([resultSet next])
        {
            [grparr addObject:[resultSet resultDictionary]];
                          //condition 2
            
        }
        
    }
    [instance.database close];
    NSMutableArray *intermediate = [NSMutableArray arrayWithArray:grparr];
    [intermediate removeObjectsInArray:grpIdArr];
    NSUInteger difference = [intermediate count];
    NSLog(@"count : %lu",(unsigned long)difference);

    return difference;
    
}


@end
