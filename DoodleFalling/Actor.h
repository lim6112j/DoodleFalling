//
//  Actor.h
//  DoodleFalling
//
//  Created by lim byeong cheol on 11. 9. 7..
//  Copyright 2011년 SK M&S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameCharacter.h"
@interface Actor : GameCharacter {
    id <MainSceneDelegate> delegate;
}
+(id)actor;
-(id)initWithImage;
-(CCAnimation *)setAnimation;
@property(nonatomic,assign)id  delegate;
@end
