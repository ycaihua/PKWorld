//
//  XHSegmentItem.m
//  PKWorld
//
//  Created by 曾 宪华 on 13-10-10.
//  Copyright (c) 2013年 Jack_team. All rights reserved.
//

#import "XHSegmentItem.h"

#define sepImageWidth 0

@implementation XHSegmentItem

@synthesize titleLabel,sepratorLine;
@synthesize index;
@synthesize delegate;
@synthesize backgroundImgView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}

- (void)dealloc
{
    self.titleLabel = nil;
    self.sepratorLine = nil;
    self.backgroundImgView = nil;
}

- (void)tapOnSelf:(UITapGestureRecognizer*)tapR
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapOnItem:)]) {
        [self.delegate didTapOnItem:self];
    }
}

- (void)switchToNormal
{
    self.titleLabel.textColor = [UIColor blackColor];
}
- (void)switchToSelected
{
    self.titleLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:66.0/255.0 blue:94.0/255.0 alpha:1];
}

- (id)initWithFrame:(CGRect)frame withSepratorLine:(UIImage *)sepImage withTitle:(NSString *)title isLastRightItem:(BOOL)state withBackgroundImage:(UIImage *)backImage
{
    if (self = [super initWithFrame:frame]) {
        
        //set backgroundImageView
        backgroundImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,frame.size.width, frame.size.height)];
        self.backgroundImgView.image = backImage;
        [self addSubview:backgroundImgView];
        
        //set title
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,frame.size.width-sepImageWidth,frame.size.height)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.text = title;
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        //        if (!state) {
        //            //set line
        //            self.sepratorLine = [[UIImageView alloc]initWithFrame:CGRectMake(self.titleLabel.frame.size.width,0,sepImageWidth,frame.size.height)];
        //            self.sepratorLine.image = sepImage;
        //            [self addSubview:self.sepratorLine];
        //            [self.sepratorLine release];
        //        }
        
        //add tap gesture
        UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnSelf:)];
        [self addGestureRecognizer:tapR];
    }
    return self;
}

@end
