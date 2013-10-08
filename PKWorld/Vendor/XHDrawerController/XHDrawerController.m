//
//  XHDrawerController.m
//  PKWorld
//
//  Created by 曾 宪华 on 13-10-7.
//  Copyright (c) 2013年 Jack_team. All rights reserved.
//

#import "XHDrawerController.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "UIView-Transform.h"

static NSTimeInterval const kDefaultAnimationDelayDuration = 0.2;
static NSTimeInterval const kDefaultAnimationDuration = 0.5;
static NSTimeInterval const kDefaultSwapAnimationDuration = 0.55;
static NSTimeInterval const kDefaultSwapAnimationClosedDuration = 0.45;

@interface XHDrawerController () {
    CGAffineTransform menuCloseTransfrom;
    CGAffineTransform mainOpenTransfrom;
    
    CGAffineTransform originScaleTransfrom;
    BOOL isIpad;
    
    // ScrollView 转换过来的手势
    BOOL isPaning;
}
@property (nonatomic, assign, readwrite) XHDrawerSide openSide;
@property (nonatomic, strong) UIView *closeOverlayView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView * childControllerContainerView;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@end

@implementation XHDrawerController
@synthesize mainScrollView = _mainScrollView;

#pragma mark - MainScrollView  setter getter

- (void)setMainScrollView:(UIScrollView *)mainScrollView {
    if (_mainScrollView == mainScrollView)
        return ;
    _mainScrollView = nil;
    _mainScrollView = mainScrollView;
    [_mainScrollView.panGestureRecognizer addTarget:self action:@selector(scrollViewPanGestureHandle:)];
}

- (UIScrollView *)mainScrollView {
    return _mainScrollView;
}

- (UIView *)childControllerContainerView {
    if(_childControllerContainerView == nil){
        _childControllerContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
        [_childControllerContainerView setBackgroundColor:[UIColor blackColor]];
        [_childControllerContainerView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [self.view addSubview:_childControllerContainerView];
    }
    return _childControllerContainerView;
}

#pragma mark - Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)initWithLeftViewController:(UIViewController *)leftViewController mainViewController:(UIViewController *)mainViewController
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        [self commonInitialization];
        [self setCenterViewController:mainViewController];
        
        [self setLeftDrawerViewController:leftViewController];
    }
    return self;
}

- (void)commonInitialization
{
    isIpad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    self.animationDuration = kDefaultAnimationDuration;
    self.edgeOffset = UIOffsetMake((isIpad ? -50 : 18), 0);
    self.zoomScale = (isIpad ? 0.75 : 0.65);
}

#pragma mark - 状态设置

-(void)setOpenSide:(XHDrawerSide)openSide{
    if(_openSide != openSide){
        _openSide = openSide;
        if(openSide == XHDrawerSideNone){
            [self.leftViewController.view setHidden:YES];
        }
    }
}

#pragma mark - UIViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.childControllerContainerView setBackgroundColor:[UIColor blackColor]];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandle:)];
    [self.view addGestureRecognizer:panGesture];
}

#pragma mark - Left Right ViewController manager

-(void)setRightDrawerViewController:(UIViewController *)rightDrawerViewController{
    [self setDrawerViewController:rightDrawerViewController forSide:XHDrawerSideRight];
}

-(void)setLeftDrawerViewController:(UIViewController *)leftDrawerViewController{
    [self setDrawerViewController:leftDrawerViewController forSide:XHDrawerSideLeft];
}

