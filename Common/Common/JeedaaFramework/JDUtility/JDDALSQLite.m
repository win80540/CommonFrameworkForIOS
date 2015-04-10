//
//  JDDALSQLite.m
//  qinyuan
//
//  Created by 田凯 on 15/3/23.
//  Copyright (c) 2015年 田凯. All rights reserved.
//

#import "JDDALSQLite.h"

NSString * getDataBasePath(NSString * dbName){
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSString *documentsDirectory=@"/DataBase/";
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",dbName]];
    DLog(@"database path : %@" , path);
    return path;
}


@implementation JDDALSQLite{
    FMDatabaseQueue *_queue;
    FMDatabase *_db;
    NSString *_dbName;
}
-(FMDatabaseQueue *)queue{
    return self->_queue;
}
-(FMDatabase *)db{
    return self->_db;
}
-(NSString *)dbName{
    return self->_dbName;
}

+(id)shareDataBaseQueue{
    static dispatch_once_t t;
    static JDDALSQLite *_self;
    dispatch_once(&t, ^{
        @autoreleasepool {
            _self=[[JDDALSQLite alloc] init];
            _self->_dbName=@"jeedaa.sqlite";
            NSString *dataBasePath=getDataBasePath(_self->_dbName);
            if (!dataBasePath) {
                dataBasePath=@"";
            }
            _self->_db= [FMDatabase databaseWithPath:dataBasePath];
            _self->_queue=[FMDatabaseQueue databaseQueueWithPath:dataBasePath];
        }
    });
    return _self;
}

+(id)shareDataBaseQueueWithDBName:(NSString *)dbName{
    static dispatch_once_t t;
    static NSMutableDictionary *_DALs;
    dispatch_once(&t, ^{
            _DALs=[[NSMutableDictionary alloc] init];
    });
    JDDALSQLite *_DALEntity=[_DALs objectForKey:dbName];
    if (!_DALEntity) {
        @synchronized(self){
            _DALEntity=[[JDDALSQLite alloc] init];
            _DALEntity->_dbName=dbName;
            NSString *path=getDataBasePath(dbName);
            _DALEntity->_db= [FMDatabase databaseWithPath:path];
            _DALEntity->_queue = [FMDatabaseQueue databaseQueueWithPath:path];
            [_DALs setObject:_DALEntity forKey:dbName];
        }
    }
    return _DALEntity;
}
@end
