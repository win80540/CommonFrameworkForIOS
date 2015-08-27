//
//  JDBaseModel.m
//  wetoolsSAAS
//
//  Created by 田凯 on 14-4-18.
//  Copyright (c) 2014年 田凯. All rights reserved.
//

#import "JDBaseModel.h"
#import "JDDateService.h"
#import "JDDALSQLite.h"
#import <objc/runtime.h>
static NSMutableDictionary *_dicForTable;
@implementation JDBaseModel{
    NSMutableDictionary *_undifinedKeyDic;
}

-(id)init{
    self=[super init];
    if (nil!=self) {
        self->_undifinedKeyDic=[NSMutableDictionary dictionary];
        //[self initValue];
    }
    return self;
}

//-(void)initValue{
//    unsigned int propertyCount=0;
//    objc_property_t *propertyArray=class_copyPropertyList([self class], &propertyCount);
//    for (unsigned int i=0; i<propertyCount; i++) {
//        objc_property_t propertyItem=propertyArray[i];
//        NSString *stringPropertyName=[NSString stringWithUTF8String:property_getName(propertyItem)];
//        NSString *attriutes= [NSString stringWithUTF8String:property_getAttributes(propertyItem)];
//        NSRange range=[attriutes rangeOfString:@"(?<=^T)(.+?)(?=,)"options:NSRegularExpressionSearch];
//        NSString *typeCode= [attriutes substringWithRange:range];
//        if([typeCode rangeOfString:@"String"].length>0){
//            [self setValue:@"" forKey:stringPropertyName];
//        }else if([typeCode rangeOfString:@"NSNumber"].length>0){
//            [self setValue:[NSNumber numberWithInt:0] forKey:stringPropertyName];
//        }else{
//            [self setValue:nil forKey:stringPropertyName];
//        }
//    }
//    free(propertyArray);
//}

-(id)initWithDictionary:(NSDictionary *)jsonData Extend:(BOOL)canExtend{
    self = [self init];
    if(self != nil){
        NSMutableArray *existKey=[NSMutableArray array];
        unsigned int propertyCount=0;
        objc_property_t *propertyArray=  class_copyPropertyList([self class], &propertyCount);
        for (int i=0; i<propertyCount; i++) {
            objc_property_t propertyItem=propertyArray[i];
            NSString *propertyName=[NSString stringWithUTF8String: property_getName(propertyItem)];
            if (canExtend) {
                [existKey addObject:propertyName];
            }
        }
        free(propertyArray);
        if(canExtend){
            for (NSString *key in [jsonData allKeys]) {
                BOOL exist=false;
                for (NSString *tempKey in existKey) {
                    if ([tempKey isEqualToString:key]) {
                        exist=true;
                        break;
                    }
                }
                if (exist) {
                    continue;
                }else{  
                    NSString* typeCode = NSStringFromClass([[jsonData valueForKey:key] class]) ;
                    objc_property_attribute_t type = { "T", [[NSString stringWithFormat:@"@\"%@\"",typeCode] UTF8String] };
                    objc_property_attribute_t ownership = { "&", "" }; // & = retain
                    objc_property_attribute_t ownership2 = { "N", "" }; // N = nonatomic
                    NSString *backingivarName=[NSString stringWithFormat:@"_%@",key];
                    objc_property_attribute_t backingivar  = { "V", [backingivarName UTF8String]};
                    objc_property_attribute_t attrs[] = { type, ownership,ownership2, backingivar};
                    class_addProperty([self class], [key UTF8String], attrs, 4);
                }
            }
        }
        [self setValuesForKeysWithDictionary:jsonData];
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)jsonData{
    return  [self initWithDictionary:jsonData Extend:true];
}

-(NSString *)getID{
    return _mainID;
}

-(void)setID:(NSString *)mainID{
    _mainID=mainID;
}

+(NSArray *)getALLPropertiesKey{
    NSMutableArray *existKey=[NSMutableArray array];
    unsigned int propertyCount=0;
    objc_property_t *propertyArray=  class_copyPropertyList(self, &propertyCount);
    for (int i=0; i<propertyCount; i++) {
        objc_property_t propertyItem=propertyArray[i];
        NSString *propertyName=[NSString stringWithUTF8String: property_getName(propertyItem)];
        [existKey addObject:propertyName];
    }
    free(propertyArray);
    return [NSArray arrayWithArray: existKey];
}

-(NSString*) description{
    unsigned int propertyCount=0;
    NSMutableArray *strArray=[NSMutableArray array];
    objc_property_t *propertyArray=class_copyPropertyList([self class], &propertyCount);
    for (unsigned int i=0; i<propertyCount; i++) {
        objc_property_t propertyItem=propertyArray[i];
        NSString *stringPropertyName=[NSString stringWithUTF8String:property_getName(propertyItem)];
        NSString *attriutes= [NSString stringWithUTF8String:property_getAttributes(propertyItem)];
        //NSRange range=[attriutes rangeOfString:@"(?<=^T)(.+?)(?=,)"options:NSRegularExpressionSearch];
        //NSString *typeCode= [attriutes substringWithRange:range];
        [strArray addObject:[NSString stringWithFormat:@"\n\"%@\":\"%@\"(%@)",stringPropertyName,[[self valueForKey:stringPropertyName] description],attriutes]];
    }
    free(propertyArray);
    return [strArray componentsJoinedByString:@""];
}


#pragma mark-KVC
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    [self->_undifinedKeyDic setValue:value forKey:key];
}
-(id)valueForUndefinedKey:(NSString *)key{
    return [self->_undifinedKeyDic valueForKey:key];
}

