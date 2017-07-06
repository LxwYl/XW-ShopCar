//
//  UIButton+Action.m
//  LeSong
//
//  Created by 韩军强 on 2017/6/15.
//  Copyright © 2017年 李学文. All rights reserved.
//

#import "UIButton+Action.h"
#import <objc/runtime.h>

static NSString *BlockAddrKey = @"ButtonBlockKey";


@interface UIButton ()

@property (nonatomic, copy) void(^block)(NSInteger tag);

@end
@implementation UIButton (Action)

- (void (^)(NSInteger))block {
    return objc_getAssociatedObject(self, &BlockAddrKey);
}

- (void)setBlock:(void (^)(NSInteger))block {
    objc_setAssociatedObject(self, &BlockAddrKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//1.0 block方式添加点击事件
- (void)addAction:(void(^)(NSInteger tag))block {
    
    self.block = block;
    [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonAction:(UIButton *)bt {
    self.block(bt.tag);
}

//--------------------------增加按钮的点击范围--------------------------------
static const NSString *KEY_HIT_TEST_EDGE_INSETS = @"HitTestEdgeInsets";

-(void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = [NSValue value:&hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS);
    if(value) {
        UIEdgeInsets edgeInsets; [value getValue:&edgeInsets]; return edgeInsets;
    }else {
        return UIEdgeInsetsZero;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if(UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero) ||       !self.enabled || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}





@end
