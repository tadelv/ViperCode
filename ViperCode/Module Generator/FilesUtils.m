//
//  FilesUtils.m
//  ViperCode
//
//  Created by Sameh Mabrouk on 2/1/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import "FilesUtils.h"

@implementation FilesUtils

- (BOOL)mkdir:(NSString *)path {
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSError *error = nil;
    BOOL isDirectoryCreated;

    if(![fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
        if (error) {
            NSLog(@"Failed to create directory \"%@\". Error: %@", @"", error);
            isDirectoryCreated = NO;
        }
        else {
            isDirectoryCreated = YES;
        }
    }
    else {
        return isDirectoryCreated = YES;
    }
    
    return isDirectoryCreated;
}

- (NSString *) readFileContents {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"API_KEY" ofType:@""];

    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    return content;
}

- (void)writeToContentsFile:(NSString*)contents {
    NSString *cont = contents;
    [cont writeToFile:@"/Users/gbahig/Desktop/ViperGenerator/ViperGenerator/Modules/Interactor.h" atomically:false encoding:NSUTF8StringEncoding error:nil];
}

- (NSString*)readFileContentAtPath:(NSString*)path {
    NSError *error = nil;
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:&error];
    if (error) {
        NSLog(@"Failed to read file \"%@\". Error: %@", @"", error);
    }
    
    return content;
}

- (BOOL)writeContents:(NSString*)contents ToFileAtPath:(NSString*)path {
    NSError *error = nil;
    [contents writeToFile:path atomically:false encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"Failed to write to file \"%@\". Error: %@", @"", error);
        return NO;
    }
    else {
        return YES;
    }
}

@end
