//
//  NSString+HYPFormula.m
//  HYPFormula
//
//  Created by Christoffer Winterkvist on 13/10/14.
//
//

#import "NSString+HYPFormula.h"

@implementation NSString (HYPFormula)

- (NSString *)hyp_processValues:(NSDictionary *)values
{
    __block NSMutableString *mutableString = [self mutableCopy];

    [values enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {

        if (![value isKindOfClass:[NSString class]] && [value respondsToSelector:NSSelectorFromString(@"stringValue")]) {
            value = [value stringValue];
        }

        [mutableString replaceOccurrencesOfString:key withString:value options:NSLiteralSearch range:NSMakeRange(0,mutableString.length)];
    }];

    return [mutableString copy];
}

- (id)hyp_runFormula
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

- (id)hyp_runFormulaWithDictionary:(NSDictionary *)dictionary
{
    NSString *formula = [self hyp_processValues:dictionary];
    return [formula hyp_runFormula];
}

@end
