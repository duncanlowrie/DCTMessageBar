//
//  DCTMessageBarInputAccessoryView.h
//  DCTMessageBar
//
//  Created by Daniel Tull on 14.11.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

@import UIKit;
@protocol DCTMessageBarInputAccessoryViewDelegate;

@interface DCTMessageBarInputAccessoryView : UIView
@property (nonatomic) CGFloat height;
@property (nonatomic, weak) id<DCTMessageBarInputAccessoryViewDelegate> delegate;
@end
