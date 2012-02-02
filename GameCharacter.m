//
//  GameCharacter.m
//  DoodleFalling
//
//  Created by lim byeong cheol on 11. 9. 17..
//  Copyright 2011년 SK M&S. All rights reserved.
//

#import "GameCharacter.h"


@implementation GameCharacter
@synthesize characterState,health;
-(id)init
{
    if (self=[super init]) {
        health=kMaxHealth;
        characterState=kStateNone;
    }
    return self;
}
-(int)getDamage
{
    CCLOG(@"override this method");
    return 0;
}
-(void)checkSpritePosition
{
    CGPoint pos=[self position];
    CGSize size=[self contentSize];

    if (pos.x<size.width*0.5) {
        pos=ccp(size.width*0.5, pos.y);
    } else if (pos.x>screenSize.width-size.width*0.5)
    {
        pos=ccp(screenSize.width-size.width*0.5, pos.y);
    }

}
-(void)dealloc
{
    [super dealloc];
}
@end
