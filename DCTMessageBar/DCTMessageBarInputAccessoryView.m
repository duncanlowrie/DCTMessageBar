//
//  DCTMessageBarInputAccessoryView.m
//  DCTMessageBar
//
//  Created by Daniel Tull on 14.11.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import "DCTMessageBarInputAccessoryView.h"
#import "DCTMessageBarInputAccessoryViewDelegate.h"

NSString *const DCTMessageBarInputAccessoryViewKeyboardFrameDidChangeNotification = @"DCTMessageBarInputAccessoryViewKeyboardFrameDidChangeNotification";
static void* DCTMessageBarInputAccessoryViewContext = &DCTMessageBarInputAccessoryViewContext;

@interface DCTMessageBarInputAccessoryView ()
@property (nonatomic, weak) UIView *observedSuperview;
@end

@implementation DCTMessageBarInputAccessoryView

- (void)dealloc {
	self.observedSuperview = nil;
}

- (void)willMoveToSuperview:(UIView *)superview {
	[super willMoveToSuperview:superview];
	self.observedSuperview = superview;
}

- (void)setHeight:(CGFloat)height {
	_height = height;
	self.heightConstraint.constant = height;
}

- (void)setObservedSuperview:(UIView *)observedSuperview {

	NSString *keyPath = NSStringFromSelector(@selector(center));
	[_observedSuperview removeObserver:self forKeyPath:keyPath context:DCTMessageBarInputAccessoryViewContext];
	_observedSuperview = observedSuperview;
	[_observedSuperview addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:DCTMessageBarInputAccessoryViewContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

	if (context != DCTMessageBarInputAccessoryViewContext) {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
		return;
	}

	[self.delegate inputAccessoryView:self keyboardDidChangeFrame:self.superview.frame];
}

- (NSLayoutConstraint *)heightConstraint {

	for (NSLayoutConstraint *constraint in self.constraints) {

		if (constraint.firstAttribute == NSLayoutAttributeHeight &&
			constraint.secondAttribute == NSLayoutAttributeNotAnAttribute &&
			[constraint.firstItem isEqual:self] &&
			constraint.secondItem == nil) {
			return constraint;
		}

		if (constraint.secondAttribute == NSLayoutAttributeHeight &&
			constraint.firstAttribute == NSLayoutAttributeNotAnAttribute &&
			[constraint.secondItem isEqual:self] &&
			constraint.firstItem == nil) {
			return constraint;
		}
	}

	return nil;
}

@end
