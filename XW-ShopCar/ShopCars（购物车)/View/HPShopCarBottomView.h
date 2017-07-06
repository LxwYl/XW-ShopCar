//
//  HPShopCarBottomView.h
//  HPShop
//
//  Created by 李学文 on 2017/2/7.
//  Copyright © 2017年 李学文. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HPShopCarBottomView;
@protocol HPShopCarBottomViewDelegate <NSObject>

-(void)HPShopCarBottomView:(HPShopCarBottomView*)view ClickSettlementBtn:(UIButton *)sender;

-(void)HPShopCarBottomView:(HPShopCarBottomView*)view clickAllSelectBtn:(UIButton *)sender;


@end

@interface HPShopCarBottomView : UIView
@property (weak, nonatomic) IBOutlet UIButton *select_bt;

@property (weak, nonatomic) IBOutlet UIButton *Settlement_btn;
@property (weak, nonatomic) IBOutlet UILabel *totalamount_bl;
@property (weak, nonatomic) IBOutlet UILabel *amount_bl;
@property(strong, nonatomic) NSString * totalprice;// 包含运费 不包含满减的
@property(strong, nonatomic) NSString * Actualprice;// 包含运费 包含满减的
@property(strong, nonatomic) id<HPShopCarBottomViewDelegate> delegate;
- (IBAction)ClickSettlementBtn:(UIButton *)sender;
- (IBAction)clickAllSelectBtn:(UIButton *)sender;
@end
