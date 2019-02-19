//
//  easyflyDB.h
//  easyflyDemo
//
//  Created by dukai on 15/5/29.
//  Copyright (c) 2015年 杜凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface CrazyDB : NSObject

+(id)shareDBName:(NSString *)theSqliteName;
+(FMDatabase *)specifiedDB;

//单独处理一条sql
+(BOOL)executeUpdate:(NSString *)sql;
//批量处理多条sql
+(BOOL)executeUpdateTransaction:(NSArray *)sqlArr;
//查询多条数据
+(NSArray *)executeQuery:(NSString *)sql;
//查询单条数据
+(NSDictionary *)GetOne:(NSString *)sql;

//数据库位置
@property(nonatomic,strong)NSString * sqliteName;
@property(nonatomic,strong)NSString * writableDBPath;




@end
