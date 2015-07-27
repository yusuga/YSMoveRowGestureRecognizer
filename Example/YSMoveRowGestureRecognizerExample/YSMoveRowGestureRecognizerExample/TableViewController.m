//
//  TableViewController.m
//  YSMoveRowGestureRecognizerExample
//
//  Created by Yu Sugawara on 7/27/15.
//  Copyright (c) 2015 Yu Sugawara. All rights reserved.
//

#import "TableViewController.h"
#import "YSMoveRowGestureRecognizer.h"

@interface TableViewController ()

@property (nonatomic) NSMutableArray *data;
@property (nonatomic) YSMoveRowGestureRecognizer *moveRowGestureRecognizer;

@end

@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.data = [NSMutableArray array];
    for (NSUInteger section = 0; section < 10; section++) {
        NSMutableArray *secData = [NSMutableArray array];
        for (NSUInteger row = 0; row < 5; row++) {
            [secData addObject:[NSString stringWithFormat:@"%zd - %zd", section, row]];
        }
        [self.data addObject:secData];
    }
    
    self.moveRowGestureRecognizer = [[YSMoveRowGestureRecognizer alloc] initWithTableView:self.tableView
                                                               addGestureRecognizerToView:self.tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.data[indexPath.section][indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Move

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    id obj = self.data[sourceIndexPath.section][sourceIndexPath.row];
    [self.data[sourceIndexPath.section] removeObjectAtIndex:sourceIndexPath.row];
    [self.data[destinationIndexPath.section] insertObject:obj atIndex:destinationIndexPath.row];
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    return proposedDestinationIndexPath;
}

#pragma Edit

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Button

- (IBAction)editButtonClicked:(id)sender
{
    [self.moveRowGestureRecognizer setDisabled:!self.isEditing];
    [self setEditing:!self.isEditing animated:YES];
}

@end
