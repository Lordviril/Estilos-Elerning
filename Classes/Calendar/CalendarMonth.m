//
//  CalendarMonth.m
//  Calendar
//
//  Created by hidden brains.
//  Copyright 2010 Savage Media Pty Ltd. All rights reserved.
//

#import "CalendarMonth.h"
#import "eEducationAppDelegate.h"
#import "CalendarLogic.h"


#define kCalendarDayWidth	76.75f
#define kCalendarDayHeight	59.0f


@implementation CalendarMonth


#pragma mark -
#pragma mark Getters / setters

@synthesize calendarLogic;
@synthesize datesIndex;
@synthesize buttonsIndex;

@synthesize numberOfDaysInWeek;
@synthesize selectedButton;
@synthesize selectedDate;



#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	self.calendarLogic = nil;
	self.datesIndex = nil;
	self.buttonsIndex = nil;
	self.selectedDate = nil;
	
    [super dealloc];
}



#pragma mark -
#pragma mark Initialization

// Calendar object init
- (id)initWithFrame:(CGRect)frame logic:(CalendarLogic *)aLogic :(NSMutableArray*)arraySelectedDays :(id)delegate{
	
    self.delegate = delegate;
	// Size is static
	NSInteger numberOfWeeks = 6;
	frame.size.width = 545;
	frame.size.height = ((numberOfWeeks + 1) * kCalendarDayHeight) + 60;
	selectedButton = -1;
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];	
	NSDate *todayDate = [calendar dateFromComponents:components];
	
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor]; // Red should show up fails.
		self.opaque = YES;
		self.clipsToBounds = NO;
		self.clearsContextBeforeDrawing = NO;
		
		UIImageView *headerBackground = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 545, 83)] autorelease];
		[headerBackground setBackgroundColor:[UIColor clearColor]];
		[self addSubview:headerBackground];
		
		UIImageView *calendarBackground = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 83, 545, (numberOfWeeks + 1) * kCalendarDayHeight)] autorelease];
		[calendarBackground setBackgroundColor:[UIColor clearColor]];
		[self addSubview:calendarBackground];
		
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
		NSArray *daySymbols = [formatter shortWeekdaySymbols];
		self.numberOfDaysInWeek = [daySymbols count];
		
		UILabel *aLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 8, 545, 60)] autorelease];
		aLabel.backgroundColor = [UIColor clearColor];
		aLabel.textAlignment = NSTextAlignmentCenter;
		aLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:23.0];
		aLabel.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
		aLabel.shadowColor = [UIColor whiteColor];
		aLabel.shadowOffset = CGSizeMake(0, 1);
        [formatter setDateFormat:@"MMMM"];        
        NSString *dateStr = [eEducationAppDelegate getLocalvalue:[formatter stringFromDate:aLogic.referenceDate]];
        dateStr = dateStr;//[Globals getLocalvalue:dateStr];
        [formatter setDateFormat:@"yyyy"];
        dateStr =[dateStr stringByAppendingFormat:@" %@",[formatter stringFromDate:aLogic.referenceDate]];
		aLabel.text = dateStr;
		[self addSubview:aLabel];
		
		UIView *lineView = [[[UIView alloc] initWithFrame:CGRectMake(0, 82, 535, 1)] autorelease];
		lineView.backgroundColor = [UIColor lightGrayColor];
		[self addSubview:lineView];
		
		
		// Build calendar buttons (6 weeks of 7 days)
		NSMutableArray *aDatesIndex = [[[NSMutableArray alloc] init] autorelease];
		NSMutableArray *aButtonsIndex = [[[NSMutableArray alloc] init] autorelease];
        NSMutableArray *days;
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"IS_SPANISH_LANG"] isEqualToString:@"YES"]) {
            days = [[NSMutableArray alloc] initWithObjects:@"L",@"M",@"M",@"J",@"V",@"S",@"D", nil];
        } else {
            days = [[NSMutableArray alloc] initWithObjects:@"S",@"M",@"T",@"W",@"T",@"F",@"S", nil];
        }
		for (NSInteger aWeek = 0; aWeek <= numberOfWeeks; aWeek ++) {
			CGFloat positionY = (aWeek * kCalendarDayHeight) + 83;
			
			for (NSInteger aWeekday = 1; aWeekday <= numberOfDaysInWeek; aWeekday ++) {
				CGFloat positionX = ((aWeekday - 1) * kCalendarDayWidth) - 1;
                CGRect dayFrame;
                if (aWeek == 0) {
                    dayFrame = CGRectMake(positionX, positionY, kCalendarDayWidth, kCalendarDayHeight-10);
                    UIButton *dayButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    dayButton.opaque = YES;
                    dayButton.clipsToBounds = NO;
                    dayButton.clearsContextBeforeDrawing = NO;
                    dayButton.frame = dayFrame;
                    dayButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
                    dayButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
                    dayButton.tag = [aDatesIndex count]+7;
                    dayButton.adjustsImageWhenHighlighted = NO;
                    dayButton.adjustsImageWhenDisabled = NO;
                    dayButton.showsTouchWhenHighlighted = YES;
                    [dayButton setBackgroundImage:[UIImage imageNamed:@"calender_bx@2x.png"] forState:UIControlStateNormal];
                    [dayButton setTitle:[days objectAtIndex:aWeekday-1]
                               forState:UIControlStateNormal];
                    [dayButton setTitleColor:[UIColor colorWithRed:0.166 green:0.172 blue:0.142 alpha:1.000] forState:UIControlStateNormal];
                    
                    [self addSubview:dayButton];

                } else {
                    dayFrame = CGRectMake(positionX, positionY-10, kCalendarDayWidth, kCalendarDayHeight);
                    NSDate *dayDate = [CalendarLogic dateForWeekday:aWeekday
                                                             onWeek:aWeek-1
                                                      referenceDate:[aLogic referenceDate]];
                    NSDateComponents *dayComponents = [calendar
                                                       components:NSDayCalendarUnit fromDate:dayDate];
                    
//                    NSLog(@"%@",dayDate);
                    NSString *str= [eEducationAppDelegate convertString:[NSString stringWithFormat:@"%@",dayDate] fromFormate:@"yyyy-MM-dd HH:mm:ss zzz" toFormate:@"yyyy-MM-dd"];
                    if ([str isEqualToString:@""] || [str isKindOfClass:[NSNull class]] || [str isEqualToString:@"(null)"] || [str isEqualToString:@"null"] || str == nil) {
                        str= [eEducationAppDelegate convertString:[NSString stringWithFormat:@"%@",dayDate] fromFormate:@"yyyy-MM-dd hh:mm:ss a zzz" toFormate:@"yyyy-MM-dd"];
                    }
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"self.date CONTAINS '%@'",str]];
                    NSArray* filteredPersons = [arraySelectedDays filteredArrayUsingPredicate:predicate];
//                    NSLog(@"predicate : %@",filteredPersons);
                    
//                    UIColor *titleColor = [UIColor colorWithRed:0.166 green:0.172 blue:0.142 alpha:1.000];
//                    if ([dayDate timeIntervalSince1970] > [todayDate timeIntervalSince1970]) {
//                        titleColor = [UIColor colorWithRed:0.166 green:0.172 blue:0.142 alpha:1.000];
//                    }
                    UIColor *titleColor = [UIColor colorWithRed:0.166 green:0.172 blue:0.142 alpha:1.000];
                    if ([aLogic distanceOfDateFromCurrentMonth:dayDate] != 0) {
                        titleColor = [UIColor colorWithWhite:0.497 alpha:1.000];
                    }
                    
                    UIButton *dayButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    dayButton.opaque = YES;
                    dayButton.clipsToBounds = NO;
                    dayButton.clearsContextBeforeDrawing = NO;
                    dayButton.frame = dayFrame;
                    dayButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
                    dayButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:16.0];
                    dayButton.tag = [aDatesIndex count];
                    dayButton.adjustsImageWhenHighlighted = NO;
                    dayButton.adjustsImageWhenDisabled = NO;
                    dayButton.showsTouchWhenHighlighted = YES;
                    
                        // Normal
                    [dayButton setTitle:[NSString stringWithFormat:@"%d", [dayComponents day]]
                               forState:UIControlStateNormal];
                    // Selected
                    [dayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                    
                    [dayButton setTitleShadowColor:[UIColor grayColor] forState:UIControlStateSelected];
                    if (filteredPersons.count > 0) {
                        [dayButton setBackgroundImage:[UIImage imageNamed:@"calender_bx_1@2x.png"] forState:UIControlStateNormal];
                    } else if ([dayDate compare:todayDate] != NSOrderedSame) {
                        [dayButton setBackgroundImage:[UIImage imageNamed:@"calender_bx@2x.png"] forState:UIControlStateNormal];
                        [dayButton setTitleColor:titleColor forState:UIControlStateNormal];
                        [dayButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [dayButton setBackgroundColor:[UIColor clearColor]];
                    } else {
                        [dayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [dayButton setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
                        [dayButton setBackgroundImage:[UIImage imageNamed:@"calender_hover@2x.png"] forState:UIControlStateNormal];
                    }
                    
                    [dayButton addTarget:self action:@selector(dayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:dayButton];
                    
                    // Saves
                    [aDatesIndex addObject:dayDate];
                    [aButtonsIndex addObject:dayButton];
                    
                    if (filteredPersons.count > 0) {
                        if ([dayDate compare:todayDate] == NSOrderedSame) {
                            [self dayPreButtonPressed:[aDatesIndex count] :aDatesIndex];
                        }
                    }
                }
			}
		}
		
		// save
		self.calendarLogic = aLogic;
		self.datesIndex = [[aDatesIndex copy] autorelease];
		self.buttonsIndex = [[aButtonsIndex copy] autorelease];
    }
    return self;
}

