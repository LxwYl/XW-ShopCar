//
//  HPShopCarVC.m
//  HPShop
//
//  Created by 李学文 on 2017/1/27.
//  Copyright © 2017年 李学文. All rights reserved.
//

#import "HPShopCarVC.h"
#import "HPShopCarDetailCell.h"
#import "HPShopCarModel.h"
#import "HPShopCarHeaderView.h"
#import "HPShopCarBottomView.h"
//#import "HPSureOrderVC.h"
//#import "XWShopDetetailsVC.h"
//#import "HPStoreVC.h"
#import "XWSignButton.h"
//#import "HPLoginController.h"
//#import "HPMessagecateoryVC.h"
#define BottomView_H 50
static NSString *HPShopCarDetailCellID = @"HPShopCarDetailCellID";
static NSString *HPShopCarHeaderViewID = @"HPShopCarHeaderViewID";
@interface HPShopCarVC ()<UITableViewDelegate,UITableViewDataSource,HPShopCarDetailCellDelegate,HPShopCarHeaderViewDelegate,UIGestureRecognizerDelegate,HPShopCarBottomViewDelegate>
@property(strong, nonatomic) NSMutableArray * dataArr;
@property(strong, nonatomic) HPFreightMode * freightMode;//配送费model

@property(strong, nonatomic) UILabel * freightbl;
@property(strong, nonatomic) UITableView * mainTable;
@property(strong, nonatomic) HPShopCarBottomView * BottomView;
@property(strong, nonatomic) NSString * totalprice;// 包含运费 不包含满减的
@property(strong, nonatomic) NSString * Actualprice;// 包含运费 包含满减的
@property(strong, nonatomic) NSString * canMadeCoup;//是否参与满减 参与满减的订单不可使用优惠劵 “参与满减：1”
@property(assign, nonatomic) NSInteger  GoodsSelectCount;//将要购买商品的总件数

@end

@implementation HPShopCarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    [self CreatNav];
    [self CreatBottomView];
    [self CreatMainTable];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self requestData];
    self.navigationController.navigationBar.translucent = YES;
}
-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    
    return _dataArr;
    
}
-(UILabel *)freightbl
{
    if (!_freightbl) {
        
        _freightbl =[[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-BottomView_H-30, SCREEN_HEIGHT, 30)];
        [self.view addSubview:_freightbl];
        _freightbl.backgroundColor =[UIColor colorFromHexRGB:@"c32e00"];
        _freightbl.font =[UIFont systemFontOfSize:12];
        _freightbl.textColor =[UIColor whiteColor];
        _freightbl.alpha = 0.7;
        _freightbl.text = @"  单笔订单满15免配送费";
        
    }
    
    return _freightbl;
}
-(void)CreatBottomView
{
    _BottomView = [HPShopCarBottomView viewFromXib];
    
    _BottomView.frame = CGRectMake(0, SCREEN_HEIGHT-BottomView_H, SCREEN_WIDTH, BottomView_H);
    _BottomView.delegate =self;
    [self.view addSubview:_BottomView];
}
#pragma mark- 点击选择全部
-(void)HPShopCarBottomView:(HPShopCarBottomView*)view clickAllSelectBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    for (int i=0; i<self.dataArr.count; i++) {
        
        HPShopCarModel * ShopCarModel =[self.dataArr objectAtIndex:i];
        
        ShopCarModel.isSelectArr =  sender.selected;
        
        
        for (int i = 0 ; i<ShopCarModel.content.count; i++) {
            
            HPShopdetailModel * model = [ShopCarModel.content objectAtIndex:i];
            
            model.isSelect = sender.selected;
            
            if ([[DJTUtility YRIsEmptString:model.goodsMark] floatValue]==-2) {
                
                // 商品下架
//                [AppDelegate showHUDAndHide:@"亲，已下架商品不可选" view:self.view];
                
                
                model.isSelect = NO;
                
                
            }
            
            
            
        };
        ShopCarModel.isSelectArr = NO ;
        
        
        
        
    }
    sender.selected = NO;
    [self.mainTable reloadData];
}
-(void)HPShopCarBottomView:(HPShopCarBottomView*)view ClickSettlementBtn:(UIButton *)sender
{
   
}
/**
 *  导航设置   左右按钮 背景
 */

