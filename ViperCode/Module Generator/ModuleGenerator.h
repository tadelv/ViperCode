//
//  ModuleGenerator.h
//  ViperCode
//
//  Created by Sameh Mabrouk on 2/1/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilesUtils.h"
#import "FileManager.h"
#import "TemplateManager.h"

//call back clock that will be called when generateViperModuleWith: method generating module.
typedef void(^callback_block)(BOOL success, NSError *error);

@interface ModuleGenerator : NSObject

@property(nonatomic, strong) FilesUtils* filesUtilObj;

@property(nonatomic, strong) FileManager* fileManager;

/*!
 @brief It generate Viper Module file structure.
 @discussion generateViperModuleWith: Generate Viper Module file structure based on passed Viper module name, author name, company, language Swift/Objective C, path to save module and Viper template
 @param  name The Viper module name.
 @param  projectName The project name.
 @param  author The class author name.
 @param  company The App company name.
 @param  path The path to save the generated module.
 @param  language The App language to generate the Viper module based on it.
 @param  viperTemplate The Viper module template.
 @param  includeUnitTests Bool variable to check if to generated unit tests or not.
 @param  unitTestsPath The path to save the generated module unit tests.
 @param  replaceExistedModule Bool to indicate if user want to replace existed module or not.
 @param  replaceExistedModuleTests Bool to indicate if user want to replace existed module's test or not.
 @param  callback The completion handler that gets called when generating module finishs.
 @return void
 */
- (void)generateViperModuleWithName:(NSString*)viperModuleName projectName:(NSString*)projectName author:(NSString*)author company:(NSString*)company path:(NSString*)path language:(NSString*)language viperTemplate:(NSString *)templateName includeUnitTests:(BOOL)includeUnitTests unitTestsPath:(NSString*)unitTestsPath replaceExistedModule:(BOOL)replaceExistedModule replaceExistedModuleTests:(BOOL)replaceExistedModuleTests callback:(callback_block)callback;

@end
