//
//  GameObject.h
//  DoodleFalling
//
//  Created by lim byeong cheol on 11. 9. 15..
//  Copyright 2011년 SK M&S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MyProtocol.h"
#import "Constants.h"
#import "b2Body.h"

@interface GameObject : CCSprite {
    CGSize screenSize;
    GameObjectTypes gameObjectType;
    ObjectStates objectState;
    BOOL isActive;
    BOOL meetBoundaries;
}
-(id)init;
- (NSString *)applicationDocumentsDirectory;
-(void)updateState:(ccTime)dt gameObjects:(CCArray *)obj;
-(void)changeState:(ObjectStates)state;
-(CGRect)modifiedBoundingBox;
-(CCAnimation *)loadPlistForAnimationWithName:(NSString *)animationName className:(NSString *)className;
//-(CCAnimation *)loadPlistForAnimationWithName:(NSString *)animationName className:(NSString *)className
@property(readwrite)CGSize screenSize;
@property(readwrite)GameObjectTypes gameObjectType;
@property(readwrite)ObjectStates objectState;
@property(readwrite)BOOL isActive;
@property(readwrite)BOOL meetBoundaries;
@end
