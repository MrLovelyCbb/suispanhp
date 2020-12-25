//
//  InAppManager.m
//  slotmachine
//
//  Created by Tao Yang on 12-2-7.
// 
//  edit by zzg on 2013-06-10 将收据发送后台服务器验证后再发货

#import "InAppManager.h"
#import "suispa-swift.h"

//版本号
NSString *const gVer                                       = @"1.0";
//游戏包名
NSString *const gName                                       = @"com.szzp.suispa";
//需要控制台提供Id
NSString *const kInAppProUpgradeEightyeigthProductId              = @"com.szzp.suispa.88rmb";
NSString *const kInAppProUpgradeHundredSixtyEightProductId        = @"com.szzp.suispa.1rmb168";

@implementation InAppManager

+ (InAppManager*)sharedInstance
{
    NSLog(@"in sharedInstance");
    static InAppManager* pInAppManager = nil;
    if (pInAppManager == nil)
    {
        pInAppManager = [[InAppManager alloc] init];
    }
    return pInAppManager;
}

-(void)setDelegate:(id<InAppManagerDelegate>)delegate inAppMode:(InAppMode)mode orderID:(NSString *const)order
{
    NSLog(@"in setDelegate\n");
    _delegate = delegate;
    _eMode = mode;
    _orderID = order;
}

- (NSString *const)getCurProductId
{
    NSLog(@"in getCurProductID _eMode=%u\n",_eMode);
    if (_eMode == eInAppFirst)
    {
        return kInAppProUpgradeEightyeigthProductId;
    }else {
        return kInAppProUpgradeHundredSixtyEightProductId;
    }
}

- (NSInteger)getPriceIndexWithProductId:(NSString*)productId
{
    NSLog(@"in getPriceIndexWithProductId- productId=%@\n",productId);
    if ([productId isEqualToString:kInAppProUpgradeEightyeigthProductId])
    {
        return 0;
    }
    else if ([productId isEqualToString:kInAppProUpgradeHundredSixtyEightProductId])
    {
        return 1;
    }
    
    return index;
}

-(void)requestProUpgradeProductData
{
    
    NSLog(@"in requestProUpgradeProductData");
    NSSet *productIdentifier= [NSSet setWithObjects: kInAppProUpgradeEightyeigthProductId, kInAppProUpgradeHundredSixtyEightProductId, nil];
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifier];
    _productsRequest.delegate = self;
    [_productsRequest start];
}

- (NSString*)localizedPrice:(SKProduct*)product {
    NSLog(@"in localizedPrice");
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:product.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:product.price];
    return formattedString;
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"in productsRequest");
    NSArray *products = response.products;
    int nCount = [products count];
    NSLog(@"nCount=%d\n",nCount);
    if (nCount == 6)
    {
        SKProduct* proUpgradeProduct = nil;
        NSMutableArray* pArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 6; ++i)
        {
            [pArray addObject:@"1"];
        }
        
        for (int i = 0; i < nCount; ++i)
        {
            proUpgradeProduct = [products objectAtIndex:i];
            [pArray replaceObjectAtIndex: [self getPriceIndexWithProductId:proUpgradeProduct.productIdentifier] withObject:[self localizedPrice:proUpgradeProduct]];
        }
        
        if (_delegate)
        {
            [_delegate inAppManagerProductsFetched:pArray];
        }
    }
    else
    {
        if (_delegate)
        {
            [_delegate inAppManagerProductsFetchFailed:0];
        }
    }
    
    // finally release the reqest we alloc/init’ed in requestProUpgradeProductData
    _productsRequest;
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"in request");
    if (_delegate)
    {
        [_delegate inAppManagerProductsFetchFailed:error.code];
    }
}

//
// call this method once on startup
//
- (void)loadStore
{
    NSLog(@"in loadStore");
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    [self requestProUpgradeProductData];
}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    NSLog(@"in canMakePurchases");
    return [SKPaymentQueue canMakePayments];
}

