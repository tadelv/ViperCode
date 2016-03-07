//
//  NSString+Substring.h
//  ViperCode
//
//  Created by Sameh Mabrouk on 2/17/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Substring)

/*!
 @brief finds last occurrence of substring in a string of characters.
 @param  subString The string to search for. This value must not be nil.
 @return An NSRange structure giving the location and length in the receiver of the first occurrence of subString.
 */
-(NSRange)findLastOccurrenceOfSubString:(NSString*)subString;

/*!
 @brief replace a substring at certainn index in NSString
 @param  range structure giving the location and length of substring to search for.
 @param  stringContainingAChars The string with which to replace the characters in range.
 @return A new string in which the characters in range of the receiver are replaced by replacement.
 */
-(NSString *)replaceACharacterAtRange:(NSRange)range byCharacters:(NSString*)stringContainingAChars;

/*!
 @brief capitalize the first character in string.
 @param  stringContainingAChars The string with which to replace the characters in range.
 @return The capitalized string.
 */
-(NSString *)capitalizeFirstCharacterInString:(NSString *)stringContainingAChars;

@end
