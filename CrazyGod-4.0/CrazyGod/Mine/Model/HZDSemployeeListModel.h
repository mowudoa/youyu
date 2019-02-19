//
//  HZDSemployeeListModel.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/13.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "rootModel.h"

@interface HZDSemployeeListModel : rootModel


@property(copy,nonatomic)NSString* employeeID; //员工id

@property(copy,nonatomic)NSString* userID; //用户id


@property(copy,nonatomic)NSString* employeeName; //员工名字

@property(copy,nonatomic)NSString* employeeJob; //员工职务

@property(copy,nonatomic)NSString* employeePhone; //员工电话

@property(copy,nonatomic)NSString* employeeTel; //员工电话

@property(copy,nonatomic)NSString* employeeQQ; //员工qq

@property(copy,nonatomic)NSString* employeeWchat; //微信
@property(copy,nonatomic)NSString* employeeAddress; //员工地址

@property(copy,nonatomic)NSString* employeePower; //员工权限


@property(copy,nonatomic)NSString* createTime; //时间
@end
