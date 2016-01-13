//
//  CalendarViewControllerDelegate.h
//  Sorted
//
//  Created by hidden brains.
//  Copyright 2010 Savage Media Pty Ltd. All rights reserved.
//

@class CalendarViewController;

@protocol CalendarViewControllerDelegate

- (void)calendarViewController:(CalendarViewController *)aCalendarViewController dateDidChange:(NSDate *)aDate;

@end
