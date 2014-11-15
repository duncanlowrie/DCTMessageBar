//
//  DCTMessageBarController.m
//  DCTMessageBar
//
//  Created by Daniel Tull on 14.11.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import "DCTMessageBarController.h"

@interface DCTMessageBarController ()
@property (nonatomic, readwrite) UIViewController *viewController;
@property (nonatomic) IBOutlet UIView *containerView;
@end

@implementation DCTMessageBarController

- (instancetype)initWithViewController:(UIViewController *)viewController {
	NSString *name = @"DCTMessageBar";
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:bundle];
	DCTMessageBarController *controller = [storyboard instantiateInitialViewController];
	controller.viewController = viewController;
	return controller;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	UIView *view = self.viewController.view;
	view.frame = self.containerView.bounds;
	[self.containerView addSubview:view];
}

@end
