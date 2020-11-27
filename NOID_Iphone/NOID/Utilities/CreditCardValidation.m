//
//  CreditCardValidation.m
//  Sugartin.info
//  Created by Sugartin.info on 08/06/12.
//
#define kMagicSubtractionNumber 48 // The ASCII value of 0

#import "CreditCardValidation.h"
@implementation CreditCardValidation


-(BOOL)validateCard:(NSString *)cardNumber
{
	
	int Luhn = 0;

		// I'm running through my string backwards
	for (int i=0;i<[cardNumber length];i++)
        {
            NSUInteger count = [cardNumber length]-1; // Prevents Bounds Error and makes characterAtIndex easier to read
			int doubled = [[NSNumber numberWithUnsignedChar:[cardNumber characterAtIndex:count-i]] intValue] - kMagicSubtractionNumber;
            if (i % 2)
            {doubled = doubled*2;}
            
			NSString *double_digit = [NSString stringWithFormat:@"%d",doubled];

            if ([[NSString stringWithFormat:@"%d",doubled] length] > 1)
			{   Luhn = Luhn + [[NSNumber numberWithUnsignedChar:[double_digit characterAtIndex:0]] intValue]-kMagicSubtractionNumber;
                Luhn = Luhn + [[NSNumber numberWithUnsignedChar:[double_digit characterAtIndex:1]] intValue]-kMagicSubtractionNumber;}
            else
			{Luhn = Luhn + doubled;}
        }
       
	if (Luhn%10 == 0) // If Luhn/10's Remainder is Equal to Zero, the number is valid
            return true;
    else
		return false;
        
}


@end
