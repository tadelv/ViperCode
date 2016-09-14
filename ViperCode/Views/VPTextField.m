//
//  VPTextField.m
//  ViperCode
//
//  Created by Mário Cosme on 14/09/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import "VPTextField.h"

@interface VPTextField ()

@property (nonatomic, assign) BOOL notFirstTime;

@end

@implementation VPTextField

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (BOOL)becomeFirstResponder {
    if (self.notFirstTime) {
        [self.vpDelegate didBecomeFirstResponder:self];
        return [super becomeFirstResponder];
    }
    else {
        self.notFirstTime = YES;
        return NO;
    }
}

@end