//
// kick off the upgrade transaction
//
- (void)purchaseProUpgrade
{
    NSLog(@"in purchaseProUpgrade");
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    SKPayment *payment = [SKPayment paymentWithProductIdentifier: [self getCurProductId]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma -
#pragma Purchase helpers

//
// enable pro features
//
- (void)provideContent:(NSString *)productId
{
    NSLog(@"in provideContent");
    if ([productId isEqualToString: [self getCurProductId]])
    {
        // enable the pro features
        
    }
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    NSLog(@"in finishTransaction");
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        NSLog(@"iap wasSuccessful\n");
        // send out a notification that we’ve finished the transaction
        if (_delegate)
        {
            [_delegate inAppManagerTransactionSucceeded:userInfo];
        }
    }
    else
    {
        NSLog(@"iap faile\n");
        // send out a notification for the failed transaction
        if (_delegate)
        {
            [_delegate inAppManagerTransactionFailed:transaction.error.code];
        }
    }
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"in completeTransaction productIdentifier=%@",transaction.payment.productIdentifier);
    
    // truely purchase IAP product for user
    NSString* jsonObjectString = [self encode:(uint8_t *)transaction.transactionReceipt.bytes length:transaction.transactionReceipt.length];
    
    //NSLog(@"AAA|%d-%@\n",transaction.transactionState,transaction.transactionIdentifier);
    //NSLog(@"CCC|%@\n",jsonObjectString);
    
    
    
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
    
    //提交给服务器做2次验证的数据
    //V1[]listid[]receipt[]gamename
    
    //barry add ------------------------------------------------
    //NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    //NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
    
    if ([transaction.payment.productIdentifier isEqualToString:kInAppProUpgradeEightyeigthProductId])
    {
        NSString *sstring88 = [NSString stringWithFormat:@"88_V4[]%@[]%@[]%@[]%@",transaction.transactionIdentifier,jsonObjectString,gName,gVer];
        const char * useid88 = [sstring88 cStringUsingEncoding:NSASCIIStringEncoding];
        //NSLog(@"88------------------%s",useid88);
        PayViewController *ob = [[PayViewController alloc] init];
        NSString *string = [[NSString alloc]initWithUTF8String:useid88];
        [ob OCAppleCallBack:string orderID:_orderID];
//        [ob OCJumpViewController];
    }
    
    if ([transaction.payment.productIdentifier isEqualToString:kInAppProUpgradeHundredSixtyEightProductId])
    {
        NSString *sstring168 = [NSString stringWithFormat:@"168_V4[]%@[]%@[]%@[]%@",transaction.transactionIdentifier,jsonObjectString,gName,gVer];
        const char * useid168 = [sstring168 cStringUsingEncoding:NSASCIIStringEncoding];
        //NSLog(@"168-----------------%s",useid168);
        PayViewController *ob = [[PayViewController alloc] init];
        NSString *string = [[NSString alloc] initWithUTF8String:useid168];
        [ob OCAppleCallBack:string orderID:_orderID];
//        [ob OCJumpViewController];
    }
    //barry add ------------------------------------------------
}

////
//// called when a transaction has been restored and and successfully completed
////
//- (void)restoreTransaction:(SKPaymentTransaction *)transaction
//{
//    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
//    [self finishTransaction:transaction wasSuccessful:YES];
//}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        NSLog(@"in failedTransaction err\n");
    }
    else
    {
        NSLog(@"in failedTransaction ok\n");
        [self finishTransaction:transaction wasSuccessful:NO];
        // this is fine, the user just cancelled, so don’t notify
        //[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"in paymentQueue SKPaymentTransactionStatePurchased");
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"in paymentQueue SKPaymentTransactionStateFailed");
                [self failedTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

//
// to docode transactionReceipt
//
- (NSString *)encode:(const uint8_t *)input length:(NSInteger)length {
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t *output = (uint8_t *)data.mutableBytes;
    
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger index = (i / 3) * 4;
        output[index + 0] =                    table[(value >> 18) & 0x3F];
        output[index + 1] =                    table[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

@end 