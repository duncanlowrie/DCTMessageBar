//
//  CommentBar.m
//  Commenting
//
//  Created by Daniel Tull on 13.09.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import "CommentBar.h"
#import "IntrinsicTextView.h"

@interface CommentBar () <UITextViewDelegate>
@property (nonatomic) IBOutlet UITextView *placeholderTextView;
@property (nonatomic) IBOutlet IntrinsicTextView *textView;
@property (nonatomic) IBOutlet UIButton *sendButton;
@property (nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *marginConstraints;
@property (nonatomic) IBOutlet UIView *sizingView;

@end

@implementation CommentBar

- (instancetype)init {
	Class class = [self class];
	NSString *name = NSStringFromClass(class);
	NSBundle *bundle = [NSBundle bundleForClass:class];
	UINib *nib = [UINib nibWithNibName:name bundle:bundle];
	NSArray *objects = [nib instantiateWithOwner:nil options:nil];
	for (id object in objects) {
		if ([object isKindOfClass:class]) {
			return object;
		}
	}

	return nil;
}

#pragma mark - UIView

- (void)didMoveToSuperview {
	[super didMoveToSuperview];
	[self updatePlaceholderAlpha];
	[self updateHeight];
}

- (void)didMoveToWindow {
	[super didMoveToWindow];
	self.textView.layer.borderWidth = 1.0f/self.window.screen.nativeScale;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGSize currentSize = self.frame.size;
	CGFloat sendWidth = [self.sendButton intrinsicContentSize].width;
	CGFloat totalMargins = [[self.marginConstraints valueForKeyPath:@"@sum.constant"] floatValue];
	self.textView.preferredMaxLayoutWidth = currentSize.width - totalMargins - sendWidth;
}

#pragma mark - CommentBar

- (void)updateHeight {

	[self.textView invalidateIntrinsicContentSize];
	CGSize currentSize = self.frame.size;
	CGSize targetSize = CGSizeMake(currentSize.width, 0);
	CGSize size = [self.sizingView systemLayoutSizeFittingSize:targetSize];

	CGFloat height = size.height;
	if (self.maximumHeight < height && self.maximumHeight > 0.0f) {
		height = self.maximumHeight;
	}

	self.heightConstraint.constant = height;
}

- (void)updatePlaceholderAlpha {
	BOOL empty = self.textView.text.length == 0;
	CGFloat alpha = empty ? 1.0f : 0.0f;
	self.placeholderTextView.alpha = alpha;
	self.sendButton.enabled = !empty;
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

- (void)setTextView:(IntrinsicTextView *)textView {
	_textView = textView;
	_textView.layer.cornerRadius = 6.0f;
	_textView.layer.borderColor = [[UIColor colorWithWhite:0.8f alpha:1.0f] CGColor];
}

- (void)setText:(NSString *)text {
	self.textView.text = text;
}

- (NSString *)text {
	return self.textView.text;
}

- (void)setPlaceholder:(NSString *)placeholder {
	_placeholder = [placeholder copy];
	self.placeholderTextView.text = _placeholder;
	self.placeholderTextView.textColor = [UIColor lightGrayColor];
	self.placeholderTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
}

- (void)setMaximumHeight:(CGFloat)maximumHeight {
	_maximumHeight = maximumHeight;
	[self updateHeight];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
	[self updatePlaceholderAlpha];
	[self updateHeight];
}

@end
