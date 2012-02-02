//
//  Wall.h
//  DoodleFalling
//
//  Created by lim byeong cheol on 11. 9. 19..
//  Copyright 2011년 SK M&S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"
@interface Wall : GameObject
{
    CCSprite *wallSprite;
    CCSprite *wallSpriteBelow;
}
@property(nonatomic,retain)CCSprite *wallSprite;
@property(nonatomic,retain)CCSprite *wallSpriteBelow;
-(void)setSprite;
@end
