//
//  Constants.h
//  DoodleFalling
//
//  Created by lim byeong cheol on 11. 9. 17..
//  Copyright 2011년 SK M&S. All rights reserved.
//

#ifndef DoodleFalling_Constants_h
#define DoodleFalling_Constants_h

//for gameobject
#define kMaxHealth 100
//for MainScene
typedef enum
{
    defaultCollision,
    rectCollision,
    contactCollision
}CollisionSystem;
typedef enum
{
normalStair,
    fireStair
}
kindsOfStair;
#define stairNum 12
//#define kFlameStairNum 4
#define TILESIZE 93
#define TILESET_COLUMNS 9
#define TILESET_ROWS 19
#define PTM_RATIO 93
#define wallNum 5
#define kScoreLabelZIndex 10
#define kModifiedBoundingBoxFactorX 1.0
#define kModifiedBoundingBoxFactorY 1.0
#define kModifiedBoundingBoxFactorXForSpeedUpItem 0.9
#define zIndexOfOptionMenu 0
#define actorAnimationNums 4
#define actorDirectionRight 0
#define actorDirectionLeft 1
#define kInitialHealth 100
#define kInitialHealthFloat 100.0

#define pauseTag 1
#define scoreDescLabelTag 2
#define optionMenuTag 3
#define itemBoxTag 4
#define balloonTag 5
#define wallTag 6
#define wallBelowTag 7
#define actorTag 8
#define stairTag 9
#define kTagFish 13
#define hiScoreDescLabelTag 14
//#define stairFireTag 10
#define kHealthBar 11
#define kTagSpeedUpItem 12
// for MainMenu
#define startLabelTag 1
// for OptionMenu
#define soundLabelTag 1
#define resumeLabelTag 2
//for actor
#define kActorScale 1.0
#define kFireDamage 1.0
//for ceiling
#define kIncrementNormal -1.5
#define kIncrementUp 1.0
//for stair
#define kStairUpSpeedNormal 1.5
#define kStairUpSpeedFast 3.0
#define kStairUpSpeedReverse 0.3
//box 2d parameter
#define kRestitution 0.6 // 충돌시 튕김 정도
#define kActorDensity 50 // actor의 질량을 결정하는 밀도
# define kStairDensity 100
#define kBalloonForce 2.0
#define kGravity -1.5 
#endif
