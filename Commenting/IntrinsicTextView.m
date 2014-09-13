//
//  IntrinsicTextView.m
//  Commenting
//
//  Created by Daniel Tull on 13.09.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import "IntrinsicTextView.h"

@implementation IntrinsicTextView

- (void)setPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth {
	_preferredMaxLayoutWidth = preferredMaxLayoutWidth;
	[self invalidateIntrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
	CGSize max = CGSizeMake(self.preferredMaxLayoutWidth, CGFLOAT_MAX);
	CGSize size = CGSizeZero;

	NSString *text = self.text;
	if (text.length == 0) {
		self.text = @"A";
		size = [self sizeThatFits:max];
		self.text = text;
	} else {
		size = [self sizeThatFits:max];
	}

	return size;
}

@end
