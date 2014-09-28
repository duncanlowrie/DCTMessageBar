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

@property (nonatomic) IBOutlet IntrinsicTextView *textView;
@property (nonatomic) IBOutlet UIButton *sendButton;
@property (nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *marginConstraints;
@property (nonatomic) IBOutlet UIView *sizingView;

@end




@implementation CommentBar

#pragma mark - UIView

- (void)didMoveToWindow {
	[super didMoveToWindow];
	self.textView.layer.borderWidth = 1.0f/self.window.screen.nativeScale;
}

+ (instancetype)view {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle bundleForClass:[self class]]];
    NSArray *objects = [nib instantiateWithOwner:nil options:nil];
    for (id object in objects) {
        if ([object isKindOfClass:[self class]]) {
            return object;
        }
    }
    
    return nil;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGSize currentSize = self.frame.size;
	CGFloat sendWidth = [self.sendButton intrinsicContentSize].width;
	CGFloat totalMargins = [[self.marginConstraints valueForKeyPath:@"@sum.constant"] floatValue];
	self.textView.preferredMaxLayoutWidth = currentSize.width - totalMargins - sendWidth;
}

- (void)setTextView:(IntrinsicTextView *)textView {
	_textView = textView;
	_textView.layer.cornerRadius = 6.0f;
	_textView.layer.borderColor = [[UIColor colorWithWhite:0.8f alpha:1.0f] CGColor];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {

    for (NSLayoutConstraint *constraint in self.constraints) {
        if ([constraint.identifier isEqualToString:@"_UIKBAutolayoutHeightConstraint"]) { // This is the constraint that controls the height!!

			[self.textView invalidateIntrinsicContentSize];
			[self invalidateIntrinsicContentSize];
			CGSize currentSize = self.frame.size;
			CGSize targetSize = CGSizeMake(currentSize.width, 0);
			CGSize size = [self.sizingView systemLayoutSizeFittingSize:targetSize];
            constraint.constant = size.height;
        }
    }
}

@end
