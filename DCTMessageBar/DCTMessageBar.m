//
//  CommentBar.m
//  Commenting
//
//  Created by Daniel Tull on 13.09.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import "DCTMessageBar.h"
#import "DCTMessageBarTextView.h"

const BOOL DCTMessageBarDebug = NO;
const CGFloat DCTMessageBarNoMaximumHeight = 1000000.0f; // CGFLOAT_MAX is too big for layout constraints apparently

@interface DCTMessageBar () <UITextViewDelegate>
@property (nonatomic) IBOutlet DCTMessageBarTextView *mbTextView;
@property (nonatomic) IBOutlet UITextView *placeholderTextView;
@property (nonatomic) IBOutlet UIButton *sendButton;
@property (nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *marginConstraints;
@property (nonatomic) IBOutlet UIView *sizingView;
@property (nonatomic) IBOutlet NSLayoutConstraint *maximumHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
@end

@implementation DCTMessageBar

#pragma mark - NSObject

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

- (void)awakeFromNib {
	[super awakeFromNib];
	if (DCTMessageBarDebug) {
		self.textView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1f];
	}
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority {
	[self.textView invalidateIntrinsicContentSize];
	return [self.sizingView systemLayoutSizeFittingSize:targetSize withHorizontalFittingPriority:horizontalFittingPriority verticalFittingPriority:verticalFittingPriority];
}

- (void)didMoveToSuperview {
	[super didMoveToSuperview];
	[self updateViews];
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
	self.mbTextView.preferredMaxLayoutWidth = currentSize.width - totalMargins - sendWidth;
}

#pragma mark - CommentBar

- (UITextView *)textView {
	return self.mbTextView;
}

- (void)updateViews {
	BOOL empty = self.textView.text.length == 0;
	CGFloat alpha = empty ? 1.0f : 0.0f;
	self.placeholderTextView.alpha = alpha;
	self.sendButton.enabled = !empty;
}

- (void)setMbTextView:(DCTMessageBarTextView *)mbTextView {
	_mbTextView = mbTextView;
	_mbTextView.layer.cornerRadius = 6.0f;
	_mbTextView.layer.borderColor = [[UIColor colorWithWhite:0.8f alpha:1.0f] CGColor];
	_mbTextView.scrollsToTop = NO;
}

- (void)setText:(NSString *)text {
	self.textView.text = text;
	[self updateViews];
	[self.delegate messageBar:self didChangeText:text];
	[self.delegate messageBarNeedsHeightUpdate:self];
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

- (IBAction)send:(id)sender {
	[self.delegate messageBarSendButtonTapped:self];
}

- (void)setMaximumHeight:(CGFloat)maximumHeight {

	NSInteger oldHeight = _maximumHeight + 0.5f;
	NSInteger newHeight = maximumHeight + 0.5f;
	if (oldHeight == newHeight) {
		return;
	}

	_maximumHeight = maximumHeight;

	self.maximumHeightConstraint.constant = maximumHeight;
	[self.delegate messageBarNeedsHeightUpdate:self];
}

- (NSLayoutConstraint *)maximumHeightConstraint {

	if (!_maximumHeightConstraint) {
		_maximumHeightConstraint = [NSLayoutConstraint constraintWithItem:self
																attribute:NSLayoutAttributeHeight
																relatedBy:NSLayoutRelationLessThanOrEqual
																   toItem:nil
																attribute:NSLayoutAttributeNotAnAttribute
															   multiplier:1.0f
																 constant:DCTMessageBarNoMaximumHeight];
		[self addConstraint:_maximumHeightConstraint];
	}

	return _maximumHeightConstraint;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
	[self updateViews];
	[self.delegate messageBar:self didChangeText:textView.text];
	[self.delegate messageBarNeedsHeightUpdate:self];
    
    self.textViewHeightConstraint.constant = textView.contentSize.height;
    
//    NSLog(@"textView.contentSize.height = %f", textView.contentSize.height);
//    NSLog(@"textView.frame.size.height = %f", textView.frame.size.height);
//    NSLog(@"textView.text.length = %@", @(textView.text.length));

}

@end