- (void)setDrawerViewController:(UIViewController *)viewController forSide:(XHDrawerSide)drawerSide{
    NSParameterAssert(drawerSide != XHDrawerSideNone);
    
    UIViewController *currentSideViewController = [self sideDrawerViewControllerForSide:drawerSide];
    if (currentSideViewController != nil) {
        [currentSideViewController beginAppearanceTransition:NO animated:NO];
        [currentSideViewController.view removeFromSuperview];
        [currentSideViewController endAppearanceTransition];
        [currentSideViewController removeFromParentViewController];
    }
    
    
    UIViewAutoresizing autoResizingMask = 0;
    if (drawerSide == XHDrawerSideLeft) {
        _leftViewController = viewController;
        autoResizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    }
    else if(drawerSide == XHDrawerSideRight){
        _leftViewController = viewController;
        autoResizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    }
    
    if(viewController){
        [self addChildViewController:viewController];
        
        if ((self.openSide == drawerSide) &&
            [self.childControllerContainerView.subviews containsObject:self.containerView]){
            [self.childControllerContainerView insertSubview:viewController.view belowSubview:self.containerView];
            [viewController beginAppearanceTransition:YES animated:NO];
            [viewController endAppearanceTransition];
        } else {
            [self.childControllerContainerView addSubview:_leftViewController.view];
            [self.childControllerContainerView sendSubviewToBack:_leftViewController.view];
        }
        [viewController didMoveToParentViewController:self];
        [viewController.view setFrame:self.childControllerContainerView.bounds];
        viewController.view.autoresizingMask = autoResizingMask;
        viewController.view.transform = [self closeTransformForMenuView];
        menuCloseTransfrom = viewController.view.transform;
    }
    
}

-(void)prepareToPresentDrawer:(XHDrawerSide)drawer animated:(BOOL)animated {
    XHDrawerSide drawerToHide = XHDrawerSideNone;
    if(drawer == XHDrawerSideLeft){
        drawerToHide = XHDrawerSideRight;
    }
    else if(drawer == XHDrawerSideRight){
        drawerToHide = XHDrawerSideLeft;
    }
    
    UIViewController * sideDrawerViewControllerToPresent = [self sideDrawerViewControllerForSide:drawer];
    UIViewController * sideDrawerViewControllerToHide = [self sideDrawerViewControllerForSide:drawerToHide];
    
    [self.childControllerContainerView sendSubviewToBack:sideDrawerViewControllerToHide.view];
    
    //    [sideDrawerViewControllerToHide.view setHidden:YES];
    //    [sideDrawerViewControllerToPresent.view setHidden:NO];
    //    [sideDrawerViewControllerToPresent.view setFrame:self.childControllerContainerView.bounds];
    
    [sideDrawerViewControllerToPresent beginAppearanceTransition:YES animated:animated];
}

#pragma mark - sideDrawerViewController manager

-(UIViewController*)sideDrawerViewControllerForSide:(XHDrawerSide)drawerSide{
    UIViewController * sideDrawerViewController = nil;
    if(drawerSide != XHDrawerSideNone){
        sideDrawerViewController = [self childViewControllerForSide:drawerSide];
    }
    return sideDrawerViewController;
}

-(UIViewController*)childViewControllerForSide:(XHDrawerSide)drawerSide{
    UIViewController * childViewController = nil;
    switch (drawerSide) {
        case XHDrawerSideLeft:
            childViewController = self.leftViewController;
            break;
        case XHDrawerSideRight:
            childViewController = nil;
            break;
        case XHDrawerSideNone:
            childViewController = self.mainViewController;
            break;
    }
    return childViewController;
}


#pragma mark - Main ViewController manager

-(void)setCenterViewController:(UIViewController *)centerViewController{
    [self setCenterViewController:centerViewController animated:NO];
}

-(void)setCenterViewController:(UIViewController *)centerViewController animated:(BOOL)animated {
    if(_containerView == nil){
        _containerView = [[UIView alloc] initWithFrame:self.view.bounds];
        [self.childControllerContainerView addSubview:self.containerView];
        
        if (!_closeOverlayView) {
            _closeOverlayView = [[UIView alloc] initWithFrame:self.view.bounds];
            self.closeOverlayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
            self.closeOverlayView.alpha = 0.;
            [self.childControllerContainerView addSubview:self.closeOverlayView];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle:)];
            [self.closeOverlayView addGestureRecognizer:tapGesture];
        }
    }
    
    UIViewController * oldCenterViewController = self.mainViewController;
    if(oldCenterViewController){
        if(animated == NO){
            [oldCenterViewController beginAppearanceTransition:NO animated:NO];
        }
        [oldCenterViewController removeFromParentViewController];
        [oldCenterViewController.view removeFromSuperview];
        if(animated == NO){
            [oldCenterViewController endAppearanceTransition];
        }
    }
    
    _mainViewController = centerViewController;
    [self stupCenterViewControllerObserver:centerViewController];
    
    [self addChildViewController:self.mainViewController];
    [self.mainViewController.view setFrame:self.containerView.bounds];
    [self.containerView addSubview:self.mainViewController.view];
    [self.mainViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    if(animated == NO) {
        [self.mainViewController beginAppearanceTransition:YES animated:NO];
        [self.mainViewController endAppearanceTransition];
        [self.mainViewController didMoveToParentViewController:self];
    }
}

