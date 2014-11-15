//
//  CommentBar.h
//  Commenting
//
//  Created by Daniel Tull on 13.09.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

@import UIKit;
#import <DCTMessageBar/DCTMessageBarDelegate.h>

//! Project version number and string for DCTMessageBar.
FOUNDATION_EXPORT double DCTMessageBarVersionNumber;
FOUNDATION_EXPORT const unsigned char DCTMessageBarVersionString[];

@interface DCTMessageBar : UIView

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic) CGFloat maximumHeight;
@property (nonatomic, weak) id<DCTMessageBarDelegate> delegate;

//@property (nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (nonatomic) IBOutlet NSLayoutConstraint *bottomMarginConstraint;

@end
