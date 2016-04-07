//
//  UIControl+YYAdd.h
//  UIImageRoundedCornerDemo
//
//  Created by jm on 16/3/12.
//  Copyright © 2016年 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (YYAdd)

- (void)addBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block;

@end