#pragma mark--DAL 
+(BOOL)insert:(JDBaseModel *)entity{
    [self prepareTable];
    __block BOOL success=false;
    [[[JDDALSQLite shareDataBaseQueue] queue] inDatabase:^(FMDatabase *db) {
        @autoreleasepool {
            NSMutableArray* keyArray=[NSMutableArray array];
            NSMutableArray* varArray=[NSMutableArray array];
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            unsigned int propertyCount=0;
            objc_property_t *propertyArray=  class_copyPropertyList([self class], &propertyCount);
            for (int i=0; i<propertyCount; i++) {
                objc_property_t propertyItem=propertyArray[i];
                NSString *propertyName=[NSString stringWithUTF8String: property_getName(propertyItem)];
                [keyArray addObject:propertyName];
                [varArray addObject:[NSString stringWithFormat:@":%@",propertyName]];
                [dic setValue:[NSNull null] forKey:propertyName];
            }
            free(propertyArray);
            [keyArray enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop) {
                id value=[entity valueForKey:key];
                if (value) {
                    [dic setObject:value forKey:key];
                }else{
                    [dic setObject:[NSNull null] forKey:key];
                }
                
            }];
            [dic setObject:[entity getID] forKey:@"ID"];
            NSString *sqlStr=[NSString stringWithFormat:@"INSERT INTO %s (ID,%@) VALUES (:ID,%@)",class_getName([entity class]),[keyArray componentsJoinedByString:@","],[varArray componentsJoinedByString:@","]];
            success=[db executeUpdate:sqlStr withParameterDictionary:dic];
            if (!success) {
                DLog(@"error:%d,message:%@",[db lastErrorCode],[db lastErrorMessage]);
            }

        }
    }];
    if (!success) {
        if ([self deleteTable] && [self prepareTable]) {
            return [self insert:entity];
        }
    }
    return success;
}
+(BOOL)inserts:(NSArray *)array{
    if (!array && array.count==0) {
        return false;
    }
    [self prepareTable];
    Class objClass=[[array objectAtIndex:0] class];
    __block BOOL success=false;
    [[[JDDALSQLite shareDataBaseQueue] queue] inTransaction:^(FMDatabase *db,BOOL *rollback)  {
        @autoreleasepool {
            NSMutableArray* keyArray=[NSMutableArray array];
            NSMutableArray* varArray=[NSMutableArray array];
            unsigned int propertyCount=0;
            objc_property_t *propertyArray=  class_copyPropertyList(objClass, &propertyCount);
            for (int i=0; i<propertyCount; i++) {
                objc_property_t propertyItem=propertyArray[i];
                NSString *propertyName=[NSString stringWithUTF8String: property_getName(propertyItem)];
                [keyArray addObject:propertyName];
                [varArray addObject:[NSString stringWithFormat:@":%@",propertyName]];
            }
            free(propertyArray);
            NSString *sqlStr=[NSString stringWithFormat:@"INSERT INTO %s (ID,%@) VALUES (:ID,%@)",class_getName(objClass),[keyArray componentsJoinedByString:@","],[varArray componentsJoinedByString:@","]];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSMutableDictionary *dic=[NSMutableDictionary dictionary];
                [keyArray enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop) {
                    id value=[obj valueForKey:key];
                    if (value) {
                        [dic setObject:value forKey:key];
                    }else{
                        [dic setObject:[NSNull null] forKey:key];
                    }
                    
                }];
                [dic setObject:[obj getID] forKey:@"ID"];
                success=[db executeUpdate:sqlStr withParameterDictionary:dic];
                if (!success) {
                    DLog(@"error:%d,message:%@",[db lastErrorCode],[db lastErrorMessage]);
                    *stop=true;
                }
            }];
            if (!success) {
                *rollback=true;
            }
        }
    }];
    if (!success) {
        if ([self deleteTable]&&[self prepareTable]) {
            return [self inserts:array];
        }
    }
    return success;
}

