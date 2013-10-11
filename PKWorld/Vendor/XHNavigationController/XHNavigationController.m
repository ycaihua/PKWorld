//
//  AnimationNavigationController.m
//  PKWorldFrameWork
//
//  Created by 曾 宪华 on 13-9-17.
//  Copyright (c) 2013年 Jack_team. All rights reserved.
//

#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]

#import "XHNavigationController.h"
#import <QuartzCore/QuartzCore.h>

#pragma mark - DirectionPanGestureRecognizer

typedef enum
{
    DirectionPanGestureRecognizerVertical,
    DirectionPanGestureRecognizerHorizontal
    
} DirectionPanGestureRecognizerDirection;

@interface DirectionPanGestureRecognizer : UIPanGestureRecognizer

@property (nonatomic, assign) DirectionPanGestureRecognizerDirection direction;

@end


@implementation DirectionPanGestureRecognizer
{
    BOOL _dragging;
    CGPoint _init;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    _init = [touch locationInView:self.view];
    _dragging = NO;
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    if (self.state == UIGestureRecognizerStateFailed)
        return;
    
    if ( _dragging )
        return;
    
    const int kDirectionPanThreshold = 5;
    
    UITouch *touch = [touches anyObject];
    CGPoint nowPoint = [touch locationInView:self.view];
    
    CGFloat moveX = nowPoint.x - _init.x;
    CGFloat moveY = nowPoint.y - _init.y;
    
    if (abs(moveX) > kDirectionPanThreshold)
    {
        if (_direction == DirectionPanGestureRecognizerHorizontal)
            _dragging = YES;
        else
            self.state = UIGestureRecognizerStateFailed;
    }
    else if (abs(moveY) > kDirectionPanThreshold)
    {
        if (_direction == DirectionPanGestureRecognizerVertical)
            _dragging = YES ;
        else
            self.state = UIGestureRecognizerStateFailed;
    }
}

@end

@interface XHNavigationController () <UIGestureRecognizerDelegate>
{
    CGPoint startTouch;
    CGPoint startTouchLocation;
    BOOL isMoving;
    
    UIImageView *lastScreenShotView;
    UIView *blackMask;
    
    //
    UIPanGestureRecognizer *_panGestureRecognizer;
}

@property (nonatomic,retain) UIView *backgroundView;


@end

@implementation XHNavigationController
{
    NSMutableArray *_animationQueue;
    BOOL _userInteractionStore;
}

@synthesize screenShotsList;

- (UIPanGestureRecognizer*)panGestureRecognizer
{
    if ( _panGestureRecognizer == nil )
    {
        DirectionPanGestureRecognizer *customRecognizer =
        [[DirectionPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRevealGesture:)];
        
        customRecognizer.direction = DirectionPanGestureRecognizerHorizontal;
        customRecognizer.delegate = self;
        _panGestureRecognizer = customRecognizer ;
    }
    return _panGestureRecognizer;
}

- (void)handleRevealGesture:(UIPanGestureRecognizer *)recognizer
{
    switch ( recognizer.state )
    {
        case UIGestureRecognizerStateBegan:
            [self handleRevealGestureStateBeganWithRecognizer:recognizer];
            break;
            
        case UIGestureRecognizerStateChanged:
            [self handleRevealGestureStateChangedWithRecognizer:recognizer];
            break;
            
        case UIGestureRecognizerStateEnded:
            [self handleRevealGestureStateEndedWithRecognizer:recognizer];
            break;
            
        case UIGestureRecognizerStateCancelled:
            [self handleRevealGestureStateCancelledWithRecognizer:recognizer];
            break;
            
        default:
            break;
    }
}

- (void)handleRevealGestureStateBeganWithRecognizer:(UIPanGestureRecognizer *)recognizer
{
    // we know that we will not get here unless the animationQueue is empty because the recognizer
    // delegate prevents it, however we do not want any forthcoming programatic actions to disturb
    // the gesture, so we just enqueue a dummy block to ensure any programatic acctions will be
    // scheduled after the gesture is completed
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    [self _enqueueBlock:^{}]; // <-- dummy block
    
    // we store the initial position and initialize a target position
//    _panInitialFrontPosition = _frontViewPosition;
    
    // we disable user interactions on the views, however programatic accions will still be
    // enqueued to be performed after the gesture completes
    [self _disableUserInteraction];
    isMoving = NO;
    UIViewController *vc = [self.viewControllers objectAtIndex:self.viewControllers.count-1];
    startTouch = [recognizer translationInView:vc.view];
    startTouchLocation = [recognizer locationInView:vc.view];
}

- (void)handleRevealGestureStateChangedWithRecognizer:(UIPanGestureRecognizer *)recognizer
{
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    UIViewController *vc = [self.viewControllers objectAtIndex:self.viewControllers.count-1];
    CGPoint moveTouch = [recognizer translationInView:vc.view];
    if (!isMoving) {
        if(moveTouch.x - startTouch.x > 10)
        {
            isMoving = YES;
            [self replaceScreenShotView];
        }
    }
    
    if (isMoving) {
        [self moveViewWithX:moveTouch.x - startTouch.x];
    }
}

