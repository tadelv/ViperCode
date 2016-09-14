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

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.window.title = @"ViperCode";
    [self.generatedModuleButton setEnabled:NO];
    self.ProjectNameTextField.delegate = self;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

/*!
 @brief Access address book and retreive user name as first and last name.
 @return NSString user name.
 */
- (NSString*)fetchUserNameFromAddressBook {
    ABAddressBook *addressBook = [ABAddressBook sharedAddressBook];
    ABPerson* currentLoggedInUser = addressBook.me;
    NSString *firstName = [currentLoggedInUser valueForKey:kABFirstNameProperty];
    NSString *capitalizedFirstName = [firstName capitalizeFirstCharacterInString:firstName];
    NSString *lastName = [currentLoggedInUser valueForKey:kABLastNameProperty];
    NSString *capitalizedLastName = [firstName capitalizeFirstCharacterInString:lastName];
    return [[capitalizedFirstName stringByAppendingString:@" "] stringByAppendingString:capitalizedLastName];
}

- (void)fireGenerateAction:(BOOL)replaceExistedModule replaceExsitedModuleTest:(BOOL)replaceExsitedModuleTest {
    
    // Generate Class
    self.moduleGenerator = [[ModuleGenerator alloc] init];
    enum TemplateType template = KDefault;
    NSString *userName = [self fetchUserNameFromAddressBook]; //TODO: add field to username
    
    [self.moduleGenerator generateViperModuleWithName:self.moduleNameTextField.stringValue projectName:self.ProjectNameTextField.stringValue author:userName company:self.companyTextField.stringValue path:self.modulePathTexField.stringValue language:self.languagesPopUpButton.titleOfSelectedItem viperTemplate:template includeUnitTests:self.includeTestsCheckBoxButton.state unitTestsPath:self.testsPathTextField.stringValue replaceExistedModule:replaceExistedModule replaceExistedModuleTests:replaceExsitedModuleTest callback:^(BOOL success, NSError *error) {

        if (error) {
            if (error.code == 516) {
                // Handle Copying Error: because an item with the same name already exists.
                NSArray *arr = @[@"Replace", @"Stop"];
                [self displayPopupAlert:@"Module couldn't be created becasue it's already exists. Do you want to replace it with the new one?" withButtons:arr alertTag:kCOPYALERT];
            }
            else if (error.code == 4) {
                // Handle Copying Error: because an item with the same name already exists.
                [self displayPopupAlert:@"Module couldn't be replaced becasue some files couldn't be removed " withButtons:nil alertTag:kREMOVEALERT];
            }
        }
        else {
            // Module generated successfully
            [self displayPopupAlert:@"Module generated successfully. Please check your project directory" withButtons:nil alertTag:kMODULESUCCESSALERT];
        }
    }];

}

- (IBAction)createModule:(id)sender {
    // Check if user selected Include unite tests option and did not enered test file path.
    if (self.includeTestsCheckBoxButton.state == 1 && [self.testsPathTextField.stringValue  isEqual: @""]) {
        NSArray *arr = @[@"Ok"];
        [self displayPopupAlert:@"Test File Path couldn't be empty. Please select Tests File Path." withButtons:arr alertTag:kTESTSALERT];
    }
    else {
        [self fireGenerateAction:NO replaceExsitedModuleTest:NO];
    }
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
                [self fireGenerateAction:YES replaceExsitedModuleTest:YES];
            }
        }
        else if (returnCode == NSAlertSecondButtonReturn) {
            // Handling stop case
        }
    }];
}

#pragma mark - NSControlSubclassNotifications
- (void)controlTextDidChange:(NSNotification *)notification {
    
    NSTextField *textField = [notification object];
    if ([textField doubleValue] < 0 | [textField doubleValue] > 255) {
        textField.textColor = [NSColor redColor];
    }

    // Just show NSOpenPanel if editing Module File Path textfield
    if (textField.tag == 400 || textField.tag == 500) {
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

- (void)controlTextDidEndEditing:(NSNotification *)notification {
    NSTextField *textField = [notification object];
    if ([textField resignFirstResponder]) {
        textField.textColor = [NSColor blackColor];
    }
}

@end
