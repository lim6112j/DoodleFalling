//
//  MainScene.h
//  DoodleFalling
//
//  Created by lim byeong cheol on 11. 9. 7..
//  Copyright 2011년 SK M&S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Actor.h"
#import "Stair.h"
#import "Balloon.h"
#import "Ceiling.h"
#import "HealthBar.h"
#import "Wall.h"
#import "SpeedUpItem.h"
#import "Fish.h"
#import "Item.h"
#import "Constants.h"
#import "MyProtocol.h"
#import "PlistLoader.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "MyContactListener.h"
@interface MainScene : CCLayer <MainSceneDelegate>{
    CGPoint playerVelocity;
    ccTime totalTime;
    CGSize screenSize;
    CGSize ceilingSize;
    CGPoint ceilingPoint;
    Actor *actor;
    b2Body *actorBody;
    Stair *stair;
    Wall *wall;
    SpeedUpItem *speedUpItem;
    Fish *fish;
    Ceiling *ceiling;
    CCSpriteFrameCache *frameCache;
    CCSpriteBatchNode *stairBatchNode;
    CCSpriteBatchNode *leftWallBatch;
    CCSpriteBatchNode *rightWallBatch;
    CCSpriteBatchNode *batch;
    CCArray *stairs;
    CCArray *walls;
    float stairMoveDuration;
    int numstairsMoved;
    BOOL actorLanded;
    float wallWidth;
    CCLabelTTF *scoreLabel;
    int score;
    int actorDirection;
    BOOL gameEnded;
    BOOL balloonActivated;
    BOOL speedUpItemActivated;
    CollisionSystem collisionSystem;
    NSMutableDictionary *dic;
    b2World *_world;
    MyContactListener *_contactListener;
    GLESDebugDraw *_debugDraw;
}
+(id)scene;
+(id)sharedInstance;
-(id)init;
//-(void)initWalls;
-(void)updateHealthBar;
-(void)checkForCollision:(ccTime)delta;
//-(void)wallUpdate:(ccTime)time;
-(void)gamePause;
-(void)resetBalloon;
-(void)changeStairSpeed:(ObjectStates)state;
-(void)CreateObjectWithType:(GameObjectTypes)type withHealth:(int)health location:(CGPoint)at zValue:(int)z;
-(b2Vec2)toMeters:(CGPoint)point;
-(CGPoint)toPixels:(b2Vec2)vect;
-(void)spriteToBody:(CGPoint)pos sprite:(GameObject *)obj objectType:(GameObjectTypes)type;
-(void)setUpWorld;
@property (nonatomic,retain) NSMutableDictionary *dic;

@end
