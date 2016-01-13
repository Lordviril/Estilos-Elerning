


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

#import "KLTile.h"
#import "KLDate.h"

#define KL_CHANGE_MONTH_BUTTON_WIDTH    44.0f//44
#define KL_CHANGE_MONTH_BUTTON_HEIGHT   32.0f//32
#define KL_SELECTED_MONTH_WIDTH        200.0f//200
#define KL_HEADER_HEIGHT                25.0f//21
#define KL_HEADER_FONT_SIZE             (KL_HEADER_HEIGHT)

@class KLCalendarModel, KLGridView, KLTile;
@protocol KLCalendarViewDelegate;

@interface KLCalendarView : UIView
{
    IBOutlet id <KLCalendarViewDelegate> delegate;
    KLCalendarModel *_model;
    UILabel *_selectedMonthLabel;
    KLGridView *_grid;
    NSMutableArray *_trackedTouchPoints;  // the gesture's sequential position in calendar view coordinates
}

@property(nonatomic, assign) id <KLCalendarViewDelegate> delegate;
@property(nonatomic, retain) KLGridView *grid;

- (id)initWithFrame:(CGRect)frame delegate:(id <KLCalendarViewDelegate>)delegate;

- (BOOL)isZoomedIn;
- (void)zoomInOnTile:(KLTile *)tile;
- (void)zoomOutFromTile:(KLTile *)tile;
- (void)panToTile:(KLTile *)tile;
- (KLTile *)leftNeighborOfTile:(KLTile *)tile;
- (KLTile *)rightNeighborOfTile:(KLTile *)tile;
- (void)redrawNeighborsAndTile:(KLTile *)tile;			// when zooming in, only redraw the chosen tile and adjacent tiles
- (NSString *)selectedMonthName;
- (NSInteger)selectedMonthNumberOfWeeks;

@end

//
// The delegate for handling date selection and appearance
//  
//     NOTES: Your application controller should implement this protocol 
//            to create & configure tiles when the selected month changes,
//            and in order to respond to the user's taps on tiles.
// 
@protocol KLCalendarViewDelegate <NSObject>
@required
- (void)calendarView:(KLCalendarView *)calendarView tappedTile:(KLTile *)aTile;
- (KLTile *)calendarView:(KLCalendarView *)calendarView createTileForDate:(KLDate *)date;
- (void)didChangeMonths;
@optional
- (void)wasSwipedToTheLeft;
- (void)wasSwipedToTheRight;
@end