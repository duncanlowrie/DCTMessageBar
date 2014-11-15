//
//  DCTMessageBarInputAccessoryViewDelegate.h
//  DCTMessageBar
//
//  Created by Daniel Tull on 15.11.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

@import UIKit;
@class DCTMessageBarInputAccessoryView;

@protocol DCTMessageBarInputAccessoryViewDelegate <NSObject>
- (void)inputAccessoryView:(DCTMessageBarInputAccessoryView *)inputAccessoryView keyboardDidChangeFrame:(CGRect)frame;
@end
