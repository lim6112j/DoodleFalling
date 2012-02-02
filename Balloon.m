//
//  Balloon.m
//  DoodleFalling
//
//  Created by lim byeong cheol on 11. 9. 18..
//  Copyright 2011년 SK M&S. All rights reserved.
//

#import "Balloon.h"

@implementation Balloon

-(id)initWithImage
{
    if (self=[super initWithSpriteFrameName:@"balloon.png"]) {

    }
    return self;
}
-(void)updateState:(ccTime)dt gameObjects:(CCArray *)obj
{
    
}
-(void)dealloc
{
    [super dealloc];
}
@end
