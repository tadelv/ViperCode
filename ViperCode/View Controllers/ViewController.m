//
//  ViewController.m
//  ViperCode
//
//  Created by Sameh Mabrouk on 2/1/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import "ViewController.h"
#import "ModuleGenerator.h"
#import "FilesUtils.h"
#import "TemplateManager.h"
#import "Constants.h"
#import "FileManager.h"
#import "NSString+Substring.h"
#import <AddressBook/AddressBook.h>

// Constants for defining alerts types.
#define kCOPYALERT 0
#define kTESTSALERT 1
#define kREMOVEALERT 2
#define kMODULESUCCESSALERT 2

#define kOBJECTIVE_C @"Objective-C"
#define kSWIFT @"Swift"

@implementation ViewController

#pragma mark - View Controller methods
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.window.title = @"ViperCode";
    [self.generatedModuleButton setEnabled:NO];
    self.ProjectNameTextField.delegate = self;
    [self.previewHeaderCodeTextView setUserInteractionEnabled:NO];
    
    [self configAvailableTemplates];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

- (void)viewDidAppear {
    [super viewDidAppear];
    self.modulePathTexField.vpDelegate = self;
    self.testsPathTextField.vpDelegate = self;
}

- (void)updatePreviewHeaderCode {
    NSString *languageSuffix = @"";
    if ([[self generateLanguage] isEqualToString:kOBJECTIVE_C]) {
        languageSuffix = @".h";
    }
    else if ([[self generateLanguage] isEqualToString:kSWIFT]) {
        languageSuffix = @".swift";
    }
    
    NSString *previewText = @"//\n";
    previewText = [previewText stringByAppendingString:[NSString stringWithFormat:@"//  %@%@\n", [self generateModuleName], languageSuffix]];
    previewText = [previewText stringByAppendingString:[NSString stringWithFormat:@"//  %@\n", [self generateProductName]]];
    previewText = [previewText stringByAppendingString:@"//\n"];
    previewText = [previewText stringByAppendingString:[NSString stringWithFormat:@"//  Created by %@ on %@.\n", [self generateUserName], [self generateCurrentDate]]];
    previewText = [previewText stringByAppendingString:[NSString stringWithFormat:@"//  Copyright (c) %@ %@. All rights reserved.\n", [self generateCurrentYear], [self generateCompanyName]]];
    previewText = [previewText stringByAppendingString:@"//\n"];

    self.previewHeaderCodeTextView.string = previewText;
}

/*!
 @brief Create and display Alert sheet.  The functionality of Alert Sheets is the same like Alert Panel, but instead of being a floating window the Alert Sheet is attached to your main application window.
 @param message The alert’s informative text.
 */
- (void)displayPopupAlert:(NSString*)message withButtons:(NSArray*)buttons alertTag:(NSInteger)tag {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@""];
    [alert setInformativeText:message];
    
    for(NSString *buttonTitle in buttons) {
        [alert addButtonWithTitle:buttonTitle];
    }
    
    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        // Check returnCode here
        if (returnCode == NSAlertFirstButtonReturn) {
            if (tag == kCOPYALERT) {
                //Handling replace case
                [self fireGenerateAction:YES replaceExistedModuleTest:YES];
            }
        }
        else if (returnCode == NSAlertSecondButtonReturn) {
            // Handling stop case
        }
    }];
}

- (void)configAvailableTemplates {
    TemplateManager *templateManager = [TemplateManager new];
    [self.templatePopUpButton addItemsWithTitles:[templateManager getTemplates]];
    [self.templatePopUpButton selectItemWithTitle:[templateManager defaultTemplate]];
}

#pragma mark - Module Generation methods
- (void)fireGenerateAction:(BOOL)replaceExistedModule replaceExistedModuleTest:(BOOL)replaceExistedModuleTests {
    
    // Generate Class
    self.moduleGenerator = [[ModuleGenerator alloc] init];
    
    [self.moduleGenerator generateViperModuleWithName:[self generateModuleName]
                                          projectName:[self generateProductName]
                                               author:[self generateUserName]
                                              company:[self generateCompanyName]
                                                 path:self.modulePathTexField.stringValue
                                             language:[self generateLanguage]
                                        viperTemplate:[self generateTemplateName]
                                     includeUnitTests:self.includeTestsCheckBoxButton.state
                                        unitTestsPath:self.testsPathTextField.stringValue
                                 replaceExistedModule:replaceExistedModule
                            replaceExistedModuleTests:replaceExistedModuleTests
                                             callback:^(BOOL success, NSError *error) {
                                                 
                                                 if (error) {
                                                     if (error.code == 516) {
                                                         // Handle Copying Error: because an item with the same name already exists.
                                                         NSArray *arr = @[@"Replace", @"Stop"];
                                                         [self displayPopupAlert:@"Module could not be created because it already exists. Do you want to replace it with a new one?" withButtons:arr alertTag:kCOPYALERT];
                                                     }
                                                     else if (error.code == 4) {
                                                         // Handle Copying Error: because an item with the same name already exists.
                                                         [self displayPopupAlert:@"Module could not be replaced becasue some files could not be removed." withButtons:nil alertTag:kREMOVEALERT];
                                                     }
                                                 }
                                                 else {
                                                     // Module generated successfully
                                                     [self displayPopupAlert:@"Module successfully generated. Please check your project directory." withButtons:nil alertTag:kMODULESUCCESSALERT];
                                                 }
                                             }];
    
}

