//
//  EditableTableController.m
//  Edit Demo
//
//  Created by Alfred Hanssen on 8/15/14.
//  Copyright (c) 2014 Alfie Hanssen. All rights reserved.
//

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net

#import "EditableTableController.h"
#import "AppDelegate.h"
//#import "FMMoveTableViewCell.h"

static CGFloat SnapshotZoomScale = 1.1f;
static CGFloat SnapshotInsaneZoomScale = 1.5f;
static CGFloat MinLongPressDuration = 0.5f;
static CGFloat ZoomAnimationDuration = 0.20f;
int ResetMove=1;
int ZoneChanged,startIndex;

@interface EditableTableController ()

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressRecognizer;
//@property (nonatomic, strong) UILongPressGestureRecognizer *movingGestureRecognizer;

@property (nonatomic, weak) UITableView *tableView;
//@property (nonatomic, weak) UIView *snapshotView;
@property (nonatomic, strong) UIView *snapshotOfMovingCell;
@property (nonatomic, assign) CGPoint touchOffset;

@property (nonatomic, strong) NSIndexPath *initialIndexPath;
@property (nonatomic, strong) NSIndexPath *previousIndexPath;

@property (nonatomic, strong) NSTimer *autoscrollTimer;
@property (nonatomic, assign) NSInteger autoscrollDistance;
@property (nonatomic, assign) NSInteger autoscrollThreshold;


@end

@implementation EditableTableController

- (instancetype)init
{
    NSAssert(NO, @"Use custom initializer");
    return nil;
}

- (instancetype)initWithTableView:(UITableView *)tableView
{
    NSAssert(tableView != nil, @"tableView cannot be nil.");
    NSAssert([tableView numberOfSections] == 1, @"This class currently supports single section tableViews only.");
    NSAssert(tableView.estimatedRowHeight > 0, @"The tableView's estimatedRowHeight must be set.");
    
    self = [super init];
    if (self)
    {
        _enabled = YES;
        _tableView = tableView;
        
      //  [self setupGestureRecognizer];
        [self prepareGestureRecognizer];
    }
    
    return self;
}

//- (void)cancel
//{
//    self.longPressRecognizer.enabled = NO;
//    self.longPressRecognizer.enabled = YES;
//}

#pragma mark - Setup

- (void)setupGestureRecognizer
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"])
        {
            return;
        }
    }

    self.longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizeLongPress:)];
    self.longPressRecognizer.minimumPressDuration = MinLongPressDuration;
    [_tableView addGestureRecognizer:self.longPressRecognizer];
}
//
//#pragma mark - Accessors
//
//- (void)setEnabled:(BOOL)enabled
//{
//    if (_enabled != enabled)
//    {
//        _enabled = enabled;
//        
//        self.longPressRecognizer.enabled = enabled;
//    }
//}

#pragma mark - Superview Logic

//- (UIView *)snapshotSuperview
//{
////    if (self.superview)
////    {
////        return self.superview;
////    }
//    
//    return self.tableView;
//}

//- (CGRect)rectInSuperview:(CGRect)rect
//{
//    return [self.tableView convertRect:rect toView:[self snapshotSuperview]];
//}
//
//- (CGPoint)pointInSuperview:(CGPoint)point
//{
//    return [self.tableView convertPoint:point toView:[self snapshotSuperview]];
//}

- (void)prepareGestureRecognizer
{
    //self.longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizeLongPress:)];
    self.longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    self.longPressRecognizer.delegate = self;
    [_tableView addGestureRecognizer:self.longPressRecognizer];
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self prepareGestureRecognizer];
}


- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    //self = [super initWithFrame:frame style:style];
    
    //if (self) {
        [self prepareGestureRecognizer];
   // }
    
    return self;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL shouldBegin = YES;
    
    if ([gestureRecognizer isEqual:self.longPressRecognizer])
    {
        CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
        NSIndexPath *touchedIndexPath = [self.tableView indexPathForRowAtPoint:touchPoint];
        shouldBegin = [self isValidIndexPath:touchedIndexPath];
        
               shouldBegin = [self isValidIndexPath:touchedIndexPath];
        
        if (shouldBegin && [self.delegate respondsToSelector:@selector(moveTableView:canMoveRowAtIndexPath:)]) {
            shouldBegin = [self.delegate moveTableView:self canMoveRowAtIndexPath:touchedIndexPath];
        }
//        if (self.delegate && [self.delegate respondsToSelector:@selector(editableTableController:willBeginMovingCellAtIndexPath:)])
//        {
//            [self.delegate editableTableController:self willBeginMovingCellAtIndexPath:touchedIndexPath];
//        }
        
    }
    
    return shouldBegin;
}


- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.tableView];
 //   NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:touchPoint];
    self.indexPath = [self.tableView indexPathForRowAtPoint:touchPoint];
    
    switch (gestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            
            [self prepareForMovingRowAtTouchPoint:touchPoint];
        
            
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            CGPoint touchPoint = [gestureRecognizer locationInView:self.tableView];
            [self moveSnapshotToLocation:touchPoint];
            
            
            if (![self isAutoscrolling]) {
                [self moveRowToLocation:touchPoint];
            }
            
            
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        {
          //  [self finishMovingRow];
            
            NSLog(@"ind==%ld",(long)self.indexPath.row);
            NSLog(@"indexpath%@",self.indexPath);
            NSLog(@"zonechange==%ld",(long)ZoneChanged);
            
            if(self.indexPath.row == ZoneChanged)
            {
                NSLog(@"%@",self.indexPath);
                //Check if the cell being moved is above the first cell or below the last
                if (self.indexPath == nil)
                {
                    CGFloat cellHeight = [self.tableView estimatedRowHeight];
                    NSInteger count = [self.tableView numberOfRowsInSection:0];
                    if (touchPoint.y > count * cellHeight)
                    {
                        self.indexPath = [NSIndexPath indexPathForRow:count - 1 inSection:0];
                    }
                    else if (touchPoint.y <= 0)
                    {
                        self.indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    }
                }
            }
            
            self.indexPath = [NSIndexPath indexPathForRow:ZoneChanged inSection:0];
            
            NSLog(@"%@",self.indexPath);
            NSLog(@"%ld",(long)self.indexPath.row);
            
            CGRect rect = [self.tableView rectForRowAtIndexPath:self.indexPath];
            
            BOOL shouldMoveCell = YES;
            
            if (!shouldMoveCell)
            {
                [UIView animateWithDuration:ZoomAnimationDuration animations:^{
                    
                    self.snapshotOfMovingCell.transform = CGAffineTransformMakeScale(SnapshotInsaneZoomScale, SnapshotInsaneZoomScale);
                    self.snapshotOfMovingCell.alpha = 0.0f;
                    
                } completion:^(BOOL finished) {
                    
                    [self.snapshotOfMovingCell removeFromSuperview];
                    self.snapshotOfMovingCell = nil;
                    
                    self.initialIndexPath = nil;
                    self.previousIndexPath = nil;
                    
                }];
                
                return;
            }
            
            
            [UIView animateWithDuration:ZoomAnimationDuration animations:^{
                self.snapshotOfMovingCell.transform = CGAffineTransformIdentity;
                self.snapshotOfMovingCell.center = (CGPoint){CGRectGetMidX(rect), CGRectGetMidY(rect)};
                
            } completion:^(BOOL finished) {
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(editableTableController:didMoveCellFromInitialIndexPath:toIndexPath:)])
                {
                    NSLog(@"%@",self.indexPath);
                    NSLog(@"%ld",(long)self.indexPath.row);
                    //  [self.delegate editableTableController:self didMoveCellFromInitialIndexPath:self.initialIndexPath toIndexPath:self.indexPath];
                    if ([self.initialIndexPath compare:self.movingIndexPath] != NSOrderedSame) {
                    [self.delegate moveTableView:self moveRowFromIndexPath:self.initialIndexPath toIndexPath:self.movingIndexPath];
                    }
                }
                
                [self.snapshotOfMovingCell removeFromSuperview];
                self.snapshotOfMovingCell = nil;
                
                self.initialIndexPath = nil;
                self.previousIndexPath = nil;
            }];

            break;
        }
            
//        default:
//        {
//            [self cancelMovingRowIfNeeded];
//            break;
//        }
    }
}