+(BOOL)deleteEntity:(JDBaseModel *)entity{
    [self prepareTable];
    __block BOOL success=false;
    [[[JDDALSQLite shareDataBaseQueue] queue] inDatabase:^(FMDatabase *db) {
        @autoreleasepool {
            NSString *sqlStr=[NSString stringWithFormat:@"delete from %s where id='%@'",class_getName([entity class]),entity.getID];
            success=[db executeUpdate:sqlStr];
            DLog(@"%@",sqlStr);
            if (!success) {
                DLog(@"error:%d,message:%@",[db lastErrorCode],[db lastErrorMessage]);
            }

        }
    }];
    return success;
}

+(BOOL)deleteEntitys:(NSArray *)array{
    if (!array && array.count==0) {
        return false;
    }
    [self prepareTable];
    Class objClass=[[array objectAtIndex:0] class];
    __block BOOL success=false;
    [[[JDDALSQLite shareDataBaseQueue] queue] inDatabase:^(FMDatabase *db) {
        @autoreleasepool {
            NSMutableArray *deleteIDs=[NSMutableArray array];
            [array enumerateObjectsUsingBlock:^(JDBaseModel * obj, NSUInteger idx, BOOL *stop) {
                [deleteIDs addObject:[NSString stringWithFormat:@"'%@'",[obj getID]]];
            }];
            NSString *sqlStr=[NSString stringWithFormat:@"delete from %s where id in(%@)",class_getName(objClass),[deleteIDs componentsJoinedByString:@","]];
            DLog(@"%@",sqlStr);
            success=[db executeUpdate:sqlStr];
            if (!success) {
                DLog(@"error:%d,message:%@",[db lastErrorCode],[db lastErrorMessage]);
            }
        }
    }];
    return success;
}

+(BOOL)deleteAll{
    [self prepareTable];
    __block BOOL success=false;
    [[[JDDALSQLite shareDataBaseQueue] queue] inDatabase:^(FMDatabase *db) {
        @autoreleasepool {
            NSString *sqlStr=[NSString stringWithFormat:@"delete from %s ",class_getName(self)];
            DLog(@"%@",sqlStr);
            success=[db executeUpdate:sqlStr];
            if (!success) {
                DLog(@"error:%d,message:%@",[db lastErrorCode],[db lastErrorMessage]);
            }
        }
    }];
    return success;
}

