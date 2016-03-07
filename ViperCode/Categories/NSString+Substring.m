//
//  NSString+Substring.m
//  ViperCode
//
//  Created by Sameh Mabrouk on 2/17/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import "NSString+Substring.h"

@implementation NSString (Substring)

-(NSRange)findLastOccurrenceOfSubString:(NSString*)subString
{
    return [self rangeOfString:subString options:NSBackwardsSearch];
}

-(NSString *)replaceACharacterAtRange:(NSRange)range byCharacters:(NSString*)stringContainingAChars
{
    return [self stringByReplacingCharactersInRange:range withString:stringContainingAChars];
}

-(NSString *)capitalizeFirstCharacterInString:(NSString *)stringContainingAChars
{
    NSString *firstCapChar = [[stringContainingAChars substringToIndex:1] capitalizedString];
    NSString *cappedString = [stringContainingAChars stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
    return cappedString;
}

@end
