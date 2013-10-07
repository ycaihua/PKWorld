//
//  XHDrawerController.h
//  PKWorld
//
//  Created by 曾 宪华 on 13-10-7.
//  Copyright (c) 2013年 Jack_team. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,XHDrawerSide){
    XHDrawerSideNone = 0,
    XHDrawerSideLeft,
    XHDrawerSideRight,
};

@interface XHDrawerController : UIViewController

/** Time interval for opening and closing the side menu */
@property (nonatomic, assign) NSTimeInterval animationDuration;

/** Is the menu currently open? */
@property (nonatomic, assign, getter = isOpen) BOOL open;

/** Offset to position the menu in open position */
@property (nonatomic, assign) UIOffset edgeOffset;

/** The scale for zooming the viewport. 0.0 to 1.0 */
@property (nonatomic, assign) CGFloat zoomScale;

/** The color of the shadow to display behind the scaled main view */
@property (nonatomic, strong) UIColor *shadowColor;

/** Left side menu view */
@property (nonatomic, strong) UIViewController *leftViewController;

/** Main View */
@property (nonatomic, strong) UIViewController *mainViewController;

@property (nonatomic, assign, readonly) XHDrawerSide openSide;

/** Initializer that sets up a menuViewController and a mainViewController
 @param menuViewController The view controller to display in the left view
 @param mainViewController The view controller to display in the right view
 @return TWTMenuViewController A view that manages a menu view and opening/closing animations
 */
- (id)initWithLeftViewController:(UIViewController *)leftViewController mainViewController:(UIViewController *)mainViewController;

@end

@interface XHDrawerController (MenuActions)

/** Open the left side menu; animated or not
 @param animated Is the menu open action animated
 */
- (void)openMenuAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

/** Close the left side menu; animated or not
 @param animated Is the menu close action animated
 */
- (void)closeMenuAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

/** Toggle the state of the left side menu
 @param animated Is the toggle action animated
 */
- (void)toggleMenuAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

@end

@interface XHDrawerController (MainViewActions)

- (void)setMainViewController:(UIViewController *)mainViewController animated:(BOOL)animated closeMenu:(BOOL)closeMenu;

@end

@interface UIViewController (XHDrawerController)

@property (nonatomic, weak) XHDrawerController *xh_drawerController;

@end