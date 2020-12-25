//
//  IapComFun.m
//  Unity-iPhone
//
//  Created by ZOXUN on 13-5-4.
//
//

#import "IapComFun.h"
#import "InAppManager.h"

static InAppManager* s_InAppManager = nil;

//0越狱 1正式版 2企业版
static int is_alipay = 1;

//versioncode
static int versioncode = 11;

//gameid
const int GameID = 2;

@implementation IapComFun
int money = 0;
NSTimeInterval lastTimet = 0;


//游戏渠道号  unity3d游戏内调用  gameid << 8 + channelID
int _iosGetChannel()
{
    return ((GameID << 8) +  (90 + is_alipay));
}

-(void) _iosIapManager:(int)uid sp:(int)sp iapmoney:(int)iapmoney gameid:(NSString *const)gameid
{
    
    NSLog(@"213123213");
    //return;
    //money  18  30 68 118 258 588
    //index  0   1  2  3   4   5
//    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
//    
//    if (uid == 0) //版本校验
//    {
//        NSString *s_update = [NSString stringWithFormat:@"%d_com.game.%d.%d_9%d_%d",iapmoney,gameid,is_alipay,is_alipay,versioncode];
//        const char *s_s_updateout = [s_update cStringUsingEncoding:NSUTF8StringEncoding];
//        //UnitySendMessage("UIHall", "appupdate",s_s_updateout);
//        NSLog(@"UIHall %s",s_s_updateout);
//        return;
//    }
//    
//    if (is_alipay != 1)
//    {
//        NSString *s_alipai = [NSString stringWithFormat:@"%d_0",iapmoney];
//        const char *s_alipaiout = [s_alipai cStringUsingEncoding:NSUTF8StringEncoding];
//        //UnitySendMessage("UIHall", "StartIPhonePayCallBack",s_alipaiout);
//        NSLog(@"UIHall %s",s_alipaiout);
//        return;
//    }
//    
//    if (now - lastTimet < 10)
//    {
//        //请稍后再充值
//        NSString *sstringwait60sec = [NSString stringWithFormat:@"0_正在与服务器通信，请您在%d秒后再购买。",(int)(12-(now-lastTimet))];
//        NSLog(@"wait 40sec %@\n",sstringwait60sec);
//        const char *charpwait60sec = [sstringwait60sec cStringUsingEncoding:NSUTF8StringEncoding];
//        //UnitySendMessage("UIHall", "StartIPhonePayCallBack",charpwait60sec);
//        NSLog(@"UIHall %s",charpwait60sec);
//        return;
//    }
//    else
//        lastTimet = now;
    
    
    //NSLog(@"uid=%d sp=%d iapmoney=%d gameid=%d lastTimet=%f\n",uid,sp,iapmoney,gameid,lastTimet);
    if (s_InAppManager == nil)
    {
        s_InAppManager = [InAppManager sharedInstance];
    }
    
    InAppMode mode = eInAppNone;
    
    
    if (money > 0) {
        //UnitySendMessage("UIHall", "StartIPhonePayCallBack","0_您的上次购买未完成，请您稍候再购买。");
        return;
    }
    
    money = iapmoney;
    
    
    
    if (money == 88)
    {
        mode = eInAppFirst;
    }
    else if (money == 168)
    {
        mode = eInAppSecond;
    }
    else
    {
        money = 0;
        
        // UnitySendMessage("UIHall", "StartIPhonePayCallBack","0_购买失败，请稍候再购买。");
        return;
        
    }
    
    if (mode != eInAppNone)
    {
        NSLog(@"id=%u\n",mode);
        [s_InAppManager setDelegate:[IapComFun shareInstance] inAppMode:mode orderID:gameid];
        if ([s_InAppManager canMakePurchases])
        {
            
            [s_InAppManager purchaseProUpgrade];
            //[s_InAppManager loadStore];
        }
        else
        {
            //不能购买
            //TODO:
            money = 0;
        }
    }
    
}

+ (IapComFun*)shareInstance
{
    static IapComFun* pIapComFun = nil;
    if (pIapComFun == nil)
    {
        pIapComFun = [[IapComFun alloc] init];
    }
    return pIapComFun;
}

- (void)inAppManagerProductsFetched:(NSMutableArray*)priceDatas
{
    NSLog(@"inAppManagerProductsFetched");
    money = 0;
    //UnitySendMessage("UIHall", "StartIPhonePayCallBack","0_购买失败，请稍候再购买。");
}

- (void)inAppManagerProductsFetchFailed:(NSInteger)errorCode
{
    NSLog(@"inAppManagerProductsFetchFailed");
    money = 0;
    //UnitySendMessage("UIHall", "StartIPhonePayCallBack","0_购买失败，请稍候再购买。");
}

- (void)inAppManagerTransactionFailed:(NSInteger)errorCode
{
    NSLog(@"inAppManagerTransactionFailed");
    money = 0;
   // UnitySendMessage("UIHall", "StartIPhonePayCallBack","0_please wait 5 min ");
}

- (void)inAppManagerTransactionSucceeded:(NSDictionary*)transaction
{
    /*
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
    
    NSLog(@"inAppManagerTransactionSucceeded money=%d\n",money);
    
    if (money == 6)
    {
        NSString *sstring6 = [NSString stringWithFormat:@"1_ok%@",timeStampObj];
        const char *useid6 = [sstring6 cStringUsingEncoding:NSASCIIStringEncoding];
        UnitySendMessage("UIHall", "StartIPhonePayCallBack",useid6);
    }
    else if(money == 18)
    {
        NSString *sstring18 = [NSString stringWithFormat:@"2_ok%@",timeStampObj];
        const char *useid18 = [sstring18 cStringUsingEncoding:NSASCIIStringEncoding];
        UnitySendMessage("UIHall", "StartIPhonePayCallBack",useid18);

    }
    else if(money == 50)
    {
        NSString *sstring50 = [NSString stringWithFormat:@"3_ok%@",timeStampObj];
        const char *useid50 = [sstring50 cStringUsingEncoding:NSASCIIStringEncoding];
        UnitySendMessage("UIHall", "StartIPhonePayCallBack",useid50);
    }
    else if(money == 118)
    {
        NSString *sstring118 = [NSString stringWithFormat:@"4_ok%@",timeStampObj];
        const char *useid118 = [sstring118 cStringUsingEncoding:NSASCIIStringEncoding];
        UnitySendMessage("UIHall", "StartIPhonePayCallBack",useid118);
    }
    else if(money == 258)
    {
        NSString *sstring258 = [NSString stringWithFormat:@"5_ok%@",timeStampObj];
        const char *useid258 = [sstring258 cStringUsingEncoding:NSASCIIStringEncoding];
        UnitySendMessage("UIHall", "StartIPhonePayCallBack",useid258);
    }
    else if(money == 588)
    {
        NSString *sstring588 = [NSString stringWithFormat:@"6_ok%@",timeStampObj];
        const char *useid588 = [sstring588 cStringUsingEncoding:NSASCIIStringEncoding];
        UnitySendMessage("UIHall", "StartIPhonePayCallBack",useid588);
    }
    else
        UnitySendMessage("UIHall", "StartIPhonePayCallBack","0_please try again ");
    */
     money = 0;
}

@end