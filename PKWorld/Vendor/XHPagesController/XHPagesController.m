//
//  XHPagesController.m
//  PKWorld
//
//  Created by 曾 宪华 on 13-10-9.
//  Copyright (c) 2013年 Jack_team. All rights reserved.
//

#import "XHPagesController.h"
#import "XHSegmentControl.h"

#define ScrollViewIntroBaseTag 100

@interface XHPagesController () <XHSegmentControlDataSource> {
    // We use a dictionary of mutable arrays
    // Each key correspond to the "identifier" we use to dequeue
    
    NSMutableDictionary     *_viewControllers;
    NSMutableArray          *_indexes;
    NSUInteger              _futureIndex; // The predictible next index.
    
    BOOL _IOS7ANDGREATER;
}
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) XHSegmentControl *xh_segmentControl;
@end

@implementation XHPagesController
@synthesize mainScrollView = _mainScrollView;
@synthesize xh_segmentControl = _xh_segmentControl;

#pragma mark - getter

- (XHSegmentControl *)xh_segmentControl {
    if (!_xh_segmentControl) {
        // Configure and add the SegementControl
        CGFloat navigationBarAndStatuBarHeight = 0.;
        if (_IOS7ANDGREATER) {
            navigationBarAndStatuBarHeight += AdptNavigationBarAndStatusBarHeight;
        }
        _xh_segmentControl = [[XHSegmentControl alloc] initWithFrame:CGRectMake(0, navigationBarAndStatuBarHeight, CGRectGetWidth(self.mainScrollView.bounds), ItemBarHeight) withDataSource:self];
        _xh_segmentControl.titleFont = [UIFont systemFontOfSize:13];
        _xh_segmentControl.backgroundColor = self.backgroundColor;
        [self.view addSubview:_xh_segmentControl];
    }
    return _xh_segmentControl;
}

