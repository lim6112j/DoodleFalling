//
//  Fish.h
//  DoodleFalling
//
//  Created by lim byeong cheol on 11. 9. 21..
//  Copyright 2011년 SK M&S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"

@interface Fish : GameObject
{
    float scaleNum;
}
-(CCAnimation *)setAnimation;
-(void)tick;
@end
