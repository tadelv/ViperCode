//
//  FilesUtils.h
//  ViperCode
//
//  Created by Sameh Mabrouk on 2/1/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilesUtils : NSObject

@property(nonatomic, retain)NSError *error;

/*!
 @brief Creates a directory at specified path.
 @param  path A path string identifying the directory to create. You may specify a full path or a path that is relative to the current working directory. This parameter must not be nil.
 @return YES if the directory was created, or NO if an error occurred.
 */
- (BOOL)mkdir:(NSString*)path;

/*!
 @brief It reads file content.
 @discussion Open file and read it. It Returns a string created by reading data from the file at a given path interpreted using a given encoding.
 @param  path A path to a file.
 @return YES if the file is written successfully, otherwise NO (if there was a problem writing to the file).
 */
- (NSString*)readFileContentAtPath:(NSString*)path;

/*!
 @brief It write contents to system's file.
 @discussion get all files and directories in a given path.
 @param  contents to be written to the file.
 @param  file path to file you want to write content to.
 @return NSArray contains items in a given path
 */
- (BOOL)writeContents:(NSString*)contents ToFileAtPath:(NSString*)path;

@end