-(void)CreatNav
{
    
    
    //导航背景
    
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"fqrwBackground"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    
    // 标题
    UILabel * titleView =[[UILabel alloc] init];
    
    titleView.text = @"购物车";
    
    titleView.font =[UIFont systemFontOfSize:18];
    
    titleView.textAlignment = NSTextAlignmentCenter;
    
    titleView.textColor =[UIColor blackColor];
    
    titleView.frame =CGRectMake(0, 7, 100, 30);
    
    self.navigationItem.titleView =titleView;
    
    // 左边按钮
    
    UIButton *leftbut =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftbut setImage:[UIImage imageNamed:@"btn_left"] forState:UIControlStateNormal];
    
    [leftbut addTarget:self action:@selector(ClicknavleftBut) forControlEvents:UIControlEventTouchUpInside];
    [leftbut sizeToFit];
    
    
    
    
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:leftbut];
    // 右边按钮
    UIButton *rightnav =[UIButton buttonWithType:UIButtonTypeCustom];
    rightnav.backgroundColor =[UIColor clearColor];
    [rightnav addTarget:self action:@selector(ClicknavrightBut) forControlEvents:UIControlEventTouchUpInside];
    
    [  rightnav setBackgroundImage:[UIImage imageNamed:@"news_s"] forState:UIControlStateNormal];
    [rightnav sizeToFit];
    UIBarButtonItem* righttwo= [[UIBarButtonItem alloc] initWithCustomView:rightnav];
    XWSignButton * carbutton =[[XWSignButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    carbutton.Type = XWSignButtonTypeWithNumber;
    
    carbutton.NumberStr = @"0";
    // [carbutton setImage:[UIImage imageNamed:@"gouwc"] forState:UIControlStateNormal];
    [carbutton setTitle:@"完成" forState:UIControlStateNormal];
    carbutton.titleLabel.font =[UIFont systemFontOfSize:15];
    [carbutton addTarget:self action:@selector(Clicknavrightend) forControlEvents:UIControlEventTouchUpInside];
    [carbutton setTitleColor:[UIColor colorFromHexRGB:@"C32E00"] forState:UIControlStateNormal];
    UIBarButtonItem* right= [[UIBarButtonItem alloc] initWithCustomView:carbutton];
    
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceBarButtonItem.width = 10;
    
    self.navigationItem.rightBarButtonItems = @[righttwo,fixedSpaceBarButtonItem,right];
    
    // self.navigationItem.rightBarButtonItem  =
    
}
-(void)Clicknavrightend
{
    
}
-(void)ClicknavrightBut
{
    
}


-(void)ClicknavleftBut
{
    // [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

/**
 *  数据加载
 */

-(void)requestData
{
    
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"addshopcar" ofType:@"plist"];
    NSMutableDictionary *response = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    if ([[response objectForKey:@"success"] integerValue]==1) {
        
                        NSArray * arr =[[response objectForKey:@"map"] objectForKey:@"cartList"];
                        self.dataArr =[HPShopCarModel mj_objectArrayWithKeyValuesArray:arr];
                        self.freightMode = [HPFreightMode mj_objectWithKeyValues:[[response objectForKey:@"map"] objectForKey:@"freightS"]];
        
                    }
    
     [self.mainTable reloadData];
    
    //
//    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:1];
//    
//    [param setObject:[DJTUtility YRIsEmptString:[HPPersonModel shareManager].loginKey] forKey:@"loginKey"];
//    
//    
//    [XWNetWorkManager XW_requestWithType:XWHttpRequestTypePost urlString:[NSString stringWithFormat:@"%@/%@",BASEURL,PATH_SHOPCAR] parameters:param successBlock:^(id response) {
//        
//        NSLog(@"购物车：%@",response);
//        
//        if ([response isKindOfClass:[NSDictionary class]]) {
//            
//            if ([[response objectForKey:@"success"] integerValue]==1) {
//                
//                NSArray * arr =[[response objectForKey:@"map"] objectForKey:@"cartList"];
//                self.dataArr =[HPShopCarModel mj_objectArrayWithKeyValuesArray:arr];
//                self.freightMode = [HPFreightMode mj_objectWithKeyValues:[[response objectForKey:@"map"] objectForKey:@"freightS"]];
//                
//            }else
//            {
//                
//                
//                [AppDelegate showHUDAndHide:[response objectForKey:@"content"]  view:self.view];
//            }
//        }
//        [self.mainTable reloadData];
//    } failureBlock:^(NSError *error) {
//        NSLog(@"error:%@",error);
//        
//        [AppDelegate showHUDAndHide:@"网络异常" view:self.view];
//        // [self.mainTable.mj_header endRefreshing];
//    } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
//        
//    }];
    
}

/**
 *  创建maintable
 */
#pragma mark-
#pragma mark- 创建tableview

-(void)CreatMainTable
{
    self.mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-BottomView_H-20-64) style:UITableViewStylePlain];
    
    
    self.mainTable.delegate = self ;
    
    self.mainTable.dataSource = self ;

    self.mainTable.separatorStyle = UITableViewCellSeparatorStyleNone ;
    
    //self.mainTable.backgroundColor =[UIColor colorFromHexRGB:@"f8f8f9"];
    
    [self.mainTable registerNib:[UINib nibWithNibName:NSStringFromClass([HPShopCarDetailCell class]) bundle:nil] forCellReuseIdentifier:HPShopCarDetailCellID];
    
    
    [self.view addSubview:self.mainTable];
    
    
    [self.mainTable registerNib:[UINib nibWithNibName:NSStringFromClass([HPShopCarHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:HPShopCarHeaderViewID];
    

    
    [self requestData];
}

/**
 *  mainTable 代理方法实现
 */

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HPShopCarModel * ShopCarModel =[self.dataArr objectAtIndex:section];
    return ShopCarModel.content.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HPShopCarDetailCell * cell= [tableView dequeueReusableCellWithIdentifier:HPShopCarDetailCellID];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    HPShopCarModel * ShopCarModel =[self.dataArr objectAtIndex:indexPath.section];
    
    HPShopdetailModel *detailModel =[ShopCarModel.content objectAtIndex:indexPath.row];
    
    [cell setShopDetailModel:detailModel];
    
    cell.select_btn.index=indexPath.row;
    
    cell.select_btn.section = indexPath.section;
    KDButton *deleteBtn = [cell rowActionWithStyle:LYSideslipCellActionStyleNormal title:nil];
    
    deleteBtn.index = indexPath.row;
    deleteBtn.section = indexPath.section;
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    deleteBtn.backgroundColor =[UIColor redColor];
    [deleteBtn addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell setRightButtons:@[deleteBtn]];//可以传多个
    
    
    [_BottomView.select_bt setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    
    
    _BottomView.select_bt.selected =[self iSallSelect];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 107.0;
}
#pragma mark- 点击商品进入详情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

// 需要注意下架问题
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HPShopCarHeaderView * view =[tableView dequeueReusableHeaderFooterViewWithIdentifier:HPShopCarHeaderViewID];
    HPShopCarModel * ShopCarModel =[self.dataArr objectAtIndex:section];
    
    
    view.section =section;
    view.sectionUI.text = [NSString stringWithFormat:@"%ld",(long)section];
    
    view.backgroundColor =[UIColor whiteColor];
    view.contentView.backgroundColor =[UIColor whiteColor];
    [view SetHpShopCarMode:ShopCarModel];
    view.delegate = self;
    view.select_btn.selected = ShopCarModel.isSelectArr;
    
    [view.select_btn setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    HPShopCarModel * ShopCarModel =[self.dataArr objectAtIndex:section];
    
    if ([ShopCarModel.full_price floatValue]>0) {
        
        return 40+34;
    }
    return 40;
}
#pragma mark-
#pragma mark- HPShopCarDetailCellDelgate
#pragma mark- 选择 与 取消选择
-(void)HPShopCarDetailCell:(HPShopCarDetailCell *)cell ClickSelect_btn:(KDButton *)sender
{
    
    HPShopCarModel * ShopCarModel =[self.dataArr objectAtIndex:sender.section];
    
    HPShopdetailModel *detailModel =[ShopCarModel.content objectAtIndex:sender.index];
    
    if ([[DJTUtility YRIsEmptString:detailModel.goodsMark] floatValue]==-2) {
        
        // 商品下架
//        [AppDelegate showHUDAndHide:@"亲，该商品已下架了哦" view:self.view];
        return;
    }
    
    detailModel.isSelect = !detailModel.isSelect;
    
    [self.mainTable reloadData];
    
}
#pragma mark- 删除
-(void)deleteBtn:(KDButton *)sender
{
    
    HPShopCarModel * ShopCarModel =[self.dataArr objectAtIndex:sender.section];
    
    HPShopdetailModel *detailModel =[ShopCarModel.content objectAtIndex:sender.index];
    
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:1];
    [param setObject:[DJTUtility YRIsEmptString:detailModel.id] forKey:@"id"];
    
    
    
    
                    NSIndexPath * indexpath =[NSIndexPath indexPathForRow:sender.index inSection:sender.section];
    
    
                    if (ShopCarModel.content.count==1) {
                        // 判断当前Scetion 下面是否还有商品 没有的情况清除整个scetion
    
    
                        [self.dataArr removeObjectAtIndex:sender.section];
    
                        NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:sender.section];
    
                        [self.mainTable deleteSections:set withRowAnimation:UITableViewRowAnimationLeft];
    
    
                    }else
                    {
                        [ ShopCarModel.content removeObjectAtIndex:sender.index];
                        // 删除单行cell 刷新
                        [self.mainTable deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationLeft];
                    }
    
                    // ⚠️ cell或者section 删除动画结束后 必须要刷新整个tableview，目的是为了更新KDButton的index和section
                    __block HPShopCarVC/*主控制器*/ *weakSelf = self;
                    // 估计系统动画时间为0.2秒 ，延迟0.2秒刷新
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2/*延迟执行时间*/ * NSEC_PER_SEC));
    
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        [weakSelf.mainTable reloadData];
                    });

    
    
    
    
