//
//  TableQueryCell.m
//  spbhelper
//
//  Created by MrLovelyCbb on 15/4/24.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

#import "TableQueryCell.h"

@implementation TableQueryCell


@synthesize txtuname;
@synthesize txtnumber;
@synthesize txtservices;
@synthesize txtdates;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
    }
    
    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


@end
