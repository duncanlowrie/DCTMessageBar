//
//  IntrinsicTextView.m
//  Commenting
//
//  Created by Daniel Tull on 13.09.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import "DCTMessageBarTextView.h"

@implementation DCTMessageBarTextView

- (void)setPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth {
	_preferredMaxLayoutWidth = preferredMaxLayoutWidth;
	[self invalidateIntrinsicContentSize];
}

- (void)setText:(NSString *)text {
	[super setText:text];
	[self invalidateIntrinsicContentSize];
}

- (void)layoutSubviews {
	[super layoutSubviews];
}

//- (CGSize)intrinsicContentSize {
//    CGSize max = CGSizeMake(self.preferredMaxLayoutWidth, CGFLOAT_MAX);
//    CGSize size = [self sizeThatFits:max];
//    NSLog(@"%@ %@", NSStringFromSelector(_cmd), NSStringFromCGSize(size));
//    return size;
//}

@end