//    
//    [XWNetWorkManager XW_requestWithType:XWHttpRequestTypePost urlString:[NSString stringWithFormat:@"%@/%@",BASEURL,PATH_DELETCARGOODS] parameters:param successBlock:^(id response) {
//        
//        NSLog(@"response：%@",response);
//        
//        if ([response isKindOfClass:[NSDictionary class]]) {
//            
//            if ([[response objectForKey:@"success"] integerValue]==1) {
//                
//                [AppDelegate showHUDAndHide:[response objectForKey:@"content"] view:self.view timer:0.4];
//                
//                NSIndexPath * indexpath =[NSIndexPath indexPathForRow:sender.index inSection:sender.section];
//                
//                
//                if (ShopCarModel.content.count==1) {
//                    // 判断当前Scetion 下面是否还有商品 没有的情况清除整个scetion
//                    
//                    
//                    [self.dataArr removeObjectAtIndex:sender.section];
//                    
//                    NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:sender.section];
//                    
//                    [self.mainTable deleteSections:set withRowAnimation:UITableViewRowAnimationLeft];
//                    
//                    
//                }else
//                {
//                    [ ShopCarModel.content removeObjectAtIndex:sender.index];
//                    // 删除单行cell 刷新
//                    [self.mainTable deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationLeft];
//                }
//                
//                // ⚠️ cell或者section 删除动画结束后 必须要刷新整个tableview，目的是为了更新KDButton的index和section
//                __block HPShopCarVC/*主控制器*/ *weakSelf = self;
//                // 估计系统动画时间为0.2秒 ，延迟0.2秒刷新
//                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2/*延迟执行时间*/ * NSEC_PER_SEC));
//                
//                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//                    [weakSelf.mainTable reloadData];
//                });
//                
//                
//            }else
//            {
//                [AppDelegate showHUDAndHide:[response objectForKey:@"content"] view:self.view timer:0.4];
//            }
//        }
//        
//        
//    } failureBlock:^(NSError *error) {
//        NSLog(@"error:%@",error);
//        [AppDelegate showHUDAndHide:@"网络异常" view:self.view];
//        
//    } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
//        
//    }];
    
    
    NSLog(@"删除");
}