- (IBAction)createModule:(id)sender {
    // Check if user selected Include unite tests option and did not enered test file path.
    if (self.includeTestsCheckBoxButton.state == 1 && [self.testsPathTextField.stringValue isEqual: @""]) {
        NSArray *arr = @[@"Ok"];
        [self displayPopupAlert:@"Test File Path cannot be empty. Please select Tests File Path." withButtons:arr alertTag:kTESTSALERT];
    }
    else {
        [self fireGenerateAction:NO replaceExistedModuleTest:NO];
    }
}

#pragma mark - Module Generation Helper methods
/*!
 @brief Access address book and retreive user name as first and last name.
 @return NSString user name.
 */
- (NSString *)fetchUserNameFromAddressBook {
    ABAddressBook *addressBook = [ABAddressBook sharedAddressBook];
    ABPerson* currentLoggedInUser = addressBook.me;
    NSString *firstName = [currentLoggedInUser valueForKey:kABFirstNameProperty];
    NSString *capitalizedFirstName = [firstName capitalizeFirstCharacterInString:firstName];
    NSString *lastName = [currentLoggedInUser valueForKey:kABLastNameProperty];
    NSString *capitalizedLastName = [firstName capitalizeFirstCharacterInString:lastName];
    return [[capitalizedFirstName stringByAppendingString:@" "] stringByAppendingString:capitalizedLastName];
}

- (NSString *)generateUserName {
    if (self.userNameTextField.stringValue.length > 0) {
        return self.userNameTextField.stringValue;
    }
    else {
        return [self fetchUserNameFromAddressBook];
    }
}

- (NSString *)generateModuleName {
    // Prevents spaces in the Module Name (filename)
    return [self.moduleNameTextField.stringValue stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)generateProductName {
    return self.ProjectNameTextField.stringValue;
}

- (NSString *)generateTemplateName {
    return [self.templatePopUpButton titleOfSelectedItem];
}

- (NSString *)generateLanguage {
    return self.languagesPopUpButton.titleOfSelectedItem;
}
                       
- (NSString *)generateCompanyName {
    return self.companyTextField.stringValue;
}

- (NSString *)generateCurrentDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    return [dateFormatter stringFromDate:[NSDate new]];
}

- (NSString *)generateCurrentYear {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    return [formatter stringFromDate:[NSDate new]];
}

#pragma mark - NSControlSubclassNotifications
- (void)controlTextDidChange:(NSNotification *)notification {
    [self updatePreviewHeaderCode];
    
    NSTextField *textField = [notification object];
    if ([textField doubleValue] < 0 | [textField doubleValue] > 255) {
        textField.textColor = [NSColor redColor];
    }
}

- (void)controlTextDidEndEditing:(NSNotification *)notification {
    NSTextField *textField = [notification object];
    if ([textField resignFirstResponder]) {
        textField.textColor = [NSColor blackColor];
    }
}

#pragma mark - VPTextFieldDelegate methods
- (void)didBecomeFirstResponder:(NSTextField *)textField {
    
    // Check if TextField is of kind to chose path
    if (textField == self.modulePathTexField || textField == self.testsPathTextField) {
        
        NSOpenPanel* openDlg = [NSOpenPanel openPanel];
        
        // Enable the selection of files in the dialog.
        [openDlg setCanChooseFiles:YES];
        
        // Enable the selection of directories in the dialog.
        [openDlg setCanChooseDirectories:YES];
        
        // Change "Open" dialog button to "Select"
        [openDlg setPrompt:@"Select"];
        
        // Display the dialog. If the OK button was pressed process the files
        if ([openDlg runModal] == NSModalResponseOK ) {
            NSURL *result = openDlg.URL;
            if (result != nil) {
                NSString *path = result.path;
                textField.stringValue = path;
                
                // Check if all textfields contain stringValue or not to enable Generate button.
                [self.generatedModuleButton setEnabled:YES];
            }
            else {
                // User clicked on cancel
                return;
            }
            
        }
    }
}


#pragma mark - NSMenuDelegate methods
- (void)menuDidClose:(NSMenu *)menu {
    [self updatePreviewHeaderCode];
}

@end
