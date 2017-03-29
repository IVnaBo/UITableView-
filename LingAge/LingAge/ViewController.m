//
//  ViewController.m
//  LingAge
//
//  Created by BO on 17/3/28.
//  Copyright © 2017年 xsqBO. All rights reserved.
//

#import "ViewController.h"
#import "leftCell.h"
#import "rightCell.h"
#import "FoodM.h"
#import <UIImageView+WebCache.h>
static NSString * leftIdentify = @"leftIdentify";
static NSString * rightIdentify = @"rightIdentify";
#define iPhone_w  [UIScreen mainScreen].bounds.size.width
#define iPhone_h  [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
BOOL _isScrollDown;
}
/** 左边的表格 */
@property (strong,nonatomic)UITableView * leftTabview;
/** 右边的表格 */
@property (strong,nonatomic)UITableView * rightTabview;
/** 左数据源 */
@property (strong,nonatomic)NSMutableArray * leftData;
/** 右数据源 */
@property (strong,nonatomic)NSMutableArray * rightData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ self.leftTabview registerNib:[UINib nibWithNibName:@"leftCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:leftIdentify];
    [self.rightTabview registerNib:[UINib nibWithNibName:@"rightCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:rightIdentify];
    
    self.title = @"联动";
    NSString * path = [[NSBundle mainBundle]pathForResource:@"meituan" ofType:@"json"];
    NSData * jsondata = [NSData dataWithContentsOfFile:path];
    NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:jsondata options: NSJSONReadingAllowFragments error:nil];
    NSArray * foods = jsonDic[@"data"][@"food_spu_tags"];
    for (NSDictionary * tempDic in foods) {
        category * catL = [[category alloc]initWithDic:tempDic];
        [self.leftData addObject:catL];
        NSMutableArray *datas = [NSMutableArray array];
        for (NSDictionary * dic in catL.skuArr) {//一次一次进行的。。 数组和字典的关系理清
            FoodM * foods = [[FoodM alloc]initWithDic:dic];
            [datas addObject:foods];
        }
        [self.rightData addObject:datas];
    }
    
    [self.view addSubview:self.leftTabview];
    [self.view addSubview:self.rightTabview];
    // Do any additional setup after loading the view, typically from a nib.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftTabview) {
        return self.leftData.count;
    }else{
        category * cat = self.leftData[section];
        return cat.skuArr.count;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.rightTabview) {
        return self.leftData.count;
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTabview) {
        return 55;
    }else{
        return 105;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.rightTabview) {
        UILabel * namelab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, iPhone_w, 25)];
        namelab.font = [UIFont systemFontOfSize:13.0];
        namelab.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
        category * cat = self.leftData[section];
        namelab.text = cat.name;
        return namelab;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.rightTabview) {
        return 25;
    }else{
        return 0.01;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (tableView == self.leftTabview) {
        leftCell * cell = [tableView dequeueReusableCellWithIdentifier:leftIdentify];
        category * cat = self.leftData[indexPath.row];
//        NSLog(@"%@",cat.icon);
        cell.leftTitleLab.text = cat.name;
//        [cell.iconImgv sd_setImageWithURL:[NSURL URLWithString:cat.icon] placeholderImage:[UIImage imageNamed:@"socute"]];
        return cell;
    }else{
        rightCell * cell = [tableView dequeueReusableCellWithIdentifier:rightIdentify];
       
        FoodM * foods = self.rightData[indexPath.section][indexPath.row];
        
        [cell.cuteImgv sd_setImageWithURL:[NSURL URLWithString:foods.goodsImgName] placeholderImage:[UIImage imageNamed:@"sucute"]];
        cell.riglab.text = foods.goodsTitles;
        cell.price.text = [NSString stringWithFormat:@"￥%@",foods.goodsPrice];
        return cell;
    }
    
}
// TableView分区标题即将展示
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    // 当前的tableView是RightTableView，RightTableView滚动的方向向上，RightTableView是用户拖拽而产生滚动的（（主要判断RightTableView用户拖拽而滚动的，还是点击LeftTableView而滚动的）
    if ((_rightTabview == tableView) && !_isScrollDown && _rightTabview.dragging)
    {
        [self selectRowAtIndexPath:section];
    }
}

// TableView分区标题展示结束
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // 当前的tableView是RightTableView，RightTableView滚动的方向向下，RightTableView是用户拖拽而产生滚动的（（主要判断RightTableView用户拖拽而滚动的，还是点击LeftTableView而滚动的）
    if ((_rightTabview == tableView) && _isScrollDown && _rightTabview.dragging)
    {
        /** 向下滚动的话 则表示 左边的分类也应该向下移动一位 */
        
        [self selectRowAtIndexPath:section + 1];
    }
}
// 当拖动右边TableView的时候，处理左边TableView
- (void)selectRowAtIndexPath:(NSInteger)index
{
    [self.leftTabview selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}
// 标记一下RightTableView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static CGFloat lastOffsetY = 0;
    
    UITableView *tableView = (UITableView *) scrollView;
    if (_rightTabview == tableView)
    {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        
        lastOffsetY = scrollView.contentOffset.y;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTabview) {
        NSIndexPath * index = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
        
        [self.rightTabview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self.leftTabview scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
    }
}
#pragma mark - get
-(UITableView *)leftTabview
{
    if (!_leftTabview) {
        _leftTabview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 80, iPhone_h) style:UITableViewStylePlain];
        _leftTabview.dataSource = self;
        _leftTabview.delegate = self;
        _leftTabview.showsVerticalScrollIndicator = NO;
        _leftTabview.showsHorizontalScrollIndicator = NO;
    }
    return _leftTabview;
}
-(UITableView *)rightTabview
{
    if (!_rightTabview) {
        _rightTabview = [[UITableView alloc]initWithFrame:CGRectMake(80, 64, iPhone_w - 80, iPhone_h-64) style:UITableViewStylePlain];
        _rightTabview.delegate = self;
        _rightTabview.dataSource = self;
        _rightTabview.showsHorizontalScrollIndicator = NO;
        _rightTabview.showsVerticalScrollIndicator = NO;

    }
    return _rightTabview;
}
-(NSMutableArray *)leftData
{
    if (!_leftData) {
        _leftData = [NSMutableArray array];
        
    }
    return _leftData;
}
-(NSMutableArray *)rightData
{
    if (!_rightData) {
        _rightData = [NSMutableArray array];
    }
    return _rightData;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
