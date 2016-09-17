//
//  VPTextField.h
//  ViperCode
//
//  Created by Mário Cosme on 14/09/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol VPTextFieldDelegate

- (void)didBecomeFirstResponder:(NSTextField *)textField;

@end

@interface VPTextField : NSTextField

@property (nonatomic, weak) id<VPTextFieldDelegate> vpDelegate;

@end
