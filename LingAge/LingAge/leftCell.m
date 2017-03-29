//
//  leftCell.m
//  LingAge
//
//  Created by BO on 17/3/28.
//  Copyright © 2017年 xsqBO. All rights reserved.
//

#import "leftCell.h"

@implementation leftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    [UIColor colorWithWhite:0 alpha:0.1]
    self.contentView.backgroundColor = selected?[UIColor whiteColor]:[UIColor colorWithWhite:0 alpha:0.1];
    // Configure the view for the selected state
}

@end
