//
//  CommentViewController.m
//  Commenting
//
//  Created by Daniel Tull on 13.09.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentBar.h"

@interface CommentViewController () <UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic) CommentBar *commentBar;
@end

@implementation CommentViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    self.commentBar = [CommentBar new];
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (UIView *)inputAccessoryView {
	return self.commentBar;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	cell.textLabel.text = [NSString stringWithFormat:@"%@.%@", @(indexPath.section), @(indexPath.row)];
	return cell;
}

@end
