//
//  TemplateManager.m
//  ViperCode
//
//  Created by Sameh Mabrouk on 2/13/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import "TemplateManager.h"

@implementation TemplateManager

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

-(NSString*)getTemplateDirectory
{
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    return [bundlePath stringByAppendingString:@"/Contents/Resources/Templates/"];
}

-(NSArray *)getTemplates
{
    FileManager *fileManager = [[FileManager alloc] init];
    NSString *templateDir = [self getTemplateDirectory];
    return [fileManager filesAtPath:templateDir];
}

@end