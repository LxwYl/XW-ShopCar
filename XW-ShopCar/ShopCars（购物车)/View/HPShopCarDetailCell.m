//
//  HPShopCarDetailCell.m
//  HPShop
//
//  Created by 李学文 on 2017/1/27.
//  Copyright © 2017年 李学文. All rights reserved.
//

#import "HPShopCarDetailCell.h"

@implementation HPShopCarDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setShopCarModel:(HPShopCarModel *)model
{
    _model = model;
    

}
-(void)setShopDetailModel:(HPShopdetailModel *)detailmodel
{
    _detailmodel = detailmodel;
    
    _select_btn.selected = _detailmodel.isSelect;
    
    [self.select_btn setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];

    
//    @property (weak, nonatomic) IBOutlet UIImageView *header_imageView;
//    @property (weak, nonatomic) IBOutlet UILabel *title_bl;
//    @property (weak, nonatomic) IBOutlet UILabel *info_bl;
//    @property (weak, nonatomic) IBOutlet UILabel *rice_bl;
//    @property (weak, nonatomic) IBOutlet UIButton *reduce_bt;
//    @property (weak, nonatomic) IBOutlet UIButton *add_bt;
//    @property (weak, nonatomic) IBOutlet UITextField *number_field;
    
    self.title_bl.text = [DJTUtility YRIsEmptString:detailmodel.goods_name];
    self.info_bl.text = [DJTUtility YRIsEmptString:detailmodel.spec_info];
    self.rice_bl.text = [NSString stringWithFormat:@"¥%.2lf",[[DJTUtility YRIsEmptString:detailmodel.price] floatValue]];
    self.number_field.text = [DJTUtility YRIsEmptString:detailmodel.count];
    [self.header_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",BASEURL,detailmodel.pathName]] placeholderImage:[UIImage imageNamed:@""]];
    if ([[DJTUtility YRIsEmptString:detailmodel.goodsMark ] integerValue]==-2) {
        
        self.isgoodsmark.hidden = NO;
        
//        @property (weak, nonatomic) IBOutlet UILabel *title_bl;
//        @property (weak, nonatomic) IBOutlet UILabel *info_bl;
//        @property (weak, nonatomic) IBOutlet UILabel *info_bl;
//        @property (weak, nonatomic) IBOutlet UIButton *reduce_bt;
//        @property (weak, nonatomic) IBOutlet UIButton *add_bt;
//        @property (weak, nonatomic) IBOutlet UITextField *number_field;
        
        self.title_bl.textColor =[UIColor colorFromHexRGB:@"9e9e9e"];
        self.info_bl.textColor =[UIColor colorFromHexRGB:@"9e9e9e"];
        self.rice_bl.textColor =[UIColor colorFromHexRGB:@"9e9e9e"];
        self.add_bt.hidden =YES;
        self.reduce_bt.hidden =YES;
        self.number_field.hidden =YES;
        
    }else
    {
        self.isgoodsmark.hidden = YES;
        self.title_bl.textColor =[UIColor blackColor];
        self.info_bl.textColor =[UIColor colorFromHexRGB:@"9e9e9e"];
        self.rice_bl.textColor =[UIColor colorFromHexRGB:@"EC2F0E"];
        self.add_bt.hidden =NO;
        self.reduce_bt.hidden =NO;
        self.number_field.hidden =NO;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

  
}

- (IBAction)ClickReduceBtn:(UIButton *)sender {
    

    if ([self.delegate respondsToSelector:@selector(HPShopCarDetailCell:ClickReduceBtn:)]) {
        [self.delegate HPShopCarDetailCell:self ClickReduceBtn:sender];
        
    }
}

- (IBAction)ClickSelect_btn:(KDButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(HPShopCarDetailCell:ClickSelect_btn:)]) {
        [self.delegate HPShopCarDetailCell:self ClickSelect_btn:sender];
    }
}
- (IBAction)ClickAddBtn:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(HPShopCarDetailCell:ClickAddBtn:)]) {
        [self.delegate HPShopCarDetailCell:self ClickAddBtn:sender];
    }
}

@end