#pragma mark -
#pragma mark life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _IOS7ANDGREATER=(floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1);
    _viewControllers=[NSMutableDictionary dictionary];
    _indexes=[NSMutableArray array];
    _pagingEnabled=YES;
    _scrollEnabled=YES;
    _bounces=NO;
    _pageIndex=_futureIndex=NSNotFound;
    
    // Set up the main view
    [self.view setAutoresizesSubviews:YES];
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.view setOpaque:YES];
    [self.view setBounds:[self _adpativeReferenceBounds]];
    
    // Configure and add the scroll view
    
    self.mainScrollView=[[UIScrollView alloc] initWithFrame:[self _adpativeReferenceBounds]];//initWithFrame:CGRectMake(10, 10, 512, 512)];
    [_mainScrollView setClipsToBounds:YES];
    [_mainScrollView setScrollEnabled:self.scrollEnabled];
    [_mainScrollView setPagingEnabled:self.pagingEnabled];
    [_mainScrollView setBounces:self.bounces];
    [_mainScrollView setShowsHorizontalScrollIndicator:NO];
    [_mainScrollView setShowsVerticalScrollIndicator:NO];
    [_mainScrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [_mainScrollView setDelegate:self];
    
    [self.view addSubview:_mainScrollView];
    [self.view sendSubviewToBack:_mainScrollView]; // If there are for example next and previous button.
    self.backgroundColor = [UIColor whiteColor]; // We setup to whiteColor by default
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    if(_pageIndex != NSNotFound && _IOS7ANDGREATER){
//        [self reloadPages];
//    }
}

- (void)viewDidUnload{
    [super viewDidUnload];
    [_mainScrollView removeFromSuperview];
    _mainScrollView = nil;
    _backgroundColor=nil;
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)removeFromParentViewController{
    [super removeFromParentViewController];
    for(NSString*key in _viewControllers){
        NSArray *list=[_viewControllers objectForKey:key];
        for (UIViewController*controller in list) {
            [controller willMoveToParentViewController:nil];
            [controller.view removeFromSuperview];
            [controller removeFromParentViewController];
        }
    }
    
    [_indexes removeAllObjects];
    _indexes=nil;
    
    [_viewControllers removeAllObjects];
    _viewControllers=nil;
    
    [_mainScrollView removeFromSuperview];
    _mainScrollView = nil;
    
    _backgroundColor=nil;
    
}

#pragma mark - XHSegement DataSource

- (NSInteger)numberOfItemsInSegmentControl:(XHSegmentControl *)sgmCtrl {
    return [[self.dataSource items] count];
}

- (CGFloat)widthForEachItemInsegmentControl:(XHSegmentControl *)sgmCtrl {
    return CGRectGetWidth(sgmCtrl.frame) / 5;
}

- (id)segmentControl:(XHSegmentControl *)sgmCtrl titleForItemAtIndex:(NSInteger)index {
    return [[self.dataSource items] objectAtIndex:index];
}

- (void)segmentControl:(XHSegmentControl *)sgmCtrl didSelectAtIndex:(NSInteger)index {
    [self goToPage:index animated:NO];
}

#pragma mark -

- (void)setScrollEnabled:(BOOL)scrollEnabled{
    _scrollEnabled=scrollEnabled;
    [_mainScrollView setScrollEnabled:scrollEnabled];
}

#pragma mark Look and feel


- (void)setBackgroundColor:(UIColor *)backgroundColor{
    _mainScrollView.backgroundColor = backgroundColor;
    [self.view setBackgroundColor:backgroundColor];
    _backgroundColor=backgroundColor;
}

- (void)setPagingEnabled:(BOOL)pagingEnabled{
    [_mainScrollView setPagingEnabled:pagingEnabled];
    _pagingEnabled=pagingEnabled;
}

- (void)setBounces:(BOOL)bounces{
    [_mainScrollView setBounces:bounces];
    _bounces=bounces;
}



#pragma mark -
#pragma mark Rect and Bounds


- (CGRect)_referenceBounds {
    CGRect scrollViewFrame;
    if(self.view.superview && ![self.view.superview isMemberOfClass:[UIWindow class]]){
        scrollViewFrame = self.view.superview.bounds;
        return  scrollViewFrame;
    } else {
        CGFloat navigationBarHeight = 0.;
        if (!self.navigationController.navigationBarHidden && !_IOS7ANDGREATER) {
            navigationBarHeight += 44;
        }
        CGFloat statuesNarHeight = 0.;
        if (![UIApplication sharedApplication].statusBarHidden && !_IOS7ANDGREATER) {
            statuesNarHeight += 20;
        }
        CGRect mainBounds = [[UIScreen mainScreen] bounds];
        scrollViewFrame = CGRectMake(0, 0, CGRectGetWidth(mainBounds), CGRectGetHeight(mainBounds) - navigationBarHeight - statuesNarHeight);
        return scrollViewFrame;
    }
}

- (CGRect)_adpativeReferenceBounds{
    CGRect adpativeFrame;
    adpativeFrame = [self _adaptRect:[self _referenceBounds]];
    return adpativeFrame;
}

- (CGRect)_rectRotate:(CGRect)rect {
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.height, rect.size.width);
}

- (CGRect)_adaptRect:(CGRect)rect{
    if(self.view.superview && ![self.view.superview isMemberOfClass:[UIWindow class]]){
        return rect;
    }else{
        CGRect adptRect = [self _isLandscapeOrientation]?[self _rectRotate:rect]:rect;
        return adptRect;
    }
}

- (BOOL)_isLandscapeOrientation{
    BOOL isLandscapeOrientation = UIDeviceOrientationIsLandscape([self _currentOrientation]);
    return isLandscapeOrientation;
}

- (UIInterfaceOrientation)_currentOrientation{
    return [[UIApplication sharedApplication] statusBarOrientation];
}


#pragma mark -
#pragma mark

