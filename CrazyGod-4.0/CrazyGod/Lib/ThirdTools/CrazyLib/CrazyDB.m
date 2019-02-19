//
//  easyflyDB.m
//  easyflyDemo
//
//  Created by dukai on 15/5/29.
//  Copyright (c) 2015年 杜凯. All rights reserved.
//

#import "CrazyDB.h"


static CrazyDB *DB = nil;
@implementation CrazyDB


+(id)shareDBName:(NSString *)theSqliteName
{
    if (DB == nil) {
        DB = [[CrazyDB alloc]init];
        DB.sqliteName = theSqliteName;
        [DB createEditableCopyOfDatabaseIfNeeded:theSqliteName];
    }
 
    return  DB ;
}
+(FMDatabase *)specifiedDB
{
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent: DB.sqliteName];
   // NSLog(@"%@",writableDBPath);
   FMDatabase * db = [FMDatabase databaseWithPath:writableDBPath];
   return db;
}

-(BOOL)createEditableCopyOfDatabaseIfNeeded:(NSString *)sqlite
{
    
    BOOL ret = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    _writableDBPath = [documentsDirectory stringByAppendingPathComponent:sqlite];
    ret = [fileManager fileExistsAtPath:_writableDBPath];
    FMDatabase * db = [FMDatabase databaseWithPath:_writableDBPath];
    if(ret == YES)
    {
        
        ret = [db open];
        [db close];
        return ret;
    }
    
    NSString *defaultPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:sqlite];
    ret = [fileManager copyItemAtPath: defaultPath toPath: _writableDBPath error: &error];
    
    if(!ret)
    {
        NSLog(@"copyPath Fail %@",error);
        return  ret;
    }
    
    return ret;
}
//单独处理一条sql
+(BOOL)executeUpdate:(NSString *)sql{
    FMDatabase * FMDB = [self specifiedDB];
    
    BOOL ret =[FMDB open];
    ret = [FMDB executeUpdate: sql];
    
    [FMDB close];
    
    return ret;
    
}
//批量处理多条sql
+(BOOL)executeUpdateTransaction:(NSArray *)sqlArr{
    FMDatabase * FMDB = [self specifiedDB];
    
    [FMDB open];
    [FMDB beginTransaction];
    BOOL ret = NO;
    for (int i = 0; i<sqlArr.count; i++) {
        NSString *sql = [sqlArr objectAtIndex:i];
        
        ret = [FMDB executeUpdate: sql];
    }
    
   ret = [FMDB commit];
   [FMDB close];
    
   return ret;
    
}

//查询多条数据
+(NSArray *)executeQuery:(NSString *)sql{
    
    NSMutableArray * arr = [NSMutableArray array];
    FMDatabase * FMDB = [self specifiedDB];
    
    [FMDB open];
    FMResultSet *rs = [FMDB executeQuery:sql];
    
    while ([rs next]){
        NSMutableDictionary * dic = [NSMutableDictionary dictionary] ;
       
        for (int i = 0; i< [rs columnCount]; i++) {
            NSString *key = [rs columnNameForIndex:i];
            NSString *value = [rs stringForColumn:key];
            [dic setObject:value forKey:key];
        }
      
        [arr addObject:dic];
        
    }
    [FMDB close];
    
    return arr;
    
}
//查询单条数据
+(NSDictionary *)GetOne:(NSString *)sql{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary] ;
    FMDatabase *FMDB = [self specifiedDB];
    
    [FMDB open];
    FMResultSet *rs = [FMDB executeQuery:sql];
    while ([rs next]) {
        
        for (int i =0; i<[rs columnCount]; i++) {
            NSString *key = [rs columnNameForIndex:i];
            NSString *value = [rs stringForColumn:key];
            [dic setObject:value forKey:key];
        }
        
        break;
    }
    
    [FMDB close];
    
    return dic;
    
}


@end
