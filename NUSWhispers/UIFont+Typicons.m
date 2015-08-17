//
//  UIFont+Typicons.m
//  NightScoutiOS
//
//  Created by Mike Cahill on 7/24/15.
//  Copyright (c) 2015 Mike Cahill. All rights reserved.
//

#import "UIFont+Typicons.h"
#import "NSString+Typicons.h"

@implementation UIFont (Typicons)

#pragma mark - Public API
+ (UIFont*)typiconFontOfSize:(CGFloat)size {
  return [UIFont fontWithName:kTypiconsFamilyName size:size];
}
@end
