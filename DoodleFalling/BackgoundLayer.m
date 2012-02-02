//
//  BackgoundLayer.m
//  DoodleFalling
//
//  Created by lim byeong cheol on 11. 9. 19..
//  Copyright 2011년 SK M&S. All rights reserved.
//

#import "BackgoundLayer.h"


@implementation BackgoundLayer
-(id)init
{
    if (self=[super init]) 
    {
        CGSize  screenSize=[[CCDirector sharedDirector]winSize];
        CCSprite *BG=[CCSprite spriteWithFile:@"BG.png"];
        BG.position=CGPointMake(screenSize.width*0.5, screenSize.height*0.5);
        [self addChild:BG z:0];
        
        CCSprite *dragonSprite=[CCSprite spriteWithSpriteFrameName:@"dragon.png"];
        dragonSprite.position=CGPointMake(screenSize.width*0.5, screenSize.height*0.5);
        [self addChild:dragonSprite z:0];
    }
    return self;
}
@end
