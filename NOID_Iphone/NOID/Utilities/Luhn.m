//
//  Luhn.m
//  Luhn Algorithm (Mod 10)
//
//  Created by Max Kramer on 30/12/2012.
//  Copyright (c) 2012 Max Kramer. All rights reserved.
//

#import "Luhn.h"

@implementation NSString (Luhn)

- (BOOL) isValidCreditCardNumber {
    return [Luhn validateString:self];
}

- (OLCreditCardType) creditCardType {
    return [Luhn typeFromString:self];
}

@end

@interface NSString (Luhn_Private)

- (NSString *) formattedStringForProcessing;

@end

@implementation NSString (Luhn_Private)

- (NSString *) formattedStringForProcessing {
    NSCharacterSet *illegalCharacters = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray *components = [self componentsSeparatedByCharactersInSet:illegalCharacters];
    return [components componentsJoinedByString:@""];
}

@end

@implementation Luhn

+ (OLCreditCardType) typeFromString:(NSString *) string {
    BOOL valid = [string isValidCreditCardNumber];
    if (!valid) {
        return OLCreditCardTypeInvalid;
    }
    
    NSString *formattedString = [string formattedStringForProcessing];
    if (formattedString == nil || formattedString.length < 9) {
        return OLCreditCardTypeInvalid;
    }
    
    NSArray *enums = @[@(OLCreditCardTypeAmex), @(OLCreditCardTypeDinersClub), @(OLCreditCardTypeDiscover), @(OLCreditCardTypeJCB), @(OLCreditCardTypeMastercard), @(OLCreditCardTypeVisa)];
    
    __block OLCreditCardType type = OLCreditCardTypeInvalid;
    [enums enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        OLCreditCardType _type = [obj integerValue];
        NSPredicate *predicate = [Luhn predicateForType:_type];
        BOOL isCurrentType = [predicate evaluateWithObject:formattedString];
        if (isCurrentType) {
            type = _type;
            *stop = YES;
        }
    }];
    return type;
}
/*
 Visa: ^4[0-9]{12}(?:[0-9]{3})?$ All Visa card numbers start with a 4. New cards have 16 digits. Old cards have 13.
 MasterCard: ^5[1-5][0-9]{14}$ All MasterCard numbers start with the numbers 51 through 55. All have 16 digits.
 American Express: ^3[47][0-9]{13}$ American Express card numbers start with 34 or 37 and have 15 digits.
 Diners Club: ^3(?:0[0-5]|[68][0-9])[0-9]{11}$ Diners Club card numbers begin with 300 through 305, 36 or 38. All have 14 digits. There are Diners Club cards that begin with 5 and have 16 digits. These are a joint venture between Diners Club and MasterCard, and should be processed like a MasterCard.
 Discover: ^6(?:011|5[0-9]{2})[0-9]{12}$ Discover card numbers begin with 6011 or 65. All have 16 digits.
 JCB: ^(?:2131|1800|35\d{3})\d{11}$ JCB cards beginning with 2131 or 1800 have 15 digits. JCB cards beginning with 35 have 16 digits.
 */
+ (NSPredicate *) predicateForType:(OLCreditCardType) type {
    if (type == OLCreditCardTypeInvalid || type == OLCreditCardTypeUnsupported) {
        return nil;
    }
    NSLog(@"regularexpress mat");
    NSString *regex = nil;
    switch (type) {
        case OLCreditCardTypeAmex:
            regex = @"^3[47][0-9]{5,}$";
            break;
        case OLCreditCardTypeDinersClub:
            regex = @"^3(?:0[0-5]|[68][0-9])[0-9]{4,}$";
            break; 
        case OLCreditCardTypeDiscover:
            regex = @"^6(?:011|5[0-9]{2})[0-9]{3,}$";
            break;
        case OLCreditCardTypeJCB:
            regex = @"^(?:2131|1800|35[0-9]{3})[0-9]{3,}$";
            break;
        case OLCreditCardTypeMastercard:
            regex = @"^5[1-5][0-9]{5,}$";
            break;
        case OLCreditCardTypeVisa:
            regex = @"^4[0-9]{6,}$";
            break;
        default:
            break;
    }
    return [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
}

+ (BOOL) validateString:(NSString *)string forType:(OLCreditCardType)type {
    return [Luhn typeFromString:string] == type;
}

+ (BOOL)validateString:(NSString *)string {
    NSString *formattedString = [string formattedStringForProcessing];
    if (formattedString == nil || formattedString.length < 9) {
        return NO;
    }
    
    NSMutableString *reversedString = [NSMutableString stringWithCapacity:[formattedString length]];
    
    [formattedString enumerateSubstringsInRange:NSMakeRange(0, [formattedString length]) options:(NSStringEnumerationReverse |NSStringEnumerationByComposedCharacterSequences) usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [reversedString appendString:substring];
    }];
    
    NSUInteger oddSum = 0, evenSum = 0;
    
    for (NSUInteger i = 0; i < [reversedString length]; i++) {
        NSInteger digit = [[NSString stringWithFormat:@"%C", [reversedString characterAtIndex:i]] integerValue];
        
        if (i % 2 == 0) {
            evenSum += digit;
        }
        else {
            oddSum += digit / 5 + (2 * digit) % 10;
        }
    }
    return (oddSum + evenSum) % 10 == 0;
}

@end