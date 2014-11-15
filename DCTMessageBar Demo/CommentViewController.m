//
//  CommentViewController.m
//  Commenting
//
//  Created by Daniel Tull on 13.09.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import "CommentViewController.h"
@import DCTMessageBar;

@interface CommentViewController () <DCTMessageBarDelegate>
@property (nonatomic) DCTMessageBar *messageBar;
@property (nonatomic) NSMutableArray *messages;
@end

@implementation CommentViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.messages = [NSMutableArray new];
    self.messageBar = [DCTMessageBar new];
	self.messageBar.placeholder = @"Post message";
	self.messageBar.delegate = self;
}

- (void)addMessage:(NSString *)messages {
	NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.messages.count inSection:0];
	[self.messages addObject:messages];
	[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - DCTMessageBarDelegate

- (void)messageBarSendButtonTapped:(DCTMessageBar *)messageBar {
	[self addMessage:messageBar.text];
	messageBar.text = nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	cell.textLabel.text = self.messages[indexPath.row];
	return cell;
}

@end
