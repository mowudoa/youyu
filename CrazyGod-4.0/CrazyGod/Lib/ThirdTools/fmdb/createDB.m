//
//  createDB.m
//  tuolaji
//
//  Created by dukai on 14/10/29.
//  Copyright (c) 2014年 longcai. All rights reserved.
//

#import "createDB.h"
#import "FMDatabase.h"

@implementation createDB

+(id)shareDBName:(NSString *)sqliteName
{
    createDB *DB = [[createDB alloc]init];
    
   [self createEditableCopyOfDatabaseIfNeeded:sqliteName];
    
    return  DB ;
}

+(BOOL)createEditableCopyOfDatabaseIfNeeded:sqlite
{
    
    BOOL ret = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:sqlite];
    ret = [fileManager fileExistsAtPath:writableDBPath];
    FMDatabase * db = [FMDatabase databaseWithPath:writableDBPath];
    if(ret == YES)
    {
        
        ret = [db open];
        [db close];
        return ret;
    }
    
    NSString *defaultPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:sqlite];
    ret = [fileManager copyItemAtPath: defaultPath toPath: writableDBPath error: &error];
    
    if(!ret)
    {
        NSLog(@"copyPath Fail %@",error);
        return  ret;
    }
    
    return ret;
}

@end
