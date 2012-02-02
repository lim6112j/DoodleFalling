//
//  SpeedUpItem.h
//  DoodleFalling
//
//  Created by lim byeong cheol on 11. 9. 20..
//  Copyright 2011년 SK M&S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"

@interface SpeedUpItem : GameObject
{

    float scaleNum;
}
-(void)setSprite;
-(id)initWithImage;
-(void)tick;
-(void)tick2;
@end
