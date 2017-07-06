//
//  HPShopCarBottomView.m
//  HPShop
//
//  Created by 李学文 on 2017/2/7.
//  Copyright © 2017年 李学文. All rights reserved.
//

#import "HPShopCarBottomView.h"

@implementation HPShopCarBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    //    NSMutableAttributedString
    NSMutableAttributedString *attributedStr01 = [[NSMutableAttributedString alloc] initWithString:self.totalamount_bl.text];
    
    //给所有字符设置字体为Zapfino，字体高度为15像素
   
    [attributedStr01 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize: 15]
                            range: NSMakeRange( 0, self.totalamount_bl.text.length)];
    
    [attributedStr01 addAttribute: NSForegroundColorAttributeName value: [UIColor colorFromHexRGB:@"f23030"] range: NSMakeRange(3, self.totalamount_bl.text.length-3)];
    
    //分段控制，最开始4个字符颜色设置成蓝色
    //[attributedStr01 addAttribute: NSForegroundColorAttributeName value: [UIColor blueColor] range: NSMakeRange(0, 4)];
    //分段控制，第5个字符开始的3个字符，即第5、6、7字符设置为红色

    
    self.self.totalamount_bl.attributedText =attributedStr01;
 
}
-(void)setTotalprice:(NSString *)totalprice
{
    _totalprice = totalprice;
   
    
    
    
     self.amount_bl.text =[NSString stringWithFormat:@"总额:¥%@",[DJTUtility notRounding: [NSDecimalNumber decimalNumberWithString:self.totalprice] afterPoint:2]];
    
     //self.amount_bl.text =[NSString stringWithFormat:@"总额:¥%.2lf",[self.totalprice floatValue]];

}
-(void)setActualprice:(NSString *)Actualprice
{
    _Actualprice = Actualprice;
    
    
    self.totalamount_bl.text =[NSString stringWithFormat:@"合计:¥%@",[DJTUtility notRounding: [NSDecimalNumber decimalNumberWithString:self.Actualprice] afterPoint:2]];
    NSMutableAttributedString *attributedStr01 = [[NSMutableAttributedString alloc] initWithString:self.totalamount_bl.text];
    
    //给所有字符设置字体为Zapfino，字体高度为15像素
    
    [attributedStr01 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize: 15]
                            range: NSMakeRange( 0, self.totalamount_bl.text.length)];
    
    [attributedStr01 addAttribute: NSForegroundColorAttributeName value: [UIColor colorFromHexRGB:@"f23030"] range: NSMakeRange(3, self.totalamount_bl.text.length-3)];
    
    //分段控制，最开始4个字符颜色设置成蓝色
    //[attributedStr01 addAttribute: NSForegroundColorAttributeName value: [UIColor blueColor] range: NSMakeRange(0, 4)];
    //分段控制，第5个字符开始的3个字符，即第5、6、7字符设置为红色
    
    
    self.self.totalamount_bl.attributedText =attributedStr01;
    
   
}

- (IBAction)ClickSettlementBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(HPShopCarBottomView:ClickSettlementBtn:)]) {
        
        [self.delegate HPShopCarBottomView:self ClickSettlementBtn:sender];
    }
}

- (IBAction)clickAllSelectBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(HPShopCarBottomView:clickAllSelectBtn:)]) {
        
        [self.delegate HPShopCarBottomView:self clickAllSelectBtn:sender];
    }
}
@end
