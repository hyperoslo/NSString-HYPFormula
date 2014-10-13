//
//  NSString_HYPFormula.m
//  NSString-HYPFormula
//
//  Created by Christoffer Winterkvist on 13/10/14.
//
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "NSString+HYPFormula.h"

@interface NSString_HYPFormula : XCTestCase

@end

@implementation NSString_HYPFormula

- (void)testFormulaString
{
    NSDictionary *dictionary = @{
        @"first_name" : @"John",
        @"last_name"  : @"Hyperseed"
    };

    NSString *formula = @"first_name last_name";

    NSLog(@"formula: %@", [formula processValues:dictionary]);
}

@end
