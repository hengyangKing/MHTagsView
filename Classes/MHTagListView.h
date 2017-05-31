//
//  MHTagListView.h
//  foo
//
//  Created by J on 2017/5/31.
//  Copyright © 2017年 J. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^MHTagListViewBlock)(NSInteger index);
typedef void(^MHTagListCanNotSeleteTagBlock)();


@interface MHTagListView : UIView


@property (nonatomic, strong) UIColor *tagStrokeColor;// default: lightGrayColor
@property (nonatomic, strong) UIColor *tagTextColor;// default: darkGrayColor
@property (nonatomic, strong) UIColor *tagBackgroundColor;// default: clearColor
@property (nonatomic, strong) UIColor *tagSelectedBackgroundColor;// default: rgb(217,217,217)

@property (nonatomic, assign) CGFloat tagCornerRadius;// default: 10
@property (nonatomic, assign) BOOL canSelectTags;// default: NO

@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) NSMutableArray *selectedTags;

@property (nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic,assign)NSInteger maxSeleteCount;

- (void)setCompletionBlockWithSelected:(MHTagListViewBlock)completionBlock;

-(void)setCanNotSeleteBlockWithBlock:(MHTagListCanNotSeleteTagBlock)canNotSeleteBlock;


@end
