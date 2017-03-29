//
//  FoodM.m
//  LingAge
//
//  Created by BO on 17/3/28.
//  Copyright © 2017年 xsqBO. All rights reserved.
//

#import "FoodM.h"

@implementation FoodM
-(instancetype)initWithDic:(NSDictionary *)dic
{
    self.goodsId = dic[@"id"];
    self.goodsPrice = dic[@"min_price"];
    self.goodsTitles = dic[@"name"];
    self.goodsImgName = dic[@"picture"];
    
    return self;
}
@end
@implementation category

-(instancetype)initWithDic:(NSDictionary *)dic
{
    self.name = dic[@"name"];
    self.goodsTag  = dic[@"tag"];
    self.icon = dic[@"icon"];
    self.skuArr = dic[@"spus"];
    return self;
}

@end