-(void)HPShopCarDetailCell:(HPShopCarDetailCell *)cell ClickAddBtn:(UIButton *)sender
{
    if (sender.selected==YES) {
        return;
    }
    
    if (cell.number_field.text.length>0) {
        
        NSInteger currnumber = [cell.number_field.text integerValue]+1;
        if (currnumber==0) {
//            [AppDelegate showHUDAndHide:@"至少一件商品" view:self.view];
            return;
        }
        cell.number_field.text = [NSString stringWithFormat:@"%ld",currnumber];
        
        
        
        cell.detailmodel.number = [NSString stringWithFormat:@"%ld",currnumber];
        
        [self modifyGoodsNumber:currnumber withID: cell.detailmodel.id button:sender andMode:cell.detailmodel];
    }
    
    
}

-(void)HPShopCarDetailCell:(HPShopCarDetailCell *)cell ClickReduceBtn:(UIButton *)sender
{
    
    if (sender.selected==YES) {
        return;
    }
    if (cell.number_field.text.length>0) {
        
        NSInteger currnumber = [cell.number_field.text integerValue]-1;
        if (currnumber==0) {
            // 商品数量必须大于0
//            [AppDelegate showHUDAndHide:@"至少一件商品" view:self.view timer:0.4];
            return;
        }
        cell.number_field.text = [NSString stringWithFormat:@"%ld",currnumber];
        
        
        
        cell.detailmodel.number = [NSString stringWithFormat:@"%ld",currnumber];
        
        [self modifyGoodsNumber:currnumber withID: cell.detailmodel.id button:sender andMode:cell.detailmodel];
    }
}
#pragma mark- 修改购物车商品数量
-(void)modifyGoodsNumber:(NSInteger )number withID:(NSString *)shopid button:(UIButton *)sender andMode:(HPShopdetailModel *)model;
{
    //发送请求前设置
      sender.selected = YES;
    
    // 请求中。。。。
     [self jisuanPrice];
    // 请求结束。。。
    
    // 请求成功恢复
     sender.selected = NO;
    
  //目的： 线程安全 ，
}
#pragma mark-
#pragma mark- HPShopCarHeaderViewDelegate

