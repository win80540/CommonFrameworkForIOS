//
//  JDBaseModel.h
//  wetoolsSAAS
//
//  Created by 田凯 on 14-4-18.
//  Copyright (c) 2014年 田凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDBaseModel : NSObject{
    NSString *_mainID;
}

-(NSString *)getID;
-(void)setID:(NSString *)mainID;

-(id)initWithDictionary:(NSDictionary *)jsonData;
-(id)initWithDictionary:(NSDictionary *)jsonData Extend:(BOOL)canExtend;
-(NSString*) description;
#pragma mark--DAL 
+(NSArray *)getALLPropertiesKey;
+(BOOL)insert:(JDBaseModel *)entity;
+(BOOL)inserts:(NSArray *)array;
+(BOOL)deleteEntity:(JDBaseModel *)entity;
+(BOOL)deleteEntitys:(NSArray *)array;
+(BOOL)deleteAll;
+(NSUInteger)getRowCount;
+(NSUInteger)getRowCountByType:(NSString *)billID;
+(JDBaseModel *)getEntityByID:(NSString *)ID;
+(NSArray *)getEntitysWithSQL:(NSString *)sql withDic:(NSDictionary *)paramsDic;
+(NSArray *)getEntitys:(NSArray *)IDs;
+(NSArray *)getAllEntitys;
+(BOOL)isExistTable;
+(BOOL)createTable;
+(BOOL)deleteTable;
+(BOOL)prepareTable;
@end
