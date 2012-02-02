//
//  GameCharacter.h
//  DoodleFalling
//
//  Created by lim byeong cheol on 11. 9. 17..
//  Copyright 2011년 SK M&S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"

@interface GameCharacter : GameObject {
    int health;

}
-(int)getDamage;
-(void)checkSpritePosition;

@property(readwrite) int health;
@end
