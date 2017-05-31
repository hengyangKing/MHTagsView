//
//  MHTagListView.m
//  foo
//
//  Created by J on 2017/5/31.
//  Copyright © 2017年 J. All rights reserved.
//

#import "MHTagListView.h"
#import "MHCollectionViewTagsFlowLayout.h"
#import "MHTagViewCell.h"

@interface MHTagListView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, copy) MHTagListViewBlock selectedBlock;

@property(nonatomic,copy)MHTagListCanNotSeleteTagBlock  canNotSelectedBlock;
@end



@implementation MHTagListView

static NSString * const reuseIdentifier = @"tagListViewItemId";
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
}

- (void)setup
{
    _selectedTags = [NSMutableArray array];
    _tags = [NSMutableArray array];
    
    _tagStrokeColor = [UIColor lightGrayColor];
    _tagBackgroundColor = [UIColor clearColor];
    _tagTextColor = [UIColor darkGrayColor];
    _tagSelectedBackgroundColor = [UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1];
    
    _tagCornerRadius = 10.0f;
    
    MHCollectionViewTagsFlowLayout *layout = [[MHCollectionViewTagsFlowLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[MHTagViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self addSubview:_collectionView];
}

- (void)setCompletionBlockWithSelected:(MHTagListViewBlock)completionBlock
{
    self.selectedBlock = completionBlock;
}

-(void)setCanNotSeleteBlockWithBlock:(MHTagListCanNotSeleteTagBlock)canNotSeleteBlock
{
    self.canNotSelectedBlock=canNotSeleteBlock;
}
#pragma mark - UICollectionViewDelegate | UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tags.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MHCollectionViewTagsFlowLayout *layout = (MHCollectionViewTagsFlowLayout *)collectionView.collectionViewLayout;
    CGSize maxSize = CGSizeMake(collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
    
    CGRect frame = [self.tags[indexPath.item] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
    
    return CGSizeMake(frame.size.width + 20.0f, layout.itemSize.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MHTagViewCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = self.tagBackgroundColor;
    cell.layer.borderColor = self.tagStrokeColor.CGColor;
    cell.layer.cornerRadius = self.tagCornerRadius;
    cell.titleLabel.text = self.tags[indexPath.item];
    cell.titleLabel.textColor = self.tagTextColor;
    
    if ([self.selectedTags containsObject:self.tags[indexPath.item]]) {
        cell.backgroundColor = self.tagSelectedBackgroundColor;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.canSelectTags) {
        MHTagViewCell *cell = (MHTagViewCell  *)[collectionView cellForItemAtIndexPath:indexPath];
        
        if ([self.selectedTags containsObject:self.tags[indexPath.item]]) {
            //已选则反选
            cell.backgroundColor = self.tagBackgroundColor;
            [self.selectedTags removeObject:self.tags[indexPath.item]];
        }else {
            //未选选中
            if (self.selectedTags.count >=_maxSeleteCount)
            {
                if (self.canNotSelectedBlock) {
                    self.canNotSelectedBlock();
                    return;
                }
                
            }else{
                cell.backgroundColor = self.tagSelectedBackgroundColor;
                [self.selectedTags addObject:self.tags[indexPath.item]];
            }
        }
    }
    if (self.selectedBlock) {
        self.selectedBlock(indexPath.item);
    }
}


@end
