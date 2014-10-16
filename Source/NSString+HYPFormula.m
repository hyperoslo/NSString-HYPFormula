//
//  NSString+HYPFormula.m
//  HYPFormula
//
//  Created by Christoffer Winterkvist on 13/10/14.
//
//

#import "NSString+HYPFormula.h"

@implementation NSString (HYPFormula)

- (NSString *)processValues:(NSDictionary *)dictionary
{
    NSMutableString *mutableString = [self mutableCopy];
    NSArray *sortedKeysArray = [[dictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *a, NSString *b) {
        return a.length < b.length;
    }];

    for (NSString *key in sortedKeysArray) {
        id value = dictionary[key];

        if (![value isKindOfClass:[NSString class]] && [value respondsToSelector:NSSelectorFromString(@"stringValue")]) {
            value = [value stringValue];
        }

        [mutableString replaceOccurrencesOfString:key withString:value options:NSLiteralSearch range:NSMakeRange(0,mutableString.length)];
    }

    return [mutableString copy];
}

- (id)runFormula
{
    NSString *formula = self;
    formula = [self stringByReplacingOccurrencesOfString:@"," withString:@"."];

    if ([formula rangeOfString:@". "].location != NSNotFound) {
        return nil;
    }

    NSExpression *expression = [NSExpression expressionWithFormat:formula];
    id value = [expression expressionValueWithObject:nil context:nil];
    return value;
}

- (id)runFormulaWithDictionary:(NSDictionary *)dictionary
{
    NSString *formula = [self processValues:dictionary];
    return [formula runFormula];
}

@end
