//
//  AnimationNavigationController.h
//  PKWorldFrameWork
//
//  Created by 曾 宪华 on 13-9-17.
//  Copyright (c) 2013年 Jack_team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>


@interface AnimationNavigationController : UINavigationController

@property (nonatomic,retain) NSMutableArray *screenShotsList;

@property (nonatomic,assign) BOOL canDragBack;

-(void)setCanDragBack:(BOOL)canDragBack;

- (UIPanGestureRecognizer*)panGestureRecognizer;

@end
