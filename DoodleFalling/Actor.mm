//
//  Actor.m
//  DoodleFalling
//
//  Created by lim byeong cheol on 11. 9. 7..
//  Copyright 2011년 SK M&S. All rights reserved.
//

#import "Actor.h"


@implementation Actor
@synthesize delegate;
+(id)actor
{
    return [[[self alloc]initWithImage]autorelease];
}
-(id)initWithImage
{
    if (self=[super initWithSpriteFrameName:@"seadog1r.png"]) {
        objectState=kStateNone;
        CCAnimation *anim=[self setAnimation];
        CCAnimate *animate=[CCAnimate actionWithAnimation:anim];
        self.position=CGPointMake([[CCDirector sharedDirector]winSize].width*0.3, [[CCDirector sharedDirector]winSize].height*0.8);
        CCRepeatForever *rep=[CCRepeatForever actionWithAction:animate];
        [self runAction:rep];
        [self setScale:kActorScale];
        CGSize size=self.contentSize;
        [self setContentSize:CGSizeMake(size.width*kActorScale, size.height*kActorScale)];
        [self setAnchorPoint:CGPointMake(0.3,0.5)];//box2d바디와 에니메이션의 위치차이로 발생하는 부분을 상쇄하기위함
    }
    return self;
}
-(CCAnimation *)setAnimation
{

    return [self loadPlistForAnimationWithName:@"moveAnim" className:[[self class]description]];
}
-(void)updateState:(ccTime)dt gameObjects:(CCArray *)obj
{
    //NSLog(@"Actor updating");
    //CGSize size=[self contentSize];
   // NSLog(@"actor's rect width:%f, height:%f",rect.size.width,rect.size.height);

    

    
}

-(void)changeState:(ObjectStates)state
{
    [self setObjectState:state];
    switch (state) {
        case kStateOnBalloon:
            
            break;
        case kStateLanding:
            //CCLOG(@"actor landed on stair");
            break;
        case kStateFalling:
            //CCLOG(@"actor falling off stair");
            break;        
        case kStateGettingDamageByFire  :
            //CCLOG(@"actor is on fire");
            health=(int)(health*1000-kFireDamage)/1000;
            //CCLOG(@"current actor's health is %d",health);
            if (health<=0) {

                [delegate gamePause];
            }
            break;                
        default:
            break;
    }
}
/*
-(CGRect)modifiedBoundingBox
{
    CGRect actorBoundingBox=[self boundingBox];
    float xOffset=self.contentSize.width*0.1;
    CGPoint pos=self.position;
    CGSize size=self.contentSize;
    if (self.flipX==NO) {
            actorBoundingBox=CGRectMake(pos.x+xOffset*5, pos.y, size.width*kModifiedBoundingBoxFactorX, size.height*kModifiedBoundingBoxFactorY);
       // CCLOG(@"flipx=no");
    } else if(self.flipX==YES)
    {
            actorBoundingBox=CGRectMake(pos.x-xOffset, pos.y, size.width*kModifiedBoundingBoxFactorX, size.height*kModifiedBoundingBoxFactorY);
      //   CCLOG(@"flipx=YES");
    }


    return actorBoundingBox;
}
 */
-(void)dealloc
{
    [super dealloc];
}
@end