- (void)prepareForMovingRowAtTouchPoint:(CGPoint)touchPoint
{
   // NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:touchPoint];
    
    NSLog(@"%ld",(long)self.indexPath.row);
    ZoneChanged = (int)self.indexPath.row;
    startIndex = (int)self.indexPath.row;
    self.movingIndexPath = self.indexPath;
    NSLog(@"zonechange==%ld",(long)ZoneChanged);
    self.initialIndexPath = self.indexPath;

    self.snapshotOfMovingCell = [self snapshotFromRowAtMovingIndexPath];
    [self.tableView addSubview:self.snapshotOfMovingCell];
    
    self.touchOffset = CGPointMake(self.snapshotOfMovingCell.center.x - touchPoint.x, self.snapshotOfMovingCell.center.y - touchPoint.y);
    
    if ([self.delegate respondsToSelector:@selector(moveTableView:willMoveRowAtIndexPath:)]) {
        [self.delegate moveTableView:self willMoveRowAtIndexPath:self.movingIndexPath];
    }
    
    self.previousIndexPath = self.indexPath;

    
}

- (BOOL)isValidIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath != nil && indexPath.section != NSNotFound && indexPath.row != NSNotFound);
}

- (void)moveSnapshotToLocation:(CGPoint)touchPoint
{
    CGPoint currentCenter = self.snapshotOfMovingCell.center;
    self.snapshotOfMovingCell.center = CGPointMake(currentCenter.x, touchPoint.y + self.touchOffset.y);
}

- (void)maybeAutoscroll
{
    //[self determineAutoscrollDistanceForSnapShot];
    
    if (self.autoscrollDistance == 0)
    {
        [self.autoscrollTimer invalidate];
        self.autoscrollTimer = nil;
    }
    else if (self.autoscrollTimer == nil)
    {
        self.autoscrollTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 60.0) target:self selector:@selector(autoscrollTimerFired:) userInfo:nil repeats:YES];
    }
}
- (BOOL)isAutoscrolling
{
    return (self.autoscrollDistance != 0);
}
- (void)moveRowToLocation:(CGPoint)location
{
    //NSIndexPath *newIndexPath = [self.tableView indexPathForRowAtPoint:location];
   
//    if (![self canMoveToIndexPath:newIndexPath]) {
//        return;
//    }
    
    NSLog(@"prrrrrrr===%ld",(long)self.indexPath.row);
    NSLog(@"prrrrrrr===%d",ZoneChanged-1);
    if(self.indexPath.row == ZoneChanged-1||self.indexPath.row == ZoneChanged+1||self.indexPath.row == ZoneChanged)
    {
        
        if (self.previousIndexPath && self.indexPath && ![self.previousIndexPath isEqual:self.indexPath])
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(editableTableController:movedCellWithInitialIndexPath:fromAboveIndexPath:toAboveIndexPath:)])
            {
                [self.delegate editableTableController:self movedCellWithInitialIndexPath:self.initialIndexPath fromAboveIndexPath:self.previousIndexPath toAboveIndexPath:self.indexPath];
                
//                [self.tableView beginUpdates];
//                [self.tableView deleteRowsAtIndexPaths:@[self.previousIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//                [self.tableView insertRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
//                
//                self.movingIndexPath = self.indexPath;
 //               [self.tableView endUpdates];
                
                NSLog(@"ind==%ld",(long)self.indexPath.row);
                ZoneChanged = (int)self.indexPath.row;
                NSLog(@"zonechange==%ld",(long)ZoneChanged);
            }
        }
        NSLog(@"ind==%ld",(long)self.indexPath.row);
        self.previousIndexPath = self.indexPath;
        NSLog(@"preeeevious==%ld",(long)self.previousIndexPath.row);
        
        
    }

}

