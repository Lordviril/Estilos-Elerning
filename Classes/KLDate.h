
#import <UIKit/UIKit.h>

@interface KLDate : NSObject <NSCopying, NSCoding> {
    NSInteger _year, _month, _day;
}

+ (id)today;

// Designated initializer
- (id)initWithYear:(NSInteger)year month:(NSUInteger)month day:(NSUInteger)day;

- (NSComparisonResult)compare:(KLDate *)otherDate;
- (NSInteger)yearOfCommonEra;
- (NSInteger)monthOfYear;
- (NSInteger)dayOfMonth;

- (BOOL)isEarlierThan:(KLDate *)aDate;
- (BOOL)isLaterThan:(KLDate *)aDate;
- (BOOL)isToday;
- (BOOL)isTheDayBefore:(KLDate *)anotherDate;
- (BOOL)isSelDate:(KLDate*)seldate;

// NSCopying
- (id)copyWithZone:(NSZone *)zone;

// NSCoding
- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;

@end








