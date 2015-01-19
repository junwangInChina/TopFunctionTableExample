//
//  ViewController.m
//  TopFunctionTableExample
//
//  Created by wangjun on 15-1-19.
//  Copyright (c) 2015年 wangjun. All rights reserved.
//

#import "ViewController.h"

@interface TopFunctionCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

- (void)reloadTableCell:(NSString *)title;

@end

@implementation TopFunctionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 50)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)reloadTableCell:(NSString *)title
{
    self.titleLabel.text = title;
}

@end

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *exampleTableView;
@property (nonatomic, strong) NSMutableArray *exampleArray;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.exampleArray = [[NSMutableArray alloc] initWithObjects:@"第一行",@"第二行",@"第三行",@"第四行",@"第五行",@"第六行",@"第七行",@"第八行",@"第九行", nil];
    
    self.exampleTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.exampleTableView.delegate = self;
    self.exampleTableView.dataSource = self;
    [self.view addSubview:_exampleTableView];
    
    UIView *zeroView = [UIView new];
    [self.exampleTableView setTableFooterView:zeroView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.exampleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *exampleIdentifier = @"TopFunctionExampleTableCellIdentifier";
    TopFunctionCell *cell = (TopFunctionCell *)[tableView dequeueReusableCellWithIdentifier:exampleIdentifier];
    if (cell == nil)
    {
        cell = [[TopFunctionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:exampleIdentifier];
    }
    if (self.exampleArray.count > indexPath.row)
    {
        [cell reloadTableCell:self.exampleArray[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"置顶";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopFunctionCell *topFunctionCell = (TopFunctionCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIImage *topFunctionImage = [self imageScreenWithView:topFunctionCell];
    UIImageView *topFunctionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                                      topFunctionCell.frame.origin.y,
                                                                                      topFunctionCell.frame.size.width,
                                                                                      topFunctionCell.frame.size.height)];
    topFunctionImageView.image = topFunctionImage;
    [self.view addSubview:topFunctionImageView];
    
    NSString *topFunctionString = self.exampleArray[indexPath.row];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.exampleArray replaceObjectAtIndex:indexPath.row withObject:@""];
        [self.exampleTableView reloadData];
        
        topFunctionImageView.frame = CGRectMake(0,
                                                self.exampleTableView.frame.origin.y,
                                                topFunctionCell.frame.size.width,
                                                topFunctionCell.frame.size.height);
        
    } completion:^(BOOL finished) {
       
        [topFunctionImageView removeFromSuperview];
        [self.exampleArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        [self.exampleArray insertObject:topFunctionString atIndex:0];
        NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [tableView insertRowsAtIndexPaths:@[topIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }];
}

#pragma mark - Private Method
// 获取屏幕截图
- (UIImage *)imageScreenWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