- (void)finishMovingRow
{

                           //  [self resetMovingRow];
    
    
    NSLog(@"ind==%ld",(long)self.indexPath.row);
    NSLog(@"indexpath%@",self.indexPath);
    NSLog(@"zonechange==%ld",(long)ZoneChanged);
    
    if(self.indexPath.row == ZoneChanged)
    {
        NSLog(@"%@",self.indexPath);
        //Check if the cell being moved is above the first cell or below the last
        if (self.indexPath == nil)
        {
            CGFloat cellHeight = [self.tableView estimatedRowHeight];
            NSInteger count = [self.tableView numberOfRowsInSection:0];
          //  if (touchPoint.y > count * cellHeight)
            {
                self.indexPath = [NSIndexPath indexPathForRow:count - 1 inSection:0];
            }
         //   else if (touchPoint.y <= 0)
            {
                self.indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            }
        }
    }
    
    self.indexPath = [NSIndexPath indexPathForRow:ZoneChanged inSection:0];
    
    NSLog(@"%@",self.indexPath);
    NSLog(@"%ld",(long)self.indexPath.row);
    
    CGRect rect = [self.tableView rectForRowAtIndexPath:self.indexPath];
    
    BOOL shouldMoveCell = YES;
    
    if (!shouldMoveCell)
    {
        [UIView animateWithDuration:ZoomAnimationDuration animations:^{
            
            self.snapshotOfMovingCell.transform = CGAffineTransformMakeScale(SnapshotInsaneZoomScale, SnapshotInsaneZoomScale);
            self.snapshotOfMovingCell.alpha = 0.0f;
            
        } completion:^(BOOL finished) {
            
            [self.snapshotOfMovingCell removeFromSuperview];
            self.snapshotOfMovingCell = nil;
            
            self.initialIndexPath = nil;
            self.previousIndexPath = nil;
            
        }];
        
        return;
    }
    
    
    [UIView animateWithDuration:ZoomAnimationDuration animations:^{
        self.snapshotOfMovingCell.transform = CGAffineTransformIdentity;
        self.snapshotOfMovingCell.center = (CGPoint){CGRectGetMidX(rect), CGRectGetMidY(rect)};
        
    } completion:^(BOOL finished) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(editableTableController:didMoveCellFromInitialIndexPath:toIndexPath:)])
        {
            NSLog(@"%@",self.indexPath);
            NSLog(@"%ld",(long)self.indexPath.row);
          //  [self.delegate editableTableController:self didMoveCellFromInitialIndexPath:self.initialIndexPath toIndexPath:self.indexPath];
            [self.delegate moveTableView:self moveRowFromIndexPath:self.initialIndexPath toIndexPath:self.indexPath];
        }
        
        [self.snapshotOfMovingCell removeFromSuperview];
        self.snapshotOfMovingCell = nil;
        
        self.initialIndexPath = nil;
        self.previousIndexPath = nil;
    }];


}


