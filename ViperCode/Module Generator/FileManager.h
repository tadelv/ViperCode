//
//  FileManager.h
//  ViperCode
//
//  Created by Sameh Mabrouk on 2/10/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TemplateManager.h"
#import "FilesUtils.h"

@class TemplateManager;

//call back clock that will be called when coyEntryFrom: method finishs copying files.
typedef void(^callback_block)(BOOL success, NSError *error);

@interface FileManager : NSObject

/*! Shared instance of NSFileManager. */
@property(nonatomic, strong)NSFileManager *manager;

/*! TemplateManager instance */
@property(nonatomic, strong)TemplateManager *templateManager;

/*! FilesUtils instance */
@property(nonatomic, strong)FilesUtils *filesUtilObj;

/*!
 @brief Creates a directory at the specified path.
 @discussion YES if the directory was created, or NO if an error occurred.
 @param  path A path string identifying the directory to create. You may specify a full path or a path that is relative to the current working directory. This parameter must not be nil.
 @return YES if the directory was created, YES if createIntermediates is set and the directory already exists), or NO if an error occurred.
 */
- (BOOL)mkdir:(NSString*)path;

/*!
 @brief It copies a system item to another place.
 @discussion Copies the item at the specified path to a new location.
 @param  pathFrom The path to the file or directory you want to copy. This parameter must not be nil.
 @param  pathTo The path at which to place the copy of srcPath. This path must include the name of the file or directory in its new location. This parameter must not be nil.
  @param  callback The completion handler that gets called when copying file finishs.
 */
- (void)copyEntryFrom:(NSString*)pathFrom pathTo:(NSString*)pathTo callback:(callback_block)callback;

/*!
 @brief It moves a system item to another place (aka Renaming a file).
 @discussion move the item at the source path to a destination path.
 @param  srcPath The path to the file or directory you want to move. This parameter must not be nil.
 @param  destPath The path at which to place the copy of srcPath. This parameter must not be nil.
 @return YES if the item was copied successfully or the file manager’s delegate aborted the operation deliberately.
 */
- (BOOL)moveFileAtPath:(NSString*)srcPath toPath:(NSString*)destPath;

/*!
 @brief Removes the file or directory at the specified path.
 @discussion Removes the file or directory at the specified path.
 @param  path A path string indicating the file or directory to remove. If the path specifies a directory, the contents of that directory are recursively removed. You may specify nil for this parameter.
 @param  callback The completion handler that gets called when removing files finishs.
 */
- (void)removeEntryAtPath:(NSString*)path callback:(callback_block)callback;

/*!
 @brief It return files in a given path(shallow search).
 @discussion get all files and directories in a given path using shallow search.
 @param  path A path to a files.
 @return NSArray contains items in a given path
 */
- (NSArray*)filesAtPath:(NSString*)path;

/*!
 @brief It return files in a given path(Deep search).
 @discussion get all files and directories in a given path using deep search.
 @param  path A path to a files.
 @return NSArray contains items in a given path
 */
- (NSArray*)deepSeachFilesAtPath:(NSString*)path;

/*!
 @brief get the source path of template code or test.
 @discussion get source path of template using template dirc, template name,language and Code directory.
 @param  templateName the name of template to generate Viper skeleton based on.
 @param  language the language of to generate Viper skeleton based on.
 @param  includeUnitTest Bool to decide either to return code template or test template.
 @return NSString source path of template.
 */
- (NSString*)getSourcePath:(NSString*)templateName language:(NSString*)language includeUnitTest:(BOOL)includeUnitTest;

/*!
 @brief get the destination Viper path.
 @discussion get the destination Viper path by appending viperModuleName to path.
 @param  path the path selected by the end user.
 @param  viperModuleName Module name entered by the end user.
 @return NSString complete destination path.
 */
- (NSString*)getDestinationPath:(NSString*)path viperModuleName:(NSString*)viperModuleName;

@end
