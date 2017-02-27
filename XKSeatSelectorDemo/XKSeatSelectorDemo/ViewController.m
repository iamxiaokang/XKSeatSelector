//
//  ViewController.m
//  XKSeatSelectorDemo
//
//  Created by liping kang on 17/2/27.
//  Copyright © 2017年 liping kang. All rights reserved.
//

#import "ViewController.h"
#import "XKSeatSelector.h"
@interface ViewController () <XKSeatSelectorDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSString *map =
	@"__AAAAAAAAAAAAAAAAAAAAAAAAAAA/"
	@"__AAAAAAAAAAAAAAAAAAAAAAAAAAA/"
	@"_AAAAAAAAAAAAAAAAAAAAAAAAAAAA/"
	@"_AAAAAAAAAAAAAAAAAAAAAAAAAAAA/"
	@"_AAAAAAAAAAAAAAAAAAAAAAAAAAAA/"
	@"_AAAAAAAAAAAAAAAAAAAAAAAAAAAA/"
	@"_______________________/"
	@"___AAAAAAAAAAAAAAAAAAAAAAA/"
	@"___AAAAAAAAAAAAAAAAAAAAAAA/"
	@"___AAAAAAAAAAAAAAAAAAAAAAA/"
	@"___AAAAAAAAAAAAAAAAAAAAAAA/"
	@"___AAAAAAAAAAAAAAAAAAAAAAA/"
	@"___AAAAAAAAAAAAAAAAAAAAAAA/"
	@"_______________________/"
	@"_AAAAAAAAAAAAAAAAAAAAAAAAAAAA/"
	@"_AAAAAAAAAAAAAAAAAAAAAAAAAAAA/"
	@"AAAAAAAAAAAAAAAAAAAAAAAAAAAAA/"
	;
	
	XKSeatSelector *seat = [[XKSeatSelector alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.bounds.size.height - 64  - 150)];
	[seat setSeatSize:CGSizeMake(30, 30)];
	[seat setAvailableImage:[UIImage imageNamed:@"seat_available"]
		andUnavailableImage:[UIImage imageNamed:@"seat_disabled"]
		   andDisabledImage:[UIImage imageNamed:@"seat_disabled"]
		   andSelectedImage:[UIImage imageNamed:@"seat_selected"]];
	[seat setMap:map];
	seat.minimumZoomScale = 1;
	seat.maximumZoomScale = 5.0;
	[seat setSelected_seat_limit:4];
	seat.seat_delegate = self;
	
	[self.view addSubview:seat];
	
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)seatSelected:(XKSeat *)seat{
	NSLog(@"Seat at Row:%zd and Column:%zd", seat.row,seat.column);
}

-(void)getSelectedSeats:(NSMutableArray *)seats{
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