- (void)cancelMovingRowIfNeeded
{
    if (self.movingIndexPath != nil)
    {
        //[self stopAutoscrolling];
        [self resetSnapshot];
        [self resetMovingRow];
    }
}
- (UIView *)snapshotFromRowAtMovingIndexPath
{
    UITableViewCell *touchedCell = [self.tableView cellForRowAtIndexPath:self.movingIndexPath];
    touchedCell.selected = NO;
    touchedCell.highlighted = NO;
    
   // [touchedCell prepareForMoveSnapshot];
    
    UIView *snapshot = [touchedCell snapshotViewAfterScreenUpdates:NO];
    snapshot.frame = touchedCell.frame;
    snapshot.alpha = 0.95;
    snapshot.layer.shadowOpacity = 0.7;
    snapshot.layer.shadowRadius = 3.0;
    snapshot.layer.shadowOffset = CGSizeZero;
    snapshot.layer.shadowPath = [[UIBezierPath bezierPathWithRect:snapshot.layer.bounds] CGPath];
    
    //[touchedCell prepareForMove];
    
    return snapshot;
}
- (void)prepareAutoscrollForSnapshot
{
    self.autoscrollThreshold = CGRectGetHeight(self.snapshotOfMovingCell.frame) * 0.6;
    self.autoscrollDistance = 0;
}
- (void)determineAutoscrollDistanceForSnapShot
{
    self.autoscrollDistance = 0;
    
    // Check for autoscrolling
    // 1. The content size is bigger than the frame's
    // 2. The snap shot is still inside the table view's bounds
    if ([self canScroll] && CGRectIntersectsRect(self.snapshotOfMovingCell.frame, self.tableView.bounds))
    {
        CGPoint touchLocation = [self.longPressRecognizer locationInView:self.tableView];
        touchLocation.y += self.touchOffset.y;
        
        CGFloat distanceToTopEdge = touchLocation.y - CGRectGetMinY(self.tableView.bounds);
        CGFloat distanceToBottomEdge = CGRectGetMaxY(self.tableView.bounds) - touchLocation.y;
        
        if (distanceToTopEdge < self.autoscrollThreshold)
        {
            self.autoscrollDistance = [self autoscrollDistanceForProximityToEdge:distanceToTopEdge] * -1;
        }
        else if (distanceToBottomEdge < self.autoscrollThreshold)
        {
            self.autoscrollDistance = [self autoscrollDistanceForProximityToEdge:distanceToBottomEdge];
        }
    }
}
- (BOOL)canMoveToIndexPath:(NSIndexPath *)indexPath
{
    if (![self isValidIndexPath:indexPath]) {
        NSLog(@"1111");
        return NO;
    }
    
    if ([indexPath compare:self.movingIndexPath] == NSOrderedSame) {
        NSLog(@"2222");
        ResetMove=ResetMove+1;
        NSLog(@"ResetMove==%d",ResetMove);
        return NO;
    }
    
    if ([self.delegate respondsToSelector:@selector(moveTableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)])
    {
        if(ResetMove>3){
         NSLog(@"3333");
        ResetMove=1;
        //strResetMove=@"";
        NSIndexPath *proposedDestinationIndexPath = [self.delegate moveTableView:self targetIndexPathForMoveFromRowAtIndexPath:self.movingIndexPath toProposedIndexPath:indexPath];
        return ([indexPath compare:proposedDestinationIndexPath] == NSOrderedSame);
        }
    }
//    if (self.delegate && [self.delegate respondsToSelector:@selector(editableTableController:willBeginMovingCellAtIndexPath:)])
//    {
//         NSLog(@"3333");
//        [self.delegate editableTableController:self willBeginMovingCellAtIndexPath:self.movingIndexPath];
//    }
    
    
    return YES;
}

- (void)stopAutoscrolling
{
    self.autoscrollDistance = 0.0;
    [self.autoscrollTimer invalidate];
    self.autoscrollTimer = nil;
}

