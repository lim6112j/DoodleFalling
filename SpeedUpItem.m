//
//  SpeedUpItem.m
//  DoodleFalling
//
//  Created by lim byeong cheol on 11. 9. 20..
//  Copyright 2011년 SK M&S. All rights reserved.
//

#import "SpeedUpItem.h"

@implementation SpeedUpItem

-(id)initWithImage
{
    if (self=[super initWithSpriteFrameName:@"speedUp.png"]) {
        [self setGameObjectType:kTypeSpeedUpItem];
        [self setObjectState:kStateNone];
        isActive=NO;
        scaleNum=1.0;
        [self schedule:@selector(tick) interval:10.0f];
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
-(void)setSprite{

}
-(void)updateState:(ccTime)dt gameObjects:(CCArray *)obj
{


 //           int i=(int)(CCRANDOM_0_1()*[obj count]);
  //      GameObject *stairObj=[obj objectAtIndex:i];
   //         self.position=CGPointMake(stairObj.position.x, stairObj.position.y+stairObj.contentSize.height*0.4);


}
-(void)changeState:(ObjectStates)state
{
    [self setObjectState:state];
    switch (state) {
        case kStateEatUpItem:
            self.isActive=NO;
            self.position=ccp(-100, -100);
            [self schedule:@selector(tick2) interval:6.0];
            break;
        case kStateEatUpItemWearOff:
            self.isActive=NO;
            self.position=ccp(-100,-100);
            [self schedule:@selector(tick) interval:10.0f];
            break;
        default:
            break;
    }
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
-(void)dealloc
{
    [super dealloc];
}
@end
