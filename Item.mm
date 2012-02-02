//
//  Item.m
//  DoodleFalling
//
//  Created by lim byeong cheol on 11. 9. 24..
//  Copyright 2011년 SK M&S. All rights reserved.
//

#import "Item.h"

@implementation Item

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)changeState:(ObjectStates)state
{
    if (self.gameObjectType==kTypeRollingStair) {
        CCLOG(@"item is kTypeRollingStair");
    }
}
-(void)updateState:(ccTime)dt gameObjects:(CCArray *)obj
{
    if (self.gameObjectType==kTypeRollingStair) {
        CCLOG(@"item is kTypeRollingStair");
    }
}
-(CGRect)modifiedBoundingBox
{
    if (self.gameObjectType==kTypeRollingStair) {
        CCLOG(@"item is kTypeRollingStair");
    }
    CGRect rect;
    return rect;
}
@end