- (void)handleRevealGestureStateEndedWithRecognizer:(UIPanGestureRecognizer *)recognizer
{
    [self _restoreUserInteraction];
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    UIViewController *vc = [self.viewControllers objectAtIndex:self.viewControllers.count-1];
    
    CGPoint endTouch = [recognizer translationInView:vc.view];
    if (endTouch.x - startTouch.x > 50)
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:CGRectGetWidth(self.view.frame)];
        } completion:^(BOOL finished) {
            
            [self popViewControllerAnimated:NO];
            CGRect frame = self.view.frame;
            frame.origin.x = 0;
            self.view.frame = frame;
            isMoving = NO;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            isMoving = NO;
        }];
    }
}

- (void)handleRevealGestureStateCancelledWithRecognizer:(UIPanGestureRecognizer *)recognizer
{
    [self _restoreUserInteraction];
    [self _dequeue];
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self moveViewWithX:0];
    } completion:^(BOOL finished) {
        isMoving = NO;
    }];
}
#pragma mark - Deferred block execution queue

// Define a convenience macro to enqueue single statements
#define _enqueue(code) [self _enqueueBlock:^{code;}];

// Defers the execution of the passed in block until a paired _dequeue call is received,
// or executes the block right away if no pending requests are present.
- (void)_enqueueBlock:(void (^)(void))block
{
    [_animationQueue insertObject:block atIndex:0];
    if ( _animationQueue.count == 1)
    {
        block();
    }
}

// Removes the top most block in the queue and executes the following one if any.
// Calls to this method must be paired with calls to _enqueueBlock, particularly it may be called
// from within a block passed to _enqueueBlock to remove itself when done with animations.
- (void)_dequeue
{
    [_animationQueue removeLastObject];
    
    if ( _animationQueue.count > 0 )
    {
        void (^block)(void) = [_animationQueue lastObject];
        block();
    }
}


#pragma mark - Gesture Delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return ( gestureRecognizer == _panGestureRecognizer && _animationQueue.count == 0) ;
}

#pragma mark - UserInteractionEnabling

// disable userInteraction on the entire control
- (void)_disableUserInteraction
{
    UIViewController *vc = [self.viewControllers objectAtIndex:self.viewControllers.count-1];
    [vc.view setUserInteractionEnabled:NO];
}

// restore userInteraction on the control
- (void)_restoreUserInteraction
{
    UIViewController *vc = [self.viewControllers objectAtIndex:self.viewControllers.count-1];
    [vc.view  setUserInteractionEnabled:YES];
}

#pragma mark - Base

- (void)replaceScreenShotView {
    if (!self.backgroundView)
    {
        CGRect frame = self.view.frame;
        
        self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
        [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
        
        blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
        blackMask.backgroundColor = [UIColor blackColor];
        [self.backgroundView addSubview:blackMask];
        blackMask.alpha = 0.0;
    }
    
    if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
    UIImage *lastScreenShot = [self.screenShotsList lastObject];
    lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
    [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.screenShotsList = [[NSMutableArray alloc] initWithCapacity:2];
        self.canDragBack = YES;
    }
    return self;
}

- (void)dealloc
{
    self.screenShotsList = nil;
    
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenShotsList = [[NSMutableArray alloc]initWithCapacity:2];
    
    self.view.layer.shadowColor = [[UIColor blackColor]CGColor];
    self.view.layer.shadowOffset = CGSizeMake(5, 5);
    self.view.layer.shadowRadius = 5;
    self.view.layer.shadowOpacity = 1;
    self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
}

- (void)setCanDragBack:(BOOL)canDragBack {
    _canDragBack = canDragBack;
    if (canDragBack) {
        [self.view addGestureRecognizer:self.panGestureRecognizer];
    } else {
        [self.view removeGestureRecognizer:self.panGestureRecognizer];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.screenShotsList addObject:[self capture]];

    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self.screenShotsList removeLastObject];

    UIViewController *vc = [super popViewControllerAnimated:animated];
    return vc;
}

#pragma mark - Utility Methods -

// get the current view screen shot
- (UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)AnimationScaleWithPush:(BOOL)isPush WithX:(float)x {
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    
    x = x > viewWidth ? viewWidth : x;
    x = x < 0 ? 0 : x;
        
    float scale = (x / (viewWidth * 2 * 10)) + 0.95;
    float alpha = 0.4 - (x / 800);
    
    lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);
    blackMask.alpha = alpha;
}


- (void)moveViewWithX:(float)x
{
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);

    x = x > viewWidth ? viewWidth : x;
    x = x < 0 ? 0 : x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    float scale = (x / (viewWidth * 2 * 10)) + 0.95;
    float alpha = 0.4 - (x / 800);
    
    lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);
    blackMask.alpha = alpha;
}

@end
