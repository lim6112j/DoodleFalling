//
//  Wall.m
//  DoodleFalling
//
//  Created by lim byeong cheol on 11. 9. 19..
//  Copyright 2011년 SK M&S. All rights reserved.
//

#import "Wall.h"

@implementation Wall
@synthesize wallSpriteBelow,wallSprite;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        isActive=TRUE;
        gameObjectType=kTypeWall;
        [self setSprite];
        
    }
    
    return self;
}
-(void)setSprite
{
    wallSprite=[CCSprite spriteWithSpriteFrameName:@"wall.png"];
    wallSprite.anchorPoint=CGPointMake(0.5, 0);
    wallSprite.position=ccp(self.screenSize.width*0.5, 0) ;
    wallSpriteBelow=[CCSprite spriteWithSpriteFrameName:@"wall.png"];
    wallSpriteBelow.anchorPoint=CGPointMake(0.5, 1.0);
    wallSpriteBelow.position=ccp(self.screenSize.width*0.5, 0);
}
-(void)updateState:(ccTime)dt gameObjects:(CCArray *)obj
{
    CGPoint pos=wallSprite.position;
    pos.y+=2.0;
    CGPoint posBelow=wallSpriteBelow.position;
    posBelow.y+=2.0;
    if (pos.y>screenSize.height) {
        pos.y=0;
    }
    if (posBelow.y>screenSize.height) {
        posBelow.y=0;
    }
    wallSprite.position=pos;
    wallSpriteBelow.position=posBelow;
    

}

-(void)changeState:(ObjectStates)state
{
    NSLog(@"override this method");
}
-(CGRect)modifiedBoundingBox
{
    
    NSLog(@"override this method");
    return [self boundingBox];
}
-(void)dealloc
{
    [super dealloc];
}
@end