#pragma mark- 点击进入商店
-(void)HPShopCarHeaderViewSelect:(HPShopCarHeaderView *)view
{
    
    
    HPShopCarModel * ShopCarModel =[self.dataArr objectAtIndex:view.section];
    
    
    NSLog(@"进入商店");
    
}
#pragma mark- 商店选择
-(void)HPShopCarHeaderViewSelect:(HPShopCarHeaderView*)view clickselect_btn:(KDButton *)sender
{
    
    
    HPShopCarModel * ShopCarModel =[self.dataArr objectAtIndex:[view.sectionUI.text integerValue]];
    
    
    
    // HPShopCarModel * ShopCarModel =view.Model;
    
    ShopCarModel.isSelectArr = !ShopCarModel.isSelectArr ;
    
    view.select_btn.selected = ShopCarModel.isSelectArr;
    for (int i = 0 ; i<ShopCarModel.content.count; i++) {
        
        HPShopdetailModel * model = [ShopCarModel.content objectAtIndex:i];
        
        model.isSelect = ShopCarModel.isSelectArr;
        
        if ([[DJTUtility YRIsEmptString:model.goodsMark] floatValue]==-2) {
            
            // 商品下架
//            [AppDelegate showHUDAndHide:@"亲，已下架商品不可选" view:self.view];
            
            
            model.isSelect = NO;
        }
        
        
        
    };
    
    ShopCarModel.isSelectArr = NO ;
    [self.mainTable reloadData];
    
}


#pragma mark- 判断次商店下商品是否全选
-(BOOL)isAllSectionSelection:(HPShopCarModel*)model
{
    
    for (int m = 0 ; m <model.content.count; m++) {
        
        HPShopdetailModel * modeldetail = [model.content objectAtIndex:m];
        
        if (!modeldetail.isSelect) {
            
            model.isSelectArr = NO;
            return NO;
        }
        
        
    };
    model.isSelectArr = YES;
    return YES;
    
}

