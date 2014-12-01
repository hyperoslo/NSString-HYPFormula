//
//  NSString_HYPFormula.m
//  NSString-HYPFormula
//
//  Created by Christoffer Winterkvist on 13/10/14.
//
//

@import Foundation;
@import XCTest;

#import "NSString+HYPFormula.h"

@interface NSString (HYPFormulaPrivate)

- (NSString *)sanitize;
- (BOOL)isStringFormulaWithValuesDictionary:(NSDictionary *)valuesDictionary;
- (BOOL)isValidExpression;

@end

@interface NSString_HYPFormula : XCTestCase

@end

@implementation NSString_HYPFormula

- (void)testProcessValuesOnStringFormula
{
    NSDictionary *values = @{
                             @"first_name" : @"John",
                             @"last_name" : @"Hyperseed"
                             };

    NSString *formula = [@"first_name last_name" hyp_processValuesDictionary:values];
    NSString *expectedResult = [NSString stringWithFormat:@"%@ %@", values[@"first_name"], values[@"last_name"]];

    XCTAssert([formula isEqualToString:expectedResult], @"String formula was successfully generated.");
}

- (void)testProcessValuesOnStringFormulaWithInvalidNumberOfValues
{
    NSDictionary *values = @{
                             @"first_name" : @"John"
                             };

    NSString *formula = [@"first_name last_name" hyp_processValuesDictionary:values];

    XCTAssertNil(formula, @"Result is nil because values are insufficient.");
}

- (void)testMathFormula
{
    NSDictionary *values = @{
                             @"hourly_pay" : @120,
                             @"work_per_week" : @37.5
                             };

    NSNumber *result = [@"hourly_pay * work_per_week" hyp_runFormulaWithValuesDictionary:values];
    NSNumber *expectedResult = @4500;

    XCTAssert([result isEqualToNumber:expectedResult], @"Result is 4500");
}

- (void)testMathFormulaWithInvalidNumberOfValues
{
    NSDictionary *values = @{
                             @"hourly_pay" : @120
                             };

    NSNumber *result = [@"hourly_pay * work_per_week" hyp_runFormulaWithValuesDictionary:values];

    XCTAssertNil(result, @"Result is nil because values are insufficient.");
}

- (void)testMathFormulaWithInvalidValues
{
    NSDictionary *values = @{
                             @"hourly_pay" : @120,
                             @"hodo" : @200
                             };

    NSNumber *result = [@"hourly_pay * work_per_week" hyp_runFormulaWithValuesDictionary:values];

    XCTAssertNil(result, @"Result is nil because values are insufficient.");
}

- (void)testShorthandMathFormula
{
    NSDictionary *values = @{
                             @"hourly_pay" : @150,
                             @"work_per_week" : @32.5
                             };
    NSNumber *expectedResult = @4875;
    NSNumber *result = [@"hourly_pay * work_per_week" hyp_runFormulaWithValuesDictionary:values];

    XCTAssert([result isEqualToNumber:expectedResult], @"Result is 4875");
}

- (void)testAdvancedFormula
{
    NSDictionary *values = @{
                             @"hourly_pay" : @160,
                             @"hourly_pay_premium_currency" : @"10",
                             @"hourly_pay_premium_percent"  : @"50",
                             @"work_per_week" : @37.5
                             };
    NSString *stringFormula = @"(hourly_pay * work_per_week/37.5) * (1 + (hourly_pay_premium_percent.0/100)) + hourly_pay_premium_currency";

    NSNumber *expectedResult = @250;
    NSNumber *result = [stringFormula hyp_runFormulaWithValuesDictionary:values];

    XCTAssert([result isEqualToNumber:expectedResult], @"Result is 250");
}

- (void)testFormulaWithStrayDots
{
    NSDictionary *values = @{
                             @"hourly_pay" : @160,
                             @"hourly_pay_premium_currency" : @"10",
                             @"hourly_pay_premium_percent"  : @"50",
                             @"work_per_week" : @37.5
                             };
    NSString *stringFormula = @"(hourly_pay * work_per_week/37.5) * (1 + (hourly_pay_premium_percent.0.0/100)) + hourly_pay_premium_currency";

    NSNumber *expectedResult = @250;
    NSNumber *result = [stringFormula hyp_runFormulaWithValuesDictionary:values];

    XCTAssertEqualObjects(result, expectedResult);
}

- (void)testStringFormula
{
    NSDictionary *values = @{
                             @"firstName" : @"John",
                             @"lastName"  : @"Hyperseed"
                             };

    NSString *displayNameFormula = @"firstName lastName";

    NSString *result = [displayNameFormula hyp_runFormulaWithValuesDictionary:values];

    XCTAssertEqualObjects(result, @"John Hyperseed");
}

- (void)testStringFormulaWithInvalidValue
{
    NSDictionary *values = @{
                             @"firstName" : @"John",
                             @"hodo": @"hodo"
                             };

    NSString *displayNameFormula = @"firstName lastName";

    NSString *result = [displayNameFormula hyp_runFormulaWithValuesDictionary:values];

    XCTAssertNil(result, @"Result is nil because values are insufficient.");
}

- (void)testStringFormulaWithOnlyOneValue
{
    NSDictionary *values = @{
                             @"firstName" : @"John",
                             @"lastName": @""
                             };

    NSString *displayNameFormula = @"firstName lastName";

    NSString *result = [displayNameFormula hyp_runFormulaWithValuesDictionary:values];

    XCTAssertEqualObjects(result, @"John ");
}

- (void)testValidationOnFaultyExpression
{
    NSString *expressionString = @"100 * (100.0/100) * 1 + (12.0) + ";

    XCTAssertFalse([expressionString isValidExpression]);
}

- (void)testValidationOnOtherEdgeCaseExpression
{
    NSString *expressionString = @"18387 * (employment_percent.0/100) * 1 + (1.0) + 1";

    XCTAssertFalse([expressionString isValidExpression]);
}

- (void)testNullValues
{
    NSDictionary *values = @{
                             @"salary" : @100,
                             @"bonus"  : [NSNull null],
                             @"taxes"  : @10
                             };
    NSNumber *expectedResult = @90;
    NSNumber *result = [@"salary + bonus - taxes" hyp_runFormulaWithValuesDictionary:values];

    XCTAssertEqualObjects(result, expectedResult);
}

- (void)testEmptyStringValues
{
    NSDictionary *values = @{
                             @"a" : @70,
                             @"b" : @"",
                             @"c" : @20
                             };
    NSNumber *expectedResult = @20;
    NSNumber *result = [@"(b / a) + c" hyp_runFormulaWithValuesDictionary:values];

    XCTAssertEqualObjects(result, expectedResult);
}

#pragma mark - Private methods

- (void)testIsStringFormulaWithDictionary
{
    XCTAssertTrue([@"first_name last_name" isStringFormulaWithValuesDictionary:(@{@"first_name" : @"John",
                                                                                  @"last_name" : @"Hyperseed"})]);

    XCTAssertTrue([@"first_name last_name" isStringFormulaWithValuesDictionary:(@{@"first_name" : @"",
                                                                                  @"last_name" : @"Hyperseed"})]);

    XCTAssertFalse([@"first_name + last_name" isStringFormulaWithValuesDictionary:(@{@"first_name" : @1,
                                                                                     @"last_name" : @2})]);
}

@end