+(NSUInteger)getRowCount{
    [self prepareTable];
    __block NSUInteger rowCount=0;
    [[[JDDALSQLite shareDataBaseQueue] queue] inDatabase:^(FMDatabase *db) {
        @autoreleasepool {
            FMResultSet *s = [db executeQuery:[NSString stringWithFormat:@"select count(*)  from %s",class_getName([self class])]];
            while ([s next]) {
                rowCount= [s intForColumnIndex:0];
                break;
            }
        }
    }];
    return rowCount;
}
+(NSUInteger)getRowCountByType:(NSString *)billID{
    [self prepareTable];
    __block NSUInteger rowCount=0;
    [[[JDDALSQLite shareDataBaseQueue] queue] inDatabase:^(FMDatabase *db) {
        @autoreleasepool {
            FMResultSet *s = [db executeQuery:[NSString stringWithFormat:@"select count(*)  from %s where billType='%@'",class_getName([self class]),billID]];
            while ([s next]) {
                rowCount= [s intForColumnIndex:0];
                break;
            }
        }
    }];
    return rowCount;
}
+(JDBaseModel *)getEntityByID:(NSString *)ID{
    [self prepareTable];
    __block id result;
    [[[JDDALSQLite shareDataBaseQueue] queue] inDatabase:^(FMDatabase *db) {
        @autoreleasepool {
            FMResultSet *s = [db executeQuery:[NSString stringWithFormat:@"select *  from %s where id='%s'",class_getName([self class]),[ID UTF8String]]];
            while ([s next]) {
                id entity = [[self alloc] init];
                for (int i=0; i<[s columnCount]; i++) {
                    [entity setValue:[s objectForColumnIndex:i] forKey:[s columnNameForIndex:i]];
                }
                result = entity;
                break;
            }
        }
    }];

    return result;
}
+(NSArray *)getEntitysWithSQL:(NSString *)sql withDic:(NSDictionary *)paramsDic{
    [self prepareTable];
    NSMutableArray * result=[NSMutableArray array];
    [[[JDDALSQLite shareDataBaseQueue] queue] inDatabase:^(FMDatabase *db) {
        @autoreleasepool {
            FMResultSet *s = [db executeQuery:sql withParameterDictionary:paramsDic];
            while ([s next]) {
                id entity = [[self alloc] init];
                for (int i=0; i<[s columnCount]; i++) {
                    [entity setValue:[s objectForColumnIndex:i] forKey:[s columnNameForIndex:i]];
                }
                [result  addObject: entity];
            }
        }
    }];
    return result;
}
+(NSArray *)getEntitys:(NSArray *)IDs{
    [self prepareTable];
    NSMutableArray * result=[NSMutableArray array];;
    [[[JDDALSQLite shareDataBaseQueue] queue] inDatabase:^(FMDatabase *db) {
        @autoreleasepool {
            [IDs enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
                obj=[NSString stringWithFormat:@"'%@'",obj];
            }];
            FMResultSet *s = [db executeQuery:[NSString stringWithFormat:@"select *  from %s where id in (%s)",class_getName([self class]),[[IDs componentsJoinedByString:@","] UTF8String]]];
            while ([s next]) {
                id entity = [[self alloc] init];
                for (int i=0; i<[s columnCount]; i++) {
                    [entity setValue:[s objectForColumnIndex:i] forKey:[s columnNameForIndex:i]];
                }
                [result  addObject: entity];
            }
        }
    }];
    return result;
}
+(NSArray *)getAllEntitys{
    [self prepareTable];
    NSMutableArray * result=[NSMutableArray array];
    [[[JDDALSQLite shareDataBaseQueue] queue] inDatabase:^(FMDatabase *db) {
        @autoreleasepool {
            FMResultSet *s = [db executeQuery:[NSString stringWithFormat:@"select *  from %s ",class_getName([self class])]];
            while ([s next]) {
                id entity = [[self alloc] init];
                for (int i=0; i<[s columnCount]; i++) {
                    [entity setValue:[s objectForColumnIndex:i] forKey:[s columnNameForIndex:i]];
                }
                [result  addObject: entity];
            }
        }
    }];
    return result;
}


#pragma mark-table operate
+(BOOL)prepareTable{
    return [self isExistTable] || [self createTable];
}

