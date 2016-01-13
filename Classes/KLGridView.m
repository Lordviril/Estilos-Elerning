

#import "KLGridView.h"
#import "KLTile.h"
#import "KLColors.h"
#import<QuartzCore/QuartzCore.h>

@implementation KLGridView

- (id)initWithFrame:(CGRect)frame
{
    if (![super initWithFrame:frame])
        return nil;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin| UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.clipsToBounds = YES;
   self.backgroundColor = [UIColor colorWithCGColor:kCalendarBodyDarkColor];
	
	
    _numberOfColumns = 7;
    _tiles = [[NSMutableArray alloc] init];

    return self;
}

- (CGFloat)columnWidth { return floorf(self.bounds.size.width/_numberOfColumns); } // 46px when zoomed out

- (void)layoutSubviews
{
    NSInteger currentColumnIndex = 0;
    NSInteger currentRowIndex = 0;
    
    [UIView beginAnimations:nil context:NULL];
	int index=0;
    for (UIView *tileContainer in [self subviews]) {
        CGRect containerFrame = tileContainer.frame;
        containerFrame.size.width =102;
		containerFrame.size.height = 60; // square it up and zoom
        containerFrame.origin.x = (currentColumnIndex * 102);
        containerFrame.origin.y = (currentRowIndex * 60); // tiles are required to be square!
        KLTile *tile = [[tileContainer subviews] objectAtIndex:0];
		
        CGRect tileFrame = containerFrame;
        tileFrame.origin.x = tileFrame.origin.y = 0.0f;
        
        tileContainer.frame = containerFrame;
        tile.frame = tileFrame;
		tile.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
		if (index%7==0) {
			//CALayer *maskLayer = [tile layer];
//			maskLayer.cornerRadius = 12;
			UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:tile.bounds 
														   byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft
																 cornerRadii:CGSizeMake(10.0, 12.0)];
			
			// Create the shape layer and set its path
			CAShapeLayer *maskLayer = [CAShapeLayer layer];
			maskLayer.frame = tile.bounds;
			maskLayer.path = maskPath.CGPath;
			
			// Set the newly created shape layer as the mask for the image view's layer
			tile.layer.mask = maskLayer;
			
		}
		if (index%7==6) {
			UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:tile.bounds 
														   byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight
																 cornerRadii:CGSizeMake(14.0, 14.0)];
			
			// Create the shape layer and set its path
			CAShapeLayer *maskLayer = [CAShapeLayer layer];
			maskLayer.frame = tile.bounds;
			maskLayer.path = maskPath.CGPath;
			
			// Set the newly created shape layer as the mask for the image view's layer
			tile.layer.mask = maskLayer;
		}
		index++;
        
        currentColumnIndex++;
        if (currentColumnIndex == _numberOfColumns) {
            currentRowIndex++;
            currentColumnIndex = 0;
        } 
    }
    [UIView commitAnimations];
}

// --------------------------------------------------------------------------------------------
//      addTile:
// 
//      The only way correct way to place a tile in the KLGridView
//
- (void)addTile:(KLTile *)tile
{
    UIView *container = [[[UIView alloc] initWithFrame:tile.frame] autorelease];
    [container addSubview:tile];
    [self addSubview:container];

    [_tiles addObject:tile];
}

- (void)removeAllTiles
{
    for (KLTile *tile in _tiles)
        [[tile superview] removeFromSuperview]; // remove the tile's container
    [_tiles removeAllObjects];
}

- (void)flipView:(UIView *)viewToBeRemoved toRevealView:(UIView *)replacementView transition:(UIViewAnimationTransition)transition
{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
    UIView *container = [viewToBeRemoved superview];
	[UIView setAnimationTransition:transition forView:container cache:YES];
	[viewToBeRemoved removeFromSuperview];
	[container addSubview:replacementView];
    [self setNeedsLayout];
	[UIView commitAnimations];
}

- (KLTile *)tileOrNilAtIndex:(NSInteger)tileIndex
{
    return (tileIndex >= 0 && tileIndex <  [_tiles count]) ? [_tiles objectAtIndex:tileIndex] : nil;
}

- (void)redrawAllTiles
{
    for (KLTile *tile in _tiles)
        [tile setNeedsDisplay];
}

- (void)redrawNeighborsAndTile:(KLTile *)tile
{
    NSInteger tileIndex = [_tiles indexOfObject:tile];
    
    [[self tileOrNilAtIndex:tileIndex-_numberOfColumns+1] setNeedsDisplay]; // top left
    [[self tileOrNilAtIndex:tileIndex-_numberOfColumns] setNeedsDisplay];   // top
    [[self tileOrNilAtIndex:tileIndex-_numberOfColumns-1] setNeedsDisplay]; // top right
    [[self tileOrNilAtIndex:tileIndex-1] setNeedsDisplay];                  // left
    [[self tileOrNilAtIndex:tileIndex+1] setNeedsDisplay];                  // right
    [[self tileOrNilAtIndex:tileIndex+_numberOfColumns-1] setNeedsDisplay]; // bottom left
    [[self tileOrNilAtIndex:tileIndex+_numberOfColumns] setNeedsDisplay];   // bottom
    [[self tileOrNilAtIndex:tileIndex+_numberOfColumns+1] setNeedsDisplay]; // bottom right

    [tile setNeedsDisplay]; // the center tile itself
}

- (KLTile *)leftNeighborOfTile:(KLTile *)tile
{
    NSInteger tileIndex = [_tiles indexOfObject:tile];
    return [self tileOrNilAtIndex:tileIndex-1];
}

- (KLTile *)rightNeighborOfTile:(KLTile *)tile
{
    NSInteger tileIndex = [_tiles indexOfObject:tile];
    return [self tileOrNilAtIndex:tileIndex+1];
}


- (void)dealloc {
    [_tiles release];
	[super dealloc];
}


@end