- (void)resetSnapshot
{
    [self.snapshotOfMovingCell removeFromSuperview];
   // self.snapshotOfMovingCell = nil;
}
- (void)resetMovingRow
{
    NSIndexPath *movingIndexPath = [self.movingIndexPath copy];
    self.movingIndexPath = nil;
  //  self.initialIndexPathForMovingRow = nil;
    NSLog(@"movingIndexPath=====%ld",(long)movingIndexPath.row);
//    if(!(ResetMove>3)){
//        
//        NSIndexPath *initialIndex = [self.initialIndexPathForMovingRow copy];
//        
//        CGRect rect = [self.tableView rectForRowAtIndexPath:initialIndex];
//        //self.snapshotOfMovingCell.center = CGPointMake(currentCenter.x, touchPoint.y + self.touchOffset.y);
//        self.snapshotOfMovingCell.center = (CGPoint){CGRectGetMidX(rect), CGRectGetMidY(rect)};
//    }
//    else
    
    NSLog(@"ResetMove==%d",ResetMove);
    
   // if(ResetMove>3){
        
    if(ZoneChanged+1 == startIndex || ZoneChanged-1 == startIndex || ZoneChanged-3 == startIndex || ZoneChanged+3 == startIndex || ZoneChanged-5 == startIndex || ZoneChanged+5 == startIndex || ZoneChanged-7 == startIndex ||ZoneChanged+7 == startIndex)
    {
        NSLog(@"135");
        [self.tableView reloadRowsAtIndexPaths:@[movingIndexPath] withRowAnimation:UITableViewRowAnimationNone];

//        CGRect rect = [self.tableView rectForRowAtIndexPath:movingIndexPath];
//        //self.snapshotOfMovingCell.center = CGPointMake(currentCenter.x, touchPoint.y + self.touchOffset.y);
//        self.snapshotOfMovingCell.center = (CGPoint){CGRectGetMidX(rect), CGRectGetMidY(rect)};

    }else{
        
        if(ResetMove>6){
        NSLog(@"246");
      //  [self.tableView reloadRowsAtIndexPaths:@[movingIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    CGRect rect = [self.tableView rectForRowAtIndexPath:movingIndexPath];
        //self.snapshotOfMovingCell.center = CGPointMake(currentCenter.x, touchPoint.y + self.touchOffset.y);
    self.snapshotOfMovingCell.center = (CGPoint){CGRectGetMidX(rect), CGRectGetMidY(rect)};
        }else{
           [self.tableView reloadRowsAtIndexPaths:@[movingIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }
    }
//    }else{
//        
//        NSIndexPath *initialIndex = [self.initialIndexPathForMovingRow copy];
//        
//        CGRect rect = [self.tableView rectForRowAtIndexPath:initialIndex];
//        
//        self.snapshotOfMovingCell.center = (CGPoint){CGRectGetMidX(rect), CGRectGetMidY(rect)};
//
//    }
       ResetMove=1;
}

- (BOOL)canScroll
{
    return (CGRectGetHeight(self.tableView.frame) < self.tableView.contentSize.height);
}

- (CGFloat)autoscrollDistanceForProximityToEdge:(CGFloat)proximity
{
    return ceilf((self.autoscrollThreshold - proximity) / 5.0);
}


- (NSIndexPath *)adaptedIndexPathForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.movingIndexPath == nil) {
        return indexPath;
    }
    
    CGFloat adaptedRow = NSNotFound;
    NSInteger movingRowOffset = 1;
    
    // It's the moving row so return the initial index path
    if ([indexPath compare:self.movingIndexPath] == NSOrderedSame)
    {
        indexPath = self.initialIndexPath;
    }
    // Moving row is still in it's inital section
    else if (self.movingIndexPath.section == self.initialIndexPath.section)
    {
        // 1. Index path comes after initial row or is at initial row
        // 2. Index path comes before moving row
        if (indexPath.row >= self.initialIndexPath.row && indexPath.row < self.movingIndexPath.row)
        {
            adaptedRow = indexPath.row + movingRowOffset;
        }
        // 1. Index path comes before initial row or is at initial row
        // 2. Index path comes after moving row
        else if (indexPath.row <= self.initialIndexPath.row && indexPath.row > self.movingIndexPath.row)
        {
            adaptedRow = indexPath.row - movingRowOffset;
        }
    }
    // Moving row is no longer in it's inital section
    else if (self.movingIndexPath.section != self.initialIndexPath.section)
    {
        // 1. Index path is in the moving rows initial section
        // 2. Index path comes after initial row or is at initial row
        if (indexPath.section == self.initialIndexPath.section && indexPath.row >= self.initialIndexPath.row)
        {
            adaptedRow = indexPath.row + movingRowOffset;
        }
        // 1. Index path is in the moving rows current section
        // 2. Index path comes before moving row
        else if (indexPath.section == self.movingIndexPath.section && indexPath.row > self.movingIndexPath.row)
        {
            adaptedRow = indexPath.row - movingRowOffset;
        }
    }
    
    // We finally need to create an adapted index path
    if (adaptedRow != NSNotFound) {
        indexPath = [NSIndexPath indexPathForRow:adaptedRow inSection:indexPath.section];
    }
    
    return indexPath;
}


#pragma mark - Gestures

