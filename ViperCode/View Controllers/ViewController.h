//
//  ViewController.h
//  ViperCode
//
//  Created by Sameh Mabrouk on 2/1/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ModuleGenerator.h"
#import "VPTextField.h"
#import "VPTextView.h"

@interface ViewController : NSViewController <NSTextFieldDelegate, VPTextFieldDelegate, NSMenuDelegate>

// ModuleGenerator instance
@property(nonatomic, retain) ModuleGenerator *moduleGenerator;

// Project name textfiled
@property(nonatomic, weak) IBOutlet NSTextField *ProjectNameTextField;

// Username textfield
@property (weak) IBOutlet NSTextField *userNameTextField;

// Module name textfiled
@property(nonatomic, weak) IBOutlet NSTextField *moduleNameTextField;

// Company name textfiled
@property(nonatomic, weak) IBOutlet NSTextField *companyTextField;

// Module path textfiled
@property(nonatomic, weak) IBOutlet VPTextField *modulePathTexField;

// Tests path textfiled
@property(nonatomic, weak) IBOutlet VPTextField *testsPathTextField;

// Template PopUp button
@property (weak) IBOutlet NSPopUpButton *templatePopUpButton;

// Languages PopUp button
@property(nonatomic, weak) IBOutlet NSPopUpButton *languagesPopUpButton;

// Include tests checkbox button
@property(nonatomic, weak) IBOutlet NSButton *includeTestsCheckBoxButton;

// Generated module button
@property(nonatomic, weak) IBOutlet NSButton *generatedModuleButton;

// Preview code header
@property (unsafe_unretained) IBOutlet VPTextView *previewHeaderCodeTextView;

- (IBAction)createModule:(id)sender;

@end
