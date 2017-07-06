//
//  HPShopCarDetailCell.h
//  HPShop
//
//  Created by 李学文 on 2017/1/27.
//  Copyright © 2017年 李学文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPShopCarModel.h"
#import "LYSideslipCell.h"
#import "KDButton.h"

@class HPShopCarDetailCell;
@protocol HPShopCarDetailCellDelegate <NSObject>

-(void)HPShopCarDetailCell:(HPShopCarDetailCell*)cell ClickReduceBtn:(UIButton *)sender;
-(void)HPShopCarDetailCell:(HPShopCarDetailCell*)cell ClickAddBtn:(UIButton *)sender;
-(void)HPShopCarDetailCell:(HPShopCarDetailCell*)cell ClickSelect_btn:(KDButton *)sender;

@end


@interface HPShopCarDetailCell : LYSideslipCell
@property (weak, nonatomic) IBOutlet UIImageView *header_imageView;
@property (weak, nonatomic) IBOutlet UILabel *title_bl;
@property (weak, nonatomic) IBOutlet UILabel *info_bl;
@property (weak, nonatomic) IBOutlet UILabel *rice_bl;
@property (weak, nonatomic) IBOutlet UIButton *reduce_bt;
@property (weak, nonatomic) IBOutlet UIButton *add_bt;
@property (weak, nonatomic) IBOutlet UITextField *number_field;
@property (weak, nonatomic) IBOutlet UILabel *isgoodsmark;//下架 -2 下架 

@property(weak, nonatomic) id<HPShopCarDetailCellDelegate> delegate;

@property(strong, nonatomic) HPShopCarModel * model;
@property(strong, nonatomic) HPShopdetailModel * detailmodel;
@property (weak, nonatomic) IBOutlet KDButton *select_btn;


-(void)setShopCarModel:(HPShopCarModel *)model;
-(void)setShopDetailModel:(HPShopdetailModel *)detailmodel;
- (IBAction)ClickReduceBtn:(UIButton *)sender;

- (IBAction)ClickSelect_btn:(KDButton *)sender;

- (IBAction)ClickAddBtn:(UIButton *)sender;
@end
