//
//  DCTMessageBarNavigationItem.h
//  DCTMessageBar
//
//  Created by Daniel Tull on 15.11.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

@import UIKit;

@interface DCTMessageBarNavigationItem : UINavigationItem

- (instancetype)initWithChildNavigationItem:(UINavigationItem *)childNavigationItem;
@property (nonatomic) UINavigationItem *childNavigationItem;

@end