#pragma mark- 计算价钱
-(void)jisuanPrice
{
    self.totalprice = @"0";
    self.Actualprice=@"0";
    self.GoodsSelectCount = 0;
    self.canMadeCoup = @"0";
    for (int i=0; i<self.dataArr.count; i++) {
        
        HPShopCarModel * ShopCarModel =[self.dataArr objectAtIndex:i];
        ShopCarModel.currentSelectprice=@"0";
        for (int m = 0 ; m <ShopCarModel.content.count; m++) {
            
            HPShopdetailModel * modeldetail = [ShopCarModel.content objectAtIndex:m];
            if (modeldetail.isSelect) {
                
                NSDecimalNumber *count = [NSDecimalNumber decimalNumberWithString:modeldetail.count];
                NSDecimalNumber *decimalNumber1 = [[NSDecimalNumber decimalNumberWithString: modeldetail.price] decimalNumberByMultiplyingBy:count];
                NSDecimalNumber *decimalNumber2 = [NSDecimalNumber decimalNumberWithString:ShopCarModel.currentSelectprice];
                //加
                ShopCarModel.currentSelectprice = [[decimalNumber1 decimalNumberByAdding:decimalNumber2] stringValue];
                self.GoodsSelectCount = [modeldetail.count integerValue]+self.GoodsSelectCount;
            }
            
            
        }
        NSDecimalNumber *decimalNumber1 = [NSDecimalNumber decimalNumberWithString: self.totalprice];
        
        NSDecimalNumber *decimalNumber2 = [NSDecimalNumber decimalNumberWithString:ShopCarModel.currentSelectprice];
        NSDecimalNumber *decimalNumber3 = [NSDecimalNumber decimalNumberWithString:ShopCarModel.cut_price];
        //加
        self.totalprice =  [[decimalNumber1 decimalNumberByAdding:decimalNumber2] stringValue];
        
        NSLog(@"ShopCarModel.full_price:%@.....ShopCarModel.currentSelectprice:%@...ShopCarModel.cut_price:%@",ShopCarModel.full_price,ShopCarModel.currentSelectprice,ShopCarModel.cut_price);
        NSDecimalNumber *decimalNumber4 = [NSDecimalNumber decimalNumberWithString:self.Actualprice];
        
        self.Actualprice =[[decimalNumber4 decimalNumberByAdding:decimalNumber2] stringValue];
        
        
        if ([ShopCarModel.full_price doubleValue]<[ShopCarModel.currentSelectprice doubleValue]&&[ShopCarModel.full_price doubleValue]>0) {
            // 计算实际应付的金额，（符合满减条件去掉满减的金额）
            NSDecimalNumber *decimalNumber5 = [NSDecimalNumber decimalNumberWithString:self.Actualprice];
            self.Actualprice =[[decimalNumber5 decimalNumberBySubtracting:decimalNumber3] stringValue];
            self.canMadeCoup = @"1";
            
            
        }
        
        
    }
    
    // 修改底部钱数显示

    
    _BottomView.totalprice = [DJTUtility notRounding: [NSDecimalNumber decimalNumberWithString:self.totalprice] afterPoint:2];
    _BottomView.Actualprice = [DJTUtility notRounding: [NSDecimalNumber decimalNumberWithString:self.Actualprice] afterPoint:2];
    NSLog(@"totalprice:%@=====%@",self.totalprice,[NSString stringWithFormat:@"%.2lf",[self.totalprice floatValue]]);
    [_BottomView.Settlement_btn setTitle:[NSString stringWithFormat:@"结算(%ld)",self.GoodsSelectCount] forState:UIControlStateNormal];
    [self aboutfreihtUI];
}
#pragma mark- 运费处理
-(void)aboutfreihtUI
{
    if ([self.Actualprice floatValue]>[self.freightMode.fill_exempt floatValue]) {
        
        self.freightbl.hidden = YES;
        self.freightMode.actionfreight =@"0.0";
    }else
    {
        if ([self.freightMode.fill_exempt floatValue]>=0) {
            
            self.freightbl.hidden = NO;
            self.freightbl.text =[NSString stringWithFormat:@"  单笔订单满%@免配送费",self.freightMode.fill_exempt];
            self.freightMode.actionfreight =self.freightMode.freight;
            
        }
        
        
    }
    
}

