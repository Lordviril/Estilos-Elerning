//
//  CalendarLogicDelegate.h
//  Calendar
//
//  Created by hidden brains
//  Copyright 2010 Savage Media Pty Ltd. All rights reserved.
//

@class CalendarLogic;

@protocol CalendarLogicDelegate

- (void)calendarLogic:(CalendarLogic *)aLogic dateSelected:(NSDate *)aDate;
- (void)calendarLogic:(CalendarLogic *)aLogic monthChangeDirection:(NSInteger)aDirection;

@end
