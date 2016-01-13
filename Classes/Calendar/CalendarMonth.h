//
//  CalendarMonth.h
//  Calendar
//
//  Created by hidden brains
//  Copyright 2010 Savage Media Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalendarMonthDelegate <NSObject>

-(void)btnDateSelected:(NSString *)selectedDate;

@end

@class CalendarLogic;

@interface CalendarMonth : UIView {
	CalendarLogic *calendarLogic;
	NSArray *datesIndex;
	NSArray *buttonsIndex;
	
	NSInteger numberOfDaysInWeek;
	NSInteger selectedButton;
	NSDate *selectedDate;
}
@property (nonatomic, strong) id <CalendarMonthDelegate>delegate;

@property (nonatomic, retain) CalendarLogic *calendarLogic;
@property (nonatomic, retain) NSArray *datesIndex;
@property (nonatomic, retain) NSArray *buttonsIndex;

@property (nonatomic) NSInteger numberOfDaysInWeek;
@property (nonatomic) NSInteger selectedButton;
@property (nonatomic, retain) NSDate *selectedDate;


//- (id)initWithFrame:(CGRect)frame logic:(CalendarLogic *)aLogic;
- (id)initWithFrame:(CGRect)frame logic:(CalendarLogic *)aLogic :(NSMutableArray*)arraySelectedDays :(id)delegate;

- (void)selectButtonForDate:(NSDate *)aDate;

@end
