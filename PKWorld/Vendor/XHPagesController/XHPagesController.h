//
//  XHPagesController.h
//  PKWorld
//
//  Created by 曾 宪华 on 13-10-9.
//  Copyright (c) 2013年 Jack_team. All rights reserved.
//

#import <UIKit/UIKit.h>

// You can define __WATT_DEV_LOG anyware to see developments logs.
#ifdef __XH_DEV_LOG
#define XHLog(format, ... ){NSLog( @"%s%d : %@",__PRETTY_FUNCTION__,__LINE__ ,[NSString stringWithFormat:(format), ##__VA_ARGS__]);}
#else
#define XHLog(format, ... ){}
#endif

@protocol XHPagingDataSource;
@protocol XHPageProtocol;

typedef enum {
    XHSlidingDirectionHorizontal,
    XHSlidingDirectionVertical
} XHSlidingDirection;

@interface XHPagesController : UIViewController <UIScrollViewDelegate>
/**
 The current page index
 */
@property (readonly, nonatomic) NSUInteger pageIndex;

/**
 The datasource
 **/
@property (assign, nonatomic) id<XHPagingDataSource>dataSource;

/**
 The sliding direction
 */
@property (assign, nonatomic) XHSlidingDirection direction;

/**
 default YES. if YES, stop on multiples of view bounds
 **/
@property (assign, nonatomic) BOOL pagingEnabled;

/**
 default YES. Blocks the scroller
 **/
@property (assign, nonatomic) BOOL scrollEnabled;


/**
 default NO. if YES, bounces past edge of content and back again
 **/
@property (assign, nonatomic)BOOL bounces;

/**
 default blackColor
 **/
@property (strong, nonatomic) UIColor *backgroundColor;

/**
 Reconfigures according to the data source.
 **/
-(void)populateAndGoToIndex:(NSUInteger)index
                   animated:(BOOL)animated;

/**
 Position without any transition to the given index
 @param index
 @param animated if YES the transition will be animated
 */
-(void)goToPage:(NSUInteger)index
       animated:(BOOL)animated;

/**
 Transition to the next page if any
 */
-(void)nextPageAnimated:(BOOL)animated;

/**
 Transition to the previous page if any
 */
-(void)previousPageAnimated:(BOOL)animated;

/**
 Returns a viewController that is off screen, to be reconfigured
 @param theClass The class of the desired view controller
 @return An `UIViewController`
 */
- (UIViewController*)dequeueViewControllerWithClass:(Class)theClass;


/**
 Returns the curent viewController (the view Controller that is closer to the center.)
 @return An `UIViewController`
 */
- (UIViewController*)currentViewController;


/**
 Does nothing but can be overriden to perform an action on index change.
 @param pageIndex the new page index
 */
- (void)pageIndexDidChange:(NSUInteger)pageIndex;

- (void)setScrollToTopOfCurrentViewController:(BOOL)scrollToTop;

- (void)reloadPages;

@end


#pragma mark -
#pragma mark XHPagingDataSource

@protocol XHPagingDataSource <NSObject>
@required
-(UIViewController*)viewControllerForIndex:(NSUInteger)index;
-(NSUInteger)pageCount;
@end


#pragma mark -
#pragma mark XHPageProtocol

@protocol XHPageProtocol <NSObject>
@required
-(void)configureWithModel:(id)model;
@end
