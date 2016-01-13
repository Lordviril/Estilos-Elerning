

#import <UIKit/UIKit.h>

@class THCalendarInfo;

@interface KLCalendarModel : NSObject {
    CFCalendarRef _cal;
    THCalendarInfo *_calendarInfo;
    NSArray *_dayNames;
}

- (void)decrementMonth;
- (void)incrementMonth;
- (NSString *)selectedMonthName;
- (NSInteger)selectedMonthNumberOfWeeks;
- (NSInteger)selectedYear;
- (NSString *)dayNameAbbreviationForDayOfWeek:(NSUInteger)dayOfWeek;

- (NSArray *)daysInFinalWeekOfPreviousMonth;
- (NSArray *)daysInSelectedMonth;
- (NSArray *)daysInFirstWeekOfFollowingMonth;

@end
