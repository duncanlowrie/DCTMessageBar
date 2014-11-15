//
//  UIViewController+DCTMessageBarController.h
//  DCTMessageBar
//
//  Created by Daniel Tull on 15.11.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

@import UIKit;
@class DCTMessageBarController;

@interface UIViewController (DCTMessageBarController)
@property (nonatomic, readonly) DCTMessageBarController *dct_messageBarController;
@end
