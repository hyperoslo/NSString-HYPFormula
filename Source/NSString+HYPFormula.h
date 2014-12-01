//
//  NSString+HYPFormula.h
//  HYPFormula
//
//  Created by Christoffer Winterkvist on 13/10/14.
//
//

#import <Foundation/Foundation.h>

@interface NSString (HYPFormula)

- (NSString *)hyp_processValuesDictionary:(NSDictionary *)valuesDictionary;
- (id)hyp_runFormulaWithValuesDictionary:(NSDictionary *)valuesDictionary;

@end
