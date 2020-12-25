//
//  QueryModel.m
//  spbhelper
//
//  Created by MrLovelyCbb on 15/4/24.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QueryModel.h"

@implementation QueryModel

- (id) initWithName:(NSString *)uname phone:(NSString *)uphone ywtype:(NSString *)utype adddate:(NSString *)uadddate
{
    self = [super init];
    
    if (self) {
        self.name = uname;
        self.phone = uphone;
        self.ywtype = utype;
        self.adddate = uadddate;
    }
    
    return self;
}

- (id) initWithDictionary:(NSDictionary *)dic
{
    self = [self initWithName:@"uname" phone:@"uphone" ywtype:@"yw_type" adddate:@"add_time"];
    return self;
}

- (id) init 
{
    self = [self initWithName:@"Undifined" phone:@"Undifined" ywtype:@"Undifined" adddate:@"Undifined"];
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ : %@",self.name,self.description];
}

@end