#pragma mark -
#pragma mark UI Controls

- (void)dayButtonPressed:(id)sender
{
	[calendarLogic setReferenceDate:[datesIndex objectAtIndex:([sender tag])]];
    [self.delegate btnDateSelected:[datesIndex objectAtIndex:([sender tag])]];
}
- (void)dayPreButtonPressed:(int)tag :(NSMutableArray*)aDatesIndex1
{
	[calendarLogic setReferenceDate:[aDatesIndex1 objectAtIndex:tag-1]];
    [self.delegate btnDateSelected:[aDatesIndex1 objectAtIndex:tag-1]];
}
- (void)selectButtonForDate:(NSDate *)aDate
{
	if (selectedButton >= 0) {
		NSDate *todayDate = [CalendarLogic dateForToday];
		UIButton *button = [buttonsIndex objectAtIndex:selectedButton];
		
		CGRect selectedFrame = button.frame;
		if ([selectedDate compare:todayDate] != NSOrderedSame) {
			selectedFrame.origin.y = selectedFrame.origin.y + 1;
			selectedFrame.size.width = kCalendarDayWidth;
			selectedFrame.size.height = kCalendarDayHeight;
		}
		
		button.selected = NO;
		button.frame = selectedFrame;
		
		self.selectedButton = -1;
		self.selectedDate = nil;
	}
	
	if (aDate != nil) {
		// Save
		self.selectedButton = [calendarLogic indexOfCalendarDate:aDate];
		self.selectedDate = aDate;
		
		NSDate *todayDate = [CalendarLogic dateForToday];
		UIButton *button = [buttonsIndex objectAtIndex:selectedButton];
		
		CGRect selectedFrame = button.frame;
		if ([aDate compare:todayDate] != NSOrderedSame) {
			selectedFrame.origin.y = selectedFrame.origin.y - 1;
			selectedFrame.size.width = kCalendarDayWidth + 1;
			selectedFrame.size.height = kCalendarDayHeight + 1;
		}
		
		button.selected = YES;
		button.frame = selectedFrame;
		[self bringSubviewToFront:button];	
	}
}

//- (void)dayButtonPressed:(id)sender {
//	[calendarLogic setReferenceDate:[datesIndex objectAtIndex:[sender tag]]];
//    UIButton *btn = (UIButton *)sender;
//    [delegate Popaction:btn];
//}


@end
