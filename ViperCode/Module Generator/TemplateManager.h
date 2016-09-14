//
//  TemplateManager.h
//  ViperCode
//
//  Created by Sameh Mabrouk on 2/13/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileManager.h"

@interface TemplateManager : NSObject

/*!
 @brief Returns template directory
 @return NSString the template directory name.
 */
- (NSString*)getTemplateDirectory;

/*!
 @brief Returns all available templates names.
 @return NSArray array that contain all available templates names.
 */
- (NSArray*)getTemplates;

/*!
 @brief Returns all available templates names.
 @return NSArray array that contain all available templates names.
 */
- (NSString *)defaultTemplate;

@end
