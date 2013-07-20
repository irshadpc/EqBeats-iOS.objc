//
//  EBShadowedTextField.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "SDNibLoadedTextField.h"

@interface EBShadowedTextField : SDNibLoadedTextField
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, assign) CGSize shadowOffset;
@end
