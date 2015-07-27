//
//  YSMoveRowGestureRecognizer.h
//  YSMoveRowGestureRecognizerExample
//
//  Created by Yu Sugawara on 7/27/15.
//  Copyright (c) 2015 Yu Sugawara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSMoveRowGestureRecognizer : NSObject

- (instancetype)initWithTableView:(UITableView *)tableView
       addGestureRecognizerToView:(UIView *)view;

@property (weak, nonatomic) UITableView *tableView;
@property (nonatomic, readonly) UILongPressGestureRecognizer *gesture;
- (void)addGestureRecognizerToView:(UIView *)view;

- (void)setDisabled:(BOOL)disabled;

@end
