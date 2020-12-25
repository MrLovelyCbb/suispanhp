//
//  QueryModel.h
//  spbhelper
//
//  Created by MrLovelyCbb on 15/4/24.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueryModel : NSObject

@property (strong,nonatomic)NSString *name;
@property (strong,nonatomic)NSString *phone;
@property (strong,nonatomic)NSString *ywtype;
@property (strong,nonatomic)NSString *adddate;

-(id)initWithName:(NSString *)uname
            phone:(NSString *)uphone
           ywtype:(NSString *)utype
          adddate:(NSString *)uadddate;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
