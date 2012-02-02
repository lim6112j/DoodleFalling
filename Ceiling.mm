//
//  Ceiling.m
//  DoodleFalling
//
//  Created by lim byeong cheol on 11. 9. 19..
//  Copyright 2011년 SK M&S. All rights reserved.
//

#import "Ceiling.h"

@implementation Ceiling

-(id)initWithImage
{
    if (self=[super initWithSpriteFrameName:@"ceiling.png"]) {
        CGSize ceilingSize=[self contentSize];
        increment = kIncrementNormal;
        self.position=CGPointMake(self.screenSize.width*0.5, self.screenSize.height+ceilingSize.height*0.3);
    }
    return self;
}
-(void)updateState:(ccTime)dt gameObjects:(CCArray *)obj
{
    //CCLOG(@"ceiling called");
}
-(void)changeState:(ObjectStates)state
{
    // NSLog(@"updateing now");
    [self stopAllActions];
    id action=nil;
    [self setObjectState:state];
    switch (state) {
        case kStateCeilingUp:
            //CCLOG(@"ceiling is going up");
            increment=kIncrementUp;
            break;
        case kStateCeilingDown:
            //CCLOG(@"ceiling is going down");
            increment=kIncrementNormal;
            break;
        default:
            break;
    }
    if (action!=nil) {
        [self runAction:action];
    }
}
@end
