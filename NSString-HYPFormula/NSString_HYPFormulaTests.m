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

    NSString *formula = [@"first_name last_name" hyp_processValues:values];
    NSString *expectedResult = [NSString stringWithFormat:@"%@ %@", values[@"first_name"], values[@"last_name"]];

    XCTAssert([formula isEqualToString:expectedResult], @"String formula was successfully generated.");
}

- (void)testMathFormula
{
    NSDictionary *values = @{
           @"hourly_pay" : @120,
        @"work_per_week" : @37.5
    };

    NSString *formula = [@"hourly_pay * work_per_week" hyp_processValues:values];
    NSNumber *result = [formula hyp_runFormula];
    NSNumber *expectedResult = @4500;

    XCTAssert([result isEqualTo:expectedResult], @"Result is 4500");
}

- (void)testShorthandMathFormula
{
    NSDictionary *values = @{
                             @"hourly_pay"    : @150,
                             @"work_per_week" : @32.5
                             };
    NSNumber *expectedResult = @4875;
    NSNumber *result = [@"hourly_pay * work_per_week" hyp_runFormulaWithDictionary:values];

    XCTAssert([result isEqualTo:expectedResult], @"Result is 4875");
}

@end
