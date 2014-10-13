//
//  NSString+HYPFormula.m
//  HYPFormula
//
//  Created by Christoffer Winterkvist on 13/10/14.
//
//

#import "NSString+HYPFormula.h"

@implementation NSString (HYPFormula)

- (NSString *)processValues:(NSDictionary *)values
{
    __block NSMutableString *mutableString = [self mutableCopy];

    [values enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        [mutableString replaceOccurrencesOfString:key withString:value options:NSLiteralSearch range:NSMakeRange(0,mutableString.length)];
    }];

    return [mutableString copy];
}

@end
