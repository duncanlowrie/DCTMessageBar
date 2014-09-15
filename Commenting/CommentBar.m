//
//  CommentBar.m
//  Commenting
//
//  Created by Daniel Tull on 13.09.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import "CommentBar.h"
#import "IntrinsicTextView.h"

@interface CommentBar ()
@property (nonatomic) IBOutlet UITextView *placeholder;
@property (nonatomic) IBOutlet IntrinsicTextView *textView;
@property (nonatomic) IBOutlet UIButton *sendButton;
@property (nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *marginConstraints;
@end

@implementation CommentBar

#pragma mark - UIView

- (BOOL)translatesAutoresizingMaskIntoConstraints {
	return NO;
}

// To force the view to get a contentScaleFactor
- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[self calculateFrame];
}

#pragma mark - CommentBar

- (void)calculateFrame {

	CGSize currentSize = self.frame.size;

	CGFloat sendWidth = [self.sendButton intrinsicContentSize].width;
	CGFloat totalMargins = [[self.marginConstraints valueForKeyPath:@"@sum.constant"] floatValue];
	self.textView.preferredMaxLayoutWidth = currentSize.width - totalMargins - sendWidth;

	CGSize targetSize = CGSizeMake(currentSize.width, 0);
	CGSize size = [self systemLayoutSizeFittingSize:targetSize];
	CGRect frame = self.frame;
	frame.origin.y += CGRectGetHeight(frame) - size.height;
	frame.size.height = size.height;
	self.frame = frame;
	[self layoutIfNeeded];
}

- (void)setTextView:(IntrinsicTextView *)textView {
	_textView = textView;
	_textView.layer.cornerRadius = 6.0f;
	_textView.layer.borderColor = [[UIColor colorWithWhite:0.8f alpha:1.0f] CGColor];
	_textView.layer.borderWidth = 1.0f/self.contentScaleFactor;
}

- (void)updatePlaceholderAlpha {
	BOOL hidden = self.textView.text.length > 0;
	CGFloat alpha = hidden ? 0.0f : 1.0f;
	self.placeholder.alpha = alpha;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
	[self invalidateIntrinsicContentSize];
	[textView invalidateIntrinsicContentSize];
	[self updatePlaceholderAlpha];
	[self calculateFrame];
}

@end
