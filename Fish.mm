//
//  Fish.m
//  DoodleFalling
//
//  Created by lim byeong cheol on 11. 9. 21..
//  Copyright 2011년 SK M&S. All rights reserved.
//

#import "Fish.h"

@implementation Fish

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        isActive=NO;
        gameObjectType=kTypeFish;
        scaleNum=0.7;
        self.scale=scaleNum;
        [self schedule:@selector(tick) interval:15.0f];
    }
    
    return self;
}
-(void)tick
{
    self.isActive=YES;
    [self unschedule:_cmd];
    [self schedule:@selector(tick2) interval:3.0];
}
-(void)tick2
{
    [self changeState:kStateEatUpItemWearOff];
    //[self unscheduleAllSelectors];
    [self unschedule:_cmd];
}
-(CCAnimation *)setAnimation
{
    CCAnimation *anim=[self loadPlistForAnimationWithName:@"fishAnim" className:@"Actor"];
    if (anim==NULL) {
        CCLOG(@"fish animation loading failed");
    }
    return anim;
}
-(void)changeState:(ObjectStates)state
{
    [self setObjectState:state];
    switch (state) {
        case kStateEatUpItem:
            self.isActive=NO;
            self.position=ccp(-100, -100);
            [self unschedule:@selector(tick2)];
            [self schedule:@selector(tick2) interval:6.0f];
            break;
        case kStateEatUpItemWearOff:
            [self schedule:@selector(tick) interval:15.0f];
            break;
        default:
            break;
    }
}
-(void)updateState:(ccTime)dt gameObjects:(CCArray *)obj
{
    
}
-(CGRect)modifiedBoundingBox
{
    CGRect ItemBox=[self boundingBox];
    float xOffset=self.contentSize.width*0.3*scaleNum;
    CGPoint pos=self.position;
    CGSize size=self.contentSize;
    // float xOffset=self.contentSize.width*0.1;
    float widthSize=size.width*kModifiedBoundingBoxFactorXForSpeedUpItem*scaleNum;
    float heightSize=size.height*kModifiedBoundingBoxFactorY;
    ItemBox=CGRectMake(pos.x-xOffset, pos.y, widthSize,heightSize);
    return ItemBox;
}
@end
