//
//  YSMoveRowGestureRecognizer.m
//  YSMoveRowGestureRecognizerExample
//
//  Created by Yu Sugawara on 7/27/15.
//  Copyright (c) 2015 Yu Sugawara. All rights reserved.
//

#import "YSMoveRowGestureRecognizer.h"

@interface YSMoveRowGestureRecognizer ()

@property (weak, nonatomic, readwrite) UITableView *tableView;

@property (nonatomic) UILongPressGestureRecognizer *longPressGestureRecognizer;

@end

@implementation YSMoveRowGestureRecognizer

- (instancetype)initWithTableView:(UITableView *)tableView
{
    NSParameterAssert(tableView);
    
    if (self = [super init]) {
        self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
        [tableView addGestureRecognizer:self.longPressGestureRecognizer];
        
        self.tableView = tableView;
    }
    return self;
}

- (void)setDisabled:(BOOL)disabled
{
    self.longPressGestureRecognizer.enabled = !disabled;
}

#pragma mark - Gesture

/*
 *  Cookbook: Moving Table View Cells with a Long Press Gesture
 *  http://www.raywenderlich.com/63089/cookbook-moving-table-view-cells-with-a-long-press-gesture
 */

- (IBAction)didLongPress:(UILongPressGestureRecognizer *)sender
{
    UIGestureRecognizerState state = sender.state;
    
    CGPoint location = [sender locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    static UIView       *__snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *__sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                if (![self.tableView.dataSource tableView:self.tableView canMoveRowAtIndexPath:indexPath]) {
                    __sourceIndexPath = nil;
                    
                    //  Cancel gesture http://stackoverflow.com/a/4167471
                    sender.enabled = NO;
                    sender.enabled = YES;
                    break;
                }
                
                __sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                __snapshot = [self snapshotFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                __snapshot.center = center;
                __snapshot.alpha = 0.;
                [self.tableView addSubview:__snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    // Offset for gesture location.
                    center.y = location.y;
                    __snapshot.center = center;
                    __snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    __snapshot.alpha = 0.98;
                    cell.alpha = 0.;
                } completion:^(BOOL finished) {
                    cell.hidden = YES;
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = __snapshot.center;
            center.y = location.y;
            __snapshot.center = center;
            
            if (![self.tableView.dataSource tableView:self.tableView canMoveRowAtIndexPath:indexPath]) {
                break;
            }
            indexPath = [self.tableView.delegate tableView:self.tableView targetIndexPathForMoveFromRowAtIndexPath:__sourceIndexPath toProposedIndexPath:indexPath];
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:__sourceIndexPath]) {
                
                // ... update data source.
                [self.tableView.dataSource tableView:self.tableView moveRowAtIndexPath:__sourceIndexPath toIndexPath:indexPath];
                
                // ... move the rows.
                [self.tableView moveRowAtIndexPath:__sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                __sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            if (!__sourceIndexPath) {
                break;
            }
            
            // Clean up.
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:__sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.;
            
            [UIView animateWithDuration:0.25 animations:^{
                __snapshot.center = cell.center;
                __snapshot.transform = CGAffineTransformIdentity;
                __snapshot.alpha = 0.;
                cell.alpha = 1.;
            } completion:^(BOOL finished) {
                __sourceIndexPath = nil;
                [__snapshot removeFromSuperview];
                __snapshot = nil;
            }];
            
            break;
        }
    }
}

- (UIView *)snapshotFromView:(UIView *)inputView
{
    /* https://developer.apple.com/library/ios/qa/qa1817/_index.html */
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, YES, 0);
    [inputView drawViewHierarchyInRect:inputView.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.;
    snapshot.layer.shadowOffset = CGSizeMake(-5., 0.);
    snapshot.layer.shadowRadius = 5.;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

@end
