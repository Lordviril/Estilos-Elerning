

#import "KLCalendarModel.h"
#import "THCalendarInfo.h"
#import "KLDate.h"

@implementation KLCalendarModel

- (id)init
{
    if (![super init])
        return nil;
    
    _calendarInfo = [[THCalendarInfo alloc] init];
    [_calendarInfo setDate:[NSDate date]];
    
    _cal = CFCalendarCopyCurrent();
    
	_dayNames = [[NSArray alloc] initWithObjects:[eEducationAppDelegate getLocalvalue:@"Sun"], [eEducationAppDelegate getLocalvalue:@"Mon"], [eEducationAppDelegate getLocalvalue:@"Tue"], [eEducationAppDelegate getLocalvalue:@"Wed"], [eEducationAppDelegate getLocalvalue:@"Thu"], [eEducationAppDelegate getLocalvalue:@"Fri"], [eEducationAppDelegate getLocalvalue:@"Sat"], nil];
    return self;
}



#pragma mark Public methods

- (void)decrementMonth
{
    [_calendarInfo moveToPreviousMonth];
}

- (void)incrementMonth
{
    [_calendarInfo moveToNextMonth];
}

- (NSString *)selectedMonthName
{
    return [_calendarInfo monthName];
}

- (NSInteger)selectedYear
{
    return [_calendarInfo year];
}

- (NSInteger)selectedMonthNumberOfWeeks
{
    return (NSInteger)[_calendarInfo weeksInMonth];

}

// gives you "Mon" for input 1 if region is set to United States ("Mon" for Monday)
// if region uses a calendar that starts the week with monday, an input of 1 will give "Tue"
- (NSString *)dayNameAbbreviationForDayOfWeek:(NSUInteger)dayOfWeek
{
    if (CFCalendarGetFirstWeekday(_cal) == 2)          // Monday is first day of week
        return [_dayNames objectAtIndex:(dayOfWeek+1)%7];
    
    return [_dayNames objectAtIndex:dayOfWeek];        // Sunday is first day of week
}

- (NSArray *)daysInFinalWeekOfPreviousMonth
{
    NSDate *savedState = [_calendarInfo date];
    NSMutableArray *days = [NSMutableArray array];

    [_calendarInfo moveToFirstDayOfMonth];
    [_calendarInfo moveToPreviousDay];
    NSInteger year = [_calendarInfo year];
    NSInteger month = [_calendarInfo month];
    NSInteger lastDayOfPreviousMonth = [_calendarInfo dayOfMonth];
    NSInteger lastDayOfWeekInPreviousMonth = [_calendarInfo dayOfWeek];
    
    if (lastDayOfWeekInPreviousMonth != 7)
        for (NSInteger day = 1 + lastDayOfPreviousMonth - lastDayOfWeekInPreviousMonth; day <= lastDayOfPreviousMonth; day++) {
            KLDate *d = [[KLDate alloc] initWithYear:year month:month day:day];
            [days addObject:d];
            [d release];
        }

        
    [_calendarInfo setDate:savedState];
    return days;
}

- (NSArray *)daysInSelectedMonth
{
    NSDate *savedState = [_calendarInfo date];
    NSMutableArray *days = [NSMutableArray array];
    
    NSInteger year = [_calendarInfo year];
    NSInteger month = [_calendarInfo month];
    NSInteger lastDayOfMonth = [_calendarInfo daysInMonth];
    
    for (NSInteger day = 1; day <= lastDayOfMonth; day++) {
        KLDate *d = [[KLDate alloc] initWithYear:year month:month day:day];
        [days addObject:d];
        [d release];
    }
    
    [_calendarInfo setDate:savedState];
    
    return days;
}

- (NSArray *)daysInFirstWeekOfFollowingMonth
{
    NSDate *savedState = [_calendarInfo date];
    NSMutableArray *days = [NSMutableArray array];
    
    [_calendarInfo moveToNextMonth];
    [_calendarInfo moveToFirstDayOfMonth];
    NSInteger year = [_calendarInfo year];
    NSInteger month = [_calendarInfo month];
    NSInteger firstDayOfWeekInFollowingMonth = [_calendarInfo dayOfWeek];
    
    if (firstDayOfWeekInFollowingMonth != 1)
        for (NSInteger day = 1; day <= 8-firstDayOfWeekInFollowingMonth; day++) {
            KLDate *d = [[KLDate alloc] initWithYear:year month:month day:day];
            [days addObject:d];
            [d release];
        }
    
    [_calendarInfo setDate:savedState];
    return days;
}

- (void)dealloc
{
    CFRelease(_cal);
    [_calendarInfo release];
    [_dayNames release];
    [super dealloc];
}

@end





