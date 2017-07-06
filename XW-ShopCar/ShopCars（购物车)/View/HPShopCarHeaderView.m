//
//  HPShopCarHeaderView.m
//  HPShop
//
//  Created by 李学文 on 2017/2/7.
//  Copyright © 2017年 李学文. All rights reserved.
//

#import "HPShopCarHeaderView.h"

@implementation HPShopCarHeaderView

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
    
    UITapGestureRecognizer * tap  =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapGestureRecognizer:)];
    
    [self  addGestureRecognizer:tap];
    
    self.backgroundColor =[UIColor whiteColor];
    
    self.fullcutResultbl.layer.masksToBounds = YES;
    self.fullcutResultbl.layer.cornerRadius = 1.5;
    
}
-(void)TapGestureRecognizer:(UITapGestureRecognizer*)Recognizer
{
    if ([self.delegate respondsToSelector:@selector(HPShopCarHeaderViewSelect:)]) {
        
        [self.delegate HPShopCarHeaderViewSelect:self];
    }
    
}
-(void)SetHpShopCarMode:(HPShopCarModel*)mode
{
    _Model = mode;
   
    self.title_bl.text =[DJTUtility YRIsEmptString:mode.titleinfo];
    if ([_Model.full_price floatValue]>0) {
        
        self.fullcutView.hidden = NO;
        
        self.fullcutPromptbl.text = [NSString stringWithFormat:@"满%@减%@",_Model.full_price,_Model.cut_price];
        
        if ([_Model.currentSelectprice doubleValue]>[_Model.full_price doubleValue]) {
            self.fullcutResultbl.text = [NSString stringWithFormat:@"已减%@元",_Model.cut_price];
            
        }else
        {
            NSDecimalNumber *decimalNumber1 = [NSDecimalNumber decimalNumberWithString:mode.full_price];
            NSDecimalNumber *decimalNumber2 = [NSDecimalNumber decimalNumberWithString:mode.currentSelectprice];
             self.fullcutResultbl.text = [NSString stringWithFormat:@"再购%@元，可减%@元", [[decimalNumber1 decimalNumberBySubtracting:decimalNumber2] stringValue],_Model.cut_price];
           
        }
        
    }else
    {
        self.fullcutView.hidden = YES;
    }
    
}

- (IBAction)clickselect_btn:(KDButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(HPShopCarHeaderViewSelect:clickselect_btn:)]) {
        [self.delegate HPShopCarHeaderViewSelect:self clickselect_btn:sender];
    }
}
@end
