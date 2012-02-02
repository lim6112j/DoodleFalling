//
//  MyProtocol.h
//  DoodleFalling
//
//  Created by lim byeong cheol on 11. 9. 17..
//  Copyright (c) 2011년 SK M&S. All rights reserved.
//

#ifndef DoodleFalling_MyProtocol_h
#define DoodleFalling_MyProtocol_h
typedef enum
{
    kStateNone,
    kStateDead,
    kStateWalking,
    kStateGettingDamage,
    kStateFalling,
    kStateLanding,
    kStateStairMoving,
    kStateCeilingUp,
    kStateCeilingDown,
    kStateGettingDamageByFire,
    kStateSpeedUp,
    kStateSpeedNormal,
    kStateSpeedReverse,
    kStateEatUpItem,
    kStateEatUpItemWearOff,
    kStateOnBalloon
} ObjectStates;
typedef enum
{
    kTypeNone,
    kTypeRollingStair,
    kTypeSlipperyStair,
    kTypeShortStair,
    kTypeLongStair,
    kTypeFlameStair,
    kTypeStair,
    kTypeBalloon,
    kTypeHealthUp,
    kTypeActor,
    kTypeCeiling,
    kTypeHealthBar,
    kTypeWall,
    kTypeSpeedUpItem,
    kTypeFish
} GameObjectTypes;

@protocol MainSceneDelegate <NSObject>

-(void)CreateObjectWithType:(GameObjectTypes)type withHealth:(int)health location:(CGPoint)at zValue:(int)z;
//-(void)screenMovingUp;
-(void)gamePause;
@end
#endif
