//
//  IapComFun.h
//  Unity-iPhone
//
//  Created by ZOXUN on 13-5-4.
//
//   accept at 2013-06-06 

#import <Foundation/Foundation.h>
#import "InAppManager.h"


//extern void _iosIapManager(int uid,int sp,int money,int gameid);

@interface IapComFun : NSObject<InAppManagerDelegate>
{
@private
    
    
}

+ (IapComFun*)shareInstance;
-(void) _iosIapManager:(int)uid sp:(int)sp iapmoney:(int)iapmoney gameid:(NSString *const)gameid;

@end