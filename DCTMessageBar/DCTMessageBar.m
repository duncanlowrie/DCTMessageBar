//
//  CommentBar.m
//  Commenting
//
//  Created by Daniel Tull on 13.09.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import "DCTMessageBar.h"
#import "DCTMessageBarTextView.h"
#import "DCTMessageBarInputAccessoryView.h"

@interface DCTMessageBar () <UITextViewDelegate, DCTMessageBarInputAccessoryViewDelegate>
@property (nonatomic) IBOutlet UITextView *placeholderTextView;
@property (nonatomic) IBOutlet DCTMessageBarTextView *textView;
@property (nonatomic) IBOutlet UIButton *sendButton;
@property (nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *marginConstraints;
@property (nonatomic) IBOutlet UIView *sizingView;
@property (nonatomic) DCTMessageBarInputAccessoryView *trackingView;
@property (nonatomic) BOOL disableTracking;
@property (nonatomic) BOOL tracking;
@end

@implementation DCTMessageBar

#pragma mark - NSObject

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

- (id)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	if (!self) return nil;

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideNotification:) name:UIKeyboardDidHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowNotification:) name:UIKeyboardDidShowNotification object:nil];

	return self;

}

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
	[self updateViews];
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
	[self updateHeight];
}

#pragma mark - UIKeyboard

- (void)keyboardWillHideNotification:(NSNotification *)notification {
	NSLog(@"%@", NSStringFromSelector(_cmd));

	CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	[self setKeyboardFrame:keyboardEndFrame];

	UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue];

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:animationDuration];
	[UIView setAnimationCurve:animationCurve];
	[self layoutIfNeeded];
	[UIView commitAnimations];
}

- (void)keyboardWillShowNotification:(NSNotification *)notification {
	NSLog(@"%@", NSStringFromSelector(_cmd));

	CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	[self setKeyboardFrame:keyboardEndFrame];

	UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue];

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:animationDuration];
	[UIView setAnimationCurve:animationCurve];
	[self layoutIfNeeded];
	[UIView commitAnimations];
}

- (void)keyboardDidHideNotification:(NSNotification *)notification {
	NSLog(@"%@", NSStringFromSelector(_cmd));

	if (!self.textView.isFirstResponder) {
		self.textView.inputAccessoryView = nil;
		[self.textView reloadInputViews];
	}
}

- (void)keyboardDidShowNotification:(NSNotification *)notification {
	NSLog(@"%@", NSStringFromSelector(_cmd));

	if (self.textView.isFirstResponder) {
		self.textView.inputAccessoryView = self.trackingView;
		[self.textView reloadInputViews];
	}
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

	self.trackingView.height = height;
}

- (void)updateViews {
	BOOL empty = self.textView.text.length == 0;
	CGFloat alpha = empty ? 1.0f : 0.0f;
	self.placeholderTextView.alpha = alpha;
	self.sendButton.enabled = !empty;
}

- (DCTMessageBarInputAccessoryView *)trackingView {

	if (!_trackingView) {
		DCTMessageBarInputAccessoryView *inputAccessoryView = [[DCTMessageBarInputAccessoryView alloc] initWithFrame:self.bounds];
		inputAccessoryView.delegate = self;
		inputAccessoryView.backgroundColor = [UIColor colorWithRed:251.0f/255.0f green:128.0f/255.0f blue:36.0f/255.0f alpha:0.3f];
		inputAccessoryView.userInteractionEnabled = NO;
		_trackingView = inputAccessoryView;
	}

	return _trackingView;
}

- (void)setTextView:(DCTMessageBarTextView *)textView {
	_textView = textView;
	_textView.layer.cornerRadius = 6.0f;
	_textView.layer.borderColor = [[UIColor colorWithWhite:0.8f alpha:1.0f] CGColor];
}

- (void)setText:(NSString *)text {
	self.textView.text = text;
	[self updateViews];
	[self updateHeight];
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

	if (_maximumHeight == maximumHeight) return;

	_maximumHeight = maximumHeight;
	[self updateHeight];
}

- (IBAction)send:(id)sender {
	[self.delegate messageBarSendButtonTapped:self];
}

- (void)setKeyboardFrame:(CGRect)keyboardFrame {
	CGFloat value = CGRectGetHeight(self.superview.bounds) - CGRectGetMinY(keyboardFrame) - CGRectGetHeight(self.textView.inputAccessoryView.bounds);

	if (value < 0) value = 0;
	self.bottomMarginConstraint.constant = value;
}

#pragma mark - DCTMessageBarInputAccessoryViewDelegate

- (void)inputAccessoryView:(DCTMessageBarInputAccessoryView *)inputAccessoryView keyboardDidChangeFrame:(CGRect)frame {
	self.tracking = YES;
	[self setKeyboardFrame:frame];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
	[self updateViews];
	[self updateHeight];
}

@end
