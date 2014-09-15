//
//  CommentBarViewController.m
//  Commenting
//
//  Created by Daniel Tull on 13.09.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import "CommentBarViewController.h"
#import "CommentBar.h"

@interface CommentBarViewController ()
@property (nonatomic) IBOutlet CommentBar *commentBar;
@end

@implementation CommentBarViewController

- (void)viewDidLoad {
	[super viewDidLoad];

}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (UIView *)inputAccessoryView {

	if ([self.commentBar.superview isEqual:self.view]) {
		[self.commentBar removeFromSuperview];
	}

	return self.commentBar;
}

@end
