//
//  FoodM.h
//  LingAge
//
//  Created by BO on 17/3/28.
//  Copyright © 2017年 xsqBO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodM : NSObject

@property (copy,nonatomic)NSString *goodsImgName;
@property (copy,nonatomic)NSString *goodsPrice;
@property (copy,nonatomic)NSString *goodsTitles;
@property (copy,nonatomic)NSString *goodsId;
-(instancetype)initWithDic:(NSDictionary*)dic;

@end
@interface category : NSObject
@property (copy,nonatomic)NSString *name;
@property (copy,nonatomic)NSString *icon;
@property (copy,nonatomic)NSString *goodsTag;
@property (strong,nonatomic)NSArray * skuArr;

-(instancetype)initWithDic:(NSDictionary *)dic;
@end
