//
//  VPTextView.m
//  ViperCode
//
//  Created by Mário Cosme on 15/09/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import "VPTextView.h"

@interface VPTextView ()

@property (nonatomic, assign) BOOL isUserInteractionDisabled;

@end

@implementation VPTextView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (NSView *)hitTest:(NSPoint)point {
    if (self.isUserInteractionDisabled) {
        return nil;
    }
    else {
        return [super hitTest:point];
    }
}

- (void)setUserInteractionEnabled:(BOOL)enabled {
    self.isUserInteractionDisabled = !enabled;
}

@end
