//
//  HealthBar.h
//  DoodleFalling
//
//  Created by lim byeong cheol on 11. 9. 19..
//  Copyright 2011년 SK M&S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"
@interface HealthBar : GameObject
{
    CCSprite *healthOutline;
}
-(id)initWithImage;
@property(nonatomic,retain)CCSprite *healthOutline;
@end
