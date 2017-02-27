//
//  XKSeatSelector.h
//  Theatre
//
//  Created by liping kang on 17/2/14.
//  Copyright © 2017年 liping kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKSeat.h"

@class XKSeatSelector;
@protocol XKSeatSelectorDelegate <NSObject>
- (void)seatSelected:(XKSeat *)seat;
@optional
- (void)getSelectedSeats:(NSMutableArray *)seats;
@end

@interface XKSeatSelector : UIScrollView<UIScrollViewDelegate>{
	float seat_width;
	float seat_height;
	NSMutableArray *selected_seats;
	UIView *zoomable_view;
}
@property (nonatomic, retain) UIImage *available_image;
@property (nonatomic, retain) UIImage *unavailable_image;
@property (nonatomic, retain) UIImage *disabled_image;
@property (nonatomic, retain) UIImage *selected_image;
@property (nonatomic) int selected_seat_limit;

@property (nonatomic) float seat_price;
@property (retain) id seat_delegate;

-(void)setSeatSize:(CGSize)size;
-(void)setMap:(NSString*)map;

-(void)setAvailableImage:(UIImage*)available_image andUnavailableImage:(UIImage*)unavailable_image andDisabledImage:(UIImage*)disabled_image andSelectedImage:(UIImage*)selected_image;
@end
