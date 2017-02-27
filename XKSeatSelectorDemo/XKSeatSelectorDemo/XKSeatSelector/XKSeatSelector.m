//
//  XKSeatSelector.m
//  Theatre
//
//  Created by liping kang on 17/2/14.
//  Copyright © 2017年 liping kang. All rights reserved.
//

#import "XKSeatSelector.h"
#import "XKSeatsPickerIndexView.h"

static const CGFloat kRowIndexWidth = 15;

@implementation XKSeatSelector{
	XKSeatsPickerIndexView* _rowIndexView;
}

- (void)setSeatSize:(CGSize)size{
	seat_width = size.width;
	seat_height = size.height;
}
- (void)setMap:(NSString*)map{
	
	self.delegate = self;
	zoomable_view = [[UIView alloc]init];
	
	int initial_seat_x = 0;
	int initial_seat_y = 0;
	int final_width = 0;
	
	for (int i = 0; i<map.length; i++) {
		char seat_at_position = [map characterAtIndex:i];
		
		if (seat_at_position == 'A') {
			[self createSeatButtonWithPosition:initial_seat_x and:initial_seat_y isAvailable:TRUE isDisabled:FALSE];
			initial_seat_x += 1;
			
		} else if (seat_at_position == 'D') {
			[self createSeatButtonWithPosition:initial_seat_x and:initial_seat_y isAvailable:TRUE isDisabled:TRUE];
			initial_seat_x += 1;
			
		} else if (seat_at_position == 'U') {
			[self createSeatButtonWithPosition:initial_seat_x and:initial_seat_y isAvailable:FALSE isDisabled:FALSE];
			initial_seat_x += 1;
			
		} else if(seat_at_position=='_'){
			initial_seat_x += 1;
			
		} else {
			if (initial_seat_x>final_width) {
				final_width = initial_seat_x;
			}
			initial_seat_x = 0;
			initial_seat_y += 1;
		}
	}
	
	zoomable_view.frame = CGRectMake(0, 0, final_width*seat_width + 40, initial_seat_y*seat_height);
	[self setContentSize:CGSizeMake(zoomable_view.frame.size.width, zoomable_view.frame.size.height)];
	CGFloat newContentOffsetX = (self.contentSize.width - self.frame.size.width) / 2;
	self.contentOffset = CGPointMake(newContentOffsetX, 0);
	selected_seats = [[NSMutableArray alloc]init];
	[self addSubview:zoomable_view];
	
	_rowIndexView = ({
		XKSeatsPickerIndexView* indexView = [[XKSeatsPickerIndexView alloc] initWithFrame:CGRectMake(self.contentOffset.x / self.zoomScale + 5, 0, kRowIndexWidth, 17 * 30)];
		indexView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.6];
		indexView.indexList = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"",@"7",@"8",@"9",@"10",@"11",@"12",@"",@"13",@"14",@"15", nil];
		[zoomable_view addSubview:indexView];
		indexView;
	});
	
}

- (void)createSeatButtonWithPosition:(int)initial_seat_x and:(int)initial_seat_y isAvailable:(BOOL)available isDisabled:(BOOL)disabled{
	
	XKSeat *seatButton = [[XKSeat alloc]initWithFrame:
						 CGRectMake(initial_seat_x*seat_width + 30,
									initial_seat_y*seat_height,
									seat_width,
									seat_height)];
	
	if (available && disabled) {
		[self setSeatAsDisabled:seatButton];
	} else if (available && !disabled) {
		[self setSeatAsAvaiable:seatButton];
	} else {
		[self setSeatAsUnavaiable:seatButton];
	}
	[seatButton setAvailable:available];
	[seatButton setDisabled:disabled];
	[seatButton setRow:initial_seat_y+1];
	[seatButton setColumn:initial_seat_x+1];
	[seatButton setPrice:self.seat_price];
	[seatButton addTarget:self action:@selector(seatSelected:) forControlEvents:UIControlEventTouchDown];
	[zoomable_view addSubview:seatButton];	
}

#pragma mark - Seat Selector Methods

- (void)seatSelected:(XKSeat*)sender{
	if (!sender.selected_seat && sender.available) {
		if (self.selected_seat_limit) {
			[self checkSeatLimitWithSeat:sender];
		} else {
			[self setSeatAsSelected:sender];
			[selected_seats addObject:sender];
		}
	} else {
		[selected_seats removeObject:sender];
		if (sender.available && sender.disabled) {
			[self setSeatAsDisabled:sender];
		} else if (sender.available && !sender.disabled) {
			[self setSeatAsAvaiable:sender];
		}
	}
	
	[self.seat_delegate seatSelected:sender];
	[self.seat_delegate getSelectedSeats:selected_seats];
}
- (void)checkSeatLimitWithSeat:(XKSeat*)sender{
	if ([selected_seats count]<self.selected_seat_limit) {
		[self setSeatAsSelected:sender];
		[selected_seats addObject:sender];
	} else {
		XKSeat *seat_to_make_avaiable = [selected_seats objectAtIndex:0];
		if (seat_to_make_avaiable.disabled)
			[self setSeatAsDisabled:seat_to_make_avaiable];
		else
			[self setSeatAsAvaiable:seat_to_make_avaiable];
		[selected_seats removeObjectAtIndex:0];
		[self setSeatAsSelected:sender];
		[selected_seats addObject:sender];
	}
}

#pragma mark - Seat Images & Availability

- (void)setAvailableImage:(UIImage *)available_image andUnavailableImage:(UIImage *)unavailable_image andDisabledImage:(UIImage *)disabled_image andSelectedImage:(UIImage *)selected_image{
	self.available_image    = available_image;
	self.unavailable_image  = unavailable_image;
	self.disabled_image     = disabled_image;
	self.selected_image     = selected_image;
}
- (void)setSeatAsUnavaiable:(XKSeat*)sender{
	[sender setImage:self.unavailable_image forState:UIControlStateNormal];
	[sender setSelected_seat:TRUE];
}
- (void)setSeatAsAvaiable:(XKSeat*)sender{
	[sender setImage:self.available_image forState:UIControlStateNormal];
	[sender setSelected_seat:FALSE];
}
- (void)setSeatAsDisabled:(XKSeat*)sender{
	[sender setImage:self.disabled_image forState:UIControlStateNormal];
	[sender setSelected_seat:FALSE];
}
- (void)setSeatAsSelected:(XKSeat*)sender{
	[sender setImage:self.selected_image forState:UIControlStateNormal];
	[sender setSelected_seat:TRUE];
}

- (void)repositionIndexView{
	_rowIndexView.frame = ({
		CGRect rect = _rowIndexView.frame;
		rect.origin.x = self.contentOffset.x / self.zoomScale + 5;
		rect;
	});
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[self repositionIndexView];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
	[self repositionIndexView];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	
	return zoomable_view;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{

}
@end
