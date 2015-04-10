//
//  JDDALSQLite.h
//  qinyuan
//
//  Created by 田凯 on 15/3/23.
//  Copyright (c) 2015年 田凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface JDDALSQLite : NSObject
+(id)shareDataBaseQueue;
+(id)shareDataBaseQueueWithDBName:(NSString *)dbName;
-(FMDatabaseQueue *)queue;
-(FMDatabase *)db;
-(NSString *)dbName;
@end