- (void)_preparePageAtIndex:(NSUInteger)newIndex{
    // Let's be parcimonious
    // We do prepare only if necessary
    // As it produces a view controller reconfiguration.
    if(![self _pageIsPreparedAt:newIndex]){
        if (! (newIndex >= [self.dataSource pageCount]) ){
            
            UIViewController * __weak controller=[self.dataSource viewControllerForIndex:newIndex];
            NSString *identifier=NSStringFromClass([controller class]);
            if(controller.view){// IOS 7
                // Update the registry
                [self _register:controller
                        atIndex:newIndex];
                
                // Add the view controller if ncessary
                [self _addIfNecessaryViewController:controller
                                     withIdentifier:identifier];
                
                // Position in the scrollview
                [self _positionViewFrom:controller
                                atIndex:newIndex];
                
                XHLog(@"Preparing index : %i [%@]" ,newIndex,controller);
            }
        }
    }else{
        XHLog(@"No necessity to prepare : %i",newIndex);
        return ;
    }
}

// We add a we controller once only
- (void)_addIfNecessaryViewController:(UIViewController*)controller
                      withIdentifier:(NSString*)identifier {
    
    if( [[_viewControllers allKeys] indexOfObject:identifier] == NSNotFound ){
        [_viewControllers setValue:[NSMutableArray array] forKey:identifier];
    }
    
    NSMutableArray *list=[_viewControllers valueForKey:identifier];
    if( [list indexOfObject:controller] == NSNotFound ) {
        [list addObject:controller];
        if(![controller.parentViewController isEqual:self]) {
            [self addChildViewController:controller];
            [self willMoveToParentViewController:controller];
            [controller.view setFrame:[self _referenceBounds]];
            [_mainScrollView addSubview:controller.view]; //
            [controller didMoveToParentViewController:self];
        }
    }
}

- (void)_positionViewFrom:(UIViewController*)controller
                 atIndex:(NSUInteger)index{
    CGRect pageFrame = [self _adpativeReferenceBounds];
    if(self.direction == XHSlidingDirectionHorizontal) {
        pageFrame.origin.y = (_IOS7ANDGREATER ? -AdptNavigationBarAndStatusBarHeight : 0);
        CGFloat x=[self _adpativeReferenceBounds].size.width * (CGFloat)index;
        pageFrame.origin.x = x;
    } else{
        pageFrame.origin.x = 0;
        CGFloat y = [self _adpativeReferenceBounds].size.height * (CGFloat)index;
        pageFrame.origin.y = y;
    }
    controller.view.frame = pageFrame;
}

- (void)_register:(UIViewController*)viewController
         atIndex:(NSUInteger)index {
    NSUInteger idx=[_indexes indexOfObject:viewController];
    if(idx!=index){
        if(idx!=NSNotFound){
            // We place a NSNull object reference to the previous index
            [_indexes replaceObjectAtIndex:idx
                                withObject:[NSNull null]];
        }
        //We place a reference viewController at its new index.
        //If necessary we register NSNUll placeHolders
        if(index>=[_indexes count]){
            int delta=index-[_indexes count];
            for (int i=0; i<delta; i++) {
                [_indexes addObject:[NSNull null]];
            }
            [_indexes addObject:viewController];
        }else{
            [_indexes replaceObjectAtIndex:index
                                withObject:viewController];
        }
    }
}

- (UIViewController*)dequeueViewControllerWithClass:(Class)theClass{
    NSString*identifier=NSStringFromClass(theClass);
    if([[_viewControllers allKeys] indexOfObject:identifier]==NSNotFound)
        return nil;// There are no view controller to recycle with that class.
    
    // Let's chech if there a free (currently off screen) view controller.
    NSMutableArray *list=[_viewControllers valueForKey:identifier];
    for (UIViewController *controller in list) {
        NSUInteger idx=[_indexes indexOfObject:controller];
        if(idx!=NSNotFound && idx!=_pageIndex && idx!=_futureIndex){
            return controller;
        }
    }
    // There is no free view controller.
    return nil;
}

