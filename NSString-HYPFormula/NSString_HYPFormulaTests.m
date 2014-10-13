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
    NSDictionary *values = @{
        @"first_name" : @"John",
        @"last_name"  : @"Hyperseed"
    };

    NSString *formula = [@"first_name last_name" processValues:values];
    NSString *expectedResult = [NSString stringWithFormat:@"%@ %@", values[@"first_name"], values[@"last_name"]];

    XCTAssert([formula isEqualToString:expectedResult], @"String formula was successfully generated.");
}

- (void)testMathFormula
{
    NSDictionary *values = @{
           @"hourly_pay" : @120,
        @"work_per_week" : @37.5
    };

    NSString *formula = [@"hourly_pay * work_per_week" processValues:values];

    NSLog(@"formula: %@", formula);


}

@end
