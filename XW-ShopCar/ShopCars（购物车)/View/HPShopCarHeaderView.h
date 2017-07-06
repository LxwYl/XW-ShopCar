//
//  HPShopCarHeaderView.h
//  HPShop
//
//  Created by 李学文 on 2017/2/7.
//  Copyright © 2017年 李学文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPShopCarModel.h"
#import "KDButton.h"
@class HPShopCarHeaderView;
@protocol HPShopCarHeaderViewDelegate <NSObject>

-(void)HPShopCarHeaderViewSelect:(HPShopCarHeaderView*)view ;
-(void)HPShopCarHeaderViewSelect:(HPShopCarHeaderView*)view clickselect_btn:(KDButton *)sender;

@end

@interface HPShopCarHeaderView : UITableViewHeaderFooterView<UIGestureRecognizerDelegate>
@property(weak, nonatomic) id<HPShopCarHeaderViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *sectionUI;
@property(strong, nonatomic)  HPShopCarModel * Model;
@property (weak, nonatomic) IBOutlet KDButton *select_btn;
@property (weak, nonatomic) IBOutlet UILabel *title_bl;
@property(assign,nonatomic) NSInteger section;
@property (weak, nonatomic) IBOutlet UIView *fullcutView;

@property (weak, nonatomic) IBOutlet UILabel *fullcutPromptbl;
@property (weak, nonatomic) IBOutlet UILabel *fullcutResultbl;

-(void)SetHpShopCarMode:(HPShopCarModel*)mode;

- (IBAction)clickselect_btn:(KDButton *)sender;
@end
