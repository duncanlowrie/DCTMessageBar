//
//  CommentBar.m
//  Commenting
//
//  Created by Daniel Tull on 13.09.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import "CommentBar.h"

@interface CommentBar ()

@property (nonatomic, weak) IBOutlet UITextField *textField;

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

- (IBAction)textFieldDidChange:(UITextField*)textField {
    CGFloat newHeight = 60 + (self.textField.text.length * 20);
    
    for (NSLayoutConstraint *constraint in self.constraints) {
        if ([constraint.identifier isEqualToString:@"_UIKBAutolayoutHeightConstraint"]) { // This is the constraint that controls the height!!
            constraint.constant = newHeight;
        }
    }
}

@end
