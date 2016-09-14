//
//  FileManager.m
//  ViperCode
//
//  Created by Sameh Mabrouk on 2/10/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import "FileManager.h"
#import "Constants.h"

@implementation FileManager

- (id)init {
    self = [super init];
    
    if (self) {
        self.manager = [NSFileManager defaultManager];
        self.templateManager = [[TemplateManager alloc] init];
        self.filesUtilObj = [[FilesUtils alloc] init];
    }
    
    return self;
}


- (BOOL)mkdir:(NSString*)path {
    NSError *error = nil;
    if(![self.manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
        NSLog(@"Failed to create directory \"%@\". Error: %@", @"", error);
        return NO;
    }
    return YES;
}

- (void)copyEntryFrom:(NSString*)pathFrom pathTo:(NSString*)pathTo callback:(callback_block)callback {
    /*
     if ( [[NSFileManager defaultManager] isReadableFileAtPath:fromPath] )
     [[NSFileManager defaultManager] copyItemAtURL:[NSURL URLWithString:fromPath] toURL:[NSURL URLWithString:toPath] error:nil];
     */
    NSError *error  = nil;
    BOOL success = NO;

    NSArray *files = [self.manager contentsOfDirectoryAtPath:pathFrom error:nil];
    for (NSString *file in files) {
        NSString *fileFrom = [pathFrom stringByAppendingPathComponent:file];
        NSString *fileTo = [pathTo stringByAppendingPathComponent:file];
        [self.manager copyItemAtPath:fileFrom toPath:fileTo error:&error];
        if (error) {
            NSLog(@"Failed to copy item \"%@\". Error: %@", @"", error);

            success = NO;
            //just break the loop because there is an item that cannot be copied.
            break;
        }
        else {
            success = YES;
        }


    }

    callback(success, error);
}

- (BOOL)moveFileAtPath:(NSString *)srcPath toPath:(NSString *)destPath {
    NSError *error = nil;
    if (![self.manager moveItemAtPath:srcPath toPath:destPath error:&error]) {
        NSLog(@"Failed to move file \"%@\". Error: %@", @"", error);
        return NO;
    }
    else {
        return YES;
    }
}

-(void)removeEntryAtPath:(NSString*)path callback:(callback_block)callback {
    NSError *error  = nil;
    BOOL success = NO;

    NSArray *files = [self.manager contentsOfDirectoryAtPath:path error:nil];
    for (NSString *file in files) {
        NSString *filePathTobeRemoved = [path stringByAppendingPathComponent:file];
        [self.manager removeItemAtPath:filePathTobeRemoved error:&error];
        if (error) {
            NSLog(@"Failed to remove item \"%@\". Error: %@", @"", error);
            success = NO;
            //just break the loop because there is an item that cannot be removed.
            break;
        }
        else {
            success = YES;
        }
    }
    callback(success, error);
}

- (NSArray *)filesAtPath:(NSString *)path {
    NSError *error = nil;
    return [self.manager contentsOfDirectoryAtPath:path error:&error];
}

- (NSArray *)deepSeachFilesAtPath:(NSString *)path {
    NSMutableArray *filesPaths = [[NSMutableArray alloc] init];

    NSString* encodedURL = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURL *directoryURL = [NSURL URLWithString:encodedURL]; // URL pointing to the directory you want to browse.

    NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];

    NSDirectoryEnumerator *enumerator = [self.manager
                                         enumeratorAtURL:directoryURL
                                         includingPropertiesForKeys:keys
                                         options:0
                                         errorHandler:^(NSURL *url, NSError *error) {
                                             return YES;
                                         }];

    for (NSURL *url in enumerator) {
        NSError *error;
        NSNumber *isDirectory = nil;
        if (! [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error]) {
            // Handle error
            NSLog(@"IsDirectory \"%@\". Error: %@", @"", error);
        }
        else if (! [isDirectory boolValue]) {
            // No error and it is not a directory. Do something with the file.
            [filesPaths addObject:url.path];
        }
    }
    return filesPaths;
}

/*!
 @brief check if template is valid.
 @param  template template to be checked if valid or not.
 @return YES if the template is valid, otherwise NO.
 */
- (BOOL)isTemplateValid:(NSString*)template {
    return [[self.templateManager getTemplates] containsObject:template];
}

/*!
 @brief check if language is valid.
 @param  language language to be checked if valid or not.
 @return YES if the language is valid, otherwise NO.
 */
- (BOOL)isLanguageValid:(NSString*)language {
    return [kLANGUAGES containsObject:language];
}

- (NSString*)getSourcePath:(NSString*)templateName language:(NSString*)language includeUnitTest:(BOOL)includeUnitTest {
    if (![self isTemplateValid:templateName] || ![self isLanguageValid:language]) {
        return nil;
    }
    
    if (includeUnitTest) {
        return [[self.templateManager getTemplateDirectory] stringByAppendingString:[[[templateName stringByAppendingString:@"/"] stringByAppendingString:language] stringByAppendingString:@"/Tests"]];
    }
    else {
        return [[self.templateManager getTemplateDirectory] stringByAppendingString:[[[templateName stringByAppendingString:@"/"] stringByAppendingString:language] stringByAppendingString:@"/Code"]];
    }
}

- (NSString *)getDestinationPath:(NSString *)path viperModuleName:(NSString *)viperModuleName {
    NSString *newDirPath = [path copy];
    newDirPath = [newDirPath stringByAppendingString:[@"/" stringByAppendingString:viperModuleName]];
    
    // Create the module directory.
    if ([self.filesUtilObj mkdir:newDirPath]) {
        // Return current created module directory.
        return newDirPath;
    }
    else {
        return nil;
    }

}

@end
