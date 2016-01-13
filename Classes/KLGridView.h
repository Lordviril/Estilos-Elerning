

#import <UIKit/UIKit.h>

@class KLTile;

@interface KLGridView : UIView {
    NSUInteger _numberOfColumns;
    NSMutableArray *_tiles;
}

- (void)addTile:(KLTile *)tile;
- (void)removeAllTiles;

- (void)redrawAllTiles;
- (void)redrawNeighborsAndTile:(KLTile *)tile;
- (void)flipView:(UIView *)viewToBeRemoved toRevealView:(UIView *)replacementView transition:(UIViewAnimationTransition)transition;

- (KLTile *)leftNeighborOfTile:(KLTile *)tile;
- (KLTile *)rightNeighborOfTile:(KLTile *)tile;

@end
