//
//  Stair.m
//  DoodleFalling
//
//  Created by lim byeong cheol on 11. 9. 7..
//  Copyright 2011년 SK M&S. All rights reserved.
//

#import "Stair.h"


@implementation Stair
@synthesize movingSpeed;

-(id)initWithImageName:(NSString *)imageFileName
{
    if (self=[super initWithSpriteFrameName:imageFileName]) {
        [self changeState:kStateNone];
       // NSLog(@"stair fire is working");
        scaleNum=(CCRANDOM_0_1()*0.5+0.5);
        movingSpeed=kStairUpSpeedNormal;
        [self setScaleX:scaleNum];
        CGSize size=self.contentSize;
        [self setContentSize:CGSizeMake(size.width*scaleNum, size.height)];

        //[self boundingBox]=[self modifiedBoundingBox];
    }
   // NSLog(@"stair fire is not  working");
    return self;
}
-(void)changeState:(ObjectStates)state body:(b2Body *)body
{
   // NSLog(@"updateing now");
    [self stopAllActions];
    id action=nil;
    [self setObjectState:state];
    switch (state) {
        case kStateLanding:
          //  CCLOG(@"actor is on this stair");
            movingSpeed=kStairUpSpeedReverse;
            [self updateState:body];
            break;
        case kStateSpeedUp:
          //  CCLOG(@"state is speedup");
            movingSpeed=kStairUpSpeedFast;
            [self updateState:body];
            break;
        case kStateSpeedNormal:
            //CCLOG(@"state is speed normal");
            movingSpeed=kStairUpSpeedNormal;
            [self updateState:body];
            break;
        default:
            break;
    }
    if (action!=nil) {
        [self runAction:action];
    }
}
-(void)updateState:(b2Body *)body 
{
    if (body!=nil) 
    {
        
        CGPoint pos=[self toPixels:body->GetPosition()];
        pos.y+=movingSpeed;
        if (pos.y>screenSize.height) {
            pos.y=-screenSize.height;
            pos.x=CCRANDOM_0_1()*(screenSize.width-self.contentSize.width)+self.contentSize.width*0.5;
        }
        body->SetTransform([self toMeters:pos], 0);
        
    }
}


/*
-(CGRect)modifiedBoundingBox
{
    CGRect stairBoundingBox=[self boundingBox];
    //float xOffset=self.contentSize.width*0.3*scaleNum;
    float xOffset=0.0f;
    CGPoint pos=self.position;
    CGSize size=self.contentSize;
   // float xOffset=self.contentSize.width*0.1;
    float widthSize=size.width*kModifiedBoundingBoxFactorX;
    float heightSize=size.height*kModifiedBoundingBoxFactorY;
    stairBoundingBox=CGRectMake(pos.x-xOffset, pos.y, widthSize,heightSize);
    
    return stairBoundingBox;
}
 */
-(b2Vec2)toMeters:(CGPoint)point
    {
        return b2Vec2(point.x/PTM_RATIO, point.y/PTM_RATIO);
    }
-(CGPoint)toPixels:(b2Vec2)vect
    {
        return ccpMult(CGPointMake(vect.x, vect.y), PTM_RATIO);
    }
@end
