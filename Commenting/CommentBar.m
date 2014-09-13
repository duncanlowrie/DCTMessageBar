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

#pragma mark - CommentBar

- (void)setPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth {
	_preferredMaxLayoutWidth = preferredMaxLayoutWidth;
	[self setupTextView];
	[self invalidateIntrinsicContentSize];
}

- (void)setTextView:(IntrinsicTextView *)textView {
	_textView = textView;
	[self setupTextView];
}

- (void)setupTextView {
	CGFloat sendWidth = [self.sendButton intrinsicContentSize].width;
	CGFloat totalMargins = [[self.marginConstraints valueForKeyPath:@"@sum.constant"] floatValue];
	self.textView.preferredMaxLayoutWidth = self.preferredMaxLayoutWidth - totalMargins - sendWidth;
	self.textView.layer.cornerRadius = 5.0f;
	self.textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
	self.textView.layer.borderWidth = 1.0f/self.contentScaleFactor;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
	[self invalidateIntrinsicContentSize];
}

@end
