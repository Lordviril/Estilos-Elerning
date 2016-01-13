


#import <UIKit/UIKit.h>

@class KLDate;

@interface KLTile : UIControl {
    NSString *_text;
    CGColorRef _textTopColor;
    CGColorRef _textBottomColor;
    KLDate *_date;
	KLDate *selDate;
}

@property(nonatomic, retain) NSString *text;
@property(nonatomic, retain) KLDate *date;

- (id)init;			// designated initializer

- (void)flash:(NSDate*)seldate;		// flash the tile's background color temporarily

- (CGColorRef)textTopColor;
- (void)setTextTopColor:(CGColorRef)color;
- (CGColorRef)textBottomColor;
- (void)setTextBottomColor:(CGColorRef)color;
- (void)restoreBackgroundColor;

@end



