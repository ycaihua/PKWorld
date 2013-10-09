//
//  MainCenterViewController.m
//  PKWorld
//
//  Created by 曾 宪华 on 13-10-2.
//  Copyright (c) 2013年 Jack_team. All rights reserved.
//

#import "MainCenterViewController.h"
#import "WATTItemModel.h"
#import "UIViewController+ConfigureWithModel.h"

@interface MainCenterViewController () {
    NSMutableArray *_listOfItem;
}
@end

@implementation MainCenterViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.dataSource = self;
    self.direction = XHSlidingDirectionHorizontal;
    [self loadDataSource];
    self.bounces = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"main viewDidAppear");
}

- (void)loadDataSource {
        [self _loadItems]; // Load the data
    
    
    
}

#pragma mark - data

-(void)_loadItems{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(!_listOfItem){
            _listOfItem=[NSMutableArray array];
        }
        NSArray *dictionary = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"]];
        for (NSString *className in dictionary) {
            WATTItemModel *model=[WATTItemModel alloc];
            model.imageName=className;
            [_listOfItem addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self populateAndGoToIndex:0
                              animated:NO];
        });
    });
    
}

-(void)_addItemForIndex:(NSInteger)index{
    WATTItemModel *model=[WATTItemModel alloc];
    model.imageName=[NSString stringWithFormat:@"nombres.00%i.jpg",index];
    [_listOfItem insertObject:model atIndex:index];
}



-(id)_modelAtIndex:(NSUInteger)index{
    return [_listOfItem objectAtIndex:index];
}



-(void)pageIndexDidChange:(NSUInteger)pageIndex{
    [self setScrollToTopOfCurrentViewController:YES];
    //A sample of dynamic injection
    //
//    if(pageIndex==3){
//        if(![[self _modelAtIndex:4] isKindOfClass:[WATTItemModel class]]){
//            [self _addItemForIndex:4];
//            //[self populate];
//        }
//    }
}


#pragma mark -
#pragma mark WATTPagingDataSource


-(UIViewController*)viewControllerForIndex:(NSUInteger)index{
    
    
//    if([[self _modelAtIndex:index] isKindOfClass:[WATTItemModel class]]){
    
        // 1- We try to reuse an existing viewController
        //        WATTItemViewController*controller=(WATTItemViewController*)[self dequeueViewControllerWithClass:[WATTItemViewController class]];
        
        // 2- If there is no view Controllers we instanciate one.
        UIViewController *controller=nil;
    WATTItemModel *item = [self _modelAtIndex:index];
    controller = [[NSClassFromString(item.imageName) alloc] init];
        // 3- Important : controller.view must be called once
        // So we test it to for the initialization cycle, before to configure
        if(controller.view){
            // 4 - We pass the model to the view Controller.
            [controller configureWithModel:item];
        }
        return controller;
//    }
    
    return nil;
}


-(NSUInteger)pageCount{
    return _listOfItem.count;
}


- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"main viewWillAppear");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"main viewDidDisappear");
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"main viewWillDisappear");
}

- (void)openMenu {
}

- (void)openRight {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
