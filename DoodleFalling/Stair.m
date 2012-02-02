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
        scaleNum=(CCRANDOM_0_1()*1.0+0.5);
        movingSpeed=1.5f;
        [self setScaleX:scaleNum];
    }
   // NSLog(@"stair fire is not  working");
    return self;
}
-(void)changeState:(ObjectStates)state
{
   // NSLog(@"updateing now");
    [self stopAllActions];
    id action=nil;
    [self setCharacterState:state];
    switch (state) {
        case kStateLanding:
          //  CCLOG(@"state is slippery");
            break;
        case kStateSpeedUp:
          //  CCLOG(@"state is speedup");
            movingSpeed=3.0;
            break;
        case kStateSpeedNormal:
            //CCLOG(@"state is speed normal");
            movingSpeed=1.5;
            break;
        default:
            break;
    }
    if (action!=nil) {
        [self runAction:action];
    }
}
-(void)updateState:(ccTime)dt gameObjects:(CCArray *)obj
{
   // NSLog(@"stair updation");
  //  CGRect rect=[self boundingBox];
   // NSLog(@"stair's rect width:%f, height:%f",rect.size.width,rect.size.height);
    CGPoint pos=self.position;
    pos.y+=movingSpeed;
    if (pos.y>screenSize.height) {
        pos.y=-screenSize.height;
        pos.x=CCRANDOM_0_1()*(screenSize.width-self.contentSize.width)+self.contentSize.width*0.5;
    }
    self.position=pos;
}
-(CGRect)modifiedBoundingBox
{
    CGRect stairBoundingBox=[self boundingBox];
    float xOffset=self.contentSize.width*0.3*scaleNum;
    CGPoint pos=self.position;
    CGSize size=self.contentSize;
   // float xOffset=self.contentSize.width*0.1;
    float widthSize=size.width*kModifiedBoundingBoxFactorX*scaleNum;
    float heightSize=size.height*kModifiedBoundingBoxFactorY;
    stairBoundingBox=CGRectMake(pos.x-xOffset, pos.y, widthSize,heightSize);
    
    return stairBoundingBox;
}
@end
