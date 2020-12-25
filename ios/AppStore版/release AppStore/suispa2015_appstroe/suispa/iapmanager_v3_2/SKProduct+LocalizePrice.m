//
//  SKProduct+LocalizePrice.m
//  slotmachine
//
//  Created by Tao Yang on 12-2-7.
// 
//

#import "SKProduct+LocalizePrice.h"

@implementation SKProduct (LocalizedPrice)

- (NSString *)localizedPrice
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:self.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:self.price];
   // [numberFormatter release];
    return formattedString;
}

@end
