//
//  DCTMessageBarController.h
//  DCTMessageBar
//
//  Created by Daniel Tull on 14.11.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

@import UIKit;

@interface DCTMessageBarController : UIViewController

- (instancetype)initWithViewController:(UIViewController *)viewController;
@property (nonatomic, readonly) UIViewController *viewController;

@end
