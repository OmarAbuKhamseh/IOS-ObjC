//
//  ModelManager.h
//  DataBaseDemo
//
//  Created by TheAppGuruz-New-6 on 22/02/14.
//  Copyright (c) 2014 TheAppGuruz-New-6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
#import "FMDatabase.h"
#import "Util.h"

@interface ModelManager : NSObject

@property (nonatomic,strong) FMDatabase *database;

+(ModelManager *) getInstance;

-(NSMutableArray *) displayData:(NSString *)strIsFor;
-(void)deleteData:(Model *)data isFor:(NSString *)strIsFor grp_id:(NSString *)grp_id;

-(BOOL) insertData:(Model *)data
             isFor:(NSString *)strIsFor;
-(void)updateData:(Model *)data;
-(void)deleteData:(Model *)data
            isFor:(NSString *)strIsFor;
-(bool)countData:(NSString *)passNo;
-(int)countScanTotal;
-(int)countScanOffline;
-(int)countScanTotal:(NSString *)grp_id;
-(NSMutableArray *) displayData:(NSString *)strIsFor grp_id:(NSString *)grp_id;
//-(void)deleteData:(Model *)data
//            isFor:(NSString *)strIsFor
//           grp_id:(NSString *)grp_id;
-(NSUInteger)countGroupTotal:(NSMutableArray *)grpIdArr;
-(void)deleteData:(Model *)data isFor:(NSString *)strIsFor grp_id:(NSString *)grp_id arrid:(NSString *)arrid;

-(void)deleteData:(Model *)data isFor:(NSString *)strIsFor arrId:(NSString *)arrId;
@end
