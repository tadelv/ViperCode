//
//  ModuleGenerator.m
//  ViperCode
//
//  Created by Sameh Mabrouk on 2/1/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import "ModuleGenerator.h"
#import "Constants.h"
#import "NSString+Substring.h"

@implementation ModuleGenerator

- (id)init {
    self = [super init];
    
    if (self) {
        self.fileManager = [[FileManager alloc] init];
        self.filesUtilObj = [[FilesUtils alloc] init];
    }
    
    return self;
}

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
 @return void
 */
- (void)generateViperModuleWithName:(NSString *)viperModuleName projectName:(NSString *)projectName author:(NSString *)author company:(NSString *)company path:(NSString *)path language:(NSString *)language viperTemplate:(NSString *)templateName includeUnitTests:(BOOL)includeUnitTests unitTestsPath:(NSString *)unitTestsPath replaceExistedModule:(BOOL)replaceExistedModule replaceExistedModuleTests:(BOOL)replaceExistedModuleTests callback:(callback_block)callback {
    
    // 1: path_from get viper template path based on passed language and template name.
    NSString *sourcePath;
    NSString *destinationPath;

    sourcePath = [self.fileManager getSourcePath:templateName language:language includeUnitTest:NO];

    // 2: path_to get the destination path
    destinationPath = [self.fileManager getDestinationPath:path viperModuleName:viperModuleName];

    [self generateViperModuleWithName:viperModuleName sourcePath:sourcePath destinationPath:destinationPath projectName:projectName author:author company:company replaceExistedModule:replaceExistedModule callback:^(BOOL success, NSError *error) {
        callback(success, error);
    }];

    // 6: check if user checked include unit tests or not.
    if (includeUnitTests && unitTestsPath) {
        //generate VIPER module unit test.
        //path_from get viper template path based on passed language and template name.
        sourcePath = [self.fileManager getSourcePath:templateName language:language includeUnitTest:YES];

        //path_to get the destination path
        destinationPath = [self.fileManager getDestinationPath:unitTestsPath viperModuleName:viperModuleName];

        [self generateViperModuleWithName:viperModuleName sourcePath:sourcePath destinationPath:destinationPath projectName:projectName author:author company:company replaceExistedModule:replaceExistedModuleTests callback:^(BOOL success, NSError *error) {
            callback(success, error);
        }];
    }
    else {
        NSLog(@"user don't need unit tests");
    }

}

/*!
 @brief It generate Viper Module's code or unit tests file structure based on the passed path.
 @discussion generateViperModuleWith: Generate Viper Module file structure based on passed Viper module name, author name, company, language Swift/Objective C, path to save module and Viper template
 @param  viperModuleName The Viper module name.
 @param  projectName The project name.
 @param  author The class author name.
 @param  company The App company name.
 @param  path The path to save the generated module.
 @param  language The App language to generate the Viper module based on it.
 @param  viperTemplate The Viper module template.
 @return void
 */
- (void)generateViperModuleWithName:(NSString *)viperModuleName sourcePath:(NSString *)sourcePath destinationPath:(NSString *)destinationPath projectName:(NSString *)projectName author:(NSString *)author company:(NSString *)company replaceExistedModule:(BOOL)replaceExistedModule callback:(callback_block)callback {

    if (sourcePath && destinationPath) {

        // If user want to replace current generated module with new generated one.
        if (replaceExistedModule) {
            // 3: remove viper files from destination directory
            [self.fileManager removeEntryAtPath:destinationPath callback:^(BOOL success, NSError *error) {

                if (success) {
                    // 4: copy viper files from source to destination
                    [self.fileManager copyEntryFrom:sourcePath pathTo:destinationPath callback:^(BOOL success, NSError *error) {

                        if (success) {
                            // 5: get files from destination directory
                            NSArray *files = [self.fileManager deepSeachFilesAtPath:destinationPath];

                            // 6: rename content of all files like name, author, company and class name.
                            [self renameFiles:files name:viperModuleName projectName:projectName author:author company:company];
                        }

                        callback(success, error);
                        NSLog(@"Copy Error %@", error);
                    }];
                }

                callback(success, error);
                NSLog(@"Remove Error %@", error);
            }];
        }
        else {
            // Directory is empty no replacement happens at the moment.
            // 3: copy viper files from source to destination
            [self.fileManager copyEntryFrom:sourcePath pathTo:destinationPath callback:^(BOOL success, NSError *error) {

                if (success) {
                    // 4: get files from destination directory
                    NSArray *files = [self.fileManager deepSeachFilesAtPath:destinationPath];

                    // 5: rename content of all files like name, author, company and class name.
                    [self renameFiles:files name:viperModuleName projectName:projectName author:author company:company];
                }

                callback(success, error);
                NSLog(@"Copy Error %@", error);
            }];
        }
    }
}

/*!
 @brief It generate Viper Module's unit tests file structure.
 @discussion generateViperModuleWith: Generate Viper Module file structure based on passed Viper module name, author name, company, language Swift/Objective C, path to save module and Viper template
 @param  viperModuleName The Viper module name.
 @param  projectName The project name.
 @param  author The class author name.
 @param  company The App company name.
 @param  path The path to save the generated module.
 @param  language The App language to generate the Viper module based on it.
 @param  viperTemplate The Viper module template.
 @return void
 */
