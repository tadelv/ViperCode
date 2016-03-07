//
//  ViewController.h
//  ViperCode
//
//  Created by Sameh Mabrouk on 2/1/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ModuleGenerator.h"

@interface ViewController : NSViewController <NSTextFieldDelegate>

//ModuleGenerator instance.
@property(nonatomic, retain) ModuleGenerator *moduleGenerator;

//Module path textfiled.
@property(nonatomic, weak) IBOutlet NSTextField *modulePathTexField;

//Company name textfiled.
@property(nonatomic, weak) IBOutlet NSTextField *companyTextField;

//Project name textfiled.
@property(nonatomic, weak) IBOutlet NSTextField *ProjectNameTextField;

//Module name textfiled.
@property(nonatomic, weak) IBOutlet NSTextField *moduleNameTextField;

//Tests path textfiled.
@property(nonatomic, weak) IBOutlet NSTextField *testsPathTextField;

//Include tests check box button.
@property(nonatomic, weak) IBOutlet NSButton *includeTestsCheckBoxButton;

//Languages PopUp button.
@property(nonatomic, weak) IBOutlet NSPopUpButton *languagesPopUpButton;

//Generatet module button.
@property(nonatomic, weak) IBOutlet NSButton *generatedModuleButton;

-(IBAction)createModule:(id)sender;

@end