#pragma mark- 判断是否全部选中 计算价钱
-(BOOL)iSallSelect
{
    
    
    self.totalprice = @"0";
    self.Actualprice=@"0";
    self.canMadeCoup = @"0";
    self.GoodsSelectCount = 0;
    for (int i=0; i<self.dataArr.count; i++) {
        
        HPShopCarModel * ShopCarModel =[self.dataArr objectAtIndex:i];
        ShopCarModel.currentSelectprice=@"0";
        // 更新
        [self isAllSectionSelection:ShopCarModel];
        // 计算每个商店下所有商品 选中商品的总价钱
        
        //ShopCarModel.currentSelectprice = [ShopCarModel.price  ];
        
        for (int m = 0 ; m <ShopCarModel.content.count; m++) {
            
            HPShopdetailModel * modeldetail = [ShopCarModel.content objectAtIndex:m];
            if (modeldetail.isSelect) {
                
                NSDecimalNumber *count = [NSDecimalNumber decimalNumberWithString:modeldetail.count];
                NSDecimalNumber *decimalNumber1 = [[NSDecimalNumber decimalNumberWithString: modeldetail.price] decimalNumberByMultiplyingBy:count];
                NSDecimalNumber *decimalNumber2 = [NSDecimalNumber decimalNumberWithString:ShopCarModel.currentSelectprice];
                //加
                ShopCarModel.currentSelectprice = [[decimalNumber1 decimalNumberByAdding:decimalNumber2] stringValue];
                self.GoodsSelectCount = [modeldetail.count integerValue]+self.GoodsSelectCount;
            }
            
            
        }
        NSDecimalNumber *decimalNumber1 = [NSDecimalNumber decimalNumberWithString: self.totalprice];
        
        NSDecimalNumber *decimalNumber2 = [NSDecimalNumber decimalNumberWithString:ShopCarModel.currentSelectprice];
        NSDecimalNumber *decimalNumber3 = [NSDecimalNumber decimalNumberWithString:ShopCarModel.cut_price];
        
        NSDecimalNumber *decimalNumber4 = [NSDecimalNumber decimalNumberWithString:self.Actualprice];
        //加
        self.totalprice =  [[decimalNumber1 decimalNumberByAdding:decimalNumber2] stringValue];
        
        self.Actualprice =[[decimalNumber4 decimalNumberByAdding:decimalNumber2] stringValue];
        if ([ShopCarModel.full_price doubleValue]<[ShopCarModel.currentSelectprice doubleValue]&&[ShopCarModel.full_price doubleValue]>0) {
            // 计算实际应付的金额，（符合满减条件去掉满减的金额）
            NSDecimalNumber *decimalNumber5 = [NSDecimalNumber decimalNumberWithString:self.Actualprice];
            self.Actualprice =[[decimalNumber5 decimalNumberBySubtracting:decimalNumber3] stringValue];
            self.canMadeCoup = @"1";
        }
        
        
        
        
    }
    
    _BottomView.totalprice = [DJTUtility notRounding: [NSDecimalNumber decimalNumberWithString:self.totalprice] afterPoint:2];
    _BottomView.Actualprice = [DJTUtility notRounding: [NSDecimalNumber decimalNumberWithString:self.Actualprice] afterPoint:2];
    
    
    [_BottomView.Settlement_btn setTitle:[NSString stringWithFormat:@"结算(%ld)",self.GoodsSelectCount] forState:UIControlStateNormal];
    
    NSLog(@"totalprice:%@=====%@",self.totalprice,[NSString stringWithFormat:@"%.2lf",[self.totalprice floatValue]]);
    [self aboutfreihtUI];
    
    // 判断是否全选
    for (int i=0; i<self.dataArr.count; i++) {
        
        HPShopCarModel * ShopCarModel =[self.dataArr objectAtIndex:i];
        
        
        
        
        for (int j = 0 ; j<ShopCarModel.content.count; j++) {
            
            HPShopdetailModel * model = [ShopCarModel.content objectAtIndex:j];
            
            if (!model.isSelect) {
                
                return NO;
                
            }
            
            
        };
        
        NSLog(@"1111")
        
        
    }
    return YES;
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


/**
 *    @brief    截取指定小数位的值
 *
 *    @param     price     需要转化的数据
 *    @param     position     有效小数位
 *
 *    @return    截取后数据
 */


@end