- (void)generateViperModuleUnitTestsWithName:(NSString *)viperModuleName projectName:(NSString *)projectName author:(NSString *)author company:(NSString *)company unitTestsPath:(NSString*)unitTestsPath language:(NSString *)language viperTemplate:(NSString *)templateName replaceExistedModuleTests:(BOOL)replaceExistedModuleTests callback:(callback_block)callback {

    // 1: path_from get viper template path based on passed language and template name.

    NSString *sourcePath = [self.fileManager getSourcePath:templateName language:language includeUnitTest:YES];

    // 2: path_to get the destination path
    NSString *destinationPath = [self.fileManager getDestinationPath:unitTestsPath viperModuleName:viperModuleName];

    // 3: copy viper files from source to destination
    [self.fileManager copyEntryFrom:sourcePath pathTo:destinationPath callback:^(BOOL success, NSError *error) {

        if (success) {
            // 4: get files from destination directory
            NSArray *files = [self.fileManager deepSeachFilesAtPath:destinationPath];

            // 5: rename content of all files like name, author, company and class name.
            [self renameFiles:files name:viperModuleName projectName:projectName author:author company:company];
        }

        callback(success, error);
        NSLog(@"copy Error %@", error);
    }];
}

/*!
 @brief Renames all files in the passed files array.
 @param  files files array to be renamed.
 @param  name The Viper module name.
 @param  projectName The name of the project entered by the end user.
 @param  author The class author name.
 @param  company The App company name.
 */
-( void)renameFiles:(NSArray*)files name:(NSString*)name projectName:(NSString *)projectName author:(NSString*)author company:(NSString*)company {
    // Call rename file for each file in files array.
    for (NSString *file in files) {
        [self renameFile:file name:name projectName:projectName author:author company:company];
    }

}

/*!
 @brief Renames a given file name and the content of the file.
 @param  fileName The file name to be renamed.
 @param  name The Viper module name.
 @param  author The class author name.
 @param  company The App company name.
 */
- (void)renameFile:(NSString*)filePath name:(NSString*)name projectName:(NSString *)projectName author:(NSString*)author company:(NSString*)company {
    NSRange range = [filePath findLastOccurrenceOfSubString:kVIPERMODULENAMETOBEREPLACED];
    NSString *newPath= [filePath replaceACharacterAtRange:range byCharacters:name];

    // Call move file from FileManager to rename a given file.
    [self.fileManager moveFileAtPath:filePath toPath:newPath];

    // Call rename file content to rename content of given file.
    [self renameFileContent:newPath name:name projectName:projectName author:author company:company];
}

/*!
 @brief Renames a file content.
 @param  fileName The file name to be renamed.
 @param  name The Viper module name.
 @param  author The class author name.
 @param  company The App company name.
 */
- (void)renameFileContent:(NSString*)filePath name:(NSString*)name projectName:(NSString *)projectName author:(NSString*)author company:(NSString*)company {
    // Read file content.
    NSString *fileContent = [self.filesUtilObj readFileContentAtPath:filePath];

    // Rename header code comment file names
    NSString *revisedName = [self generateFileNameForCodeHeaderWithName:name andFilePath:filePath];
    
    // Replace content.
    fileContent = [fileContent stringByReplacingOccurrencesOfString:kFILENAME withString:revisedName];
    fileContent = [fileContent stringByReplacingOccurrencesOfString:kPROJECTNAME withString:projectName];
    fileContent = [fileContent stringByReplacingOccurrencesOfString:KFULLUSERNAME withString:author];
    fileContent = [fileContent stringByReplacingOccurrencesOfString:KDATE withString:[self currentDate:[NSDate date]]];
    fileContent = [fileContent stringByReplacingOccurrencesOfString:kYEAR withString:[self currentYear:[NSDate date]]];
    fileContent = [fileContent stringByReplacingOccurrencesOfString:kORGANIZATION withString:company];
    fileContent = [fileContent stringByReplacingOccurrencesOfString:kVIPERMODULENAMETOBEREPLACED withString:name];

    // Save content with replaced string.
    [self.filesUtilObj writeContents:fileContent ToFileAtPath:filePath];
}

/*!
 @brief Renames the filename in the header code comments.
 @param name The Product Name
 @param filePath The path to template file
 @return NSString The correct filename
 */
- (NSString *)generateFileNameForCodeHeaderWithName:(NSString *)name andFilePath:(NSString *)filePath {
    NSArray *slashes = [filePath componentsSeparatedByString:@"/"];
    NSString *fileName = [[[slashes objectAtIndex:slashes.count-1] componentsSeparatedByString:@"."] objectAtIndex:0];
    fileName = [fileName stringByReplacingOccurrencesOfString:kMODULENAME withString:name];
    
    return fileName;
}

/*!
 @brief Simple function that convert current NSDate to NSString.
 @param  date Current Date.
 @return NSString Current date as string.
 */
- (NSString*)currentDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    return [dateFormatter stringFromDate:date];
}

/*!
 @brief Simple function that get current year as string from current date.
 @param  date Current Date.
 @return NSString Current year as string.
 */
- (NSString*)currentYear:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    return [formatter stringFromDate:date];
}

@end
