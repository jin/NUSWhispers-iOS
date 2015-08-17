//
//  NSString+Typicons.h
//  NightScoutiOS
//
//  Created by Mike Cahill on 7/24/15.
//  Copyright (c) 2015 Mike Cahill. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kTypiconsFamilyName = @"typicons";


@interface NSString (Typicons)
/*
 @abstract Returns the typicon character associated to the typicon identifier.
 @discussion The list of identifiers can be found here: http://www.typicons.com/
 */
+ (NSString*)typiconStringForIconName:(NSString*)identifier;

@end
