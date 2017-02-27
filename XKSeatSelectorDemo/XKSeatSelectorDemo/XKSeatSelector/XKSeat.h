//
//  XKSeat.h
//  Theatre
//
//  Created by liping kang on 17/2/14.
//  Copyright © 2017年 liping kang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKSeat : UIButton

@property (nonatomic) BOOL available;
@property (nonatomic) BOOL disabled;
@property (nonatomic) BOOL selected_seat;
@property (nonatomic) int row;
@property (nonatomic) int column;
@property (nonatomic) float price;

@end