- (BOOL)_pageIsPreparedAt:(NSUInteger)index {
    if([_indexes count]>index){
        if([_indexes objectAtIndex:index] &&
           [[_indexes objectAtIndex:index]class]!=[NSNull class]){
            return YES;
        }
    }
    return NO;
}


- (BOOL)_pageIsVisibleAt:(NSUInteger)index {
    if([self _pageIsPreparedAt:index]){
        UIViewController *__weak child=(UIViewController*)[_indexes objectAtIndex:index];
        return CGRectIntersectsRect(_mainScrollView.bounds,child.view.frame);
    }
    return NO;
}


#pragma mark -

- (void)populateAndGoToIndex:(NSUInteger)index animated:(BOOL)animated {
    [self.xh_segmentControl reloadData];
    
    CGSize mainScrollViewContentSize = [self _scrollViewContentSize];
    
    _mainScrollView.contentSize = mainScrollViewContentSize;
    [self goToPage:index
          animated:animated];
}

- (CGSize)_scrollViewContentSize{
    NSInteger minPageCount = [self.dataSource pageCount];
    if (minPageCount == 0){
        minPageCount = 1;
    }
    
    for (int i = 0; i < minPageCount; i ++) {
        CGRect labelFrame = CGRectMake(i * CGRectGetWidth(self.view.bounds), 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        label.tag = ScrollViewIntroBaseTag + i;
        label.backgroundColor = [UIColor whiteColor];
        label.text = @"网易";
        label.font = [UIFont boldSystemFontOfSize:30];
        label.textAlignment = UITextAlignmentCenter;
        [_mainScrollView addSubview:label];
    }
    
    CGSize scrollViewContentSize;
    if(self.direction == XHSlidingDirectionHorizontal){
        CGFloat navigationBarAndStatusBarHeight = 0.;
        if (_IOS7ANDGREATER) {
            navigationBarAndStatusBarHeight += AdptNavigationBarAndStatusBarHeight;
        }
        scrollViewContentSize = CGSizeMake(_mainScrollView.frame.size.width * minPageCount, _mainScrollView.frame.size.height - navigationBarAndStatusBarHeight);
        return scrollViewContentSize;
    }else{
        scrollViewContentSize = CGSizeMake(_mainScrollView.frame.size.width,_mainScrollView.frame.size.height* minPageCount);
        return scrollViewContentSize;
    }
}

- (void)nextPageAnimated:(BOOL)animated;{
    if([self.dataSource pageCount]>0){
        [self goToPage:_pageIndex+1 animated:animated];
    }
}

- (void)previousPageAnimated:(BOOL)animated{
    if([self.dataSource pageCount]>0){
        [self goToPage:_pageIndex-1 animated:animated];
    }
}

- (void)pageIndexDidChange:(NSUInteger)pageIndex{
    // No implementation
}

- (void)goToPage:(NSUInteger)index
       animated:(BOOL)animated{
    
    if(_pageIndex!=index || _pageIndex==NSNotFound){
        if(index==NSNotFound){
            index=0;
        }
        _pageIndex=index;
        
        
        _futureIndex=index;
        [self _preparePageAtIndex:index];
        BOOL horizontal=(self.direction == XHSlidingDirectionHorizontal);
        [_mainScrollView scrollRectToVisible:CGRectMake(_mainScrollView.frame.size.width * ((horizontal)?index:0.f),
                                                    _mainScrollView.frame.size.height * ((!horizontal)?index:0.f),
                                                    _mainScrollView.frame.size.width,
                                                    _mainScrollView.frame.size.height)
                                animated:animated];
        
        [self pageIndexDidChange:_pageIndex];
    }
}

/**
 Returns the curent viewController (the most central)
 @return An `UIViewController`
 */
- (UIViewController*)currentViewController{
    if(_indexes
       && _pageIndex<[_indexes count]
       && ![[_indexes objectAtIndex:_pageIndex]isKindOfClass:[NSNull class]]){
        return [_indexes objectAtIndex:_pageIndex];
    }
    return nil;
}


- (void)setScrollToTopOfCurrentViewController:(BOOL)scrollToTop{
    if(scrollToTop){
        [_mainScrollView setScrollsToTop:NO];
    }else{
        [_mainScrollView setScrollsToTop:YES];
    }
    for (id c in _indexes) {
        if([c respondsToSelector:@selector(setScrollsToTop:)]){
            [c setScrollsToTop:NO];
        }
        UITableView *tableView = [c valueForKey:@"tableView"];
        if ([tableView respondsToSelector:@selector(setScrollsToTop:)]) {
            [tableView setScrollsToTop:NO];
        }
    }
    id vc=[self currentViewController];
    if([vc respondsToSelector:@selector(setScrollsToTop:)]){
        [vc setScrollsToTop:scrollToTop];
    }
    UITableView *tableView = [vc valueForKey:@"tableView"];
    if ([tableView respondsToSelector:@selector(setScrollsToTop:)]) {
        [tableView setScrollsToTop:scrollToTop];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat fractionalPage;
    if(self.direction == XHSlidingDirectionHorizontal){
        fractionalPage  =  _mainScrollView.contentOffset.x /  _mainScrollView.frame.size.width;
    } else {
        fractionalPage  =  _mainScrollView.contentOffset.y /  _mainScrollView.frame.size.height;
    }
    
    [self _computePageIndexWithPageIndex:fractionalPage];
    
    if(![self _pageIsPreparedAt:_pageIndex]) {
        [self _preparePageAtIndex:_pageIndex];
    }
    
    if(![self _pageIsPreparedAt:_futureIndex]) {
        [self _preparePageAtIndex:_futureIndex];
    }
    
    [self.xh_segmentControl goToPage:_pageIndex];
}

- (void)_computePageIndexWithPageIndex:(CGFloat)page{
    
    if(page<0.f)
        page=0.f;
    
    NSUInteger roundedDown=(NSUInteger)floorf(page); // ceilf rounded Up
    if(_pageIndex!=roundedDown){
        _pageIndex=roundedDown;
        [self pageIndexDidChange:_pageIndex];
    }
    if(page<(CGFloat)_pageIndex){
        _futureIndex=roundedDown;
    }
    if(page>(CGFloat)_pageIndex && roundedDown<[self.dataSource pageCount]-1){
        _futureIndex=roundedDown+1;
    }
    
}

#pragma mark -
#pragma mark Debug facility


- (NSString*)description{
    NSMutableString *s=[NSMutableString string];
    for(NSString*key in _viewControllers){
        NSArray *list=[_viewControllers objectForKey:key];
        [s appendFormat:@"Identifier : %@ [%i]",key,[list count]];
        for (UIViewController*controller in list) {
            [s appendFormat:@"\n%@",controller];
        }
    }
    return s;
}


- (NSInteger)_countViewControllers{
    NSInteger counter=0;
    for(NSString*key in _viewControllers){
        NSArray *list=[_viewControllers objectForKey:key];
        for (UIViewController*controller in list) {
            counter++;
        }
    }
    return counter;
}


#pragma mark - Autorotation

//IOS 6
- (BOOL)shouldAutorotate{
    return YES;
}
// IOS 6
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}
//IOS 6
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self _currentOrientation];
}


#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
// Retro compatibility with IOS 5 (Deprecated)
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}
#endif


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    CGSize newContentSize=[self _scrollViewContentSize];
    // If the contentsize should change
    if(!CGSizeEqualToSize(newContentSize,  _mainScrollView.contentSize)){
        // Reset the scroll view content size
        _mainScrollView.contentSize=newContentSize;
        [self reloadPages];
    }
}

#pragma mark - DataSource

- (void)reloadPages {
    NSUInteger i=0;
    for (UIViewController *controller in _indexes) {
        if(controller && ![controller isMemberOfClass:[NSNull class]]){
            [self _positionViewFrom:controller
                            atIndex:i];
        }
        i++;
    }
    [self goToPage:_pageIndex animated:NO];
}

@end
