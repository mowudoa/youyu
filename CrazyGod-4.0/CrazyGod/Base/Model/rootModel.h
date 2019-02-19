//
//  rootModel.h
//  QPH
//
//  Created by  on 16/6/22.
//  Copyright © 2016年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface rootModel : NSObject

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

-(id)valueForUndefinedKey:(NSString *)key;

-(void)setNilValueForKey:(NSString *)key;


@end
