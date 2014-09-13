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

- (BOOL)translatesAutoresizingMaskIntoConstraints {
	return NO;
}

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

	NSLog(@"%@:%@ contentInset: %@", self, NSStringFromSelector(_cmd), NSStringFromUIEdgeInsets(self.textView.contentInset));

//	NSLog(@"%@:%@ %@", self, NSStringFromSelector(_cmd), NSStringFromUIEdgeInsets(self.textView.));
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
	[self invalidateIntrinsicContentSize];
}

//- (CGSize)intrinsicContentSize {
//
//	CGSize targetSize = CGSizeMake(CGRectGetWidth(self.bounds), 0);
//
//	CGFloat sendWidth = [self.sendButton intrinsicContentSize].width;
//	CGFloat totalMargins = [[self.marginConstraints valueForKeyPath:@"@sum.constant"] floatValue];
//	self.textView.preferredMaxLayoutWidth = targetSize.width - totalMargins - sendWidth;
//
//	return [self systemLayoutSizeFittingSize:targetSize];
//}

//- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize
//		withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority
//			  verticalFittingPriority:(UILayoutPriority)verticalFittingPriority {
//
//	CGFloat sendWidth = [self.sendButton intrinsicContentSize].width;
//	CGFloat totalMargins = [[self.marginConstraints valueForKeyPath:@"@sum.constant"] floatValue];
//	self.textView.preferredMaxLayoutWidth = targetSize.width - totalMargins - sendWidth;
//
//	CGSize size = [super systemLayoutSizeFittingSize:targetSize
//				withHorizontalFittingPriority:horizontalFittingPriority
//					  verticalFittingPriority:verticalFittingPriority];
//
//	NSLog(@"%@:%@ %@", self, NSStringFromSelector(_cmd), NSStringFromCGSize(size));
//
//	return size;
//}

@end
