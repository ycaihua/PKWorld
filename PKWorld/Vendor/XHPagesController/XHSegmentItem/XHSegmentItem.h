//
//  XHSegmentItem.h
//  PKWorld
//
//  Created by 曾 宪华 on 13-10-10.
//  Copyright (c) 2013年 Jack_team. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHSegmentItem;
@protocol XHSegmentItemDelegate <NSObject>
- (void)didTapOnItem:(XHSegmentItem*)item;
@end
@interface XHSegmentItem : UIView
{
    UIImageView *gripImgView;
    
    UIImageView *backgroundImgView;
    UIImageView *sepratorLine;
    UILabel *titleLabel;
    
    NSInteger index;
//    id <XHSegmentItemDelegate> delegate;
}
@property (nonatomic, retain) UIImageView *sepratorLine;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic) NSInteger index;
@property (nonatomic, assign) id<XHSegmentItemDelegate> delegate;
@property (nonatomic, retain) UIImageView *backgroundImgView;

- (id)initWithFrame:(CGRect)frame withSepratorLine:(UIImage*)sepImage withTitle:(NSString*)title isLastRightItem:(BOOL)state withBackgroundImage:(UIImage*)backImage;

- (void)switchToSelected;
- (void)switchToNormal;

@end