//- (void)didRecognizeLongPress:(UILongPressGestureRecognizer *)recognizer
//{
//    CGPoint location = [recognizer locationInView:recognizer.view];
//    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
//    
//    
//    if (recognizer.state == UIGestureRecognizerStateBegan)
//    {
//        NSLog(@"%ld",(long)indexPath.row);
//        ZoneChanged = (int)indexPath.row;
//        startIndex = (int)indexPath.row;
//        NSLog(@"zonechange==%ld",(long)ZoneChanged);
////        if (indexPath == nil)
////        {
////            [self cancel];
////            return;
////        }
//        
//        self.initialIndexPath = indexPath;
//        
//        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//        CGRect rect = [self.tableView rectForRowAtIndexPath:indexPath];
//      //  rect = [self rectInSuperview:rect];
//        
//        ///Anitha temp code
//        
//        [self.snapshotView.layer renderInContext:UIGraphicsGetCurrentContext()];
//        self.snapshotView = [cell snapshotViewAfterScreenUpdates:NO];
//   //     [self.snapshotView drawViewHierarchyInRect:self.snapshotView.bounds afterScreenUpdates:YES];
//        
//        //Anitha Temp Code end
//      //   CGPoint snapshotLocation = [self pointInSuperview:location];
//    //    self.snapshotView.frame = CGRectOffset(self.snapshotView.bounds, self.tableView.center.x-350, snapshotLocation.y-50);
//        //self.snapshotView.backgroundColor = [UIColor clearColor];
//     //   [[self snapshotSuperview] addSubview:self.snapshotView];
//        
//        // Trigger animation...
//       
//        [UIView animateWithDuration:ZoomAnimationDuration animations:^{
//          //  self.snapshotView.transform = CGAffineTransformMakeScale(SnapshotZoomScale, SnapshotZoomScale);
//          //  self.snapshotView.center = CGPointMake(self.tableView.center.x, snapshotLocation.y);
//        }];
//        
//        // ...before modifying tableView
//        if (self.delegate && [self.delegate respondsToSelector:@selector(editableTableController:willBeginMovingCellAtIndexPath:)])
//        {
//            [self.delegate editableTableController:self willBeginMovingCellAtIndexPath:indexPath];
//        }
//        
//        self.previousIndexPath = indexPath;
//    }
//    else if (recognizer.state == UIGestureRecognizerStateChanged)
//    {
//        NSLog(@"prrrrrrr===%ld",(long)indexPath.row);
//        NSLog(@"prrrrrrr===%d",ZoneChanged-1);
//        if(indexPath.row == ZoneChanged-1||indexPath.row == ZoneChanged+1||indexPath.row == ZoneChanged)
//        {
//     //       CGPoint snapshotLocation = [self pointInSuperview:location];
//      //      self.snapshotView.center = (CGPoint){self.tableView.center.x, snapshotLocation.y};
//       //     self.snapshotView.center = (CGPoint){self.tableView.center.x, self.tableView.center.y};
//            // Only notify delegate upon moving above a new cell
//            if (self.previousIndexPath && indexPath && ![self.previousIndexPath isEqual:indexPath])
//            {
//                if (self.delegate && [self.delegate respondsToSelector:@selector(editableTableController:movedCellWithInitialIndexPath:fromAboveIndexPath:toAboveIndexPath:)])
//                {
//                    [self.delegate editableTableController:self movedCellWithInitialIndexPath:self.initialIndexPath fromAboveIndexPath:self.previousIndexPath toAboveIndexPath:indexPath];
//                    
//                    NSLog(@"ind==%ld",(long)indexPath.row);
//                    ZoneChanged = (int)indexPath.row;
//                    NSLog(@"zonechange==%ld",(long)ZoneChanged);
//                }
////                if (self.delegate && [self.delegate respondsToSelector:@selector(editableTableController:didMoveCellFromInitialIndexPath:toIndexPath:)])
////                {
////                    //[self.delegate editableTableController:self willBeginMovingCellAtIndexPath:self.movingIndexPath];
////                    [self.delegate editableTableController:self didMoveCellFromInitialIndexPath:self.previousIndexPath toIndexPath:indexPath];
////                }
//            }
//            NSLog(@"ind==%ld",(long)indexPath.row);
//            self.previousIndexPath = indexPath;
////            ZoneChanged = (int) indexPath.row;
////            NSLog(@"zonechange==%ld",(long)ZoneChanged);
//            
//        }
//    }
//    else if (recognizer.state == UIGestureRecognizerStateEnded)
//    {
//    //    CGPoint snapshotLocation = [self pointInSuperview:location];
//       // self.snapshotView.center = (CGPoint){self.tableView.center.x, snapshotLocation.y};
//        NSLog(@"ind==%ld",(long)indexPath.row);
//        NSLog(@"indexpath%@",indexPath);
//        NSLog(@"zonechange==%ld",(long)ZoneChanged);
//        
////        if(indexPath == nil)
////        {
////            NSLog(@"start==%d",startIndex);
////            indexPath = [NSIndexPath indexPathForRow:startIndex inSection:0];
////            NSLog(@"iniiii%@",self.initialIndexPath);
////            NSLog(@"pree%@",self.previousIndexPath);
////            NSLog(@"in%@",indexPath);
////            
////            [self.delegate editableTableController:self movedCellWithInitialIndexPath:self.initialIndexPath fromAboveIndexPath:self.previousIndexPath toAboveIndexPath:indexPath];
////        }
////        else{
//        if(indexPath.row == ZoneChanged)
//        {
//            NSLog(@"%@",indexPath);
//            //Check if the cell being moved is above the first cell or below the last
//            if (indexPath == nil)
//            {
//                CGFloat cellHeight = [self.tableView estimatedRowHeight];
//                NSInteger count = [self.tableView numberOfRowsInSection:0];
//                if (location.y > count * cellHeight)
//                {
//                    indexPath = [NSIndexPath indexPathForRow:count - 1 inSection:0];
//                }
//                else if (location.y <= 0)
//                {
//                    indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//                }
//            }
//        }
//        
//        indexPath = [NSIndexPath indexPathForRow:ZoneChanged inSection:0];
//
//        NSLog(@"%@",indexPath);
//        NSLog(@"%ld",(long)indexPath.row);
//     //   }
//        
//        CGRect rect = [self.tableView rectForRowAtIndexPath:indexPath];
//     //   rect = [self rectInSuperview:rect];
//
//        BOOL shouldMoveCell = YES;
////        if (self.delegate && [self.delegate respondsToSelector:@selector(editableTableController:shouldMoveCellFromInitialIndexPath:toProposedIndexPath:withSuperviewLocation:)])
////        {
////            shouldMoveCell = [self.delegate editableTableController:self shouldMoveCellFromInitialIndexPath:self.initialIndexPath toProposedIndexPath:indexPath withSuperviewLocation:snapshotLocation];
////        }
//        
//        if (!shouldMoveCell)
//        {
//            [UIView animateWithDuration:ZoomAnimationDuration animations:^{
//                
//                self.snapshotView.transform = CGAffineTransformMakeScale(SnapshotInsaneZoomScale, SnapshotInsaneZoomScale);
//                self.snapshotView.alpha = 0.0f;
//                
//            } completion:^(BOOL finished) {
//                
//                [self.snapshotView removeFromSuperview];
//                self.snapshotView = nil;
//                
//                self.initialIndexPath = nil;
//                self.previousIndexPath = nil;
//                
//            }];
//            
//            return;
//        }
//        
////        else{
////        indexPath = [NSIndexPath indexPathForRow:ZoneChanged inSection:0];
////    //    }
////        NSLog(@"%@",indexPath);
////        NSLog(@"%ld",(long)indexPath.row);
////        CGRect rect = [self.tableView rectForRowAtIndexPath:indexPath];
////        rect = [self rectInSuperview:rect];
//        
////        if(indexPath.row == startIndex)
////        {
////            NSLog(@"iniiii%@",self.initialIndexPath);
////            NSLog(@"pree%@",self.previousIndexPath);
////            NSLog(@"in%@",indexPath);
////            
////            [self.delegate editableTableController:self movedCellWithInitialIndexPath:self.initialIndexPath fromAboveIndexPath:self.previousIndexPath toAboveIndexPath:indexPath];
////        }
//        
//        [UIView animateWithDuration:ZoomAnimationDuration animations:^{
//            self.snapshotView.transform = CGAffineTransformIdentity;
//            self.snapshotView.center = (CGPoint){CGRectGetMidX(rect), CGRectGetMidY(rect)};
//            // self.snapshotView.transform = CGAffineTransformMakeScale(SnapshotInsaneZoomScale, SnapshotInsaneZoomScale);
//        } completion:^(BOOL finished) {
//            
//           if (self.delegate && [self.delegate respondsToSelector:@selector(editableTableController:didMoveCellFromInitialIndexPath:toIndexPath:)])
//            {
//                NSLog(@"%@",indexPath);
//                NSLog(@"%ld",(long)indexPath.row);
//                [self.delegate editableTableController:self didMoveCellFromInitialIndexPath:self.initialIndexPath toIndexPath:indexPath];
//            }
//            
//            [self.snapshotView removeFromSuperview];
//            self.snapshotView = nil;
//            
//            self.initialIndexPath = nil;
//            self.previousIndexPath = nil;
//        }];
//    }
//}



@end