+(BOOL)isExistTable{
    if (_dicForTable) {
        if([[_dicForTable objectForKey:NSStringFromClass([self class])] boolValue]){
        return true;
        }
    }else{
        _dicForTable =[NSMutableDictionary dictionary];
    }
    __block BOOL flag=false;
    NSMutableArray* keyArray=[NSMutableArray array];
    [keyArray addObject:@"ID"];
    unsigned int propertyCount=0;
    objc_property_t *propertyArray=  class_copyPropertyList([self class], &propertyCount);
    for (int i=0; i<propertyCount; i++) {
        objc_property_t propertyItem=propertyArray[i];
        NSString *propertyName=[NSString stringWithUTF8String: property_getName(propertyItem)];
        [keyArray addObject:propertyName];
    }
    free(propertyArray);
    
    [[[JDDALSQLite shareDataBaseQueue] queue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @autoreleasepool {
            NSUInteger count=0;
            //table is already exist?
            FMResultSet *s = [db executeQuery:[NSString stringWithFormat:@"select count(*) as count from sqlite_master where type='table' and name='%s'",class_getName([self class])]];
            while ([s next]) {
                count = [s intForColumn:@"count"];
            }
            if (count == 0) {
                return;
            }
            //Are entity's properties  all contained by  table's columns?
            s = [db executeQuery:[NSString stringWithFormat:@"pragma table_info ('%s')",class_getName([self class])]];
            NSMutableArray *columnArray=[NSMutableArray array];
            while ([s next]) {
                [columnArray addObject: [s stringForColumn:@"name"]];
            }
            //compare properties to columns
            [keyArray enumerateObjectsUsingBlock:^(NSString * key, NSUInteger idx, BOOL *stop) {
                flag=false;
                [columnArray enumerateObjectsUsingBlock:^(NSString * columnName, NSUInteger idx2, BOOL *stop2) {
                    if ([key isEqualToString:columnName]){
                        *stop2=true;
                        [columnArray removeObject:columnName];
                        flag=true;
                    }
                }];
                if (!flag) {
                    *stop=true;
                }
            }];
        }
        
    }];
    if (!flag) {
        [self deleteTable];
    }
    [_dicForTable setObject:[NSNumber numberWithBool:flag] forKey:NSStringFromClass([self class])];
    return flag;
}

+(BOOL)createTable{
    __block BOOL success=false;
    [[[JDDALSQLite shareDataBaseQueue] queue] inDatabase:^(FMDatabase *db) {
        @autoreleasepool {
            NSMutableArray *array=[NSMutableArray array];
            unsigned int propertyCount=0;
            objc_property_t *propertyArray=  class_copyPropertyList([self class], &propertyCount);
            for (int i=0; i<propertyCount; i++) {
                objc_property_t propertyItem=propertyArray[i];
                NSString *propertyName=[NSString stringWithUTF8String: property_getName(propertyItem)];
                NSString *propertyAttribute=[NSString stringWithUTF8String:property_getAttributes(propertyItem)];
                //正则表达式获取属性描述
                NSRange range=[propertyAttribute rangeOfString:@"(?<=^T)(.+?)(?=,)"options:NSRegularExpressionSearch];
                NSString *typeCode= [propertyAttribute substringWithRange:range];
                if([typeCode rangeOfString:@"Number"].length>0 || [typeCode rangeOfString:@"Value"].length>0)
                {
                    [array addObject:[NSString stringWithFormat:@"%@ REAL",propertyName]];
                }else if([typeCode rangeOfString:@"Integer"].length>0){
                    [array addObject:[NSString stringWithFormat:@"%@ INTEGER",propertyName]];
                }else if([typeCode rangeOfString:@"Data"].length>0){
                    [array addObject:[NSString stringWithFormat:@"%@ BLOB",propertyName]];
                }else{
                    [array addObject:[NSString stringWithFormat:@"%@ TEXT",propertyName]];
                }
            }
            free(propertyArray);
            NSString *sql = [NSString stringWithFormat:@"create table %s (ID TEXT,%@)",class_getName([self class]),[array componentsJoinedByString:@","]];
            success=[db executeUpdate:sql];
            if (!success) {
                DLog(@"error:%d,message:%@",[db lastErrorCode],[db lastErrorMessage]);
            }
        }
    }];
    return success;
}

+(BOOL)deleteTable{
    __block BOOL success=false;
    [[[JDDALSQLite shareDataBaseQueue] queue] inDatabase:^(FMDatabase *db) {
        @autoreleasepool {
            NSString *sql = [NSString stringWithFormat:@"DROP TABLE  %s",class_getName([self class])];
            success=[db executeUpdate:sql];
            if (!success) {
                DLog(@"error:%d,message:%@",[db lastErrorCode],[db lastErrorMessage]);
            }

        }
    }];
    if (success) {
        [_dicForTable removeObjectForKey:NSStringFromClass([self class])];
    }
    return success;
}


@end
