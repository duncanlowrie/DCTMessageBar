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
@property (nonatomic) IBOutlet NSLayoutConstraint *maximumBarHeightConstraint;
@end

@implementation CommentBarViewController

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	self.commentBar.preferredMaxLayoutWidth = CGRectGetWidth(self.view.bounds);
	self.maximumBarHeightConstraint.constant = CGRectGetHeight(self.view.bounds) / 3.0f;
}

@end
