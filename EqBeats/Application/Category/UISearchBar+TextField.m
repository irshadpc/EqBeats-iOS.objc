//
//  UISearchBar+TextField.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "UISearchBar+TextField.h"
#import <objc/runtime.h>

@implementation UISearchBar (TextField)

NS_INLINE UITextField* find_textfield(UIView *view)
{
    for (UIView *subview in view.subviews) {
        UITextField *tf = find_textfield(subview);
        if (tf) {
            return tf;
        } else if ([subview isKindOfClass: [UITextField class]]) {
            return (UITextField*)subview;
        }
    }
    return nil;
}

- (UITextField*) textField
{
    UITextField *textField = objc_getAssociatedObject(self, "EBUISearchBar::TextField");
    if (textField == nil) {
        textField = find_textfield(self);
        objc_setAssociatedObject(self, "EBUISearchBar::TextField", textField, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return textField;
}

@end
