//
//  SKProduct+LocalizePrice.h
//  slotmachine
//
//  Created by Tao Yang on 12-2-7.
//
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface SKProduct (LocalizedPrice)

@property (nonatomic, readonly) NSString *localizedPrice;

@end
