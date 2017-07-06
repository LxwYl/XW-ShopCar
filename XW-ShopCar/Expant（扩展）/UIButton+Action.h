//
//  UIButton+Action.h
//  LeSong
//
//  Created by 韩军强 on 2017/6/15.
//  Copyright © 2017年 李学文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Action)

- (void)addAction:(void(^)(NSInteger tag))block;

-(void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets;

@end
