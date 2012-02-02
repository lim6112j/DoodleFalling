//
//  Stair.h
//  DoodleFalling
//
//  Created by lim byeong cheol on 11. 9. 7..
//  Copyright 2011년 SK M&S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameCharacter.h"

@interface Stair : GameCharacter {
    GameCharacter *actorCharactor;
    float scaleNum;
    float movingSpeed;
}

-(id)initWithImageName:(NSString *)imageFileName;
-(void)changeState:(ObjectStates)state body:(b2Body *)body;
-(void)updateState:(b2Body *)body;
-(b2Vec2)toMeters:(CGPoint)point;
-(CGPoint)toPixels:(b2Vec2)vect;

@property(readwrite) float movingSpeed;
@end
