//
//  InAppManager.h
//  slotmachine
//
//  Created by Tao Yang on 12-2-7.
//  
//

#import <StoreKit/StoreKit.h>
#import <UIKit/UIKit.h>

typedef enum
{
    eInAppNone,
    eInAppFirst,
    eInAppSecond
    
}InAppMode;



@protocol InAppManagerDelegate <NSObject>

@required
- (void)inAppManagerProductsFetched:(NSMutableArray*)priceDatas;
- (void)inAppManagerProductsFetchFailed:(NSInteger)errorCode;
- (void)inAppManagerTransactionFailed:(NSInteger)errorCode;
- (void)inAppManagerTransactionSucceeded:(NSDictionary*)transaction;
@end

@interface InAppManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
@private
    SKProductsRequest* _productsRequest;
    id<InAppManagerDelegate> _delegate;
    InAppMode _eMode;
    NSString *_orderID;
}

+ (InAppManager*)sharedInstance;

-(void)setDelegate:(id<InAppManagerDelegate>)delegate inAppMode:(InAppMode)mode orderID:(NSString *const)order;


- (void)loadStore;
- (BOOL)canMakePurchases;
- (void)purchaseProUpgrade;
- (NSString *)encode:(const uint8_t *)input length:(NSInteger)length;

@end