- (void)stupCenterViewControllerObserver:(UIViewController *)mainViewController {
    if ([mainViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)mainViewController;
        UIViewController *viewController = [navigationController.viewControllers firstObject];
        UIScrollView *mainScrollView = [viewController valueForKey:@"mainScrollView"];
        if (mainScrollView)
            [self setMainScrollView:mainScrollView];
        [viewController addObserver:self forKeyPath:@"mainScrollView" options:NSKeyValueObservingOptionNew context:NULL];
    } else if ([mainViewController isKindOfClass:[UIViewController class]]) {
        UIScrollView *mainScrollView = [mainViewController valueForKey:@"mainScrollView"];
        if (mainScrollView)
            [self setMainScrollView:mainScrollView];
        [mainViewController addObserver:self forKeyPath:@"mainScrollView" options:NSKeyValueObservingOptionNew context:NULL];
    }
}

#pragma mark - UIGesture

- (void)tapGestureHandle:(UITapGestureRecognizer *)tapGesture {
    if (!self.open)
        return ;
    [self closeMenuAnimated:YES completion:NULL];
}

- (void)scrollViewPanGestureHandle:(UIPanGestureRecognizer *)panGesture {
    if (self.mainScrollView.contentOffset.x < 0) {
        isPaning = YES;
    } else if (self.mainScrollView.contentOffset.x > (self.mainScrollView.contentSize.width - CGRectGetWidth(self.mainScrollView.frame))) {
        // isPaning = YES;
    }
    if (isPaning) {
        if (!self.open) {
            self.mainScrollView.scrollEnabled = NO;
            [self openMenuAnimated:YES completion:^(BOOL finished) {
                isPaning = !finished;
                self.mainScrollView.scrollEnabled = finished;
            }];
        }
    }
}

