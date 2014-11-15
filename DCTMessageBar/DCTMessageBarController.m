//
//  DCTMessageBarController.m
//  DCTMessageBar
//
//  Created by Daniel Tull on 14.11.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import "DCTMessageBarController.h"
#import "DCTMessageBarControllerDelegate.h"
#import "DCTMessageBar.h"
#import "DCTMessageBarInputAccessoryView.h"
#import "DCTMessageBarInputAccessoryViewDelegate.h"

@interface DCTMessageBarController () <DCTMessageBarDelegate, DCTMessageBarInputAccessoryViewDelegate>
@end

@implementation DCTMessageBarController

#pragma mark - Initialization

- (void)dealloc {
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	[notificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[notificationCenter removeObserver:self name:UIKeyboardDidHideNotification object:nil];
	[notificationCenter removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

- (void)sharedInit {
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self selector:@selector(keyboardWillHideShowNotification:) name:UIKeyboardWillHideNotification object:nil];
	[notificationCenter addObserver:self selector:@selector(keyboardWillHideShowNotification:) name:UIKeyboardWillShowNotification object:nil];
	[notificationCenter addObserver:self selector:@selector(keyboardDidHideShowNotification:) name:UIKeyboardDidHideNotification object:nil];
	[notificationCenter addObserver:self selector:@selector(keyboardDidHideShowNotification:) name:UIKeyboardDidShowNotification object:nil];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	if (!self) return nil;
	[self sharedInit];
	return self;
}

- (instancetype)initWithNibName:(NSString *)name bundle:(NSBundle *)bundle {
	self = [super initWithNibName:name bundle:bundle];
	if (!self) return nil;
	[self sharedInit];	
	return self;
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
	self = [self initWithNibName:nil bundle:nil];
	if (!self) return nil;
	_viewController = viewController;
	return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	UIView *view = self.viewController.view;
	if (view) {
		view.frame = self.view.bounds;
		view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		[self.view insertSubview:view belowSubview:self.messageBar];
	}
}

#pragma mark - DCTMessageBarController

- (void)updateHeight {

	CGSize currentSize = self.view.frame.size;
	CGSize targetSize = CGSizeMake(currentSize.width, 0);
	[self.messageBar systemLayoutSizeFittingSize:targetSize];

	[UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:0.7f options:0 animations:^{
		[self.messageBar layoutIfNeeded];
	} completion:nil];
	[self reloadInputAccessoryView];
}

- (void)reloadInputAccessoryView {

	NSInteger inputAccessoryHeight = CGRectGetHeight(self.messageBar.textView.inputAccessoryView.bounds) + 0.5f;
	NSInteger messageBarHeight = CGRectGetHeight(self.messageBar.bounds) + 0.5f;

	if (!self.messageBar.textView.isFirstResponder) {

		self.messageBar.textView.inputAccessoryView = nil;

	} else if (inputAccessoryHeight != messageBarHeight) {

		DCTMessageBarInputAccessoryView *inputAccessoryView = [[DCTMessageBarInputAccessoryView alloc] initWithFrame:self.messageBar.bounds];
		inputAccessoryView.delegate = self;
		inputAccessoryView.backgroundColor = DCTMessageBarDebug ? [[UIColor yellowColor] colorWithAlphaComponent:0.05f] : [UIColor clearColor];
		inputAccessoryView.userInteractionEnabled = NO;
		self.messageBar.textView.inputAccessoryView = inputAccessoryView;
	}
}

- (void)setKeyboardFrame:(CGRect)keyboardFrame {

	CGFloat inputHeight = CGRectGetHeight(self.messageBar.textView.inputAccessoryView.bounds);
	CGFloat keyboardMinY = CGRectGetMinY(keyboardFrame);
	CGFloat viewHeight = CGRectGetHeight(self.messageBar.superview.bounds);

	CGFloat value = viewHeight - keyboardMinY - inputHeight;

	if (value < 0) value = 0;
	self.messageBar.bottomMarginConstraint.constant = value;
}

#pragma mark - UIKeyboard Notifications

- (void)keyboardWillHideShowNotification:(NSNotification *)notification {

	NSDictionary *userInfo = notification.userInfo;
	CGRect keyboardEndFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
	NSTimeInterval animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] integerValue];

	[self setKeyboardFrame:keyboardEndFrame];

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:animationDuration];
	[UIView setAnimationCurve:animationCurve];
	[self.messageBar layoutIfNeeded];
	[UIView commitAnimations];
}

- (void)keyboardDidHideShowNotification:(NSNotification *)notification {
	[self reloadInputAccessoryView];
}

#pragma mark - DCTMessageBarDelegate

- (void)messageBar:(DCTMessageBar *)messageBar didChangeText:(NSString *)text {
	[self updateHeight];
	[self.delegate messageBarController:self didChangeText:text];
}

- (void)messageBarSendButtonTapped:(DCTMessageBar *)messageBar {
	[self.delegate messageBarControllerSendButtonTapped:self];
}

#pragma mark - DCTMessageBarInputAccessoryViewDelegate

- (void)inputAccessoryView:(DCTMessageBarInputAccessoryView *)inputAccessoryView keyboardDidChangeFrame:(CGRect)frame {
	[self setKeyboardFrame:frame];
}

@end
