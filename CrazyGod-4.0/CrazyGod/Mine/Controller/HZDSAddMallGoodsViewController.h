//
//  HZDSAddMallGoodsViewController.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/29.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "XTBaseBackViewController.h"

typedef enum {
    addMallGoodsType,
    editMallGoodsType
}mallGoodsType;

@interface HZDSAddMallGoodsViewController : XTBaseBackViewController

@property(nonatomic)mallGoodsType addgoodsType;

@property(nonatomic,copy) NSString *goods_id;

@end