- (void)panGestureHandle:(UIPanGestureRecognizer *)panGesture {
    UIGestureRecognizerState state = panGesture.state;
    
    CGPoint translation = [panGesture translationInView:panGesture.view];
    
    if (!self.open) {
        if ([panGesture velocityInView:panGesture.view].x < 0) {
            return;
        }
    }
    
    switch (state) {
        case UIGestureRecognizerStateBegan:
            if (!self.open) {
                // 当Menu关闭的时候
                [self prepareToPresentDrawer:XHDrawerSideLeft animated:YES];
            } else {
                [self.leftViewController beginAppearanceTransition:NO animated:YES];
            }
        case UIGestureRecognizerStateChanged: {
            
            
            if (!self.open) {
                // 当Menu关闭的时候
                CGFloat xOffset = translation.x * (isIpad ? 0.55 : 0.9);
                CGFloat width = (isIpad ? 857.5 * 2.4 : 857.5);
                
                float scaleOffset = (1.0 - (xOffset / width));
                
                if (xOffset > 0) {
                    // 正常的缩小和向右边移动
                    
                    
                    // left
                    CGAffineTransform leftScaleTransform = CGAffineTransformScale(menuCloseTransfrom, scaleOffset * (isIpad ? 0.88 : 1), scaleOffset * (isIpad ? 0.88 : 1));
                    CGAffineTransform leftPanGestureTransfrom = CGAffineTransformTranslate(leftScaleTransform, xOffset * (isIpad ? 1 : 0.9), 0);
                    self.leftViewController.view.transform = leftPanGestureTransfrom;
                    
                    // main
                    CGAffineTransform mainScaleTransfrom = CGAffineTransformScale(CGAffineTransformIdentity, scaleOffset, scaleOffset);
                    CGAffineTransform mainPanGestureTransfrom = CGAffineTransformTranslate(mainScaleTransfrom, xOffset, 0);
                    self.containerView.transform = mainPanGestureTransfrom;
                    
                    // 过度的view
                    CGFloat widthOffset = self.view.bounds.size.width / (UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? 4 : 3);
                    float alphaOffset = (translation.x + widthOffset) / self.view.bounds.size.width;
                    self.closeOverlayView.alpha = alphaOffset;
                    self.closeOverlayView.transform = mainPanGestureTransfrom;
                    
                } else if (xOffset < 0) {
                    // 不正常的放大和向左边移动
                }
                
            } else {
                CGFloat xOffset = translation.x * (isIpad ? 0.55 : 0.88);
                CGFloat width = (isIpad ? 520.5 * 2.4 : 520.5);
                
                float scaleOffset = (1.0 - (xOffset / width));
                
                // 打开的时候
                if (xOffset > 0) {
                    // 不正常的缩小和向右边移动
                    
                } else if (xOffset < 0) {
                    // 正常的放大和向左边移动
                    // left
                    self.leftViewController.view.transform = CGAffineTransformTranslate(CGAffineTransformScale(CGAffineTransformIdentity, scaleOffset, scaleOffset), xOffset * 0.75, 0);
                    
                    // main
                    CGAffineTransform originTransfrom = originScaleTransfrom;
                    CGAffineTransform scaleTransform = CGAffineTransformScale(originTransfrom, scaleOffset, scaleOffset);
                    CGAffineTransform openTransfrom = CGAffineTransformTranslate(scaleTransform, xOffset * 0.67, 0);
                    self.containerView.transform = openTransfrom;
                    
                    // 过度的view
                    CGFloat widthOffset = self.view.bounds.size.width / (UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? 4 : 3);
                    float alphaOffset = (1.0 - (-translation.x + widthOffset) / self.view.bounds.size.width);
                    self.closeOverlayView.alpha = alphaOffset;
                    self.closeOverlayView.transform = openTransfrom;
                }
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            CGFloat velocityX = [panGesture velocityInView:panGesture.view].x;
            
            CGFloat mainViewScale = self.containerView.xscale;
            
            if (!self.open) {
                // 没有打开
                if (velocityX >= 0) {
                    if (mainViewScale <= (1.0 - self.zoomScale) / 1.2 + self.zoomScale) {
                        self.open = NO;
                        [self openMenuAnimated:YES completion:^(BOOL finished) {
                            if (finished) {
                                isPaning = !finished;
                            }
                        }];
                    } else {
                        self.open = YES;
                        [self closeMenuAnimated:YES completion:^(BOOL finished) {
                            if (finished) {
                                isPaning = !finished;
                            }
                        }];
                    }
                } else {
                    self.open = YES;
                    [self closeMenuAnimated:YES completion:^(BOOL finished) {
                        if (finished) {
                            isPaning = !finished;
                        }
                    }];
                }
                
            } else {
                // 已经打开了
                // 1、我只要判断滑动距离为
                if (velocityX <= 0) {
                    if (mainViewScale >= (1.0 - self.zoomScale) / 3.8 + self.zoomScale) {
                        self.open = YES;
                        [self closeMenuAnimated:YES completion:^(BOOL finished) {
                            if (finished) {
                                isPaning = !finished;
                            }
                        }];
                    } else {
                        self.open = NO;
                        [self.leftViewController beginAppearanceTransition:YES animated:YES];
                        [self openMenuAnimated:YES completion:^(BOOL finished) {
                            if (finished) {
                                isPaning = !finished;
                            }
                        }];
                    }
                } else {
                    self.open = NO;
                    [self.leftViewController beginAppearanceTransition:YES animated:YES];
                    [self openMenuAnimated:YES completion:^(BOOL finished) {
                        if (finished) {
                            isPaning = !finished;
                        }
                    }];
                }
                
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - Status Bar management

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if ([self respondsToSelector:@selector(preferredStatusBarStyle)]) {
        if (self.open) {
            return self.leftViewController.preferredStatusBarStyle;
        } else {
            return self.mainViewController.preferredStatusBarStyle;
        }
    } else {
        return UIStatusBarStyleDefault;
    }
}

- (void)updateStatusBarStyle
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

#pragma mark - Menu Management

- (CGAffineTransform)closeTransformForMenuView
{
    CGAffineTransform originTransfrom = self.leftViewController.view.transform;
    CGFloat mainMidX = CGRectGetMidX(self.containerView.bounds);
    CGFloat menuEdgeOffsetHorizontal = self.edgeOffset.horizontal;
    CGFloat menuEdgeOffsetVertical = self.edgeOffset.vertical;
    
    CGFloat tx;
    if (originTransfrom.tx != 0) {
        tx = -menuCloseTransfrom.tx + originTransfrom.tx;
    } else {
        tx = (mainMidX + menuEdgeOffsetHorizontal);
    }
    
    CGFloat transformSize = (1.0f + (1.0f * self.zoomScale)) / self.leftViewController.view.transform.a;
    CGAffineTransform transform = CGAffineTransformScale(originTransfrom, transformSize, transformSize);
    CGAffineTransform tempMenuCloseTransfrom = CGAffineTransformTranslate(transform, -tx, -menuEdgeOffsetVertical);
    return tempMenuCloseTransfrom;
}

- (CGAffineTransform)openTransformForView:(UIView *)view
{
    CGFloat originXScale = view.xscale;
    CGFloat transformSize = (self.zoomScale / originXScale);
    CGAffineTransform newTransform = CGAffineTransformTranslate(view.transform, CGRectGetMidX(self.mainViewController.view.bounds) + self.edgeOffset.horizontal - view.tx, self.edgeOffset.vertical);
    originScaleTransfrom = CGAffineTransformScale(newTransform, transformSize, transformSize);
    return originScaleTransfrom;
}

- (void)openMenuAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    if (self.open) {
        return;
    }
    self.open = YES;
    
    UIViewController * sideDrawerViewController = [self sideDrawerViewControllerForSide:XHDrawerSideLeft];
    CGRect visibleRect = CGRectIntersection(self.childControllerContainerView.bounds,sideDrawerViewController.view.frame);
    BOOL drawerFullyCovered = (CGRectContainsRect(self.containerView.frame, visibleRect) ||
                               CGRectIsNull(visibleRect));
    if(drawerFullyCovered){
        [self prepareToPresentDrawer:XHDrawerSideLeft animated:animated];
    }
    
    void (^openMenuBlock)(void) = ^{
        self.leftViewController.view.transform = CGAffineTransformIdentity;
        self.containerView.transform = [self openTransformForView:self.containerView];
        
        self.closeOverlayView.transform = [self openTransformForView:self.closeOverlayView];
        self.closeOverlayView.alpha = 1.0;
    };
    
    void (^openCompleteBlock)(BOOL) = ^(BOOL finished) {
        if (finished) {
            [self.leftViewController endAppearanceTransition];
            [self updateStatusBarStyle];
        }
        
        if (completion) {
            completion(finished);
        }
    };
    
    [self addShadowToViewController:self.mainViewController];
    
    if (animated) {
        [UIView animateWithDuration:self.animationDuration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:openMenuBlock
                         completion:openCompleteBlock];
    } else {
        openMenuBlock();
        openCompleteBlock(YES);
    }
}

- (void)closeMenuAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    if (!self.open) {
        return;
    }
    self.open = NO;
    
    [self.leftViewController beginAppearanceTransition:NO animated:YES];
    
    void (^closeMenuBlock)(void) = ^{
        self.leftViewController.view.transform = [self closeTransformForMenuView];
        self.containerView.transform = CGAffineTransformIdentity;
        
        self.closeOverlayView.transform = CGAffineTransformIdentity;
        self.closeOverlayView.alpha = 0.;
    };
    
    void (^closeCompleteBlock)(BOOL) = ^(BOOL finished) {
        if (finished) {
            [self.leftViewController endAppearanceTransition];
            [self updateStatusBarStyle];
        }
        
        if (completion) {
            completion(finished);
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:self.animationDuration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:closeMenuBlock
                         completion:closeCompleteBlock];
    } else {
        closeMenuBlock();
    }
}

- (void)toggleMenuAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    if (self.open) {
        [self closeMenuAnimated:animated completion:completion];
    } else {
        [self openMenuAnimated:animated completion:completion];
    }
}

- (void)setMainViewController:(UIViewController *)mainViewController animated:(BOOL)animated closeMenu:(BOOL)closeMenu
{
    UIViewController *outgoingViewController = self.mainViewController;
    UIView *overlayView = [[UIView alloc] initWithFrame:outgoingViewController.view.frame];
    overlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    [self.containerView addSubview:overlayView];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @0.0f;
    animation.duration = kDefaultAnimationDuration;
    [overlayView.layer addAnimation:animation forKey:@"opacity"];
    
    UIViewController *incomingViewController = mainViewController;
    [self stupCenterViewControllerObserver:mainViewController];
    
    CGFloat outgoingStartX = CGRectGetMaxX(outgoingViewController.view.frame);
    NSTimeInterval changeTimeInterval = kDefaultSwapAnimationDuration;
    NSTimeInterval delayInterval = kDefaultAnimationDelayDuration;
    if (!self.open) {
        changeTimeInterval = kDefaultSwapAnimationClosedDuration;
        delayInterval = 0.0;
    }
    
    [self addShadowToViewController:incomingViewController];
    [self.containerView addSubview:incomingViewController.view];
    
    incomingViewController.view.frame = self.containerView.bounds;
    CGAffineTransform incomingViewControllerScaleTransfrom = CGAffineTransformScale(incomingViewController.view.transform, 1.2, 1.2);
    incomingViewController.view.transform = CGAffineTransformTranslate(incomingViewControllerScaleTransfrom, outgoingStartX, 0.0f);
    
    void (^swapChangeBlock)(void) = ^{
        outgoingViewController.view.transform = CGAffineTransformMakeScale(0.65, 0.65);
        overlayView.transform = CGAffineTransformMakeScale(0.65, 0.65);
        
        incomingViewController.view.transform = CGAffineTransformIdentity;
    };
    
    void (^finishedChangeBlock)(BOOL finished) = ^(BOOL finished) {
        [self addViewController:incomingViewController];
        
        [outgoingViewController removeFromParentViewController];
        outgoingViewController.view.transform = CGAffineTransformIdentity;
        [outgoingViewController.view removeFromSuperview];
        [outgoingViewController didMoveToParentViewController:nil];
        [overlayView removeFromSuperview];
        self.open = NO;
    };
    
    if (animated) {
        if (closeMenu) {
            [self closeMenuAnimated:animated completion:nil];
        }
        
        [UIView animateWithDuration:changeTimeInterval
                              delay:delayInterval
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:swapChangeBlock
                         completion:finishedChangeBlock];
    } else {
        swapChangeBlock();
        finishedChangeBlock(YES);
    }
    
    self.mainViewController = mainViewController;
}

#pragma mark - View Management

- (void)addViewController:(UIViewController *)viewController
{
    if (viewController) {
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
    }
}

#pragma mark - Shadow management

- (void)addShadowToViewController:(UIViewController *)viewController
{
    CALayer *mainLayer = viewController.view.layer;
    if (mainLayer) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:mainLayer.bounds];
        mainLayer.shadowPath = path.CGPath;
        mainLayer.shadowColor = self.shadowColor.CGColor;
        mainLayer.shadowOffset = CGSizeZero;
        mainLayer.shadowOpacity = 0.6f;
        mainLayer.shadowRadius = 10.0f;
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"mainScrollView"]) {
        id chageNewValue = [change valueForKey:@"new"];
        if ([chageNewValue isKindOfClass:[UIScrollView class]]) {
            [self setMainScrollView:chageNewValue];
        }
    }
}

@end

@implementation UIViewController (TWTSideMenuViewController)

- (void)setXh_drawerController:(XHDrawerController *)xh_drawerController {
    objc_setAssociatedObject(self, @selector(xh_drawerController), xh_drawerController, OBJC_ASSOCIATION_ASSIGN);
}

- (XHDrawerController *)xh_drawerController {
    UIViewController *parentViewController = self.parentViewController;
    while (parentViewController != nil) {
        if([parentViewController isKindOfClass:[XHDrawerController class]]){
            return (XHDrawerController *)parentViewController;
        }
        parentViewController = parentViewController.parentViewController;
    }
    return nil;
}

@end
