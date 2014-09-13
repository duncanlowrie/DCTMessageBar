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
@property (nonatomic) IBOutlet NSLayoutConstraint *barBottomConstraint;
@end

@implementation CommentBarViewController

#pragma mark - NSObject

- (void)dealloc {
	NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
	[defaultCenter removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (id)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	if (!self) return nil;

	NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
	[defaultCenter addObserver:self
					  selector:@selector(keyboardWillChangeFrameNotification:)
						  name:UIKeyboardWillChangeFrameNotification
						object:nil];
	return self;
}

- (IBAction)stopEditing:(id)sender {
	[self.view endEditing:YES];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	self.commentBar.preferredMaxLayoutWidth = CGRectGetWidth(self.view.bounds);
	self.maximumBarHeightConstraint.constant = CGRectGetHeight(self.view.bounds) / 3.0f;
}

#pragma mark - Keyboard Notifications

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification {

	NSDictionary *userInfo = notification.userInfo;
	CGRect keyboardEndFrame;
	[userInfo[UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
	NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];

	CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
	CGFloat keyboardOrigin = keyboardEndFrame.origin.y;
	CGFloat margin = viewHeight - keyboardOrigin;
	self.barBottomConstraint.constant = margin;

	if (duration > 0) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:duration];
		[UIView setAnimationCurve:curve];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[self.view layoutIfNeeded];
		[UIView commitAnimations];
	}
}

@end
