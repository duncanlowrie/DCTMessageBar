//
//  UIViewController+DCTMessageBarController.m
//  DCTMessageBar
//
//  Created by Daniel Tull on 15.11.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import "UIViewController+DCTMessageBarController.h"
#import "DCTMessageBarController.h"

@implementation UIViewController (DCTMessageBarController)

- (DCTMessageBarController *)dct_messageBarController {

	if ([self isKindOfClass:[DCTMessageBarController class]]) {
		return (DCTMessageBarController *)self;
	}

	return [self.parentViewController dct_messageBarController];
}

@end
