//
//  HealthBar.m
//  DoodleFalling
//
//  Created by lim byeong cheol on 11. 9. 19..
//  Copyright 2011년 SK M&S. All rights reserved.
//

#import "HealthBar.h"

@implementation HealthBar
@synthesize healthOutline;
- (id)initWithImage
{
    if (self = [super initWithSpriteFrameName:@"healthBar.png"]) 
    {
        healthOutline=[CCSprite spriteWithSpriteFrameName:@"healthBarOutline.png"];
        
    }
    return self;
}
-(void)dealloc
{
    [super dealloc];
}
@end
