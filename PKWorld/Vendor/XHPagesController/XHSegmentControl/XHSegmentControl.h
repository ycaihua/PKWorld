//
//  XHSegmentControl.h
//  PKWorld
//
//  Created by 曾 宪华 on 13-10-10.
//  Copyright (c) 2013年 Jack_team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHSegmentItem.h"

@class XHSegmentControl;
@protocol XHSegmentControlDataSource <NSObject>

//菜单里面有多少项
- (NSInteger)numberOfItemsInSegmentControl:(XHSegmentControl*)sgmCtrl;

//每一项得宽度是多少
- (CGFloat)widthForEachItemInsegmentControl:(XHSegmentControl*)sgmCtrl;

//对应索引项得标题的model是什么
- (id)segmentControl:(XHSegmentControl*)sgmCtrl titleForItemAtIndex:(NSInteger)index;

//菜单选中了哪一项
- (void)segmentControl:(XHSegmentControl*)sgmCtrl didSelectAtIndex:(NSInteger)index;
@end

@interface XHSegmentControl : UIView <XHSegmentItemDelegate, UIScrollViewDelegate>
{
    UIImageView *backgroundImageView;
    
    UIScrollView *backScrollView;
    
//    id <XHSegmentControlDataSource> dataSource;
    
    UIImageView *selectedImgView;
    UIImageView *leftTagView;
    UIImageView *rightTagView;
    
    NSInteger lastSelectedIndex;
    NSInteger selectedIndex;
    CGFloat itemWidth;
    
}
@property (nonatomic, readonly) CGFloat itemWidth;
@property (nonatomic, strong) UIScrollView *backScrollView;
@property (nonatomic, assign) id<XHSegmentControlDataSource> dataSource;
@property (nonatomic, retain) UIImage *sepratorLineImageName;
@property (nonatomic, retain) UIImageView *selectedImgView;
@property (nonatomic, retain) UIImageView *leftTagView;
@property (nonatomic, retain) UIImageView *rightTagView;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, retain) UIFont *titleFont;
@property (nonatomic, retain) UIImage *itemBackgroundImageLeft;
@property (nonatomic, retain) UIImage *itemBackgroundImageRight;
@property (nonatomic, retain) UIImage *itemBackgroundImageMiddle;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) UIImage *gripUnSelectedImage;

//使用这个方法初始化这个控件
- (id)initWithFrame      :   (CGRect)frame
     withDataSource      :   (id<XHSegmentControlDataSource>)mDataSource
withSepratorLineImageName:   (UIImage *)sepratorImage
withBackgroundImageName  :   (UIImage*)backImage
   withLeftTagImage      :   (UIImage*)leftImage
        withRightTagImage:   (UIImage*)rightImage;

//使用这个初始化，配置统一的UI
- (id)initWithFrame:(CGRect)frame withDataSource:(id<XHSegmentControlDataSource>)mDataSource;

//获取item
- (XHSegmentItem*)itemForIndex:(NSInteger)index;

//重新载入控件数据
- (void)reloadData;

/**
 Position without any transition to the given index
 @param index
 @param animated if YES the transition will be animated
 */
-(void)goToPage:(NSUInteger)index;

@end
