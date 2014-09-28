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

@end




@implementation CommentBar

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

- (void)textViewDidChange:(UITextView *)textView {

    for (NSLayoutConstraint *constraint in self.constraints) {
        if ([constraint.identifier isEqualToString:@"_UIKBAutolayoutHeightConstraint"]) { // This is the constraint that controls the height!!

			[self removeConstraint:constraint];
			[self.textView invalidateIntrinsicContentSize];
			[self invalidateIntrinsicContentSize];
			CGSize currentSize = self.frame.size;
			CGSize targetSize = CGSizeMake(currentSize.width, 0);
			CGSize size = [self systemLayoutSizeFittingSize:targetSize];


            constraint.constant = size.height;
			[self addConstraint:constraint];
			NSLog(@"%@ %@", constraint, @(size.height));
			[self layoutIfNeeded];
        }
    }
}

@end
